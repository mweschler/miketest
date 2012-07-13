world = MOAIBox2DWorld.new()
world:setGravity ( 0, -10 )
world:setUnitsToMeters ( 1 )
world:start ()
gEntityLayer:setBox2DWorld(world)

local platform = world:addBody( MOAIBox2DBody.STATIC )
platform:setTransform(0,-8.5)
local pfix =  platform:addRect(-16,-.5, 16,.5)
pfix:setFriction(1)


local top = world:addBody( MOAIBox2DBody.STATIC )
top:setTransform(0,8.5)
local tfix =  top:addRect(-16,-.5, 16,.5)

local leftp = world:addBody( MOAIBox2DBody.STATIC )
leftp:setTransform(-15.5,0)
local lfix =  leftp:addRect(-.5,-8,.5,8)

local rightp = world:addBody( MOAIBox2DBody.STATIC )
rightp:setTransform(15.5,0)
local rfix =  rightp:addRect(-.5,-8,.5,8)

local middlep = world:addBody(MOAIBox2DBody.STATIC)
middlep:setTransform( 0,-5)
local mfix = middlep:addRect(-5,-.5, 5,.5)

guy = world:addBody( MOAIBox2DBody.DYNAMIC)
gfix = guy:addRect(-.5,-.5,.5,.5)
guy:setFixedRotation(true)
gfix:setDensity(1)
gfix:setFriction(2)
guy:resetMassData()


player.prop:setParent(guy)