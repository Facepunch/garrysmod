
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
		elseif ( k != "BaseClass" && istable( t[ k ] ) ) then
			TableInherit( t[ k ], v )
		end
		
	end

	t[ "BaseClass" ] = base

	return t

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

		--
		-- Foreach entity using this class
		--
		table.ForEach( ents.FindByClass( name ), function( _, entity ) 
		
			--
			-- Replace the contents with this entity table
			--
			table.Merge( entity, t )

			--
			-- Call OnReloaded hook (if it has one)
			--
			if ( entity.OnReloaded ) then
				entity:OnReloaded()
			end
		
		end )

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
	table.ForEach( WeaponList, function( k, v ) 

		baseclass.Set( k, Get( k ) )

	end )

end

--[[---------------------------------------------------------
   Name: Get( string )
   Desc: Get a weapon by name.
-----------------------------------------------------------]]
function Get( name )

	local Stored = GetStored( name )
	if ( !Stored ) then return nil end

	-- Create/copy a new table
	local retval = table.Copy( Stored )
	retval.Base = retval.Base or "weapon_base"

	-- If we're not derived from ourselves (a base weapon) 
	-- then derive from our 'Base' weapon.
	if ( retval.Base != name ) then

		local BaseWeapon = Get( retval.Base )
	
		if ( !BaseWeapon ) then
			Msg( "SWEP (", name, ") is derived from non existant SWEP (", retval.Base, ") - Expect errors!\n" )
		else
			retval = TableInherit( retval, Get( retval.Base ) )
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
