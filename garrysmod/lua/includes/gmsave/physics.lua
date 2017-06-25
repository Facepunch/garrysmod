
--
-- Creates a save table for a single entity
--
function gmsave.PhysicsSave(ent)

	if (ent:GetPhysicsObjectCount() == 0) then return end

	local tab = {}

	for k = 0, ent:GetPhysicsObjectCount() - 1 do

		local obj = ent:GetPhysicsObjectNum(k)

		tab[ k ] = {}
		tab[ k ].origin = tostring(obj:GetPos())
		tab[ k ].angles = tostring(obj:GetAngles())
		tab[ k ].mass = tostring(obj:GetMass())
		tab[ k ].material = tostring(obj:GetMaterial())
		if (not obj:IsMotionEnabled()) then tab[ k ].frozen = 1 end
		if (not obj:IsCollisionEnabled()) then tab[ k ].nocollide = 1 end
		if (not obj:IsGravityEnabled()) then tab[ k ].nogravity = 1 end
		if (not obj:IsDragEnabled()) then tab[ k ].nodrag = 1 end

	end

	return tab

end

--
-- Creates a save table from a table of entities
--
function gmsave.PhysicsSaveList(ents)

	local tabPhys = {}

	for k, v in pairs(ents) do

		if (not IsValid( v)) then continue end

		tabPhys[ v.GMSaveName ] = gmsave.PhysicsSave(v)
		if (tabPhys[ v.GMSaveName ]) then
			tabPhys[ v.GMSaveName ].entity = v.GMSaveName
		end

	end

	return tabPhys

end

--
-- Creates a single entity from a table
--
function gmsave.PhysicsLoad(t, ent)

	for k = 0, ent:GetPhysicsObjectCount() - 1 do

		local tab = t[ k ]
		if (not tab) then continue end

		local obj = ent:GetPhysicsObjectNum(k)
		if (not IsValid( obj)) then continue end

		obj:SetPos(Vector( tab.origin))
		obj:SetAngles(Angle( tab.angles))
		obj:SetMass(tab.mass)
		obj:SetMaterial(tab.material)

		if (tab.frozen) then obj:EnableMotion( false) end
		if (tab.nocollide) then obj:EnableCollisions( false) end
		if (tab.nogravity) then obj:EnableGravity( false) end
		if (tab.nodrag) then obj:EnableDrag( false) end

	end

end

--
-- Restores multiple entitys from a table
--
function gmsave.PhysicsLoadFromTable(tab, ents)

	if (not tab) then return end

	for k, v in pairs(tab) do

		local ent = ents[ k ]
		if (not IsValid( ent)) then continue end

		gmsave.PhysicsLoad(v, ent)

	end

end
