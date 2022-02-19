defmodule QuakeParser.KillsOfPlayer do
  @doc """
  Given a player name and the kills of a game, returns the number of kills of that player
  discounting world kills.

  ## Examples
  ```
      iex> game_kills = ["3:51 Kill: 1022 4 19: <world> killed Isgalamido by MOD_FALLING",
      iex>"4:57 Kill: 3 7 10: Isgalamido killed Assasinu Credi by MOD_RAILGUN",
      iex>"4:57 Kill: 3 7 10: Isgalamido killed Zeh by MOD_RAILGUN"]
      iex> QuakeParser.KillsOfPlayer.call("Isgalamido", game_kills)
      {"Isgalamido", 1}
  ```
  """
  def call(player, game_kills) do
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
end
