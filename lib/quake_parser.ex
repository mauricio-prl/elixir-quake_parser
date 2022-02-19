defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  alias QuakeParser.{Game, FindPlayers, KillsOfPlayer, DeathReport}

  @doc """
  Parse the Quake log file, and return a QuakeParser.Game object for each game.
  """
  def start(path) do
    validate_file(path)
    |> find_games
    |> Enum.map(&parse_game/1)
  end

  @doc """
  Parse the Quake log file, and return a map with the number of game in a row, and each value
  is another map with how much deaths per meaning.
  """
  def death_report(path) do
    validate_file(path)
    |> find_games
    |> Enum.map(&game_kills/1)
    |> Enum.map(&DeathReport.call/1)
    |> Enum.with_index()
    |> Enum.map(fn {obj, index} -> {index, obj} end)
    |> Enum.into(%{})
  end

  defp parse_game(game) do
    total_kills = game_kills(game) |> Enum.count()
    players = FindPlayers.call(game)
    kills = kills_of_each_player(players, game)

    %Game{total_kills: total_kills, players: players, kills: kills}
  end

  defp find_games(log_content) do
    [_h | games] = String.split(log_content, "InitGame:")

    games |> Enum.map(&String.split(&1, "\n"))
  end

  defp kills_of_each_player(players, game) do
    players
    |> Enum.map(&KillsOfPlayer.call(&1, game_kills(game)))
    |> Enum.into(%{})
  end

  defp game_kills(game) do
    game |> Enum.filter(&String.contains?(&1, "Kill:"))
  end

  defp validate_file(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, _} -> raise "Invalid file path: #{path}"
    end
  end
end
