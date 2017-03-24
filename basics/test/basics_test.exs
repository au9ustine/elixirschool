defmodule BasicsTest do
  use ExUnit.Case
  doctest Basics

  test "basics" do
    assert 2 + 3 == 5
    assert String.length("The quick brown fox jumps over the lazy dog") == 43
    assert 0b0110 == 6
    assert :foo != :bar
  end

  test "collections" do
    # list
    list = [3.14, :pie, "Apple"]
    assert ["π"] ++ list == ["π", 3.14, :pie, "Apple"]
    assert list ++ ["Cherry"] == [3.14, :pie, "Apple", "Cherry"]
    assert ["foo", :bar, 42] -- [42, "bar"] == ["foo", :bar]
    assert [1,2,2,3,2,3] -- [1,2,3,2] == [2, 3]
    assert (hd [3.14, :pie, "Apple"]) == 3.14
    assert (tl [3.14, :pie, "Apple"]) == [:pie, "Apple"]
    [h|t] = [3.14, :pie, "Apple"]
    assert h == 3.14
    assert t == [:pie, "Apple"]
    # tuples
    {status, _} = File.read("./mix.exs")
    assert status == :ok
    {status, _} = File.read("path/to/unknown")
    assert status == :error
    # keyword list
    {k, _} = [foo: "bar", hello: "world"] |> hd
    assert k == :foo
    # maps
    my_map = %{:foo => "bar", "hello" => :world}
    assert my_map[:foo] == "bar"
    my_map = %{my_map | foo: "jfdklafjkdlsjaf"}
    assert my_map[:foo] == "jfdklafjkdlsjaf"
  end

  test "enum" do
    assert length(Enum.__info__(:functions) |> Enum.map(fn({k,_}) -> k end)) >= 83
    assert Enum.all?(["foo", "bar", "hello"], fn(s) -> String.length(s) == 3 end) == false
    assert Enum.all?(["foo", "bar", "hello"], fn(s) -> String.length(s) > 1 end) == true
    assert Enum.any?(["foo", "bar", "hello"], fn(s) -> String.length(s) == 5 end) == true
    assert Enum.chunk_by(["one", "two", "three", "four", "five", "six"], fn(x) -> String.length(x) end) == [["one", "two"], ["three"], ["four", "five"], ["six"]]
    assert Enum.each([1, 2, 3], fn(x) -> x+1 end) == :ok
    assert Enum.map([1, 2, 3], fn(x) -> x+1 end) == [2, 3, 4]
    assert Enum.reduce(["a","b","c"], "1", fn(x,acc)-> x <> acc end) == "cba1"
    assert Enum.uniq_by([1, 2, 3, 2, 1, 1, 1, 1, 1], fn x -> x end) == [1,2,3]
  end
end
