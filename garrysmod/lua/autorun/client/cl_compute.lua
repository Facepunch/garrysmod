---------------
	CLIENT-SIDE COMPUTATION OFFLOADING

	Moves expensive calculations from server to client.
	These are things RP servers currently compute server-side
	and network to clients, but could be computed locally.

	Features:
		1. Client-side distance sorting (sort entities by distance locally)
		2. Client-side visibility checks (trace-based LOS from client)
		3. Client-side NPC/entity info caching (reduce net.Receive overhead)
		4. Batch HUD data processing (process multiple HUD updates per frame)
----------------

if ( SERVER ) then return end


---------------
	1. CLIENT-SIDE SPATIAL QUERIES

	Replaces common server->client patterns where the server
	finds nearby entities and sends results to the client.
	Instead, the client does its own spatial queries.
----------------

clientside = clientside or {}


--
-- Find entities near the local player (client-side)
-- No network traffic needed
--
function clientside.FindNearby( radius, classFilter )

	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return {} end

	local pos = ply:GetPos()
	local radiusSqr = radius * radius
	local out = {}
	local count = 0

	for _, ent in ipairs( ents.GetAll() ) do

		if ( !IsValid( ent ) ) then continue end
		if ( ent == ply ) then continue end

		if ( classFilter and ent:GetClass() != classFilter ) then continue end

		if ( ent:GetPos():DistToSqr( pos ) <= radiusSqr ) then
			count = count + 1
			out[ count ] = ent
		end

	end

	return out

end


--
-- Sort entities by distance from local player (client-side)
--
function clientside.SortByDistance( entities )

	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return entities end

	local pos = ply:GetPos()

	table.sort( entities, function( a, b )
		if ( !IsValid( a ) or !IsValid( b ) ) then return false end
		return a:GetPos():DistToSqr( pos ) < b:GetPos():DistToSqr( pos )
	end )

	return entities

end


--
-- Get closest entity of class (client-side)
--
function clientside.GetClosest( classFilter )

	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return nil end

	local pos = ply:GetPos()
	local closest = nil
	local closestDist = math.huge

	for _, ent in ipairs( classFilter and ents.FindByClass( classFilter ) or ents.GetAll() ) do

		if ( !IsValid( ent ) or ent == ply ) then continue end

		local dist = ent:GetPos():DistToSqr( pos )
		if ( dist < closestDist ) then
			closestDist = dist
			closest = ent
		end

	end

	return closest, math.sqrt( closestDist )

end


---------------
	2. CLIENT-SIDE VISIBILITY CACHE

	Caches visibility (line of sight) results to avoid
	redundant traces. Many addons trace to the same entities
	multiple times per frame.
----------------

local VisCache = {}
local VisCacheTime = 0
local VisCacheLifetime = 0.1		-- 100ms cache lifetime

function clientside.IsVisible( ent )

	if ( !IsValid( ent ) ) then return false end

	local now = SysTime()

	-- Invalidate stale cache
	if ( now - VisCacheTime > VisCacheLifetime ) then
		VisCache = {}
		VisCacheTime = now
	end

	local idx = ent:EntIndex()
	if ( VisCache[ idx ] != nil ) then
		return VisCache[ idx ]
	end

	-- Perform trace
	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return false end

	local tr = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ent:GetPos() + ent:OBBCenter(),
		filter = ply,
		mask = MASK_VISIBLE
	} )

	local visible = ( tr.Entity == ent or !tr.Hit )
	VisCache[ idx ] = visible

	return visible

end


---------------
	3. CLIENT-SIDE DATA CACHE

	Generic key-value cache for data received from the server.
	Instead of re-requesting data every frame, cache it
	client-side and only refresh when told to.

	This reduces net traffic for things like player info,
	team scores, job descriptions, etc.
----------------

local DataCache = {}

function clientside.SetCached( key, value, lifetime )

	DataCache[ key ] = {
		value = value,
		expires = lifetime and ( SysTime() + lifetime ) or math.huge,
		time = SysTime()
	}

end

function clientside.GetCached( key, default )

	local entry = DataCache[ key ]
	if ( !entry ) then return default end

	if ( SysTime() > entry.expires ) then
		DataCache[ key ] = nil
		return default
	end

	return entry.value

end

function clientside.InvalidateCache( key )
	if ( key ) then
		DataCache[ key ] = nil
	else
		DataCache = {}
	end
end

function clientside.GetCacheAge( key )
	local entry = DataCache[ key ]
	if ( !entry ) then return -1 end
	return SysTime() - entry.time
end


---------------
	4. BATCHED THINK PROCESSING

	Instead of every addon running its own Think hook,
	this provides a batched system where client-side tasks
	are queued and processed in priority order with a
	per-frame time budget.

	This prevents any single addon from hogging the client's
	CPU during Think.
----------------

local TaskQueue = {}
local TaskBudgetMs = 2		-- max ms per frame for queued tasks

function clientside.AddTask( name, func, priority )

	TaskQueue[ name ] = {
		func = func,
		priority = priority or 0
	}

end

function clientside.RemoveTask( name )
	TaskQueue[ name ] = nil
end

hook.Add( "Think", "ClientBatch_Process", function()

	if ( table.IsEmpty( TaskQueue ) ) then return end

	-- Sort by priority (higher = runs first)
	local sorted = {}
	for name, task in pairs( TaskQueue ) do
		table.insert( sorted, { name = name, func = task.func, priority = task.priority } )
	end
	table.sort( sorted, function( a, b ) return a.priority > b.priority end )

	local budgetSec = TaskBudgetMs / 1000
	local startTime = SysTime()

	for _, task in ipairs( sorted ) do

		if ( SysTime() - startTime > budgetSec ) then break end

		local ok, err = pcall( task.func )
		if ( !ok ) then
			ErrorNoHaltWithStack( "[ClientBatch] Task '" .. task.name .. "' error: " .. tostring( err ) )
		end

	end

end )

MsgN( "[ClientCompute] Client-side computation offloading loaded." )
MsgN( "[ClientCompute] API: clientside.FindNearby(), clientside.IsVisible(), clientside.GetCached()" )
