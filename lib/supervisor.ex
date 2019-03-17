defmodule ElixirDistributedCache.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, name: ElixirDistributedCache.CacheSupervisor, strategy: :one_for_one},
      {ElixirDistributedCache.Registry, name: ElixirDistributedCache.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
