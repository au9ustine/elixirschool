defmodule Advanced do
  defmodule Example do
    def timed(fun, args) do
      {time, result} = :timer.tc(fun, args)
      IO.puts "Time: #{time}ms"
      IO.puts "Result: #{result}"
    end
  end
  defmodule ExampleError do
    defexception message: "an example error has occurred"
  end
  def my_throw() do
    raise(ArgumentError, message: "you have a typo")
  end
end
