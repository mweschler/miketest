local EdInput = {}

local activeSets = {}

local MASTER_DEFAULT = 2
local EDITOR_SUFFIX = "_ED"
local KEY_SUFFIX = EDITOR_SUFFIX .. "_Key"
local POINTER_SUFFIX = EDITOR_SUFFIX .. "_Pointer"
local LCLICK_SUFFIX = EDITOR_SUFFIX .. "_Lclick"
local RCLICK_SUFFIX = EDITOR_SUFFIX .. "_Rclick"

function EdInput.newSet(name, priority)
	local data = {}
	data.name = name
	data.priority = priority
	data.key = nil
	data.point = nil
	data.lclick = nil
	data.rclick = nil
	
	return data
end

local function EditorKey (data)
	local key = data[1]
	local down = data[2]
	
	print ("Key", key, "down =", down)
end

local function EditorPointer(data)

end

local function EditorLClick(data)

end

local function EditorRClick(data)

end

function EdInput.removeSet(name)
	if type(name) ~= 'string' or name == "" then
		error("Set has invalid name",2)
	end
	
	set = activeSets[name]
	if set == nil then
		MOAILogMgr.log("Set '" .. name .."' not found to be removed. Ignoring.")
		return
	end
	
	if set.key ~= nil and type(set.key) == 'function' then
		local keyname = set.name .. KEY_SUFFIX
		Input.clearCallback(keyname)
	end
	
	if set.point ~= nil and type(set.point) == 'function' then
		local pointname = set.name .. POINTER_SUFFIX
		Input.clearCallback(pointname)
	end
	
	if set.lclick ~= nil and type(set.lclick) == 'function' then
		local lname = set.name .. LCLICK_SUFFIX
		Input.clearCallback(lname)
	end
	
	if set.rclick ~=  nil and type(set.rclick) == 'function' then
		local rname = set.name .. RCLICK_SUFFIX
		Input.clearCallback(rname)
	end
	
	activeSets[name] = nil
end

function EdInput.registerSet(set)
	if set == nil  or type(set) ~= 'table' then
		error("Invalid argument for set", 2)
	end
	
	if type(set.name) ~= 'string' or set.name == "" then
		error("Set has invalid name",2)
	end
	
	if set.priority == nil or set.priority < 1 then
		error("Set has an invalid priority",2)
	end
	
	--if a set with this name already is active, deactivate previous
	if activeSets[set.name] ~= nil then
		MOAILogMgr.log("Set '" .. set.name .. "' already exists, deactivating it first\n")
		EdInput.removeSet(set.name)
	end
	
	if set.key ~= nil and type(set.key) == 'function' then
		local keyname = set.name .. KEY_SUFFIX
		Input.registerKeyCallback(keyname, set.priority, set.key)
	end
	
	if set.point ~= nil and type(set.point) == 'function' then
		local pointname = set.name .. POINTER_SUFFIX
		Input.registerPointerCallback(pointname, set.priority, set.point)
	end
	
	if set.lclick ~= nil and type(set.lclick) == 'function' then
		local lname = set.name .. LCLICK_SUFFIX
		Input.registerLClickCallback(lname, set.priority, set.lclick)
	end
	
	if set.rclick ~=  nil and type(set.rclick) == 'function' then
		local rname = set.name .. RCLICK_SUFFIX
		Input.registerRClickCallback(rname, set.priority, set.rclick)
	end
	
	activeSets[set.name] = set
end

function EdInput.pauseSet(name)
	if type(name) ~= 'string' or name == "" then
		error("Set has invalid name",2)
	end
	
	set = activeSets[name]
	if set == nil then
		MOAILogMgr.log("Set '" .. name .."' not found to be puased. Ignoring.")
		return
	end
	
	if set.key ~= nil and type(set.key) == 'function' then
		local keyname = set.name .. KEY_SUFFIX
		Input.pauseCallback(keyname)
	end
	
	if set.point ~= nil and type(set.point) == 'function' then
		local pointname = set.name .. POINTER_SUFFIX
		Input.pauseCallback(pointname)
	end
	
	if set.lclick ~= nil and type(set.lclick) == 'function' then
		local lname = set.name .. LCLICK_SUFFIX
		Input.pauseCallback(lname)
	end
	
	if set.rclick ~=  nil and type(set.rclick) == 'function' then
		local rname = set.name .. RCLICK_SUFFIX
		Input.pauseCallback(rname)
	end
	
end

function EdInput.resumeSet(name)
	if type(name) ~= 'string' or name == "" then
		error("Set has invalid name",2)
	end
	
	set = activeSets[name]
	if set == nil then
		MOAILogMgr.log("Set '" .. name .."' not found to be resumed. Ignoring.")
		return
	end
	
	if set.key ~= nil and type(set.key) == 'function' then
		local keyname = set.name .. KEY_SUFFIX
		Input.resumeCallback(keyname)
	end
	
	if set.point ~= nil and type(set.point) == 'function' then
		local pointname = set.name .. POINTER_SUFFIX
		Input.resumeCallback(pointname)
	end
	
	if set.lclick ~= nil and type(set.lclick) == 'function' then
		local lname = set.name .. LCLICK_SUFFIX
		Input.resumeCallback(lname)
	end
	
	if set.rclick ~=  nil and type(set.rclick) == 'function' then
		local rname = set.name .. RCLICK_SUFFIX
		Input.resumeCallback(rname)
	end
end

function EdInput.pauseAll()
	for key, value in pairs(activeSets) do
		EdInput.pauseSet(key)
	end
end

function EdInput.resumeAll()
	for key, value in pairs(activeSets) do
		EdInput.resumeSet(key)
	end
end

local masterSet = EdInput.newSet("master", MASTER_DEFAULT)
masterSet.key = EditorKey
masterSet.point = EditorPointer
masterSet.lclick = EditorLClick
masterSet.rclick = EditorRClick

EdInput.masterSet = masterSet

return EdInput