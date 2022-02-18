defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  def start(path) do
    validate_file(path)
    |> find_games
  end

  defp find_games(log_content) do
    [_h | games] = String.split(log_content, "InitGame:")

    Enum.map(games, fn str -> String.split(str, "\n") end)
  end

  defp validate_file(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> raise "Invalid file path: #{path}"
    end
  end
end
