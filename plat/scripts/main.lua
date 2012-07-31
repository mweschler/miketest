package.path = package.path .. ";.\\scripts\\?;.\\scripts\\?.lua"

require "scripts/gameloop"
DEVICE_WIDTH = 1280
DEVICE_HEIGHT = 720
ASPECT_WIDTH = 16
ASPECT_HEIGHT = 9

print("Initilizing window and viewpot")

--setup window and perserve aspect ratio
MOAISim.openWindow("Platformer", DEVICE_WIDTH, DEVICE_HEIGHT)
local gameAspect = ASPECT_HEIGHT / ASPECT_WIDTH
local realAspect = DEVICE_HEIGHT / DEVICE_WIDTH
if  realAspect == gameAspect then
	viewWidth = DEVICE_WIDTH
	viewHeight = DEVICE_HEIGHT
else
	if realAspect > gameAspect then
		viewWidth = DEVICE_WIDTH
		viewHeight = DEVICE_WIDTH * gameAspect
	else
		viewWidth = DEVICE_WIDTH * gameAspect
		viewHeight = DEVICE_HEIGHT
	end
end

viewOffsetX = 0
viewOffsetY = 0

if viewWidth < DEVICE_WIDTH then
	viewOffsetX = (DEVICE_WIDTH - viewWidth) * 0.5
end

if viewHeight < DEVICE_HEIGHT then
	viewOffsetY = (DEVICE_HEIGHT - viewHeight) * 0.5
end
	
print("vWidth =",viewWidth)
print("vHeight=", viewHeight)
print("offsetX =",viewOffsetX)
print("offsetY =", viewOffsetY)

--create viewport and set scale
viewport = MOAIViewport.new()
viewport:setSize(viewOffsetX,viewOffsetY,viewWidth + viewOffsetX, viewHeight + viewOffsetY)
viewport:setScale(32,18)

--Do initilization
dofile("scripts/initilize.lua")

--start the main game loop
print("Starting main gameloop")
mainthread = MOAIThread.new()
mainthread:run(gameloop)

print("Execution complete")