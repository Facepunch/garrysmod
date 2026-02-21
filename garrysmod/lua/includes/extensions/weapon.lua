
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
	if ( val != nil ) then return val end

	--
	-- Search the entity metatable
	--
	local val = entity[key]
	if ( val != nil ) then return val end

	--
	-- Search the entity table
	--
	local tab = entity.GetTable( self )
	if ( tab != nil ) then
		local val = tab[ key ]
		if ( val != nil ) then return val end
	end

	--
	-- Legacy: sometimes use self.Owner to get the owner.. so lets carry on supporting that stupidness
	-- This needs to be retired, just like self.Entity was.
	--
	if ( key == "Owner" ) then return entity.GetOwner( self ) end
	
	return nil
	
end

