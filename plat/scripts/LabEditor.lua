--[[ Basic editor. Singleton ]]
local gui = require ('gui.gui')
local filesystem = require ('gui.support.filesystem')
local inputconstants = require ('gui.support.inputconstants')
local resources = require ('gui.support.resources')

local Editor = {}

local MIN_EDITOR_LAYER = 9000
local BASE_LAYER = "editorBase"

local isReady = false
local isVisible = false
local currentState = -1
local topGuiLayer = -1


--initilizes the editor *references outside variables*
function Editor.init(screenWidth, screenHeight)
	--parameter checking
	if type(screenWidth) ~= 'number' and type(screenHeight) ~= 'number' then
		error("screenWidth and screenHeight must both be specified", 2)
	end
	
	if isReady then
		error("cannot initilize editor once previously initilized", 2)
	end
	
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
	
	dofile('scripts/LabEditorInput.lua') --create input callback functions
	
	Input.registerKeyCallback("editorKey", 5, EditorKey)
	Input.registerPointerCallback("editorPointer", 5, EditorPointer)
	Input.registerLClickCallback("editorLClick", 5, EditorLClick)
	Input.registerRClickCallback("editorRClick", 5, EditorRClick)
	
	
	isReady = true
end

function Editor.show()
	if isVisible then
		return
	end
	
	LayerManager.showLayer(BASE_LAYER)
	isVisible = true
end

function Editor.hide()
	if not isVisible then
		return
	end
	
	LayerManager.hideLayer(BASE_LAYER)
	isVisible = false
end

function Editor.isVisible()
	return isVisible
end

function Editor.isReady()
	return isReady
end

return Editor
