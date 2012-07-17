require "scripts/Player"


gRunning = true

function gameloop ()
	dofile("scripts/AudioTest.lua")

	while gRunning do
		coroutine.yield()
		Audio.update()
		player:update()
		
		AudioTest.update()
	end
end