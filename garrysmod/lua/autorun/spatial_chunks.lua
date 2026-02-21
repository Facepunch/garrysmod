---------------
	SPATIAL CHUNK SYSTEM (inspired by slib sh_chunks.lua)

	Divides the map into a 3D grid of cells. Entities register
	into cells on creation/movement, enabling O(1) spatial
	lookups instead of iterating every entity.

	This is the single biggest optimisation for RP servers
	with 100+ players and 1000+ entities.

	Usage:
		-- Get entities in same chunk as a position
		local nearby = chunks.GetEntities( somePos )

		-- Get chunk key for a position
		local key = chunks.PosToKey( ent:GetPos() )

	Console Commands:
		lua_chunks_info       - Show chunk statistics
		lua_chunks_size <n>   - Set chunk size (default 2048)

	Note: Chunk size should be tuned to your map. Smaller = more
	precise but more memory. 2048 units works well for most RP maps.
----------------

chunks = chunks or {}

local ChunkSize = 2048
local ChunkSizeInv = 1 / ChunkSize
local Grid = {}				-- [key] = { [entIndex] = entity }
local EntityChunk = {}		-- [entIndex] = key (which chunk they're in)
local math_floor = math.floor
local tostring = tostring


--
-- Convert a world position to a chunk key
--
function chunks.PosToKey( pos )

	local cx = math_floor( pos.x * ChunkSizeInv )
	local cy = math_floor( pos.y * ChunkSizeInv )
	local cz = math_floor( pos.z * ChunkSizeInv )

	return cx .. ":" .. cy .. ":" .. cz

end


--
-- Register an entity into the grid
--
function chunks.Register( ent )

	if ( !IsValid( ent ) ) then return end

	local idx = ent:EntIndex()
	local key = chunks.PosToKey( ent:GetPos() )
	local oldKey = EntityChunk[ idx ]

	-- Same chunk — no update needed
	if ( oldKey == key ) then return end

	-- Remove from old chunk
	if ( oldKey and Grid[ oldKey ] ) then
		Grid[ oldKey ][ idx ] = nil
		if ( table.IsEmpty( Grid[ oldKey ] ) ) then
			Grid[ oldKey ] = nil
		end
	end

	-- Add to new chunk
	if ( !Grid[ key ] ) then
		Grid[ key ] = {}
	end

	Grid[ key ][ idx ] = ent
	EntityChunk[ idx ] = key

end


--
-- Unregister an entity from the grid
--
function chunks.Unregister( ent )

	if ( !ent ) then return end

	local idx = ent:EntIndex()
	local key = EntityChunk[ idx ]

	if ( key and Grid[ key ] ) then
		Grid[ key ][ idx ] = nil
		if ( table.IsEmpty( Grid[ key ] ) ) then
			Grid[ key ] = nil
		end
	end

	EntityChunk[ idx ] = nil

end


--
-- Get all entities in the same chunk as a world position
--
function chunks.GetEntities( pos )

	local key = chunks.PosToKey( pos )
	local cell = Grid[ key ]
	if ( !cell ) then return {} end

	local out = {}
	local count = 0
	for _, ent in pairs( cell ) do
		if ( IsValid( ent ) ) then
			count = count + 1
			out[ count ] = ent
		end
	end

	return out

end


--
-- Get entities in this chunk AND all 26 neighboring chunks (3x3x3)
--
function chunks.GetNearbyEntities( pos )

	local cx = math_floor( pos.x * ChunkSizeInv )
	local cy = math_floor( pos.y * ChunkSizeInv )
	local cz = math_floor( pos.z * ChunkSizeInv )

	local out = {}
	local count = 0

	for dx = -1, 1 do
		for dy = -1, 1 do
			for dz = -1, 1 do

				local key = ( cx + dx ) .. ":" .. ( cy + dy ) .. ":" .. ( cz + dz )
				local cell = Grid[ key ]
				if ( !cell ) then continue end

				for _, ent in pairs( cell ) do
					if ( IsValid( ent ) ) then
						count = count + 1
						out[ count ] = ent
					end
				end

			end
		end
	end

	return out

end


--
-- Get chunk grid info
--
function chunks.GetInfo()

	local cellCount = 0
	local entCount = 0

	for key, cell in pairs( Grid ) do
		cellCount = cellCount + 1
		for _ in pairs( cell ) do
			entCount = entCount + 1
		end
	end

	return {
		cellCount = cellCount,
		entityCount = entCount,
		chunkSize = ChunkSize
	}

end


-- Auto-register entities
hook.Add( "OnEntityCreated", "Chunks_Register", function( ent )
	-- Delay to next frame so entity has a valid position
	timer.Simple( 0, function()
		if ( IsValid( ent ) ) then
			chunks.Register( ent )
		end
	end )
end )

hook.Add( "EntityRemoved", "Chunks_Unregister", function( ent )
	chunks.Unregister( ent )
end )

-- Periodic position updates for moving entities (every 0.5s)
if ( SERVER ) then
	timer.Create( "Chunks_Update", 0.5, 0, function()
		for _, ent in ipairs( ents.GetAll() ) do
			if ( IsValid( ent ) ) then
				local vel = ent:GetVelocity()
				if ( vel:LengthSqr() > 100 ) then
					chunks.Register( ent )
				end
			end
		end
	end )
end


-- Console commands
concommand.Add( "lua_chunks_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local info = chunks.GetInfo()
	print( "========== SPATIAL CHUNKS ==========" )
	print( "  Chunk size:    " .. ChunkSize .. " units" )
	print( "  Active cells:  " .. info.cellCount )
	print( "  Tracked ents:  " .. info.entityCount )
	print( "====================================" )

end )

concommand.Add( "lua_chunks_size", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local size = tonumber( args[ 1 ] )
	if ( !size or size < 128 ) then
		print( "[Chunks] Current size: " .. ChunkSize .. ". Min: 128" )
		return
	end
	ChunkSize = size
	ChunkSizeInv = 1 / size
	-- Rebuild grid
	Grid = {}
	EntityChunk = {}
	for _, ent in ipairs( ents.GetAll() ) do
		chunks.Register( ent )
	end
	print( "[Chunks] Rebuilt grid with size " .. size )
end )

MsgN( "[SpatialChunks] Loaded. Chunk size: " .. ChunkSize .. " units" )
