defmodule QuakeParserTest do
  use ExUnit.Case
  doctest QuakeParser

  describe "start/1" do
    test "validates the file path" do
      invalid_path = "invalid_path.txt"
      valid_path = "test/fixtures/log.txt"

      assert QuakeParser.start(valid_path) =~ "InitGame: \\sv_floodProtec"

      assert_raise RuntimeError, "Invalid file path: #{invalid_path}", fn ->
        QuakeParser.start(invalid_path)
      end
    end
  end
end
