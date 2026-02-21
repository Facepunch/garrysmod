---------------
	COROUTINE-BASED ASYNC SCHEDULER (inspired by slib sh_async.lua)

	Allows heavy operations to be spread across multiple frames
	using coroutine.yield(). Prevents server freezes from
	file scans, large table processing, entity iterations, etc.

	Usage:
		-- Spread a heavy operation across frames
		async.Run( "my_scan", function( yield )
			for i = 1, 100000 do
				-- Heavy work here
				if ( i % 1000 == 0 ) then yield() end  -- give up the frame
			end
			print( "Done!" )
		end )

		-- Cancel a running task
		async.Remove( "my_scan" )

		-- Check if running
		async.Exists( "my_scan" )

	Config:
		lua_async_budget <ms>  - Max ms per frame for async tasks (default 2)
----------------

async = async or {}

local Tasks = {}			-- [id] = { co, status, startTime }
local BudgetMs = 2			-- Max ms per frame
local SysTime = SysTime

if ( CLIENT ) then
	CreateClientConVar( "cl_async_budget", "2", true, false, "Max ms per frame for async tasks" )
end

if ( SERVER ) then
	CreateConVar( "sv_async_budget", "2", FCVAR_ARCHIVE, "Max ms per frame for async tasks" )
end


--
-- Run a function asynchronously across frames
-- func receives a yield function as its first argument
--
function async.Run( id, func )

	if ( Tasks[ id ] ) then
		async.Remove( id )
	end

	local co = coroutine.create( function()
		func( coroutine.yield )
	end )

	Tasks[ id ] = {
		co = co,
		started = SysTime(),
		status = "running"
	}

end


--
-- Remove/cancel an async task
--
function async.Remove( id )
	Tasks[ id ] = nil
end


--
-- Check if a task exists
--
function async.Exists( id )
	return Tasks[ id ] != nil
end


--
-- Get task count
--
function async.Count()
	return table.Count( Tasks )
end


--
-- Process async tasks each frame
--
hook.Add( "Think", "Async_Process", function()

	if ( table.IsEmpty( Tasks ) ) then return end

	-- Read budget
	local budget
	if ( SERVER ) then
		budget = GetConVar( "sv_async_budget" )
		budget = budget and budget:GetFloat() or BudgetMs
	else
		budget = GetConVar( "cl_async_budget" )
		budget = budget and budget:GetFloat() or BudgetMs
	end

	local budgetSec = budget / 1000
	local frameStart = SysTime()

	for id, task in pairs( Tasks ) do

		if ( SysTime() - frameStart > budgetSec ) then break end

		if ( task.status != "running" ) then continue end

		local ok, err = coroutine.resume( task.co )

		if ( !ok ) then
			-- Error in coroutine
			ErrorNoHaltWithStack( "[Async] Task '" .. id .. "' error: " .. tostring( err ) )
			Tasks[ id ] = nil
		elseif ( coroutine.status( task.co ) == "dead" ) then
			-- Task completed
			Tasks[ id ] = nil
		end

	end

end )


--
-- Console commands
--
concommand.Add( "lua_async_info", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	local count = async.Count()
	print( "========== ASYNC TASKS ==========" )
	print( "  Running tasks: " .. count )

	if ( count > 0 ) then
		for id, task in pairs( Tasks ) do
			local elapsed = SysTime() - task.started
			print( string.format( "    [%s] %.1fs elapsed", id, elapsed ) )
		end
	end

	print( "=================================" )

end )

MsgN( "[AsyncScheduler] Loaded. Use async.Run(id, func) to schedule work." )
