defmodule QuakeParser.DeathReportTest do
  use ExUnit.Case, async: true
  doctest QuakeParser.DeathReport

  describe ".call/1" do
    setup do
      game_kills = [
        "  1:08 Kill: 3 2 6: Isgalamido killed Mocinha by MOD_ROCKET",
        "  1:26 Kill: 1022 4 22: <world> killed Zeh by MOD_TRIGGER_HURT",
        "  1:32 Kill: 1022 4 22: <world> killed Zeh by MOD_TRIGGER_HURT",
        "  1:41 Kill: 1022 2 19: <world> killed Dono da Bola by MOD_FALLING"
      ]

      {:ok, game_kills: game_kills}
    end

    test "returns the number of death of each meaning", %{game_kills: game_kills} do
      assert %{"MOD_FALLING" => 1, "MOD_ROCKET" => 1, "MOD_TRIGGER_HURT" => 2} ==
               QuakeParser.DeathReport.call(game_kills)
    end
  end
end
