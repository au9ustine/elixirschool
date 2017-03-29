defmodule Basics do
  defmodule Example.User do
    defstruct name: "Sean", roles: []
  end

  defmodule MySigils do
    def sigil_u(string, []), do: String.upcase(string)
  end
end
