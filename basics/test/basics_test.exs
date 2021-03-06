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

  test "pattern matching" do
    k1 = "hello"
    k2 = :hello
    %{^k1 => v1} = %{"hello" => "world", :hello => "world2"}
    %{^k2 => v2} = %{"hello" => "world", :hello => "world2"}
    assert v1 == "world"
    assert v2 == "world2"

    greeting = "Hello"
    greet = fn
      (^greeting, name) -> "Hi #{name}"
      (greeting, name) -> "#{greeting}, #{name}"
    end
    assert greet.("Hello", "Sean") == "Hi Sean"
    assert greet.("Mornin'", "Sean") == "Mornin', Sean"
  end

  test "control structures" do
    pie = 3.14
    ret = case "cherry pie" do
      ^pie -> "Not so tasty"
      pie -> "I bet #{pie} is tasty"
    end
    assert ret == "I bet cherry pie is tasty"

    ret = case {1, 2, 3} do
      {1, x, 3} when x > 0 ->
        "Will match"
      _ ->
        "Won't match"
    end
    assert ret == "Will match"
  end

  test "functions" do
    my_sum = &(&1 + &2)
    assert my_sum.(2, 3) == 5
    actual = if false, do: :this, else: :that
    assert actual == :that
  end

  test "Pipe operator" do
    assert "Elixir rocks" |> String.split == ["Elixir", "rocks"]
    assert "Elixir rocks" |> String.upcase |> String.split == ["ELIXIR", "ROCKS"]
  end

  test "modules" do
    assert %Basics.Example.User{} == %Basics.Example.User{name: "Sean", roles: []}
    assert %Basics.Example.User{name: "Steve"} == %Basics.Example.User{name: "Steve", roles: []}
  end

  test "sigils" do
    assert ~c/2 + 7 = #{2 + 7}/ == '2 + 7 = 9'
    assert ~C/2 + 7 = #{2 + 7}/ == '2 + 7 = \#{2 + 7}'
    assert "Elixir" =~ ~r/elixir/ == false
    assert "elixir" =~ ~r/elixir/
    assert "ELIXIR" =~ ~r/elixir/i
    assert Regex.split(~r/_/, "100_000_000") == ["100", "000", "000"]
    assert ~s/welcome to elixir #{String.downcase "SCHOOL"}/ == "welcome to elixir school"
    assert ~S/welcome to elixir #{String.downcase "SCHOOL"}/ == "welcome to elixir \#{String.downcase \"SCHOOL\"}"
    assert ~w/i love #{"excel" |> String.codepoints |> hd}lixir school/ == ["i", "love", "elixir", "school"]
    assert ~W/i love #{"excel" |> String.codepoints |> hd}lixir school/ == ["i", "love", "\#{\"excel\"", "|>", "String.codepoints", "|>", "hd}lixir", "school"]
    assert NaiveDateTime.from_iso8601("2015-01-23 23:50:07") == {:ok, ~N[2015-01-23 23:50:07]}
    import Basics.MySigils
    assert ~u/elixir school/ == "ELIXIR SCHOOL"
  end

  test "receives ping" do
    alias Basics.SendingProcess
    SendingProcess.run(self())
    assert_received :ping
  end

  import ExUnit.CaptureIO
  test "outputs Hello World" do
    assert capture_io(fn -> IO.puts "Hello World" end) == "Hello World\n"
  end

  test "comprehensions" do
    lst = 1..5 |> Enum.to_list
    assert (for x <- lst, do: x*x) == [1, 4, 9, 16, 25]
    assert (for {_key, val} <- [one: 1, two: 2, three: 3], do: val) == [1, 2, 3]
    assert (for {k, v} <- %{"a" => "A", "b" => "B"}, do: {k, v}) == [{"a", "A"}, {"b", "B"}]
    assert (for <<c <- "hello">>, do: <<c>>) == ["h", "e", "l", "l", "o"]
    assert (for {:ok, val} <- [ok: "Hello", error: "Unknown", ok: "World"], do: val) == ["Hello", "World"]
    assert (for n <- [1, 2, 3, 4], times <- 1..n, do: String.duplicate("*", times)) == ["*", "*", "**", "*", "**", "***", "*", "**", "***", "****"]
    expected = "1 - 1
2 - 1
2 - 2
3 - 1
3 - 2
3 - 3
4 - 1
4 - 2
4 - 3
4 - 4
"
    assert capture_io(fn -> for n <- [1, 2, 3, 4], times <- 1..n, do: IO.puts "#{n} - #{times}" end) == expected

    import Integer
    assert (for x <- 1..10, is_even(x), do: x) == [2, 4, 6, 8, 10]
    assert (for x <- 1..100, is_even(x), rem(x, 3) == 0, do: x) == [6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 96]

    assert (for {k, v} <- [one: 1, two: 2, three: 3], into: %{}, do: {k, v}) == %{one: 1, three: 3, two: 2}
    assert (for c <- [72, 101, 108, 108, 111], into: "", do: <<c>>) == "Hello"
  end

  test "string" do
    assert <<104,101,108,108,111>> == "hello"
    [hd|tl] = 'hello'
    assert {hd, tl} == {104, 'ello'}
    assert Enum.reduce('hello', "", fn char, acc -> acc <> to_string(char) <> "," end) == "104,101,108,108,111,"
    assert "\u0061\u0301" == "á"
    assert length(String.codepoints "\u0061\u0301") == 2
    assert length(String.graphemes "\u0061\u0301") == 1
    assert String.length("Hello") == 5
    assert String.replace("Hello", "e", "a") == "Hallo"
    assert String.duplicate("Oh my ", 3) == "Oh my Oh my Oh my "
    assert String.split("Hello World", " ") == ["Hello", "World"]
    alias Basics.Anagram
    assert Anagram.anagrams?("Hello", "ohell")
    assert Anagram.anagrams?("María", "íMara")
  end
end
