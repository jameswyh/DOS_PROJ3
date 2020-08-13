defmodule P2pSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init({numNodes, idList}) do
    children =
      Enum.map(1..numNodes, fn x ->
        worker(P2pNode, [Enum.at(idList, x - 1), numNodes],
          id: Enum.at(idList, x - 1),
          restart: :transient
        )
      end)

    supervise(children, strategy: :one_for_one)
  end
end
