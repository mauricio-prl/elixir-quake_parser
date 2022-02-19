defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  defstruct total_kills: 0, players: [], kills: %{}

  alias QuakeParser.{FindPlayers, KillsOfPlayer, DeathReport}

  @doc """
  Parse the Quake log file, and return a QuakeParser.Game object for each game.
  """
  @spec start(String.t()) :: list()
  def start(path) do
    with {:ok, content} <- File.read(path) do
      content
      |> find_games
      |> Enum.map(&parse_game/1)
    end
  end

  @doc """
  Parse the Quake log file, and return a map with the number of game in a row, and each value
  is another map with how much deaths per meaning.
  """
  @spec death_report(String.t()) :: any
  def death_report(path) do
    with {:ok, content} <- File.read(path) do
      content
      |> find_games
      |> Enum.map(&game_kills/1)
      |> Enum.map(&DeathReport.call/1)
      |> Enum.with_index()
      |> Enum.map(fn {obj, index} -> {index, obj} end)
      |> Enum.into(%{})
    end
  end

  defp parse_game(game) do
    total_kills = game_kills(game) |> Enum.count()
    players = FindPlayers.call(game)
    kills = count_death_by_players(players, game)

    %__MODULE__{total_kills: total_kills, players: players, kills: kills}
  end

  defp find_games(log_content) do
    [_h | games] = String.split(log_content, "InitGame:")

    Enum.map(games, &String.split(&1, "\n"))
  end

  defp count_death_by_players(players, game) do
    players
    |> Enum.map(&KillsOfPlayer.call(&1, game_kills(game)))
    |> Enum.into(%{})
  end

  defp game_kills(game) do
    Enum.filter(game, &String.contains?(&1, "Kill:"))
  end
end
