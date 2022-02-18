defmodule QuakeParserTest do
  use ExUnit.Case
  doctest QuakeParser

  describe "start/1" do
    test "raises an error when invalid filepath" do
      invalid_path = "invalid_path.txt"

      assert_raise RuntimeError, "Invalid file path: #{invalid_path}", fn ->
        QuakeParser.start(invalid_path)
      end
    end

    test "returns a list of Game struct" do
    end
  end
end
