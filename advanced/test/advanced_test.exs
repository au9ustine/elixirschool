defmodule AdvancedTest do
  use ExUnit.Case
  doctest Advanced
  import ExUnit.CaptureIO

  test "erlang interoperability" do
    alias Advanced.Example
    assert capture_io(fn -> Example.timed(fn (n) -> (n * n) * n end, [100]) end) =~ ~r/Result: 1000000/i
  end
end
