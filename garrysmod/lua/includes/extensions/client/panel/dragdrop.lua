
if ( SERVER ) then return end

dragndrop = {}

function dragndrop.Clear()

	dragndrop.m_Receiver		= nil
	dragndrop.m_ReceiverSlot	= nil
	dragndrop.m_HoverStart		= nil
	dragndrop.m_MouseCode		= 0
	dragndrop.m_DragWatch		= nil
	dragndrop.m_MouseX			= 0
	dragndrop.m_MouseY			= 0
	dragndrop.m_DraggingMain	= nil
	dragndrop.m_Dragging		= nil
	dragndrop.m_DropMenu		= nil

end

function dragndrop.IsDragging()

	if ( dragndrop.m_Dragging != nil ) then return true end

	return false

end

function dragndrop.HandleDroppedInGame()

	local panel = vgui.GetHoveredPanel()
	if ( !IsValid( panel ) ) then return end
	if ( panel:GetClassName() != "CGModBase" ) then return end

end

function dragndrop.Drop()

	if ( dragndrop.HandleDroppedInGame() ) then
		dragndrop.StopDragging()
		return
	end

	-- Show the menu
	if ( dragndrop.m_MouseCode == MOUSE_RIGHT && dragndrop.m_ReceiverSlot && dragndrop.m_ReceiverSlot.Menu ) then

		local x, y = dragndrop.m_Receiver:LocalCursorPos()

		local menu = DermaMenu()
		menu.OnRemove = function( m ) -- If user clicks outside of the menu - drop the dragging
			dragndrop.StopDragging()
		end

		for k, v in pairs( dragndrop.m_ReceiverSlot.Menu ) do

			local opt = menu:AddOption( v, function()

				dragndrop.CallReceiverFunction( true, k, x, y )
				dragndrop.StopDragging()

			end )

			-- HACK: This is lame, but there's no other way that I can see to get icons for these
			if ( k == "move" ) then opt:SetIcon( "icon16/arrow_turn_right.png" ) end
			if ( k == "copy" ) then opt:SetIcon( "icon16/arrow_branch.png" ) end

		end

		menu:Open()

		dragndrop.m_DropMenu = menu

		return

	end

	dragndrop.CallReceiverFunction( true, nil, nil, nil )
	dragndrop.StopDragging()

end

function dragndrop.StartDragging()

	if ( !dragndrop.m_DragWatch:IsSelected() ) then

		dragndrop.m_Dragging = { dragndrop.m_DragWatch }

	else

		local canvas = dragndrop.m_DragWatch:GetSelectionCanvas()
		dragndrop.m_Dragging = {}

		for k, v in pairs( canvas:GetSelectedChildren() ) do

			if ( !v.m_DragSlot ) then continue end

			table.insert( dragndrop.m_Dragging, v )

		end

	end

	for k, v in pairs( dragndrop.m_Dragging ) do

		if ( !IsValid( v ) ) then continue end

		v:OnStartDragging()

	end

	dragndrop.m_DraggingMain = dragndrop.m_DragWatch
	dragndrop.m_DraggingMain:MouseCapture( true )
	dragndrop.m_DragWatch = nil

end

function dragndrop.StopDragging()

	if ( IsValid( dragndrop.m_Receiver ) ) then
		dragndrop.m_Receiver:DragHoverEnd()
		dragndrop.m_Receiver = nil
	end

	for k, v in pairs( dragndrop.m_Dragging or {} ) do

		if ( !IsValid( v ) ) then continue end
		v:OnStopDragging()

	end

	dragndrop.Clear()

end

function dragndrop.UpdateReceiver()

	local hovered = vgui.GetHoveredPanel()
	local receiver = nil
	local receiverslot = nil

	if ( IsValid( hovered ) ) then
		receiver, receiverslot = hovered:GetValidReceiverSlot()
	end

	if ( IsValid( dragndrop.m_Receiver ) ) then

		if ( receiver == dragndrop.m_Receiver ) then return end

		dragndrop.m_Receiver:DragHoverEnd()

	end

	if ( !IsValid( receiver ) ) then
		dragndrop.m_Receiver = nil
		dragndrop.m_ReceiverSlot = nil
	end

	dragndrop.m_Receiver = receiver
	dragndrop.m_ReceiverSlot = receiverslot

end

--
-- Return all the dragged panels that match this name
--
function dragndrop.GetDroppable( name )

	if ( !name ) then return dragndrop.m_Dragging end
	if ( !dragndrop.m_Dragging ) then return end

	local t = {}
	for id, pnl in pairs( dragndrop.m_Dragging ) do
		if ( pnl.m_DragSlot && pnl.m_DragSlot[ name ] ) then table.insert( t, pnl ) end
	end
	return t

end

