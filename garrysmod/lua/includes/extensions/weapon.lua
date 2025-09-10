
AddCSLuaFile()

local meta		= FindMetaTable( "Weapon" )
local entity	= FindMetaTable( "Entity" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

--
-- Cache entity.GetTable for even faster access
--
local WeaponTable = setmetatable( {}, {
	__index = function( tab, wep )
		local var = entity.GetTable( wep )
		tab[ wep ] = var
		return var
	end,
	__mode = "kv"
} )

--
-- Entity index accessor. This used to be done in engine, but it's done in Lua now because it's faster
--
function meta:__index( key )

	--
	-- Search the metatable. We can do this without dipping into C, so we do it first.
	--
	if ( meta[ key ] ~= nil ) then
		return meta[ key ]
	end

	--
	-- Search the entity metatable
	--
	if ( entity[ key ] ~= nil ) then
		return entity[ key ]
	end

	--
	-- Search the entity table
	--
	local tab = WeaponTable[ self ]
	if ( tab and tab[ key ] ~= nil ) then
		return tab[ key ]
	end

	--
	-- Legacy: sometimes use self.Owner to get the owner.. so lets carry on supporting that stupidness
	-- This needs to be retired, just like self.Entity was.
	--
	if ( key == "Owner" ) then return entity.GetOwner( self ) end
	
	return nil
	
end

