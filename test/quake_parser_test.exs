defmodule QuakeParserTest do
  use ExUnit.Case, async: true
  doctest QuakeParser

  describe "start/1" do
    test "raises an error when invalid filepath" do
      invalid_path = "invalid_path.txt"

      assert_raise RuntimeError, "Invalid file path: #{invalid_path}", fn ->
        QuakeParser.start(invalid_path)
      end
    end

    test "returns a list of Game struct" do
      assert QuakeParser.start("test/fixtures/log.txt") == [
               %QuakeParser.Game{
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
end
