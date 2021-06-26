defmodule Assinante do

  @moduledoc false
  defstruct nome: nil, numero: nil, cpf: nil

  def cadastrar(nome, numero, cpf) do
    read() ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf}]
    |> :erlang.term_to_binary()
    |> write()
  end

  defp write(lista_assinantes) do
    File.write!("assinante.txt", lista_assinantes)
  end

  defp read() do
    {:ok, assintantes} = File.read!("ässinante.txt")
    assintantes
    |> :erlang.binary_to_term()
  end
end
