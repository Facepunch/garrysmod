---------------
	ENTITY CLASS INDEX (inspired by HolyLib entitylist)

	Maintains a live index of entities by class name.
	ents.FindByClass iterates ALL entities — on a map with
	3000 entities, finding 10 NPCs requires 3000 comparisons.
	This index makes it O(1).

	Usage:
		-- Instead of ents.FindByClass("npc_zombie"):
		local zombies = entindex.GetByClass( "npc_zombie" )

		-- Pattern matching (slower, uses cache):
		local npcs = entindex.FindByPattern( "npc_*" )

	Console Commands:
		lua_entindex_info   - Show index statistics
----------------

entindex = entindex or {}

local ClassIndex = {}		-- [className] = { [entIndex] = entity }
local ClassCount = {}		-- [className] = count
local TotalTracked = 0


--
-- Get entities by exact class name (O(1))
--
function entindex.GetByClass( class )

	local bucket = ClassIndex[ class ]
	if ( !bucket ) then return {} end

	local out = {}
	local count = 0

	for idx, ent in pairs( bucket ) do
		if ( IsValid( ent ) ) then
			count = count + 1
			out[ count ] = ent
		end
	end

	return out

end


--
-- Get count for a class without creating a table
--
function entindex.CountClass( class )
	return ClassCount[ class ] or 0
end


--
-- Pattern matching (still needs iteration but only over class names, not entities)
--
function entindex.FindByPattern( pattern )

	local out = {}
	local count = 0

	for class, bucket in pairs( ClassIndex ) do

		if ( string.find( class, pattern ) or string.match( class, "^" .. string.gsub( pattern, "%*", ".*" ) .. "$" ) ) then
			for idx, ent in pairs( bucket ) do
				if ( IsValid( ent ) ) then
					count = count + 1
					out[ count ] = ent
				end
			end
		end

	end

	return out

end


--
-- Get all tracked class names
--
function entindex.GetClasses()

	local classes = {}
	local count = 0

	for class, _ in pairs( ClassIndex ) do
		count = count + 1
		classes[ count ] = class
	end

	return classes

end


--
-- Internal: add entity to index
--
local function AddToIndex( ent )

	if ( !IsValid( ent ) ) then return end

	local class = ent:GetClass()
	if ( !class or class == "" ) then return end

	local idx = ent:EntIndex()

	if ( !ClassIndex[ class ] ) then
		ClassIndex[ class ] = {}
		ClassCount[ class ] = 0
	end

	if ( !ClassIndex[ class ][ idx ] ) then
		ClassIndex[ class ][ idx ] = ent
		ClassCount[ class ] = ClassCount[ class ] + 1
		TotalTracked = TotalTracked + 1
	end

end


--
-- Internal: remove entity from index
--
local function RemoveFromIndex( ent )

	if ( !ent ) then return end

	local idx = ent:EntIndex()

	-- Check all classes (entity might have been removed before we can GetClass)
	for class, bucket in pairs( ClassIndex ) do
		if ( bucket[ idx ] ) then
			bucket[ idx ] = nil
			ClassCount[ class ] = math.max( 0, ( ClassCount[ class ] or 1 ) - 1 )
			TotalTracked = math.max( 0, TotalTracked - 1 )

			if ( ClassCount[ class ] == 0 ) then
				ClassIndex[ class ] = nil
				ClassCount[ class ] = nil
			end

			break
		end
	end

end


-- Hook into entity lifecycle
hook.Add( "OnEntityCreated", "EntIndex_Add", function( ent )
	-- Delay so entity has valid class
	timer.Simple( 0, function()
		if ( IsValid( ent ) ) then
			AddToIndex( ent )
		end
	end )
end )

hook.Add( "EntityRemoved", "EntIndex_Remove", function( ent )
	RemoveFromIndex( ent )
end )


-- Rebuild on map load
hook.Add( "InitPostEntity", "EntIndex_Rebuild", function()
	ClassIndex = {}
	ClassCount = {}
	TotalTracked = 0

	for _, ent in ipairs( ents.GetAll() ) do
		AddToIndex( ent )
	end

	MsgN( "[EntIndex] Indexed " .. TotalTracked .. " entities across " .. table.Count( ClassIndex ) .. " classes" )
end )


-- Console command
concommand.Add( "lua_entindex_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	print( "========== ENTITY INDEX ==========" )
	print( "  Total tracked:  " .. TotalTracked )
	print( "  Classes:        " .. table.Count( ClassIndex ) )
	print( "" )

	-- Sort by count
	local sorted = {}
	for class, count in pairs( ClassCount ) do
		table.insert( sorted, { class = class, count = count } )
	end
	table.sort( sorted, function( a, b ) return a.count > b.count end )

	local limit = math.min( 15, #sorted )
	if ( limit > 0 ) then
		print( string.format( "  %-30s %s", "CLASS", "COUNT" ) )
		for i = 1, limit do
			print( string.format( "  %-30s %d", sorted[ i ].class, sorted[ i ].count ) )
		end
		if ( #sorted > 15 ) then
			print( "  ... and " .. ( #sorted - 15 ) .. " more classes" )
		end
	end

	print( "==================================" )

end )

MsgN( "[EntIndex] Entity class index loaded." )
