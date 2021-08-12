defmodule PospagoTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "deve testar estrutura" do
    assert %Pospago{valor: 10}.valor == 10
  end

  test "deve fazer uma ligacao" do
    Assinante.cadastrar("Fagner", "12345", "12345", :pospago)

    assert Pospago.fazer_chamada("12345", DateTime.utc_now(), 5) ==
             {:ok, "Chamada feita com sucesso! duracao: 5 minutos"}
  end

  test "deve imprimir a conta do assinante" do
    Assinante.cadastrar("Fagner", "12345", "12345", :pospago)
    data = DateTime.utc_now()
    data_antiga = ~U[2020-06-16 21:39:05.612085Z]
    Pospago.fazer_chamada("12345", data, 3)
    Pospago.fazer_chamada("12345", data_antiga, 3)
    Pospago.fazer_chamada("12345", data, 3)
    Pospago.fazer_chamada("12345", data, 3)

    assinante = Assinante.buscar_assinante("12345", :pospago)
    assert Enum.count(assinante.chamadas) == 4

    assinante = Pospago.imprimir_conta(data.month, data.year, "12345")
    assert assinante.numero == "12345"
    assert Enum.count(assinante.chamadas) == 3
    assert assinante.plano.valor == 12.599999999999998
  end
end
