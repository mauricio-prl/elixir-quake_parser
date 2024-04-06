defmodule QuakeParserTest do
  use ExUnit.Case, async: true
  doctest QuakeParser

  describe "parse/1" do
    test "raises an error when invalid filepath" do
      assert_raise File.Error,
                   "could not stream \"invalid_path.txt\": no such file or directory",
                   fn ->
                     QuakeParser.parse("invalid_path.txt")
                   end
    end

    test "returns a list of Game struct" do
      assert QuakeParser.parse("test/fixtures/log.txt") == [
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

  describe "scoreboard/1" do
    test "returns a map with the score of each player for all games of the log" do
      assert QuakeParser.scoreboard("test/fixtures/log.txt") == %{
               "Assasinu Credi" => 22,
               "Chessus" => 0,
               "Dono da Bola" => 12,
               "Isgalamido" => 16,
               "Mal" => -3,
               "Oootsimo" => 20,
               "Zeh" => 9
             }
    end

    test "returns a map with all games score" do
      assert QuakeParser.scoreboard("test/fixtures/full_log.txt") == %{
               "Assasinu Credi" => 111,
               "Chessus" => 33,
               "Dono da Bola" => 63,
               "Fasano Again" => 0,
               "Isgalamido" => 147,
               "Mal" => -4,
               "Maluquinho" => 0,
               "Mocinha" => 0,
               "Oootsimo" => 114,
               "UnnamedPlayer" => 0,
               "Zeh" => 124
             }
    end
  end

  describe "death_report/1" do
    test "raises an error when invalid filepath" do
      assert_raise File.Error,
                   "could not stream \"invalid_path.txt\": no such file or directory",
                   fn ->
                     QuakeParser.death_report("invalid_path.txt")
                   end
    end

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
