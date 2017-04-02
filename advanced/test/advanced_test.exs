defmodule AdvancedTest do
  use ExUnit.Case
  doctest Advanced
  import ExUnit.CaptureIO

  test "erlang interoperability" do
    alias Advanced.Example
    assert capture_io(fn -> Example.timed(fn (n) -> (n * n) * n end, [100]) end) =~ ~r/Result: 1000000/i
  end

  test "error handling" do
    import Advanced
    assert_raise ArgumentError, fn -> my_throw() end
    # `assert_raise ArgumentError, my_throw` would fail. See
    # http://stackoverflow.com/questions/37703632/elixir-assert-raise-doesnt-catch-exceptions
  end
end
