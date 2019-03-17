defmodule ElixirDistributedCache do
  use Application

  def start(_type, _args) do
    ElixirDistributedCache.Supervisor.start_link(name: ElixirDistributedCache.Supervisor)
  end
end
