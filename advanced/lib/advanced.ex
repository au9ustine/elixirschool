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

  defmodule ExampleApp.CLI do
    def main(args \\ []) do
      args
      |> parse_args
      |> response
      |> IO.puts
    end

    defp parse_args(args) do
      {opts, word, _} =
        args
        |> OptionParser.parse(switches: [upcase: :boolean])

      {opts, List.to_string(word)}
    end

    defp response({opts, word}) do
      if opts[:upcase], do: String.upcase(word), else: word
    end
  end
end
