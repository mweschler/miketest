local EditorStateData = {}

function EditorStateData.new(stateName)
	local data= {}
	data.name = stateName
	data.gui = nil
	data.input = nil
end


return EditorStateData