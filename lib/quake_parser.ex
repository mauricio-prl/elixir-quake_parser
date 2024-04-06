defmodule QuakeParser do
  @moduledoc """
  `QuakeParser` is a parser for Quake game logs.
  """

  @type t :: %__MODULE__{
          total_kills: Integer.t(),
          players: [String.t()],
          kills: %{non_neg_integer() => kill}
        }

  @typep kill :: %{String.t() => Integer.t()}

  defstruct total_kills: 0, players: [], kills: %{}

  @init_game_key "InitGame:"
  @kill_key "Kill:"
  @username_regex ~r/n\\((\w|\s)+)\\t/

  @doc """
  Parse the Quake log file, and return a QuakeParser object for each game.

  ## Examples

  ```
      iex>QuakeParser.parse("test/fixtures/log.txt")
      [
        %QuakeParser{
          kills: %{
            "Assasinu Credi" => 22,
            "Chessus" => 0,
            "Dono da Bola" => 12,
            "Isgalamido" => 16,
            "Mal" => -3,
            "Oootsimo" => 20,
            "Zeh" => 9
          },
          players: ["Oootsimo", "Isgalamido", "Zeh", "Dono da Bola", "Mal",
          "Assasinu Credi", "Chessus"],
          total_kills: 130
        }
      ]
  ```
  """
  @spec parse(String.t()) :: list(__MODULE__.t())
  def parse(path) do
    File.stream!(path)
    |> find_games
    |> Enum.map(&parse_game/1)
  end

  defp find_games(stream) do
    log_content = Enum.join(stream)
    [_ | games] = String.split(log_content, @init_game_key)

    Enum.map(games, &String.split(&1, "\n"))
  end

  defp parse_game(game) do
    total_kills = Enum.count(game_kills(game))
    players = find_players(game)
    kills = count_death_by_players(players, game)

    %__MODULE__{total_kills: total_kills, players: players, kills: kills}
  end

  defp find_players(game) do
    game
    |> Enum.map(&retrieve_username/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
  end

  defp retrieve_username(line) do
    result = Regex.run(@username_regex, line)

    case result do
      [_, username, _] -> username
      _ -> nil
    end
  end

  defp count_death_by_players(players, game) do
    players
    |> Enum.map(&kills_of_player(&1, game_kills(game)))
    |> Enum.into(%{})
  end

  defp game_kills(game), do: Enum.filter(game, &String.contains?(&1, @kill_key))

  defp kills_of_player(player, game_kills) do
    result =
      find_kills_of_player(player, game_kills)
      |> discount_world_deaths(player, game_kills)

    {player, result}
  end

  defp find_kills_of_player(player, game_kills) do
    game_kills
    |> Enum.filter(&String.contains?(&1, "#{player} killed"))
    |> Enum.count()
  end

  defp discount_world_deaths(kills, player, game_kills) do
    world_deaths =
      game_kills
      |> Enum.filter(&String.contains?(&1, "<world> killed #{player}"))
      |> Enum.count()

    kills - world_deaths
  end

  @doc """
  Build a map with the kills of each player for all games of the log.

  ## Examples
  ```
      iex(4)> QuakeParser.scoreboard("test/fixtures/log.txt")
      %{
        "Assasinu Credi" => 22,
        "Chessus" => 0,
        "Dono da Bola" => 12,
        "Isgalamido" => 16,
        "Mal" => -3,
        "Oootsimo" => 20,
        "Zeh" => 9
      }
  ```
  """
  @spec scoreboard(String.t()) :: kill
  def scoreboard(path) do
    parse(path)
    |> Enum.map(fn %__MODULE__{kills: kills} -> kills end)
    |> build_full_scoreboard()
  end

  @doc """
  Parse the Quake log file, and return a map with the number of game in a row, and each value
  is another map with how much deaths per meaning.

  ## Examples
  ```
      iex> QuakeParser.death_report("test/fixtures/log.txt")
      %{
        0 => %{
          "MOD_FALLING" => 7,
          "MOD_MACHINEGUN" => 9,
          "MOD_RAILGUN" => 9,
          "MOD_ROCKET" => 78,
          "MOD_ROCKET_SPLASH" => 49,
          "MOD_SHOTGUN" => 7,
          "MOD_TRIGGER_HURT" => 20
        }
      }
  ```
  """
  @spec death_report(String.t()) :: %{non_neg_integer() => %{String.t() => non_neg_integer()}}
  def death_report(path) do
    File.stream!(path)
    |> find_games
    |> Enum.map(&game_kills/1)
    |> Enum.map(&build_death_report/1)
    |> Enum.with_index()
    |> Enum.map(fn {obj, index} -> {index, obj} end)
    |> Enum.into(%{})
  end

  defp build_full_scoreboard(scores), do: merge_scoreboards(scores, %{})

  defp merge_scoreboards([], result), do: result

  defp merge_scoreboards([score | tail], result) do
    merge_scoreboards(tail, Map.merge(result, score, fn _k, v1, v2 -> v1 + v2 end))
  end

  defp build_death_report(game_kills) do
    game_kills
    |> causes_of_death
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

  defp causes_of_death(game_kills) do
    game_kills
    |> Enum.map(&String.split(&1, "by "))
    |> Enum.map(fn [_, str] -> str end)
    |> List.flatten()
    |> Enum.uniq()
  end
end
