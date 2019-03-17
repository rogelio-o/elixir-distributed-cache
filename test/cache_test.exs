defmodule ElixirDistributedCache.CacheTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, cache} = ElixirDistributedCache.Cache.start_link([])
    %{cache: cache}
  end

  test "stores values by key", %{cache: cache} do
    assert ElixirDistributedCache.Cache.get(cache, "milk") == nil

    ElixirDistributedCache.Cache.put(cache, "milk", 3)
    assert ElixirDistributedCache.Cache.get(cache, "milk") == 3
  end

  test "removes values by key", %{cache: cache} do
    ElixirDistributedCache.Cache.put(cache, "milk", 3)
    assert ElixirDistributedCache.Cache.get(cache, "milk") == 3

    ElixirDistributedCache.Cache.delete(cache, "milk")
    assert ElixirDistributedCache.Cache.get(cache, "milk") == nil
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(ElixirDistributedCache.Cache, []).restart == :temporary
  end
end
