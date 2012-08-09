local EditorStateData = {}

function EditorStateData.new(stateName)
	local data= {}
	data.name = stateName
	data.gui = nil
	data.inputset = nil
end


return EditorStateData