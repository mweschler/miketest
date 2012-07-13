--MOAI
serializer = ... or MOAIDeserializer.new ()

local function init ( objects )

	--Initializing Tables
	local table

	table = objects [ 0x025F8A10 ]
	table [ "__newindex" ] = objects [ 0x025F8A10 ]
	table [ "__index" ] = objects [ 0x025F8A10 ]

	--MOAIGrid
	serializer:initObject (
		objects [ 0x025F89D8 ],
		objects [ 0x025F8A10 ],
		{
			[ "mCellWidth" ] = 1,
			[ "mData" ] = "7c2hAQAADIMwuv+P3hkYRHQGTHaS/v7+/v7+fu83PQ==",
			[ "mXOff" ] = 0,
			[ "mWidth" ] = 32,
			[ "mHeight" ] = 18,
			[ "mCellHeight" ] = 1,
			[ "mRepeat" ] = 0,
			[ "mTileHeight" ] = 1,
			[ "mTileWidth" ] = 1,
			[ "mShape" ] = 0,
			[ "mYOff" ] = 0,
		}
	)

end

--Declaring Objects
local objects = {

	--Declaring Tables
	[ 0x025F8A10 ] = {},

	--Declaring Instances
	[ 0x025F89D8 ] = serializer:registerObjectID ( MOAIGrid.new (), 0x025F89D8 ),

}

init ( objects )

--Returning Tables
return objects [ 0x025F89D8 ]
