defmodule P2pNode do
  use GenServer

  def start_link(localId, numNodes) do
    GenServer.start_link(__MODULE__, {localId, numNodes}, name: intToAtom(localId))
    # IO.inspect {:ok, pid}
  end

  def init({localId, numNodes}) do
    #IO.inspect(localId)
    neighbourMap = Map.new()
    GenServer.cast(:main, {:add, localId})
    {:ok, {localId, numNodes, neighbourMap}}
  end

  def handle_cast({:getList, nodeList}, {localId, numNodes, neighbourMap}) do
    #IO.inspect nodeList
    Enum.map(nodeList, fn x ->
      GenServer.cast(P2pNode.intToAtom(x), {:update, localId})
    end)
    neighbourMaps = P2pNeighbour.generateNeighbourMap(localId, length(nodeList), nodeList, 40, neighbourMap)
    #IO.inspect neighbourMaps
    GenServer.cast(:main, :confirm)
    {:noreply, {localId, numNodes, neighbourMaps}}
  end

  def handle_cast({:update, newId}, {localId, numNodes, neighbourMap}) do
    neighbourMaps = P2pNeighbour.generateNeighbourMap(localId, 1, [newId], 40, neighbourMap)
    #IO.inspect neighbourMaps
    {:noreply, {localId, numNodes, neighbourMaps}}
  end

  def handle_cast({:next, targetId, level, maxDigit, numHops}, {localId, numNodes, neighbourMaps}) do
    #IO.puts("#{localId} start finding #{targetId} in level #{level}")
    if targetId != localId do
      nextNode = hop(targetId, level, neighbourMaps)
      #IO.puts("#{localId}'s next node in level #{level} is #{nextNode}")
      GenServer.cast(intToAtom(nextNode), {:next, targetId, level + 1, maxDigit, numHops + 1})
    else
      #IO.puts("TARGETID FOUND!, localId:#{localId}, hop:#{numHops}")
      GenServer.cast(:main, {:finish, numHops})
    end
    {:noreply, {localId, numNodes, neighbourMaps}}
  end

  def hop(targetId, level, neighbourMaps) do
    prefix = String.at("#{targetId}", level)
    #IO.puts("targetId: #{targetId}  digit: #{maxDigit}  prefix: #{prefix}  level: #{level}")
    Map.get(neighbourMaps, {level, prefix})
  end

  def intToAtom(str) do
    str
    |> String.to_atom()
  end
end
