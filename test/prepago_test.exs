defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "deve testar estrutura" do
    assert %Prepago{creditos: 0, recargas: []}.creditos == 0
  end

  describe "Funcoes de Ligacao" do
    test "fazer uma ligacao" do
      Assinante.cadastrar("Fagner", "12345", "12345", :prepago)
      Recarga.nova(DateTime.utc_now(), 10, "12345")

      assert Prepago.fazer_chamada("12345", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35, e voce tem 5.65 de creditos"}
    end

    test "fazer uma ligacao longa e nao tem creditos" do
      Assinante.cadastrar("Fagner", "12345", "12345", :prepago)

      assert Prepago.fazer_chamada("12345", DateTime.utc_now(), 10) ==
               {:error, "Voce creditos para fazer a ligacao, faca uma recarga"}
    end
  end

  describe "Testes para impressao de contas" do
    test "deve informar valores da conta do mes" do
      Assinante.cadastrar("Fagner", "12345", "12345", :prepago)
      data = DateTime.utc_now()
      data_antiga = ~U[2020-06-16 21:39:05.612085Z]
      Recarga.nova(data, 10, "12345")
      Prepago.fazer_chamada("12345",data , 3)
      Recarga.nova(data_antiga, 10, "12345")
      Prepago.fazer_chamada("12345",data_antiga , 3)

      assinante = Assinante.buscar_assinante("12345", :prepago)
      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2

      assinante = Prepago.imprimir_conta(data.month, data.year, "12345")

      assert assinante.numero == "12345"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1
    end

  end
end
