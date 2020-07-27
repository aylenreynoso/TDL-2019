defmodule Crypto do

    @moduledoc """
      Erlang's Build-in SHA256 hashing module
    """
    #specify which fields to hash in a block
    @hash_fields [:data, :timestamp, :prev_hash]

    #calculates SHA256 for a binary string
    defp sha256(binary) do
      :crypto.hash(:sha256, binary)
      |> Base.encode16
    end

    @doc """
      Calculates the current block hash
    """
    def hash(%{} = block) do #que significa ese parametro con el igual?
      block
      |> Map.take(@hash_fields) #retorna un mapa con los valores a hashear
      |> Poison.encode!
      |> sha256
    end

    @doc """
      Calculates and puts the hasu in the block
    """
    def put_hash(%{} = block) do
      %{ block | hash: hash(block)} #update a block en ese campo
    end


end
