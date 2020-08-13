defmodule Proj3 do
  def main(numNodes, numRequests) do
    #IO.inspect(numNodes)
    #IO.inspect(numRequests)
    P2pDriver.start_link({numNodes, numRequests})
    :timer.sleep(:infinity)
  end
end
