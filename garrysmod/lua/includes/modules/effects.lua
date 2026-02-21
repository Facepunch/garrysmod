local ents = ents
local pairs = pairs
local ipairs = ipairs
local string = string
local table = table

--[[---------------------------------------------------------
   Name: effects
   Desc: Engine effects hooking
-----------------------------------------------------------]]
module( "effects" )

local EffectList = {}

function Register( t, name )

	name = string.lower( name )

	local old = EffectList[ name ]

	EffectList[ name ] = t

	--
	-- If we're reloading this entity class
	-- then refresh all the existing entities.
	--
	if ( old != nil ) then

		--
		-- For each entity using this class
		--
		for _, entity in ipairs( ents.FindByClass( name ) ) do

			--
			-- Replace the contents with this entity table
			--
			table.Merge( entity, t )

		end

	end

end

function Create( name, retval )

	name = string.lower( name )

	--Msg( "Create.. ".. name .. "\n" )

	if ( EffectList[ name ] == nil ) then return nil end

	local NewEffect = retval or {}

	for k, v in pairs( EffectList[ name ] ) do

		NewEffect[ k ] = v

	end

	table.Merge( NewEffect, EffectList[ "base" ] )

	return NewEffect

end

function GetList()

	local result = {}

	for k, v in pairs( EffectList ) do
		table.insert( result, v )
	end

	return result

end
