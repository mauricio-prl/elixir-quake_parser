defmodule QuakeParser.DeathReport do
  @moduledoc """
  Given a list of deaths, return a map with the number of deaths per meaning.
  """

  @doc """
  ## Examples:
  ```
      iex>game_kills = ["  1:08 Kill: 3 2 6: Isgalamido killed Mocinha by MOD_ROCKET",
      iex>"  1:26 Kill: 1022 4 22: <world> killed Zeh by MOD_TRIGGER_HURT",
      iex>"  1:32 Kill: 1022 4 22: <world> killed Zeh by MOD_TRIGGER_HURT",
      iex>"  1:41 Kill: 1022 2 19: <world> killed Dono da Bola by MOD_FALLING"]
      iex> QuakeParser.DeathReport.call(game_kills)
      %{"MOD_FALLING" => 1, "MOD_ROCKET" => 1, "MOD_TRIGGER_HURT" => 2}
  ```
  """
  def call(game_kills) do
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
