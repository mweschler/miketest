
AudioTest = {}
Audio.playSound("effects", "dummy", true)


local lastTime = 0
local testLast = 0


function AudioTest.update()
	local currentTime = MOAISim.getElapsedTime()
	if (currentTime - lastTime > 1) then
		print("Total Playing:", Audio.getTotalPlaying(), "Master Volume:", Audio.getMasterVolume(), "Effects Volume:", Audio.getGroupVolume("effects"))
		lastTime = currentTime
	end
	
	if (currentTime - testLast > 5) then
		Audio.stopLabel("dummy")
		testLast = currentTime
	end
	
end