defmodule Basics do
  defmodule Example.User do
    defstruct name: "Sean", roles: []
  end

  defmodule MySigils do
    @moduledoc """
    This is module doc for MySigils
    """

    # This is inline documentation of sigil_u
    @doc """
    sigil_u is a function of module MySigils
    ## Title

    - item1
    - item2

    ```
    code example
    ```
    """
    def sigil_u(string, []), do: String.upcase(string)
  end

  defmodule SendingProcess do
    def run(pid) do
      send pid, :ping
    end
  end
end
