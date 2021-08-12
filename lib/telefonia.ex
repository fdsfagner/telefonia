defmodule Telefonia do
  @doc """
  Parser pra outras Funcoes
  """
  def start do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))
  end

  @doc """
  Parser pra outras Funcoes
  """
  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end

  @doc """
  Parser pra outras Funcoes
  """
  def listar_assinantes, do: Assinante.assinantes()

  @doc """
  Parser pra outras Funcoes
  """
  def listar_assinantes_prepago, do: Assinante.assinantes_prepago()

  @doc """
  Parser pra outras Funcoes
  """
  def listar_assinantes_pospago, do: Assinante.assinantes_postpago()

  @doc """
  Parser pra outras Funcoes
  """
  def fazer_chamada(numero, plano, data, duracao) do
    cond do
      plano == :prepago -> Prepago.fazer_chamada(numero, data, duracao)
      plano == :pospago -> Pospago.fazer_chamada(numero, data, duracao)
    end
  end

  @doc """
  Parser pra outras Funcoes
  """
  def recarga(numero, data, valor), do: Recarga.nova(data, valor, numero)

  @doc """
  Parser pra outras Funcoes
  """
  def buscar_por_numero(numero, plano \\ :all), do: Assinante.buscar_assinante(numero, plano)

  @doc """
  Parser pra outras Funcoes, aqui imprime os dados de todas as contas
  """
  def imprimir_contas(mes, ano) do
    Assinante.assinantes_prepago()
    |> Enum.each(fn assinante ->
      assinante = Prepago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta Prepaga do Assinante: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Recargas: ")
      IO.inspect(assinante.plano.recargas)
      IO.puts("Total de Chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Total de Recargas: #{Enum.count(assinante.plano.recargas)}")
      IO.puts("==============================================================")
    end)

    Assinante.assinantes_postpago()
    |> Enum.each(fn assinante ->
      assinante = Pospago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta do Tipo pospago do Assinante: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Total de Chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Valor da Fatura: #{assinante.plano.valor}")
      IO.puts("==============================================================")
    end)
  end
end
