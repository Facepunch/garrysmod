---------------
	VGUI PANEL RECYCLING POOL

	Creating and destroying VGUI panels is expensive.
	RP servers with scoreboards, inventories, and menus
	constantly create/remove panels causing GC pressure.

	This pool recycles panels: instead of Remove(), return
	them to the pool. Next time you need one, grab a
	recycled panel instead of creating from scratch.

	Usage:
		-- Get a panel (creates new or recycles existing):
		local panel = panelpool.Get( "DPanel", parent )
		panel:SetSize( 200, 50 )

		-- Return it when done (instead of panel:Remove()):
		panelpool.Return( panel )

	Console Commands:
		lua_panelpool_info    - Show pool stats
		lua_panelpool_flush   - Destroy all pooled panels
----------------

if ( SERVER ) then return end

panelpool = panelpool or {}

local Pools = {}			-- [panelClass] = { panel1, panel2, ... }
local Stats = { created = 0, recycled = 0, returned = 0, flushed = 0 }
local MaxPerClass = 50		-- max recycled panels per class


--
-- Get a panel from the pool (or create new)
--
function panelpool.Get( class, parent )

	class = class or "DPanel"

	if ( Pools[ class ] and #Pools[ class ] > 0 ) then
		-- Recycle from pool
		local panel = table.remove( Pools[ class ] )

		if ( IsValid( panel ) ) then
			panel:SetParent( parent )
			panel:SetVisible( true )
			panel:SetAlpha( 255 )
			panel:SetPos( 0, 0 )
			panel:SetMouseInputEnabled( true )
			panel:SetKeyboardInputEnabled( false )
			Stats.recycled = Stats.recycled + 1
			return panel
		end
	end

	-- Create new
	local panel = vgui.Create( class, parent )
	Stats.created = Stats.created + 1
	return panel

end


--
-- Return a panel to the pool (instead of Remove)
--
function panelpool.Return( panel )

	if ( !IsValid( panel ) ) then return end

	local class = panel:GetClassName()

	-- Reset the panel
	panel:SetVisible( false )
	panel:SetParent( nil )
	panel:Clear()		-- remove children

	-- Init pool if needed
	if ( !Pools[ class ] ) then Pools[ class ] = {} end

	-- Don't overfill
	if ( #Pools[ class ] >= MaxPerClass ) then
		panel:Remove()
		return
	end

	table.insert( Pools[ class ], panel )
	Stats.returned = Stats.returned + 1

end


--
-- Batch return multiple panels
--
function panelpool.ReturnAll( panels )
	for _, panel in ipairs( panels ) do
		panelpool.Return( panel )
	end
end


--
-- Flush a specific class or all pools
--
function panelpool.Flush( class )

	if ( class ) then
		if ( Pools[ class ] ) then
			for _, panel in ipairs( Pools[ class ] ) do
				if ( IsValid( panel ) ) then panel:Remove() end
				Stats.flushed = Stats.flushed + 1
			end
			Pools[ class ] = {}
		end
	else
		for cls, pool in pairs( Pools ) do
			for _, panel in ipairs( pool ) do
				if ( IsValid( panel ) ) then panel:Remove() end
				Stats.flushed = Stats.flushed + 1
			end
		end
		Pools = {}
	end

end


--
-- Set max pool size per class
--
function panelpool.SetMaxPerClass( max )
	MaxPerClass = max
end


--
-- Get pool info
--
function panelpool.GetStats()

	local pooled = 0
	local classes = 0
	local breakdown = {}

	for class, pool in pairs( Pools ) do
		local valid = 0
		for _, panel in ipairs( pool ) do
			if ( IsValid( panel ) ) then valid = valid + 1 end
		end
		if ( valid > 0 ) then
			breakdown[ class ] = valid
			pooled = pooled + valid
			classes = classes + 1
		end
	end

	return {
		pooled = pooled,
		classes = classes,
		breakdown = breakdown,
		created = Stats.created,
		recycled = Stats.recycled,
		returned = Stats.returned,
		recycleRate = ( Stats.created + Stats.recycled ) > 0
			and math.Round( Stats.recycled / ( Stats.created + Stats.recycled ) * 100, 1 ) or 0
	}

end


-- Console commands
concommand.Add( "lua_panelpool_info", function()

	local s = panelpool.GetStats()

	print( "========== PANEL POOL ==========" )
	print( string.format( "  Pooled panels:  %d (%d classes)", s.pooled, s.classes ) )
	print( string.format( "  Created:        %d", s.created ) )
	print( string.format( "  Recycled:       %d", s.recycled ) )
	print( string.format( "  Recycle rate:    %s%%", s.recycleRate ) )
	print( "" )

	if ( next( s.breakdown ) ) then
		for class, count in pairs( s.breakdown ) do
			print( string.format( "    %-20s %d", class, count ) )
		end
	end

	print( "=================================" )

end )

concommand.Add( "lua_panelpool_flush", function()
	panelpool.Flush()
	print( "[PanelPool] All pools flushed." )
end )

MsgN( "[PanelPool] VGUI panel recycling loaded." )
