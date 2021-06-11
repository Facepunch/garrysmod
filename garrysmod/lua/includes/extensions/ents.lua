
function ents.FindByClassAndParent( classname, entity )

	if ( !IsValid( entity ) ) then return end
	
	local list = ents.FindByClass( classname )
	if ( !list ) then return end
	
	local out = {}
	for k, v in pairs( list ) do
	
		if ( !IsValid(v) ) then continue end
		
		local p = v:GetParent()
		if ( !IsValid(p) ) then continue end
		if ( p != entity ) then continue end
		
		table.insert( out, v )
	
	end
	
	if ( #out == 0 ) then return end
	
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
