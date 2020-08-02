defmodule Router do
  @doc """

  """
  def no_entry_error do
    raise "could not find entry"
  end

  def table do
    [{?a..?m, :"foo@aylen-pc"}, {?n..?z, :"bar@aylen-pc"}]
  end

  def route(string, mod, fun, arg) do
    #get the first byte of the binary
    first = :binary.first(string)

    #Try to find an entry in the table() or raise
    entry = Enum.find(table(), fn {enum, _node} -> first in enum end) || no_entry_error()

    #If the entry node is the current _node
    if elem(entry,1) == node() do
      apply(mod, fun, arg)
    else
      {Blockchain.RouterTask, elem(entry,1)}
      |> Task.Supervisor.async(Router, :route, [string, mod, fun, arg])
      |> Task.await
    end

  end
end
