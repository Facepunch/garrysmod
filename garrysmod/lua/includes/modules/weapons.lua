
module( "weapons", package.seeall )

local WeaponList = {}

--[[---------------------------------------------------------
	Name: TableInherit( t, base )
	Desc: Copies any missing data from base to t
-----------------------------------------------------------]]
local function TableInherit( t, base )

	for k, v in pairs( base ) do

		if ( t[ k ] == nil ) then
			t[ k ] = v
		elseif ( k != "BaseClass" && istable( t[ k ] ) && istable( v ) ) then
			TableInherit( t[ k ], v )
		end

	end

	t[ "BaseClass" ] = base

	return t

end

--[[---------------------------------------------------------
	Name: IsBasedOn( name, base )
	Desc: Checks if name is based on base
-----------------------------------------------------------]]
function IsBasedOn( name, base )
	local t = GetStored( name )
	if ( !t ) then return false end
	if ( t.Base == name ) then return false end

	if ( t.Base == base ) then return true end
	return IsBasedOn( t.Base, base )
end


--[[---------------------------------------------------------
	Name: Register( table, string, bool )
	Desc: Used to register your SWEP with the engine
-----------------------------------------------------------]]
function Register( t, name )

	local old = WeaponList[ name ]

	t.ClassName = name
	WeaponList[ name ] = t

	--baseclass.Set( name, t )

	list.Set( "Weapon", name, {
		ClassName = name,
		PrintName = t.PrintName or t.ClassName,
		Category = t.Category or "Other",
		Spawnable = t.Spawnable,
		AdminOnly = t.AdminOnly,
		ScriptedEntityType = t.ScriptedEntityType,
		IconOverride = t.IconOverride
	} )

	-- Allow all SWEPS to be duplicated, unless specified
	if ( !t.DisableDuplicator ) then
		duplicator.Allow( name )
	end

	--
	-- If we're reloading this entity class
	-- then refresh all the existing entities.
	--
	if ( old != nil ) then

		-- Update SWEP table of entities that are based on this SWEP
		for _, e in ipairs( ents.GetAll() ) do
			local class = e:GetClass()

			if ( class == name ) then
				--
				-- Replace the contents with this entity table
				--
				table.Merge( e, t )

				--
				-- Call OnReloaded hook (if it has one)
				--
				if ( e.OnReloaded ) then
					e:OnReloaded()
				end
			end

			if ( IsBasedOn( class, name ) ) then
				table.Merge( e, Get( class ) )

				if ( e.OnReloaded ) then
					e:OnReloaded()
				end
			end
		end

	end

end

--
-- All scripts have been loaded...
--
function OnLoaded()

	--
	-- Once all the scripts are loaded we can set up the baseclass
	-- - we have to wait until they're all setup because load order
	-- could cause some entities to load before their bases!
	--
	for k, v in pairs( WeaponList ) do

		baseclass.Set( k, Get( k ) )

	end

end

--[[---------------------------------------------------------
	Name: Get( string )
	Desc: Get a weapon by name.
-----------------------------------------------------------]]
function Get( name, retval )

	local Stored = GetStored( name )
	if ( !Stored ) then return nil end

	-- Create/copy a new table
	local retval = retval or {}
	for k, v in pairs( Stored ) do
		if ( istable( v ) ) then
			retval[ k ] = table.Copy( v )
		else
			retval[ k ] = v
		end
	end
	retval.Base = retval.Base or "weapon_base"

	-- If we're not derived from ourselves (a base weapon)
	-- then derive from our 'Base' weapon.
	if ( retval.Base != name ) then

		local base = Get( retval.Base )

		if ( !base ) then
			Msg( "ERROR: Trying to derive weapon " .. tostring( name ) .. " from non existant SWEP " .. tostring( retval.Base ) .. "!\n" )
		else
			retval = TableInherit( retval, base )
		end

	end

	return retval
end

--[[---------------------------------------------------------
	Name: GetStored( string )
	Desc: Gets the REAL weapon table, not a copy
-----------------------------------------------------------]]
function GetStored( name )
	return WeaponList[ name ]
end

--[[---------------------------------------------------------
	Name: GetList( string )
	Desc: Get a list of all the registered SWEPs
-----------------------------------------------------------]]
function GetList()
	local result = {}

	for k, v in pairs( WeaponList ) do
		table.insert( result, v )
	end

	return result
end
