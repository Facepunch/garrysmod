
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
