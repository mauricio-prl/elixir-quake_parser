defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  def start(path) do
    validate_file(path)
  end

  defp validate_file(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> raise "Invalid file path: #{path}"
    end
  end
end
