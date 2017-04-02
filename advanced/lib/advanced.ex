defmodule Advanced do
  defmodule Example do
    def timed(fun, args) do
      {time, result} = :timer.tc(fun, args)
      IO.puts "Time: #{time}ms"
      IO.puts "Result: #{result}"
    end
  end
end
