defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "testes responsaveis para cadastro de assinantes" do
    test "deve retornar estrutura de assinante" do
      assert %Assinante{nome: "teste", numero: "teste", cpf: "teste", plano: "plano"}.nome ==
               "teste"
    end

    test "criar uma conta prepago" do
      assert Assinante.cadastrar("Fagner", "12345", "12345", :prepago) ==
               {:ok, "Assinante Fagner cadastrado com sucesso!"}
    end

    test "deve retornar erro dizendo que assinante ja esta cadastrado" do
      Assinante.cadastrar("Fagner", "12345", "12345", :prepago)

      assert Assinante.cadastrar("Fagner", "12345", "12345", :prepago) ==
               {:error, "Assinante com este numero Cadastrado!"}
    end
  end

  describe "testes responsaveis por busca de assinantes" do
    test "busca pospago" do
      Assinante.cadastrar("Fagner", "12345", "12345", :pospago)
      assert Assinante.buscar_assinante("12345", :pospago).nome == "Fagner"
      assert Assinante.buscar_assinante("12345", :pospago).plano.__struct__ == Pospago
    end

    test "busca prepago" do
      Assinante.cadastrar("Fagner", "12345", "12345", :prepago)
      assert Assinante.buscar_assinante("12345", :prepago).nome == "Fagner"
    end
  end

  describe "delete" do
    test "deve deletar o assinante" do
      Assinante.cadastrar("Fagner", "12345", "12345", :prepago)
      Assinante.cadastrar("Tatiana", "33333", "87654", :prepago)

      assert Assinante.deletar("12345") == {:ok, "Assinante Fagner deletado!"}
    end
  end
end
