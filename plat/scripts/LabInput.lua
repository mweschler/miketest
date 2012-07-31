-- Simple input control system. Registers and removes callbacks

local _Input = {}

local callbacks = {}
local paused = {}
local keyCallbacks = {}
local pointerCallbacks = {}
local lclickCallbacks = {}
local rclickCallbacks = {}

local CB_TYPE = {}
CB_TYPE.KEYBOARD = "keyboard"
CB_TYPE.POINTER = "pointer"
CB_TYPE.LCLICK = "lclick"
CB_TYPE.RCLICK = "rclick"

-- Helper Functions
local function _createCallbackData()
	local cb ={}
	cb.name = ""
	cb.type = ""
	cb.priority = 0
	cb.func = nil
	
	return cb
end

local function _getTypeTable(cbType)
	local ctable = nil
	if cbType == CB_TYPE.KEYBOARD then
		ctable = keyCallbacks
	end
	if cbType == CB_TYPE.POINTER then
		ctable = pointerCallbacks
	end
	if cbType == CB_TYPE.LCLICK then
		ctable = lclickCallbacks
	end
	if cbType == CB_TYPE.RCLICK then
		ctable = rclickCallbacks
	end
	
	assert (ctable ~= nil, "No appropriate callback table found")
	
	return ctable
end

local function _registerCallback(cb)
	local ctable = _getTypeTable(cb.type)
	
	local added = false
	
	for i, v in ipairs(ctable) do
		if cb.priority < v.priority then
			table.insert(ctable, i, cb)
			added = true
			break
		end
	end
	
	if not added then
		table.insert(ctable, #ctable + 1, cb)
	end
end

local function _multiRegister(inputType, name, priority, func)
	assert (priority ~= nil , "priority cannot be nil")
	assert (func ~= nil, "func cannot be nil")
	
	local cfunc = callbacks[name]
	if cfunc == nil then
		cfunc = _createCallbackData()
	end
	
	cfunc.name = name
	cfunc.type = inputType
	cfunc.priority = priority
	cfunc.func = func
	
	callbacks[name] = cfunc
	print ("callback registered", name, callbacks[name])
	_registerCallback(cfunc)
end

local function _handleCallback(cbType, ...)
	local cbTable = _getTypeTable(cbType) 
	
	local data = {}
	
	for i,v in ipairs(arg) do
		data[i] = v
	end
	
	for i,v in ipairs(cbTable) do
		v.func(data) --check for a rv? Could be used to only cascade if unhandled
	end
end

local function _handleKeyboard(key, down)
	_handleCallback(CB_TYPE.KEYBOARD, key, down)
end

local function _handlePointer( x, y)
	_handleCallback(CB_TYPE.POINTER, x, y)
end

local function _handleLClick(down)
	_handleCallback(CB_TYPE.LCLICK, down)
end

local function _handleRClick(down)
	_handleCallback(CB_TYPE.RCLICK, down)
end



--End Helper functions

-- Public functions

--registers a new keybaord callback
function _Input.registerKeyCallback(name, priority, func)
	_multiRegister(CB_TYPE.KEYBOARD, name, priority, func)
end

--pushes a keyboard callback at the lowest priority
function _Input.pushKeyCallback(name, func)
	_multiRegister(CB_TYPE.KEYBOARD, name, #keyCallbacks + 1, func)
end

function _Input.registerPointerCallback(name, priority, func)
	_multiRegister(CB_TYPE.POINTER, name, priority, func)
end

function _Input.registerLClickCallback(name, priority, func)
	_multiRegister(CB_TYPE.LCLICK, name, priority, func)
end

function _Input.regitstRClickCallback(name, priority, func)
	_multiRegister(CB_TYPE.RCLICK, name, priority, func)
end

--Clears a callback from the list by name
function _Input.clearCallback(name)
	assert (name ~= nil)
	local cb = callbacks[name]
	
	if cb == nil then
		MOAILogMgr.log("Callback with name \"" .. name .. "\" not found. Doing nothing\n")
		return
	end
	
	local cbTable = _getTypeTable(cb.type)
	
	for i, v in ipairs(cbTable) do
		if v.name == name then
			table.remove(cbTable, i)
		end
	end
	
	callbacks[name] = nil
end

function _Input.pauseCallback(name)
	if type(name) ~= 'string' then
		error("name of callback must be specified", 2)
	end
	
	local cb = callbacks[name]
	if cb == nil then
		MOAILogMgr.log("Callback with name \"" .. name .. "\" not found. Doing nothing\n")
		return
	end
	
	if paused[name] ~= nil then
		MOAILogMgr.log("Attmpted to pause already paused callback with name \"" .. name .."\"")
		return
	end
	
	local cbTable = _getTypeTable(cb.type)
	
	for i, v in ipairs(cbTable) do
		if v.name == name then
			table.remove(cbTable,i)
		end
	end
	
	paused[name] = cb
end

function _Input.resumeCallback(name)
	if type(name) ~= 'string' then
		error("name of callback must be specified", 2)
	end
	
	local cb = callbacks[name]
	if cb == nil then
		MOAILogMgr.log("Callback with name \"" .. name .. "\" not found. Doing nothing\n")
		return
	end
	
	if paused[name] == nil then
		MOAILogMgr.log("Attempted to resume callback that was not paused with name \"" .. name "\"")
		return
	end
	
	local cbTable = _getTypeTable(cb.type)
	
	local added  = false
	for i,v in ipairs(cbTable) do
		if v.priority < cb.priority then
			table.insert(cbTable, i, cb)
			added = true
			break
		end
	end
	
	if not added then
		table.insert(cbTable, #cbTable + 1, cb)
	end
	
	paused[name] = nil
end

--Initilizes the Input system
function _Input.init()
	MOAIInputMgr.device.keyboard:setCallback(_handleKeyboard)
	MOAIInputMgr.device.pointer:setCallback(_handlePointer)
	MOAIInputMgr.device.mouseLeft:setCallback(_handleLClick)
	MOAIInputMgr.device.mouseRight:setCallback(_handleRClick)
end



return _Input