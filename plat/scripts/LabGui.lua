--[[
	Library for a simple GUI.
]]

local _LabGui = {}
_LabGui.Window = require "../scripts/LabGuiWindow.lua"
local _guiLayer
local _guiElements = {}
local _nextID = 1

-- Initilize the GUI for use
function _LabGui.intilize(viewport, background)
	--Check for non nil arguments
	if not (viewport and background) then
		print("Error: could not intilize gui. Invalid argurments")
		return
	end
	
	--setup the gui layer for display
	_guiLayer = MOAILayer.new()
	_guiLayer:setViewport(viewport)
	MOAISim.setRenderPass(_guiLayer)
	
	_LabGui.Window.initilize(background)
end

--accesor for layer
function _LabGui.getLayer()
	return _guiLayer
end

--call on update to have gui handle input for itself
function _LabGui.handleInput()
end

--creates a new message box with text and ok button. Callback can be set for button
function _LabGui.newMessageBox(text)
	if _guiLayer == nil then --check for intilization
		print("Error: GUI not initillized. Could not create Message Box")
		return
	end
	
	local o = {}
	if type(text) == string then
		o.text = text
	else
		o.text = ""
	end
	
	o.callback = function () end --default do nothing callback
	
	o.window = _LabGui.Window.new()
	
	--shows the message box and registers it for input
	function o:display()
	end
	
	--changes the text of the message box
	function o:setText(text)
		if type(text) == string then
		self.text = text
	end
	
	--sets the callback of the message box
	function o:setCallback(callb)
		if type(callb) == function then
			o.callback = callb
		end
	end
	
	--input recived on messagebox area, do something about it
	function o:handleInput()
	end
	
	return o
end

return _LabGui