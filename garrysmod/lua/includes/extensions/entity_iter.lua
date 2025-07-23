
local inext = ipairs( {} )

local EntityCache = nil
function ents.Iterator()

	if ( EntityCache == nil ) then EntityCache = ents.GetAll() end

	return inext, EntityCache, 0

end

local PlayerCache = nil
function player.Iterator()

	if ( PlayerCache == nil ) then PlayerCache = player.GetAll() end

	return inext, PlayerCache, 0

end

-- Called by the engine just before OnEntityCreated & just after EntityRemoved hooks
function InvalidateInternalEntityCache( isPly )

	EntityCache = nil
	if ( isPly ) then PlayerCache = nil end

end

local function InvalidateInternalEntityCacheOld( ent )

	InvalidateInternalEntityCache( ent:IsPlayer() )

end
