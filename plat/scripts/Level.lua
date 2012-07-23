local _Level = {}
local currentLevel
local levelLayer
local currentWorld
local levelTileSet
local levelProp

--creates a new level object
function _Level.new()
	local o = {}
	o.grid = dofile("levels/blank.lua")
	local name = "Level"
	o.sizeX = 32
	o.sizeY = 18
	
	function o:setName(name)
		self.name = name
	end
	
	function o:getName()
		return self.name
	end
	
	function o:setTile(x,y,value)
		self.grid:setTile(x,y,value)
	end
	
	return o

end

function _Level.getCurrentLevel()
	return currentLevel
end

function _Level.getCurrentWorld()
	return currentWorld
end

function _Level.getLevelLayer()
	return levelLayer
end

--creates a static box at the specified location
local function createStatic(x, y, world)
	assert(world)
	local body = world:addBody(MOAIBox2DBody.STATIC)
	body:addRect(-.5,-.5, .5, .5)
	body:setTransform(x,y)
end

--itirator for a grid, returns the x,y of grid and the tile
local function gridLevelItir(level)
	local row = 1
	local col = 0
	
	return function()
			col = col + 1
			
			if col > level.sizeX then --wrap around
				row = row + 1
				col = 1
			end
			
			if row <= level.sizeY then				
				return col, row, level.grid:getTile(col, row)
			end
		end
end

--moves through a level grid and creates the static bodies
local function bodiesFromLevel(world, level)
	for x,y,tile in gridLevelItir(level) do
		if tile == 0x1 then
			createStatic(x - ((level.sizeX / 2) + .5),y - ((level.sizeY /2) + .5 ), world)
		end
	end
	
end

--loads a level as the active game world(ASSUMES NO PREVIOUS LEVEL ATM)
function _Level.load(level, tileset)
	currentLevel = level
	
	--set tileset
	assert(tileset)
	levelTileSet = tileset
	
	--setup level onto render
	levelLayer = MOAILayer.new()
	levelLayer:setViewport(viewport)
	levelProp = MOAIProp2D.new()
	levelProp:setDeck(levelTileSet)
	levelProp:setGrid(level.grid)
	levelProp:setLoc((level.sizeX / 2) * -1,(level.sizeY / 2) * -1)
	
	levelLayer:insertProp(levelProp)
	LayerManager.addLayer("level", 1, levelLayer)

	--Create physics for level
	currentWorld = MOAIBox2DWorld.new()
	currentWorld:setGravity ( 0, -10 )
	currentWorld:setUnitsToMeters ( 1 )
	bodiesFromLevel(currentWorld, currentLevel)
	
	
	currentWorld:start()

	if DEBUG_DRAW_PHYSICS then
		--add to debug layer NYI		
	end
	
	
end

return _Level