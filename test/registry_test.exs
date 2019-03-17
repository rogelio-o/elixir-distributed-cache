defmodule ElixirDistributedCache.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(ElixirDistributedCache.Registry)
    %{registry: registry}
  end

  test "spawns caches", %{registry: registry} do
    assert ElixirDistributedCache.Registry.lookup(registry, "shopping") == :error

    assert {:ok, cache} = ElixirDistributedCache.Registry.create(registry, "shopping")

    ElixirDistributedCache.Cache.put(cache, "milk", 1)
    assert ElixirDistributedCache.Cache.get(cache, "milk") == 1
  end

  test "get spawned caches", %{registry: registry} do
    assert {:ok, _} = ElixirDistributedCache.Registry.create(registry, "shopping")
    assert {:ok, cache} = ElixirDistributedCache.Registry.lookup(registry, "shopping")

    ElixirDistributedCache.Cache.put(cache, "milk", 1)
    assert ElixirDistributedCache.Cache.get(cache, "milk") == 1
  end

  test "removes caches on exit", %{registry: registry} do
    {:ok, cache} = ElixirDistributedCache.Registry.create(registry, "shopping")
    Agent.stop(cache)
    assert ElixirDistributedCache.Registry.lookup(registry, "shopping") == :error
  end

  test "removes cache on crash", %{registry: registry} do
    {:ok, cache} = ElixirDistributedCache.Registry.create(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(cache, :shutdown)
    assert ElixirDistributedCache.Registry.lookup(registry, "shopping") == :error
  end
end
