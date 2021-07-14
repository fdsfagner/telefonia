defmodule Assinante do

  @moduledoc """
    Módulo de assintante para cadastro de tipos de assinantes como `prepago` e `pospago`.
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)
  def assinantes, do: read(:prepago) ++ read(:pospago)


  @doc """
  Funçao para cadastrar assinante seja ele `prepago`e `pospago`

  ## Parametros da Função

  - nome: parametro para nome do assinante
  - numero: numero único e caso não exista .....

  ## Exemplo

      iex> Assinante.cadastrar("João", "123456", "123456")
      {:ok, "Assinante João cadastrado com Sucesso!"}

  """

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do

    case buscar_assinante(numero) do
      nil ->
        read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}]
        |> :erlang.term_to_binary()
        |> write(plano)
        {:ok, "Assinante #{nome} cadastrado com Sucesso!"}
      _assinante ->
        {:error, "Assinante com esse numero Cadastrado!"}
    end
  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def deletar(numero) do
    assinante = buscar_assinante(numero)

    result_delete = assinantes()
    |> List.delete(assinante)
    |> :erlang.term_to_binary()
    |> write(assinante.plano)

    {result_delete, "Assinante #{assinante.nome} deletado!"}
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assintantes} ->
        assintantes
        |> :erlang.binary_to_term()
      {:error, :ennoent} ->
        {:error, "Arquivo Inválido!"}
    end
  end
end
