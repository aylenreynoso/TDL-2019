defmodule Blockchain.RouterTest do
  use ExUnit.Case, async: true

  test "route requests across nodes" do
    assert Router.route("hello", Kernel, :node, []) ==
           :"foo@aylen-pc"
    assert Router.route("world", Kernel, :node, []) ==
           :"bar@aylen-pc"
  end

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/could not find entry/, fn ->
      Router.route(<<0>>, Kernel, :node, [])
    end
  end
end
