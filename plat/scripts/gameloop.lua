require "scripts/Player"



gRunning = true

function gameloop ()
	while gRunning do
		coroutine.yield()
		Audio.update()
		player:update()
	end
end