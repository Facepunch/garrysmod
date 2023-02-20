
function ents.FindByClassAndParent( classname, entity )

	if ( !IsValid( entity ) ) then return end

	local list = ents.FindByClass( classname )
	if ( !list ) then return end

	local out = {}
	for k, v in ipairs( list ) do

		if ( !IsValid(v) ) then continue end

		local p = v:GetParent()
		if ( !IsValid(p) ) then continue end
		if ( p != entity ) then continue end

		table.insert( out, v )

	end

	if ( #out == 0 ) then return end

	return out

end


--[[---------------------------------------------------------
	Name: FindFirstClass
	Desc: Gets all entities of the classname then returns the first value found, returns nil if not found
---------------------------------------------------------]]--
function ents.FindFirstClass( classname )

	if type(classname) ~= "string" then return end
	
	for _, v in ipairs( ents.FindByClass( classname ) do
		return v
	end

	return nil
end


--[[---------------------------------------------------------
	Name: FindFirstModel
	Desc: Gets all entities of the model then returns the first value found, returns nil if not found
---------------------------------------------------------]]--
function ents.FindFirstModel( model )

	if type(model) ~= "string" then return end
	
	for _, v in ipairs( ents.FindByModel( model ) do
		return v
	end

	return nil
end
