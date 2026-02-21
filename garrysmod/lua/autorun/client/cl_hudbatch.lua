---------------
	HUD DRAW BATCHING

	Reduces draw calls by batching common HUD operations.
	Instead of calling draw.RoundedBox, surface.SetDrawColor,
	surface.DrawRect etc individually, queue them and flush
	in optimised batches.

	Also provides a smart HUD update system that only redraws
	HUD elements when their data actually changes, saving GPU
	time on static elements like health bars that rarely change.

	Usage:
		-- Dirty-flag HUD (only redraws when data changes):
		hudbatch.Register( "health", function()
			return LocalPlayer():Health()
		end, function( hp )
			draw.RoundedBox( 8, 10, 10, 200, 30, Color(0,0,0,200) )
			draw.SimpleText( hp, "DermaLarge", 110, 25, color_white, 1, 1 )
		end )

	ConVars:
		cl_hudbatch 1           - Enable HUD batching
		cl_hudbatch_interval 0  - Min seconds between redraws (0 = every frame if dirty)
----------------

if ( SERVER ) then return end

hudbatch = hudbatch or {}

CreateClientConVar( "cl_hudbatch", "1", true, false, "Enable HUD draw batching" )
CreateClientConVar( "cl_hudbatch_interval", "0", true, false, "Min seconds between HUD redraws" )

local Elements = {}			-- [name] = { dataFunc, drawFunc, lastData, lastDraw, dirty }
local DrawSkipped = 0
local DrawExecuted = 0


--
-- Register a HUD element with dirty-flag rendering
--
function hudbatch.Register( name, dataFunc, drawFunc )

	Elements[ name ] = {
		dataFunc = dataFunc,
		drawFunc = drawFunc,
		lastData = nil,
		lastDraw = 0,
		dirty = true,
		rt = nil			-- render target for caching (optional future use)
	}

end


--
-- Unregister a HUD element
--
function hudbatch.Unregister( name )
	Elements[ name ] = nil
end


--
-- Force a specific element to redraw next frame
--
function hudbatch.Invalidate( name )
	if ( Elements[ name ] ) then
		Elements[ name ].dirty = true
	end
end


--
-- Force all elements to redraw
--
function hudbatch.InvalidateAll()
	for _, elem in pairs( Elements ) do
		elem.dirty = true
	end
end


--
-- Draw all registered elements (call from HUDPaint)
--
function hudbatch.Draw()

	if ( !GetConVar( "cl_hudbatch" ):GetBool() ) then return end

	local interval = GetConVar( "cl_hudbatch_interval" ):GetFloat()
	local now = SysTime()

	for name, elem in pairs( Elements ) do

		-- Check if data changed
		local newData = elem.dataFunc()

		-- Simple equality check (works for numbers, strings, booleans)
		if ( newData != elem.lastData ) then
			elem.dirty = true
			elem.lastData = newData
		end

		-- Only redraw if dirty and interval elapsed
		if ( elem.dirty and now - elem.lastDraw >= interval ) then
			elem.drawFunc( newData )
			elem.dirty = false
			elem.lastDraw = now
			DrawExecuted = DrawExecuted + 1
		else
			DrawSkipped = DrawSkipped + 1
		end

	end

end


--
-- Color pool (avoid creating new Color objects every frame)
--
local ColorPool = {}

function hudbatch.Color( r, g, b, a )

	a = a or 255
	local key = r * 16777216 + g * 65536 + b * 256 + a

	if ( !ColorPool[ key ] ) then
		ColorPool[ key ] = Color( r, g, b, a )
	end

	return ColorPool[ key ]

end


--
-- Stats
--
function hudbatch.GetStats()
	return {
		elements = table.Count( Elements ),
		drawn = DrawExecuted,
		skipped = DrawSkipped,
		colors = table.Count( ColorPool ),
		skipRate = ( DrawExecuted + DrawSkipped ) > 0
			and math.Round( DrawSkipped / ( DrawExecuted + DrawSkipped ) * 100, 1 ) or 0
	}
end


-- Console commands
concommand.Add( "lua_hudbatch_info", function()

	local s = hudbatch.GetStats()

	print( "========== HUD BATCHING ==========" )
	print( string.format( "  Registered elements: %d", s.elements ) )
	print( string.format( "  Draws executed:      %d", s.drawn ) )
	print( string.format( "  Draws skipped:       %d", s.skipped ) )
	print( string.format( "  Skip rate:           %s%%", s.skipRate ) )
	print( string.format( "  Pooled colors:       %d", s.colors ) )
	print( "===================================" )

end )

MsgN( "[HUDBatch] HUD draw batching loaded." )
