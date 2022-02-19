defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  def start(path) do
    validate_file(path)
    |> find_games
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(game) do
    total_kills = total_kills_of(game) |> Enum.count()
    players = players_of(game)
    # kills = kills_of(game)

    %Game{total_kills: total_kills, players: players}
  end

  defp find_games(log_content) do
    [_h | games] = String.split(log_content, "InitGame:")

    Enum.map(games, fn str -> String.split(str, "\n") end)
  end

  defp total_kills_of(game) do
    Enum.filter(game, fn str -> String.contains?(str, "Kill:") end)
  end

  defp players_of(game) do
    []
    |> find_players_by_pattern({"killed", "killed", " by"}, game)
    |> find_players_by_pattern({"ClientUserinfoChanged:", " n\\", "\\t"}, game)
    |> Enum.map(fn str -> String.replace(str, " ", "") end)
    |> Enum.uniq()
  end

  # defp kills_of(game, players) do
  #   players |> Enum.map(fn player ->
  #     Enum.filter(game, fn str -> String.contains?(str, player) end)
  #   end)
  # end

  defp find_players_by_pattern(players, {key, start, finish}, game) do
    result =
      game
      |> Enum.filter(fn str -> String.contains?(str, key) end)
      |> Enum.map(fn str -> String.split(str, start) end)
      |> Enum.map(fn [_, str] -> str end)
      |> Enum.map(fn str -> String.split(str, finish) end)
      |> Enum.map(fn [str | _] -> str end)

    players ++ result
  end

  defp validate_file(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> raise "Invalid file path: #{path}"
    end
  end
end
