local gameType = {
	index = 1,
	types = {
		"█ Eğlenceli Roleplay!",
		"█ En Yüksek FPS!",
		"█ FPS & LAG Sıkıntısı Yok!",
		"█ Reval Roleplay v" .. getServerSettings().version
	}
}

setTimer(function()
	if gameType.index >= #gameType.types then
        gameType.index = 1
	else
		gameType.index = gameType.index + 1
    end
	setGameType(gameType.types[gameType.index])
end, 1000 * 5, 0)