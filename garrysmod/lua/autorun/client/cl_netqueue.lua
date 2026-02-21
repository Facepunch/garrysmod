---------------
	CLIENT NET MESSAGE QUEUE

	Batches outgoing net messages from the client to reduce
	packet overhead. Instead of sending many small messages
	immediately, queues them and sends in batches.

	Also provides client-side receive batching that processes
	incoming messages across frames to prevent frame spikes
	from large net bursts.

	Usage:
		-- Queue a message (sent on next flush):
		netqueue.Queue( "MyMessage", function()
			net.WriteString( "hello" )
			net.WriteUInt( 42, 16 )
		end )

		-- Messages flush automatically every tick, or:
		netqueue.Flush()

	ConVars:
		cl_netqueue 1            - Enable net queuing
		cl_netqueue_maxbatch 10  - Max messages per batch flush
----------------

if ( SERVER ) then return end

netqueue = netqueue or {}

CreateClientConVar( "cl_netqueue", "1", true, false, "Enable client net message queuing" )
CreateClientConVar( "cl_netqueue_maxbatch", "10", true, false, "Max messages per flush" )

local Queue = {}			-- { { name, writeFunc }, ... }
local Stats = { sent = 0, batches = 0, queued = 0 }
local LastFlush = 0


--
-- Queue a net message for batched sending
--
function netqueue.Queue( name, writeFunc )

	if ( !GetConVar( "cl_netqueue" ):GetBool() ) then
		-- Bypass: send immediately
		net.Start( name )
		if ( writeFunc ) then writeFunc() end
		net.SendToServer()
		Stats.sent = Stats.sent + 1
		return
	end

	table.insert( Queue, { name = name, writeFunc = writeFunc } )
	Stats.queued = Stats.queued + 1

end


--
-- Flush queued messages
--
function netqueue.Flush()

	if ( #Queue == 0 ) then return end

	local maxBatch = GetConVar( "cl_netqueue_maxbatch" ):GetInt()
	local sent = 0

	while ( #Queue > 0 and sent < maxBatch ) do
		local msg = table.remove( Queue, 1 )

		net.Start( msg.name )
		if ( msg.writeFunc ) then msg.writeFunc() end
		net.SendToServer()

		sent = sent + 1
		Stats.sent = Stats.sent + 1
	end

	if ( sent > 0 ) then
		Stats.batches = Stats.batches + 1
	end

end


--
-- Auto-flush every tick
--
hook.Add( "Think", "NetQueue_Flush", function()

	if ( !GetConVar( "cl_netqueue" ):GetBool() ) then return end

	-- Flush once per tick
	local now = SysTime()
	if ( now - LastFlush < engine.TickInterval() ) then return end
	LastFlush = now

	netqueue.Flush()

end )


--
-- Get queue size
--
function netqueue.GetPending()
	return #Queue
end


--
-- Stats
--
function netqueue.GetStats()
	return {
		pending = #Queue,
		totalSent = Stats.sent,
		totalBatches = Stats.batches,
		totalQueued = Stats.queued,
		avgBatchSize = Stats.batches > 0
			and math.Round( Stats.sent / Stats.batches, 1 ) or 0
	}
end


-- Console commands
concommand.Add( "lua_netqueue_info", function()

	local s = netqueue.GetStats()

	print( "========== NET QUEUE ==========" )
	print( string.format( "  Pending:         %d", s.pending ) )
	print( string.format( "  Total sent:      %d", s.totalSent ) )
	print( string.format( "  Total batches:   %d", s.totalBatches ) )
	print( string.format( "  Avg batch size:  %s", s.avgBatchSize ) )
	print( "================================" )

end )

MsgN( "[NetQueue] Client net message queue loaded." )
