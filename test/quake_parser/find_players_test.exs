defmodule QuakeParser.FindPlayersTest do
  use ExUnit.Case, async: true
  doctest QuakeParser.FindPlayers

  describe ".call/1" do
    setup do
      game = [
        " \\capturelimit\\8\\g_maxGameClients\\0\\timelimit\\15\\fraglimit\\20\\dmflags\\0\\bot_minplayers\\0\\sv_allowDownload\\0\\sv_maxclients\\16\\sv_privateClients\\2\\g_gametype\\0\\sv_hostname\\Code Miner Server\\sv_minRate\\0\\sv_maxRate\\10000\\sv_minPing\\0\\sv_maxPing\\0\\sv_floodProtect\\1\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\\baseq3\\g_needpass\\0",
        "3:32 ClientConnect: 2",
        "3:32 ClientUserinfoChanged: 2 n\\Oootsimo\\t\\0\\model\\razor/id\\hmodel\\razor/id\\g_redteam\\\\g_blueteam\\\\c1\\3\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0",
        "3:32 ClientBegin: 2",
        "3:32 ClientConnect: 3",
        "3:32 ClientUserinfoChanged: 3 n\\Isgalamido\\t\\0\\model\\uriel/zael\\hmodel\\uriel/zael\\g_redteam\\\\g_blueteam\\\\c1\\5\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0",
        "3:32 ClientBegin: 3",
        "3:32 ClientConnect: 4",
        "3:32 ClientUserinfoChanged: 4 n\\Zeh\\t\\0\\model\\sarge/default\\hmodel\\sarge/default\\g_redteam\\\\g_blueteam\\\\c1\\1\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0",
        "3:32 ClientBegin: 4",
        "3:32 ClientConnect: 5",
        "3:32 ClientUserinfoChanged: 5 n\\Dono da Bola\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0",
        "3:32 ClientBegin: 5",
        "3:32 ClientConnect: 6",
        "3:32 ClientUserinfoChanged: 6 n\\Mal\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0",
        "3:32 ClientBegin: 6",
        "3:32 ClientConnect: 7",
        "3:32 ClientUserinfoChanged: 7 n\\Assasinu Credi\\t\\0\\model\\sarge\\hmodel\\sarge\\g_redteam\\\\g_blueteam\\\\c1\\4\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0",
        "3:32 ClientBegin: 7"
      ]

      {:ok, game: game}
    end

    test "returns a list of players name given a game log", %{game: game} do
      assert ["Oootsimo", "Isgalamido", "Zeh", "Dono da Bola", "Mal", "Assasinu Credi"] ==
               QuakeParser.FindPlayers.call(game)
    end
  end
end
