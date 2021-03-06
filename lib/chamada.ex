defmodule Chamada do
  defstruct data: nil, duracao: nil

  @doc """
  Funcao essencial para fazer chamada no assinante
  """
  def registrar(assinante, data, duracao) do
    assinante_atualizado = %Assinante{
      assinante
      | chamadas: assinante.chamadas ++ [%__MODULE__{data: data, duracao: duracao}]
    }

    Assinante.atualizar(assinante.numero, assinante_atualizado)
  end
end
