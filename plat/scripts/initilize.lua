require "scripts/Player"
Level = require "scripts/Level"
Audio = require "scripts/LabAudio"
LayerManager = require "scripts/layermgr"
Input = require "scripts/LabInput"

print("Begin Initilization")

--Intilize Audio
Audio.initilize()
Audio.loadSound("effects", "dummy", "sounds/mono16.wav")
Input.init()

--setup tileset for level
gWorldTile = MOAITileDeck2D.new()
gWorldTile:setTexture("textures/tiles.png")
gWorldTile:setSize(2,1)
gWorldTile:setRect ( -0.5, 0.5, 0.5, -0.5 )

--load level
print("Loading level")
level = Level.new()
level:setTile(5,5,1)
level:setTile(6,5,1)
level:setTile(7,5,1)
Level.load(level, gWorldTile)

--create the player and set his physics up
print("Creating Player")
player = Player.new()
ptex = MOAITexture.new ()
ptex:load ( "textures/stick.png" )
player:setTexture(ptex)
gEntityLayer = MOAILayer.new()
gEntityLayer:setViewport(viewport)
LayerManager.addLayer("entity", 2, gEntityLayer)
player:addToLayer(gEntityLayer)
player:addToWorld(Level.getCurrentWorld())
gEntityLayer:setBox2DWorld(Level.getCurrentWorld())

--[[GUI test area]]
print "\n\n === GUI TESTING ===\n\n\n"
local world = Level.getCurrentWorld()
world:stop()

local gui = require "gui\\gui"
local filesystem = require "gui/support/filesystem"
local inputconstants = require "gui/support/inputconstants"
local resources = require "gui/support/resources"

g = gui.GUI(DEVICE_WIDTH, DEVICE_HEIGHT)
LayerManager.addLayer("gui", 9000, g:layer())

g:addToResourcePath(filesystem.pathJoin("resources", "fonts"))
g:addToResourcePath(filesystem.pathJoin("resources", "gui"))
g:addToResourcePath(filesystem.pathJoin("resources", "media"))
g:addToResourcePath(filesystem.pathJoin("resources", "themes"))

g:setTheme("basetheme.lua")
g:setCurrTextStyle("default")
local window = g:createWindow()
window:setPos(10,10)
window:setDim(25,20)
window:setBackgroundImage(resources.getPath("background.png"))
local button = g:createButton()

window:addChild(button)
button:setPos(1,1)
button:setDim(5,5)

function guiKeyboard(data)
	local key = data[1]
	local down = data[2]
	if down then
		g:injectKeyDown(key)
	else
		g:injectKeyUp(key)
	end
end

Input.registerKeyCallback("guiKey", 5, guiKeyboard)

