require "scripts/Player"
Level = require "scripts/Level"
Audio = require "scripts/LabAudio"

print("Begin Initilization")

Audio.initilize()
Audio.loadSound("effects", "dummy", "sounds/mono16.wav")

--[[gGameLayer = MOAILayer.new()
gGameLayer:setViewport(viewport)
MOAISim.pushRenderPass(gGameLayer)]]

--dofile("scripts/blank_level.lua")

--gWorldGrid = dofile("levels/blank.lua")

gWorldTile = MOAITileDeck2D.new()
gWorldTile:setTexture("textures/tiles.png")
gWorldTile:setSize(2,1)
gWorldTile:setRect ( -0.5, 0.5, 0.5, -0.5 )

--[[
gWorldProp = MOAIProp2D.new()
gWorldProp:setDeck(gWorldTile)
gWorldProp:setGrid(gWorldGrid)
gWorldProp:setLoc(-16,-9)
gGameLayer:insertProp(gWorldProp)
]]
print("Loading level")
level = Level.new()
level:setTile(5,5,1)
level:setTile(6,5,1)
level:setTile(7,5,1)
Level.load(level, gWorldTile)


print("Creating Player")
player = Player.new()
ptex = MOAITexture.new ()
ptex:load ( "textures/stick.png" )
player:setTexture(ptex)
gEntityLayer = MOAILayer.new()
gEntityLayer:setViewport(viewport)
MOAISim.pushRenderPass(gEntityLayer)
player:addToLayer(gEntityLayer)
player:addToWorld(Level.getCurrentWorld())
gEntityLayer:setBox2DWorld(Level.getCurrentWorld())