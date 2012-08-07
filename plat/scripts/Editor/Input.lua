local EdInput = {}

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
	
	
end

local masterSet = EdInput.newSet("master", MASTER_DEFAULT)
masterSet.key = EditorKey
masterSet.point = EditorPointer
masterSet.lclick = EditorLClick
masterSet.rclick = EditorRClick

EdInput.masterSet = masterSet

return EdInput