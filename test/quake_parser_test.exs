defmodule QuakeParserTest do
  use ExUnit.Case
  doctest QuakeParser

  test "greets the world" do
    assert QuakeParser.hello() == :world
  end
end
