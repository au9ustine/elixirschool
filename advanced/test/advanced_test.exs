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

  test "concurrency" do
    {:ok, agent} = Agent.start_link(fn -> [1, 2, 3] end)
    Agent.update(agent, fn (state) -> state ++ [4, 5] end)
    assert Agent.get(agent, &(&1)) == [1,2,3,4,5]
    Agent.start_link(fn -> [1, 2, 3] end, name: Numbers)
    assert Agent.get(Numbers, &(&1)) == [1,2,3]
    alias Advanced.Example
    task = Task.async(Example, :double, [2000])
    IO.puts "Do some other works but the task is still in-progress"
    assert Task.await(task) == 4000
  end

  test "OTP Concurrency" do
    alias Advanced.SimpleQueue
    # OTP Concurrency - Synchronous Functions
    # SimpleQueue.start_link([1, 2, 3])
    # assert SimpleQueue.dequeue == 1
    # assert SimpleQueue.dequeue == 2
    # assert SimpleQueue.queue == [3]
    # OTP Concurrency - Asynchronous Functions
    SimpleQueue.start_link([1, 2, 3])
    assert SimpleQueue.queue == [1, 2, 3]
    SimpleQueue.enqueue(20)
    assert SimpleQueue.queue == [1, 2, 3, 20]
  end

  test "OTP Supervisors" do
    import Supervisor.Spec
    alias Advanced.SimpleQueue
    children = [
      worker(SimpleQueue, [], [name: SimpleQueue])
    ]
    {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)
  end

  test "metaprogramming" do
    denominator = 2
    assert quote do: divide(42, denominator) == {:divide, [], [42, {:denominator, [], Elixir}]}
    assert quote do: divide(42, unquote(denominator)) == {:divide, [], [42, 2]}
    alias Advanced.OurMacro
    require OurMacro
    assert OurMacro.unless(true, do: "Hi") == nil
    assert OurMacro.unless(false, do: "Hi") == "Hi"
    alias OurMacro.Logger
    alias OurMacro.Example
    assert capture_io(fn -> Example.test end) == "Logged message: This is a log message\n"
    quoted = quote do
      OurMacro.unless true, do: "Hi"
    end
    assert capture_io(fn -> quoted |> Macro.expand_once(__ENV__) |> Macro.to_string |> IO.puts end) == "if(!true) do
  \"Hi\"
end
"
    assert capture_io(fn -> quoted |> Macro.expand(__ENV__) |> Macro.to_string |> IO.puts end) == "case(!true) do
  x when x in [false, nil] ->
  _ ->
    \"Hi\"
"
  end
end
