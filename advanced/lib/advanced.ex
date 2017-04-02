defmodule Advanced do
  defmodule Example do
    def timed(fun, args) do
      {time, result} = :timer.tc(fun, args)
      IO.puts "Time: #{time}ms"
      IO.puts "Result: #{result}"
    end

    # Concurrency - Processes
    def add(a, b) do
      IO.puts(a + b)
    end

    # Concurrency - Message Passing
    def listen do
      receive do
        {:ok, "hello"} -> IO.puts "World"
      end

      listen
    end
    def explode, do: exit(:kaboom)

    # Concurrency - Process Linking
    # def run do
    #   Process.flag(:trap_exit, true)
    #   spawn_link(Example, :explode, [])

    #   receive do
    #     {:EXIT, from_pid, reason} -> IO.puts "Exit reason: #{reason}"
    #   end
    # end

    # Concurrency - Process Monitoring
    # def run do
    #   {pid, ref} = spawn_monitor(Example, :explode, [])

    #   receive do
    #     {:DOWN, ref, :process, from_pid, reason} -> IO.puts "Exit reason: #{reason}"
    #   end
    # end

    # Concurrency - Tasks
    def double(x) do
      :timer.sleep(2000)
      x * 2
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
