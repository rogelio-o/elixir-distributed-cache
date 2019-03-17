defmodule ElixirDistributedCache.Cache do
  use Agent, restart: :temporary

  @doc """
  Starts a new cache.
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `cache` by `key`.
  """
  def get(cache, key) do
    Agent.get(cache, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `cache`.
  """
  def put(cache, key, value) do
    Agent.update(cache, &Map.put(&1, key, value))
  end

  @doc """
  Deletes `key` from `cache`.

  Returns the current value of `key`, if `key` exists.
  """
  def delete(cache, key) do
    Agent.get_and_update(cache, &Map.pop(&1, key))
  end
end