function dragndrop.CallReceiverFunction( bDoDrop, command, mx, my )

	if ( !dragndrop.m_ReceiverSlot ) then return end
	if ( !IsValid( dragndrop.m_Receiver ) ) then return end

	local x, y = dragndrop.m_Receiver:LocalCursorPos()
	if ( mx ) then x = mx end
	if ( my ) then y = my end

	if ( dragndrop.m_ReceiverSlot.Func ) then

		local droppable = dragndrop.GetDroppable( dragndrop.m_ReceiverSlot.Name )

		dragndrop.m_ReceiverSlot.Func( dragndrop.m_Receiver, droppable, bDoDrop, command, x, y )

	end

end

function dragndrop.Think()

	if ( IsValid( dragndrop.m_DropMenu ) ) then return end

	--
	-- We're dragging but no mouse buttons are down..
	-- So force the drop whereever it is!
	--
	--[[if ( dragndrop.m_Dragging != nil && !input.IsMouseDown( MOUSE_LEFT ) && !input.IsMouseDown( MOUSE_RIGHT ) ) then
		dragndrop.m_Dragging:DragMouseRelease( dragndrop.m_MouseCode )
		return
	end]]

	--
	-- We're holding down a panel, watch for start of dragging
	--
	if ( IsValid( dragndrop.m_DragWatch ) ) then

		local dist = math.abs( dragndrop.m_MouseX - gui.MouseX() ) + math.abs( dragndrop.m_MouseY - gui.MouseY() )
		if ( dist > 20 ) then
			dragndrop.StartDragging()
			return
		end

	end

	if ( dragndrop.m_Dragging != nil ) then

		dragndrop.HoverThink()
		dragndrop.UpdateReceiver()

		if ( IsValid( dragndrop.m_Receiver ) ) then
			dragndrop.CallReceiverFunction( false )
		end

	end

end

hook.Add( "DrawOverlay", "DragNDropPaint", function()

	if ( dragndrop.m_Dragging == nil ) then return end
	if ( dragndrop.m_DraggingMain == nil ) then return end
	if ( IsValid( dragndrop.m_DropMenu ) ) then return end

	local hold_offset_x = 65535
	local hold_offset_y = 65535

	-- Find the top, left most panel
	for k, v in pairs( dragndrop.m_Dragging ) do

		if ( !IsValid( v ) ) then continue end

		hold_offset_x = math.min( hold_offset_x, v.x )
		hold_offset_y = math.min( hold_offset_y, v.y )

	end

	local wasEnabled = DisableClipping( true )

		local Alpha = 0.7
		if ( IsValid( dragndrop.m_Hovered ) ) then Alpha = 0.8 end
		surface.SetAlphaMultiplier( Alpha )

			local ox = gui.MouseX() - hold_offset_x + 8
			local oy = gui.MouseY() - hold_offset_y + 8

			for k, v in pairs( dragndrop.m_Dragging ) do

				if ( !IsValid( v ) ) then continue end

				local dist = 512 - v:Distance( dragndrop.m_DraggingMain )

				if ( dist < 0 ) then continue end

				dist = dist / 512
				surface.SetAlphaMultiplier( Alpha * dist )

				v.PaintingDragging = true
				v:PaintAt( ox + v.x - v:GetWide() / 2, oy + v.y - v:GetTall() / 2 ) -- fill the gap between the top left corner and the mouse position
				v.PaintingDragging = nil

			end

		surface.SetAlphaMultiplier( 1.0 )

	DisableClipping( wasEnabled )

end )
hook.Add( "Think", "DragNDropThink", dragndrop.Think )





--
--
--
-- Panel Drag n Drop Extensions
--
--
--

local meta = FindMetaTable( "Panel" )

--
-- Make this panel droppable
--
function meta:Droppable( name )

	self.m_DragSlot = self.m_DragSlot or {}

	self.m_DragSlot[ name ] = {}

	return self.m_DragSlot[ name ]

end

--
-- Make this pannel a drop target
--
function meta:Receiver( name, func, menu )

	self.m_ReceiverSlot = self.m_ReceiverSlot or {}

	self.m_ReceiverSlot[ name ] = {}
	self.m_ReceiverSlot[ name ].Name = name
	self.m_ReceiverSlot[ name ].Func = func
	self.m_ReceiverSlot[ name ].Menu = menu

end

--
-- Drag parent means that when we start to
-- drag this panel, we'll really start
-- dragging the defined parent
--
function meta:SetDragParent( parent )
	self.m_pDragParent = parent
end

function meta:GetValidReceiverSlot()

	if ( self.m_ReceiverSlot ) then

		-- Find matching slot..
		for k, v in pairs( self.m_ReceiverSlot ) do

			if ( !dragndrop.m_DraggingMain.m_DragSlot ) then continue end

			local slot = dragndrop.m_DraggingMain.m_DragSlot[ k ]
			if ( !slot ) then continue end

			return self, v

		end

	end

	if ( !IsValid( self:GetParent() ) ) then
		return false
	end

	return self:GetParent():GetValidReceiverSlot()

