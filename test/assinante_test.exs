defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  @moduledoc false

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "testes responsáveis para cadastro de assinantes" do
    test "deve retornar a estrututa do assinante" do
      assert %Assinante{nome: "teste", numero: "teste", cpf: "teste", plano: "plano"}.nome ==
               "teste"
    end

    test "criar uma conta prepago" do
      assert Assinante.cadastrar("Fagner da Silva", "123", "123") ==
               {:ok, "Assinante Fagner da Silva cadastrado com Sucesso!"}
    end

    test "deve retornar erro informando que assinante já está cadastrado" do
      Assinante.cadastrar("Fagner da Silva", "123", "123")

      assert Assinante.cadastrar("Fagner da Silva", "123", "123") ==
               {:error, "Assinante com esse numero Cadastrado!"}
    end
  end

  describe "testes responsáveis por busca de assinantes" do
    test "busca pospago" do
      Assinante.cadastrar("Fagner", "123", "123", :pospago)
      assert Assinante.buscar_assinante("123", :pospago).nome == "Fagner"
    end

    test "busca prepago" do
      Assinante.cadastrar("Fagner", "123", "123")
      assert Assinante.buscar_assinante("123", :prepago).nome == "Fagner"
    end
  end

  describe "delete" do
    test "deve deletar o assinante" do
      Assinante.cadastrar("Fagner", "123", "123")
      assert Assinante.deletar("123") == {:ok, "Assinante Fagner deletado!"}
    end
  end
end
