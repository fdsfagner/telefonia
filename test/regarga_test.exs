defmodule RegargaTest do
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
    assert %Recarga{data: DateTime.utc_now(), valor: 10}.valor == 10
  end

  test "deve realizar uma regarga" do
    Assinante.cadastrar("Fagner", "12345", "12345", :prepago)

    {:ok, msg} = Recarga.nova(DateTime.utc_now(), 30, "12345")
    assert msg == "Recarga realizada com sucesso!"

    assinante = Assinante.buscar_assinante("12345", :prepago)
    assert assinante.plano.creditos == 30
    assert Enum.count(assinante.plano.recargas) == 1
  end
end
