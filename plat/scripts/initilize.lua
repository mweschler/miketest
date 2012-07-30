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