end

function meta:IsDraggable()

	return self.m_DragSlot != nil

end

function meta:IsDragging()

	if ( !self.m_DragSlot ) then return false end

	return self.Dragging

end

function meta:DroppedOn( pnl )
	-- For override.
end

function meta:OnDrop()

	-- We're being dropped on something
	-- we can create a new panel here and return it, so that instead of
	-- dropping us - it drops the new panel instead! We remain where we are!

	-- By default we return ourself

	return self

end

function meta:OnStartDragging()

	self.Dragging = true
	self:InvalidateLayout()

	if ( self:IsSelectable() ) then

		local canvas = self:GetSelectionCanvas()

		if ( IsValid( canvas ) && !self:IsSelected() ) then
			canvas:UnselectAll()
		end

	end

end

function meta:OnStopDragging()
	self.Dragging = false
end

function meta:DragMousePress( mcode )

	if ( IsValid( dragndrop.m_DropMenu ) ) then return end
	if ( dragndrop.IsDragging() ) then dragndrop.StopDragging() return end

	if ( IsValid( self.m_pDragParent ) and self.m_pDragParent ~= self ) then
		return self.m_pDragParent:DragMousePress( mcode )
	end

	if ( !self.m_DragSlot ) then return end

	dragndrop.Clear()
	dragndrop.m_MouseCode = mcode
	dragndrop.m_DragWatch = self
	dragndrop.m_MouseX = gui.MouseX()
	dragndrop.m_MouseY = gui.MouseY()

end

function meta:DragClick( mcode )

	self:MouseCapture( true )
	-- Clicking one mouse button while dragging with another!
	-- Return true to stop us clicking and selecting stuff below..
	return true

end

function meta:DragMouseRelease( mcode )

	if ( IsValid( dragndrop.m_DropMenu ) ) then return end

	-- This wasn't the button we clicked with - so don't release drag
	if ( dragndrop.IsDragging() && dragndrop.m_MouseCode != mcode ) then

		return self:DragClick( mcode )

	end

	if ( !dragndrop.IsDragging() ) then
		dragndrop.Clear()
		return false
	end

	dragndrop.Drop()

	-- Todo.. we should only do this if we enabled it!
	if ( gui.EnableScreenClicker ) then
		gui.EnableScreenClicker( false )
	end

	self:MouseCapture( false )
	return true

end

function meta:SetDropTarget( x, y, w, h )

	if ( !self.m_bDrawingPaintOver ) then
		self.m_OldPaintOver = self.PaintOver
		self.m_bDrawingPaintOver = true
	end

	self.PaintOver = function()

		if ( self.m_OldPaintOver ) then
			self:m_OldPaintOver()
		end

		self:DrawDragHover( x, y, w, h )

	end

end



--
-- Drag Hover
--
-- These functions are used for things like trees
-- So that when you hover over the tree while dragging something
-- it will open up the tree. This works regardless of whether the
-- is droppable or not.
--
-- Implement DragHoverClick in your panel class to get this functionality
--
function meta:DragHover( HoverTime )

	--
	-- Call DragHoverClick if we've been hovering for 0.1 seconds..
	--
	if ( HoverTime < 0.1 ) then dragndrop.m_bHoverClick = false end
	if ( HoverTime > 0.1 && !dragndrop.m_bHoverClick ) then

		self:DragHoverClick( HoverTime )
		dragndrop.m_bHoverClick = true

	end

end

function meta:DrawDragHover( x, y, w, h )

	DisableClipping( true )

	surface.SetDrawColor( 255, 0, 255, 100 )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( 255, 220, 255, 230 )
	surface.DrawOutlinedRect( x, y, w, h )

	surface.SetDrawColor( 255, 100, 255, 50 )
	surface.DrawOutlinedRect( x - 1, y - 1, w + 2, h + 2 )

	DisableClipping( false )

end

function meta:DragHoverEnd()

	if ( !self.m_bDrawingPaintOver ) then return end

	self.PaintOver = self.m_OldPaintOver
	self.m_bDrawingPaintOver = false

end

function meta:DragHoverClick( HoverTime )
end




--
--
-- This is called to open stuff when you're hovering over it.
--
--

local LastHoverThink = nil
local LastHoverChangeTime = 0
local LastX = 0
local LastY = 0

function dragndrop.HoverThink()

	local hovered = vgui.GetHoveredPanel()
	local x = gui.MouseX()
	local y = gui.MouseY()

	-- Hovering a different panel
	if ( LastHoverThink != hovered or x != LastX or y != LastY ) then

		LastHoverChangeTime = SysTime()
		LastHoverThink = hovered

	end

	-- Hovered panel might do stuff when we're hovering it
	-- so give it a chance to do that now.
	if ( IsValid( LastHoverThink ) ) then

		LastX = x
		LastY = y
		LastHoverThink:DragHover( SysTime() - LastHoverChangeTime )

	end

end
