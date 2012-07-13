--[ LAB Audio System ]

local _Audio = {}
_Audio.running = false

_Audio._Groups = {}
_Audio._Volumes = {}
_Audio._Playing = {}

--Initilizes the audio system
function _Audio.initilize()
	assert(_Audio.running ~= true, "Audio system already initilized")
	
	print "Initilizing Audio system"
	
	MOAIUntzSystem.initialize()
	
	_Audio.running = true	
end

--creates a sound data structure
function _Audio._createSoundData(group, label, sound)
	local data = {}
	data.sound = sound
	data.group = group
	data.label = label
	return data
end

--removes any stoped audio
function _Audio._cullPlaying()
	for i, v in ipairs(_Audio._Playing) do
		if  not(v.sound:isPlaying() or v.sound:isPaused()) then
			table.remove(_Audio._Playing,i)
		end
	end
end

--main update function for the audio system. must be called every cycle
function _Audio.update()
	assert(_Audio.running == true, "Audio system not initilized")
	
	_Audio._cullPlaying() --remove anything finished playing
end

--returns the total number of sounds playing
function _Audio.getTotalPlaying()
	assert(_Audio.running == true, "Audio system not initilized")
	
	return # _Audio._Playing
end

--Plays a sound Immediatly from a file
function _Audio.playSoundImmediate(filename)
	assert(_Audio.running == true, "Audio system not initilized")
	
	if not filename or type(filename) ~= "string" then
		print "Invalid parameter for filename, doing nothing"
		return
	end
	--create a new sound, load and play it.
	local sound = MOAIUntzSound.new()
	sound:load(filename)
	sound:play()
	
	--register the sound in the playing list
	local sounddata = _Audio._createSoundData("Immediate", "None", sound)
	table.insert(_Audio._Playing, sounddata)
end

--sets the master volume
function _Audio.setMasterVolume(volume)
	assert(_Audio.running == true, "Audio system not initilized")
	
	if not( volume >= 0 or volume <= 1) then
		print "Invalid value for volume, must be between 0 and 1.0"
	end
	
	MOAIUntzSystem.setVolume(volume)
end

--gets the master volume
function _Audio.getMasterVolume()
	assert(_Audio.running == true, "Audio system not initilized")
	
	return MOAIUntzSystem.getVolume()
end

--loads a sound to play later using the supplied group and label
function _Audio.loadSound(group, label, filename)
	assert(_Audio.running == true, "Audio system not initilized")
	
	if not (group and label) then
		print "Need to specify and group and label"
		return
	end
	
	if not filename or type(filename) ~= "string" then
		print "Invalid parameter for filename, doing nothing"
		return
	end
	
	--creates new group and volume entries if needed
	if(_Audio._Groups[group] == nil) then
		_Audio._Groups[group] = {}
	end
	
	if(_Audio._Volumes[group] == nil) then
		_Audio._Volumes[group] = 1.0
	end
	
	--check if sound already loaded w/ group/label
	local soundGroup = _Audio._Groups[group]
	if (soundGroup[label] ~= nil) then
		print ("Sound already exist in", group, "with label", label)
		return
	end
	
	--load it
	soundGroup[label] = MOAIUntzSampleBuffer.new()
	soundGroup[label]:load(filename)
end

--plays a sound using the group and label, optionally can set it to loop
function _Audio.playSound(group, label, loop)
	assert(_Audio.running == true, "Audio system not initilized")
	
	if not (group and label) then
		print "Need to specify and group and label"
		return
	end
	
	--grab the buffer check to see if it exists
	
	if _Audio._Groups[group][label] == nil then
		print ("No sound at group",group," and label", label)
		return
	end
	
	local buffer = _Audio._Groups[group][label]
	
	--setup the sound and play it
	local sound = MOAIUntzSound.new()
	sound:load(buffer)
	sound:setVolume(_Audio._Volumes[group])
	if loop then
		sound:setLooping(true)
	end
	sound:play()
	
	--store the sound in the playing list
	local sounddata = _Audio._createSoundData(group, label, sound)
	table.insert(_Audio._Playing, sounddata)
end

--changes a groups volume
function _Audio.setGroupVolume(group, volume)
	assert(_Audio.running == true, "Audio system not initilized")
	
	if not group then
		print "group must be specified"
		return
	end
	
	if not (volume >= 0 or volume <= 1.0) then
		print "volume must be between 0 and 1.0"
		return
	end
	
	--update volume listing and change any playing sounds from that group
	_Audio._Volumes[group] = volume
	for i,v in ipairs(_Audio._Playing) do
		if(v.group == group) then
			v.sound:setVolume(volume)
		end
	end
end

--gets the current volume of a group
function _Audio.getGroupVolume(group)
	assert(_Audio.running == true, "Audio system not initilized")
	if not group then
		print "Must specify a group"
		return
	end
	return _Audio._Volumes[group]
end

function _Audio.pauseGroup(group)
	assert(_Audio.running == true, "Audio system not initilized")
	for i, v in ipairs(_Audio._Playing) do
		if v.group == group then
			v.sound:pause()
		end
	end	
end

return _Audio