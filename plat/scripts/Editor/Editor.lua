--[[ Basic editor. Singleton ]]
local gui = require ('gui.gui')
local filesystem = require ('gui.support.filesystem')
local inputconstants = require ('gui.support.inputconstants')
local resources = require ('gui.support.resources')

local Editor = {}
Editor.Input = require('Editor.Input')

-- constants
local MIN_EDITOR_LAYER = 9000
local BASE_LAYER = "editorBase"

--local private data
local isReady = false
local isVisible = false
local currentState = -1
local topGuiLayer = -1
local screenDimensions = {}


--initilizes the editor *references outside variables*
function Editor.init(screenWidth, screenHeight)
	--parameter checking
	if type(screenWidth) ~= 'number' and type(screenHeight) ~= 'number' then
		error("screenWidth and screenHeight must both be specified", 2)
	end
	
	if isReady then
		error("cannot initilize editor once previously initilized", 2)
	end
	
	screenDimensions.width = screenWidth
	screenDimensions.height = screenHeight
	
	--setup states
	
	--setup gui elements
	Editor._gui = gui.GUI(screenWidth, screenHeight)
	assert( MIN_EDITOR_LAYER > 0 )
	LayerManager.addLayer(BASE_LAYER, MIN_EDITOR_LAYER, Editor._gui:layer())
	LayerManager.hideLayer(BASE_LAYER)
	topGuiLayer = MIN_EDITOR_LAYER
	
	Editor._gui:addToResourcePath(filesystem.pathJoin("resources", "fonts"))
	Editor._gui:addToResourcePath(filesystem.pathJoin("resources", "gui"))
	Editor._gui:addToResourcePath(filesystem.pathJoin("resources", "media"))
	Editor._gui:addToResourcePath(filesystem.pathJoin("resources", "themes"))
	
	--[[ Need to setup a layouts for gui  ]]
	
	--setup input controls
	
	Editor.Input.registerSet(Editor.Input.masterSet)
	
	
	isReady = true
end

function Editor.show()
	if isVisible then
		return
	end
	
	Editor.Input.resumeAll()
	LayerManager.showLayer(BASE_LAYER)
	isVisible = true
end

function Editor.hide()
	if not isVisible then
		return
	end
	
	Editor.Input.pauseAll()
	LayerManager.hideLayer(BASE_LAYER)
	isVisible = false
end

function Editor.isVisible()
	return isVisible
end

function Editor.isReady()
	return isReady
end

function Editor.getScreenWidth()
	return screenDimensions.width
end

function Editor.getScreenHeight()
	return screenDimensions.height
end

return Editor
