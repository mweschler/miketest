require "scripts/GameObject" --inherates from gameobject
local MAX_VELOCITY = 9
local JUMP_STRENGTH = 10

Player = {}

function Player.new()
	o = GameObject.new()
	o.baseUpdate = o.update
	local playerBody
	local playerFixture
	
	o.update = function(self)
		assert(playerBody)
		local velX, velY = playerBody:getLinearVelocity()
	
		if MOAIInputMgr.device.keyboard:keyIsDown(97) then --A
			self.X = self.X - 0.5
			if velX > (MAX_VELOCITY * -1) then
				playerBody:applyLinearImpulse(-1,0)
			end
		end
		
		if MOAIInputMgr.device.keyboard:keyIsDown(100) then --D
			self.X = self.X + 0.5
			if velX < MAX_VELOCITY then
				playerBody:applyLinearImpulse(1,0)
			end
		end
		
		if MOAIInputMgr.device.keyboard:keyIsDown(119) then --W
			self.Y = self.Y + 0.5
			if velY == 0 then
				playerBody:applyLinearImpulse(0,JUMP_STRENGTH)
				Audio.playSound("effects", "dummy")
			end
		end
		
		if MOAIInputMgr.device.keyboard:keyIsDown(115) then --S
			--guy:applyLinearImpulse(0,1)
			self.Y = self.Y - 0.5
		end
		--print(self.X, self.Y)
		--self:baseUpdate()
	end
	
	function o:addToWorld(world)
		playerBody = world:addBody(MOAIBox2DBody.DYNAMIC)
		playerFixture = playerBody:addRect(-.5,-.5,.5,.5)
		playerBody:setTransform(self.X, self.Y)
		playerBody:setFixedRotation(true)
		playerFixture:setDensity(1)
		playerFixture:setFriction(2)
		playerBody:resetMassData()
		
		self.prop:setParent(playerBody)
	end
	
	return o
end

return Player