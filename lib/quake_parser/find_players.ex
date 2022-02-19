defmodule QuakeParser.FindPlayers do
  def call(game) do
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
end
