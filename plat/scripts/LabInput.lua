-- Simple input control system. Registers and removes callbacks

local _Input = {}

local callbacks = {}
local keyCallbacks = {}

local CB_TYPE = {}
CB_TYPE.KEYBOARD = "keyboard"
CB_TYPE.MOUSE = "mouse"

-- Helper Functions
local function _createCallbackData()
	local cb ={}
	cb.name = ""
	cb.type = ""
	cb.priority = 0
	cb.func = nil
	
	return cb
end

local function _registerCallback(cb)
	local ctable = nil
	if cb.type == CB_TYPE.KEYBOARD then
		ctable = keyCallbacks
	end
	
	assert (ctable ~= nil, "No appropriate callback table found")
	
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
	assert (priority ~= nil and func ~= nil)
	
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
	local cbTable = nil
	if cbType == CB_TYPE.KEYBOARD then
		cbTable = keyCallbacks
	end
	
	assert (cbTable ~= nil, "No appropriate callback table found")
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



--End Helper functions

-- Public functions

--registers a new keybaord callback
function _Input.registerKeyCallback(name, priority, func)
	_multiRegister(CB_TYPE.KEYBOARD, name, pripority, func)
end

--pushes a keyboard callback at the lowest priority
function _Input.pushKeyCallback(name, func)
	_multiRegister(CB_TYPE.KEYBOARD, name, #keyCallbacks + 1, func)
end

--Clears a callback from the list by name
function _Input.clearCallback(name)
	assert (name ~= nil)
	local cb = callbacks[name]
	
	if cb == nil then
		MOAILogMgr.log("Callback with name \"" .. name .. "\" not found. Doing nothing\n")
		return
	end
	
	local cbTable = nil
	if cb.type == CB_TYPE.KEYBOARD then
		cbTable = keyCallbacks
	end
	
	assert (cbTable ~= nil, "could not find appropriate callback table")
	
	for i, v in ipairs(cbTable) do
		if v.name == name then
			table.remove(cbTable, i)
		end
	end
	
	callbacks[name] = nil
end

--Initilizes the Input system
function _Input.init()
	MOAIInputMgr.device.keyboard:setCallback(_handleKeyboard)
end



return _Input