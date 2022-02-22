defmodule QuakeParserTest do
  use ExUnit.Case, async: true
  doctest QuakeParser

  describe "start/1" do
    test "raises an error when invalid filepath" do
      invalid_path = "invalid_path.txt"

      assert QuakeParser.start(invalid_path) == {:error, :enoent}
    end

    test "returns a list of Game struct" do
      assert QuakeParser.start("test/fixtures/log.txt") == [
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
                 players: [
                   "Oootsimo",
                   "Isgalamido",
                   "Zeh",
                   "Dono da Bola",
                   "Mal",
                   "Assasinu Credi",
                   "Chessus"
                 ],
                 total_kills: 130
               }
             ]
    end
  end

  describe "death_report/1" do
    test "returns a map of games, and each map contains the number of deaths per meaning" do
      assert QuakeParser.death_report("test/fixtures/log.txt") == %{
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
    end
  end
end
