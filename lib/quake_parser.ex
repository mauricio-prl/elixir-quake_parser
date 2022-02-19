defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  alias QuakeParser.{Game, FindPlayers, KillsOfPlayer}

  def start(path) do
    validate_file(path)
    |> find_games
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(game) do
    total_kills = game_kills(game) |> Enum.count()
    players = FindPlayers.call(game)
    kills = kills_of_each_player(players, game)

    %Game{total_kills: total_kills, players: players, kills: kills}
  end

  defp find_games(log_content) do
    [_h | games] = String.split(log_content, "InitGame:")

    games |> Enum.map(fn str -> String.split(str, "\n") end)
  end

  defp kills_of_each_player(players, game) do
    players
    |> Enum.map(fn player -> KillsOfPlayer.call(player, game_kills(game)) end)
    |> Enum.into(%{})
  end

  defp game_kills(game) do
    Enum.filter(game, fn str -> String.contains?(str, "Kill:") end)
  end

  defp validate_file(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> raise "Invalid file path: #{path}"
    end
  end
end
