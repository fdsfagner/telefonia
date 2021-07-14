defmodule Prepago do

  @moduledoc false

  defstruct creditos: 10, recargas: []
  @preco_minuto 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
       custo <= 10 -> {:ok, "A chamada custou #{custo}"}
       true -> {:error, "Você não tens creditos para fazer a ligação, faça uma recarga"}
    end
  endss

end
