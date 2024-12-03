
function ents.FindByClassAndParent( classname, entity )

    local entslist = ents.FindByClass( classname )
	local out = {}

    for i = 1, #entslist do

        local p = entslist[i]:GetParent()
		if ( !IsValid(p) ) then continue end
		if ( p != entity ) then continue end

		table.insert( out, v )

    end

	if ( out[1] == nil ) then return end

	return out

end

local inext = ipairs({})
local EntityCache = nil

function ents.Iterator()

	if ( EntityCache == nil ) then EntityCache = ents.GetAll() end

	return inext, EntityCache, 0

end

local function InvalidateEntityCache( ent )

	EntityCache = nil

end

hook.Add( "OnEntityCreated", "ents.Iterator", InvalidateEntityCache )
hook.Add( "EntityRemoved", "ents.Iterator", InvalidateEntityCache )
