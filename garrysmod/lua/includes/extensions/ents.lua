
function ents.FindByClassAndParent( classname, entity )

    if ( !IsValid( entity ) ) then return end

    local out = {}

    for k, v in ipairs( ents.FindByClass( classname ) ) do

        if ( v:GetParent() == entity ) then
      		table.insert( out, v )
    	end

    end

    if ( out[1] == nil ) then return end

    return out

end



local inext = ipairs( {} )
local EntityCache = nil

function ents.Iterator()

	if ( EntityCache == nil ) then EntityCache = ents.GetAll() end

	return inext, EntityCache, 0

end

local function InvalidateEntityCache()

	EntityCache = nil

end

hook.Add( "OnEntityCreated", "ents.Iterator", InvalidateEntityCache )
hook.Add( "EntityRemoved", "ents.Iterator", InvalidateEntityCache )
