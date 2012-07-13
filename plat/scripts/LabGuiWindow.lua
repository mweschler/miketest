--[[
	Part of the LabGui. Basic window for common elements
]]

local _Window = {}

--Intilize the window system
function _Window.initilize(background)
	if background then
		local bDeck = MOAIDeck2D.new()
		bDeck:setTextrue(background)
		_Window.bDeck = bDeck
	else
		print("Could not initilize window, no background specified")
	end
end

--Create a new window with the default settings
function _Window.new()
	if not Window.bDeck then
		print("Error: Window not initilized, could not create new window")
		return
	end

	local o = {width = 100, height = 100, x = 0, y = 0}

	o.prop = MOAIProp2D.new()
	prop:setDeck(_Window.bDeck)
	prop:setFrame(x, y, x + width, y + height)
	prop:setVisable(false)
	
	return o
end

return _Window