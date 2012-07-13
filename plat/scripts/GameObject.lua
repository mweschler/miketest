GameObject = {}

function GameObject.new(texture)
	local o = {}
	
	o.prop = MOAIProp2D.new()
	o.deck = MOAIGfxQuad2D.new()
	
	if texture then 
		o.texture = texture
		o.deck:setTexture(o.texture)
	else 
		o.texture = nil
	end
	
	o.X = 0
	o.Y = 0
	o.prop:setLoc(o.X, o.Y)
	
	o.prop:setDeck(o.deck)
	
	function o:update()
		self.prop:setLoc(self.X, self.Y)
	end
	
	function o:addToLayer(layer)
		layer:insertProp(self.prop)
	end
	
	function o:removeFromLayer(layer)
		layer:removeProp(self.prop)
	end
	
	function o:setTexture(texture)
		self.texture = texture
		self.deck:setTexture(texture)
	end
	
	return o
end

return GameObject