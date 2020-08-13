defmodule P2pDriver do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: :main)
  end

  def init({numNodes, numRequests}) do
    #IO.puts("Driver start")
    digit = Integer.digits(numNodes) |> length
    upperbound = (:math.pow(10, digit) - 1) |> Kernel.trunc()
    #IO.inspect(upperbound)
    idList = generateIdList(numNodes, upperbound, [])
    #IO.inspect(idList)
    P2pSupervisor.start_link({numNodes, idList})
    maxNumHops = 0
    # sendRequest(idList, maxDigit, numRequests)
    totalRequests = numNodes * numRequests
    nodeList = []
    nodeCount = 0
    {:ok, {idList, numRequests, totalRequests, maxNumHops, nodeList, nodeCount}}
  end

  def handle_cast(:confirm, {idList, numRequests, totalRequests, maxNumHops, nodeList, nodeCount}) do
    #IO.puts "#{nodeCount+1} confirm"
    if nodeCount + 1 == length(idList) do
      #IO.puts "ALL NODES ADDED"
      sendRequest(idList, 40, numRequests)
    end
    {:noreply, {idList, numRequests, totalRequests, maxNumHops, nodeList, nodeCount + 1}}
  end

  def handle_cast({:add, localId}, {idList, numRequests, totalRequests, maxNumHops, nodeList, nodeCount}) do
    nodesList = nodeList ++ [localId]
    GenServer.cast(P2pNode.intToAtom(localId), {:getList, nodesList})
    #IO.puts "add sucessfully"
    #IO.inspect nodesList
    {:noreply, {idList, numRequests, totalRequests, maxNumHops, nodesList, nodeCount}}
  end

  def handle_cast({:finish, numHops}, {idList, numRequests, totalRequests, maxNumHops, nodeList, nodeCount}) do
    # IO.puts "nodeCount is #{nodeCount}"
    maxNumHop =
    if numHops > maxNumHops do
      numHops
    else
      maxNumHops
    end
    totalRequest = totalRequests - 1

    #IO.puts("#{totalRequest} REQUESTS have not done yet")

    if(totalRequest < 1) do
      #IO.puts("All requests have done.")
      #IO.puts("Max number of hops #{maxNumHop}")
      IO.inspect maxNumHop
      System.halt(0)
    end

    {:noreply, {idList, numRequests, totalRequest, maxNumHop, nodeList, nodeCount}}
  end

  def sendRequest(idList, maxDigit, numRequests) do
    if(numRequests > 0)do
      targetId = Enum.random(idList)
      tableLevel = 0
      numHops = 0;
      Enum.map(idList, fn x ->
        GenServer.cast(P2pNode.intToAtom(x), {:next, targetId, tableLevel, maxDigit, numHops})
      end)
      sendRequest(idList, maxDigit, numRequests - 1)
    else
      #IO.puts "ALL REQUESTS ARE SENT"
    end
  end

  def generateIdList(numNodes, upperbound, list) do
    if numNodes > 0 do
      newId = Enum.random(0..upperbound)

      if Enum.any?(list, fn x -> x == :crypto.hash(:sha,"#{newId}")|>Base.encode16 end) do
        generateIdList(numNodes, upperbound, list)
      else
        idList = list ++ [:crypto.hash(:sha,"#{newId}")|>Base.encode16]
        numNode = numNodes - 1
        generateIdList(numNode, upperbound, idList)
      end
    else
      list
    end
  end
end
