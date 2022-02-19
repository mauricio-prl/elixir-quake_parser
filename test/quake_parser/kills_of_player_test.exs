defmodule QuakeParser.KillsOfPlayerTest do
  use ExUnit.Case, async: true
  doctest QuakeParser.KillsOfPlayer

  describe ".call/1" do
    setup do
      kills = [
        "3:51 Kill: 1022 4 19: <world> killed Zeh by MOD_FALLING",
        "3:55 Kill: 1022 5 22: <world> killed Dono da Bola by MOD_TRIGGER_HURT",
        "4:07 Kill: 7 2 7: Assasinu Credi killed Oootsimo by MOD_ROCKET_SPLASH",
        "4:12 Kill: 5 3 7: Dono da Bola killed Isgalamido by MOD_ROCKET_SPLASH",
        "4:13 Kill: 2 6 6: Oootsimo killed Mal by MOD_ROCKET",
        "4:23 Kill: 1022 4 22: <world> killed Zeh by MOD_TRIGGER_HURT",
        "4:23 Kill: 2 5 6: Oootsimo killed Dono da Bola by MOD_ROCKET",
        "4:26 Kill: 1022 6 22: <world> killed Mal by MOD_TRIGGER_HURT",
        "4:34 Kill: 7 5 7: Assasinu Credi killed Dono da Bola by MOD_ROCKET_SPLASH",
        "4:36 Kill: 2 3 6: Oootsimo killed Isgalamido by MOD_ROCKET",
        "4:39 Kill: 7 7 7: Assasinu Credi killed Assasinu Credi by MOD_ROCKET_SPLASH",
        "4:39 Kill: 7 6 7: Assasinu Credi killed Mal by MOD_ROCKET_SPLASH",
        "4:40 Kill: 4 5 6: Zeh killed Dono da Bola by MOD_ROCKET",
        "4:51 Kill: 4 2 1: Zeh killed Oootsimo by MOD_SHOTGUN",
        "4:52 Kill: 5 6 7: Dono da Bola killed Mal by MOD_ROCKET_SPLASH",
        "4:57 Kill: 3 7 10: Isgalamido killed Assasinu Credi by MOD_RAILGUN",
        "4:58 Kill: 2 5 7: Oootsimo killed Dono da Bola by MOD_ROCKET_SPLASH",
        "5:06 Kill: 4 6 7: Zeh killed Mal by MOD_ROCKET_SPLASH",
        "5:11 Kill: 7 5 7: Assasinu Credi killed Dono da Bola by MOD_ROCKET_SPLASH",
        "5:13 Kill: 3 6 10: Isgalamido killed Mal by MOD_RAILGUN",
        "5:18 Kill: 3 7 10: Isgalamido killed Assasinu Credi by MOD_RAILGUN",
        "5:21 Kill: 7 3 6: Assasinu Credi killed Isgalamido by MOD_ROCKET",
        "5:23 Kill: 4 7 7: Zeh killed Assasinu Credi by MOD_ROCKET_SPLASH",
        "5:28 Kill: 6 7 6: Mal killed Assasinu Credi by MOD_ROCKET",
        "5:29 Kill: 5 2 6: Dono da Bola killed Oootsimo by MOD_ROCKET",
        "5:30 Kill: 1022 6 22: <world> killed Mal by MOD_TRIGGER_HURT",
        "5:32 Kill: 2 5 6: Oootsimo killed Dono da Bola by MOD_ROCKET",
        "5:37 Kill: 2 4 7: Oootsimo killed Zeh by MOD_ROCKET_SPLASH",
        "5:38 Kill: 7 6 1: Assasinu Credi killed Mal by MOD_SHOTGUN",
        "5:42 Kill: 2 7 7: Oootsimo killed Assasinu Credi by MOD_ROCKET_SPLASH",
        "5:47 Kill: 1022 6 22: <world> killed Mal by MOD_TRIGGER_HURT",
        "5:51 Kill: 2 7 7: Oootsimo killed Assasinu Credi by MOD_ROCKET_SPLASH",
        "5:54 Kill: 5 2 6: Dono da Bola killed Oootsimo by MOD_ROCKET",
        "5:54 Kill: 5 5 7: Dono da Bola killed Dono da Bola by MOD_ROCKET_SPLASH",
        "6:01 Kill: 1022 2 22: <world> killed Oootsimo by MOD_TRIGGER_HURT",
        "6:02 Kill: 3 6 10: Isgalamido killed Mal by MOD_RAILGUN",
        "6:04 Kill: 4 5 7: Zeh killed Dono da Bola by MOD_ROCKET_SPLASH",
        "6:08 Kill: 3 4 10: Isgalamido killed Zeh by MOD_RAILGUN",
        "6:14 Kill: 5 5 7: Dono da Bola killed Dono da Bola by MOD_ROCKET_SPLASH",
        "6:15 Kill: 1022 6 22: <world> killed Mal by MOD_TRIGGER_HURT",
        "6:19 Kill: 1022 3 19: <world> killed Isgalamido by MOD_FALLING",
        "6:20 Kill: 4 2 1: Zeh killed Oootsimo by MOD_SHOTGUN",
        "6:25 Kill: 5 4 6: Dono da Bola killed Zeh by MOD_ROCKET",
        "6:27 Kill: 6 5 1: Mal killed Dono da Bola by MOD_SHOTGUN",
        "6:29 Kill: 2 6 7: Oootsimo killed Mal by MOD_ROCKET_SPLASH",
        "6:32 Kill: 7 3 7: Assasinu Credi killed Isgalamido by MOD_ROCKET_SPLASH",
        "6:37 Kill: 2 7 6: Oootsimo killed Assasinu Credi by MOD_ROCKET",
        "6:39 Kill: 4 5 6: Zeh killed Dono da Bola by MOD_ROCKET",
        "6:39 Kill: 4 4 7: Zeh killed Zeh by MOD_ROCKET_SPLASH",
        "6:39 Kill: 1022 2 22: <world> killed Oootsimo by MOD_TRIGGER_HURT"
      ]

      {:ok, kills: kills}
    end

    test "returns the number of kills of a player in a game", %{kills: kills} do
      assert {"Zeh", 6} == QuakeParser.KillsOfPlayer.call("Zeh", kills)
    end
  end
end
