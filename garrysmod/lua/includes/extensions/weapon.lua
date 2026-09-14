
AddCSLuaFile()

local meta		= FindMetaTable( "Weapon" )
local entity	= FindMetaTable( "Entity" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

--
-- Entity index accessor. This used to be done in engine, but it's done in Lua now because it's faster
--
function meta:__index( key )

	--
	-- Search the metatable. We can do this without dipping into C, so we do it first.
	--
	local val = meta[key]
	if ( val ~= nil ) then return val end

	return entity.__index( self, key )

end

function meta:__newindex( key, value )

	return entity.__newindex( self, key, value )

end
