defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  @type t :: %__MODULE__{
          total_kills: Integer.t(),
          players: [String.t()],
          kills: Map.t()
        }

  defstruct total_kills: 0, players: [], kills: %{}

  @doc """
  Parse the Quake log file, and return a QuakeParser object for each game.
  """
  @spec start(String.t()) :: list(%__MODULE__{})
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
  @spec death_report(String.t()) :: Map.t()
  def death_report(path) do
    with {:ok, content} <- File.read(path) do
      content
      |> find_games
      |> Enum.map(&game_kills/1)
      |> Enum.map(&build_death_report/1)
      |> Enum.with_index()
      |> Enum.map(fn {obj, index} -> {index, obj} end)
      |> Enum.into(%{})
    end
  end

  defp parse_game(game) do
    total_kills = game_kills(game) |> Enum.count()
    players = find_players(game)
    kills = count_death_by_players(players, game)

    %__MODULE__{total_kills: total_kills, players: players, kills: kills}
  end

  defp find_games(log_content) do
    [_h | games] = String.split(log_content, "InitGame:")

    Enum.map(games, &String.split(&1, "\n"))
  end

  defp find_players(game) do
    key = "ClientUserinfoChanged:"
    start = " n\\"
    finish = "\\t"

    game
    |> Enum.filter(fn str -> String.contains?(str, key) end)
    |> Enum.map(fn str -> String.split(str, start) end)
    |> Enum.map(fn [_, str] -> str end)
    |> Enum.map(fn str -> String.split(str, finish) end)
    |> Enum.map(fn [str | _] -> str end)
    |> Enum.map(fn str -> String.replace(str, "!", "") end)
    |> Enum.uniq()
  end

  defp count_death_by_players(players, game) do
    players
    |> Enum.map(&kills_of_player(&1, game_kills(game)))
    |> Enum.into(%{})
  end

  defp game_kills(game) do
    Enum.filter(game, &String.contains?(&1, "Kill:"))
  end

  defp kills_of_player(player, game_kills) do
    result =
      find_kills_of_player(player, game_kills)
      |> discount_world_deaths(player, game_kills)

    {player, result}
  end

  defp find_kills_of_player(player, game_kills) do
    game_kills
    |> Enum.filter(fn str -> String.contains?(str, "#{player} killed") end)
    |> Enum.count()
  end

  defp discount_world_deaths(kills, player, game_kills) do
    world_deaths =
      game_kills
      |> Enum.filter(fn str -> String.contains?(str, "<world> killed #{player}") end)
      |> Enum.count()

    kills - world_deaths
  end

  defp build_death_report(game_kills) do
    game_kills
    |> means_of_death
    |> Enum.map(&death_counter(&1, game_kills))
    |> Enum.into(%{})
  end

  defp death_counter(mean, game_kills) do
    count =
      game_kills
      |> Enum.filter(&String.contains?(&1, mean))
      |> Enum.count()

    {mean, count}
  end

  defp means_of_death(game_kills) do
    game_kills
    |> Enum.map(&String.split(&1, "by "))
    |> Enum.map(fn [_, str] -> str end)
    |> List.flatten()
    |> Enum.uniq()
  end
end
