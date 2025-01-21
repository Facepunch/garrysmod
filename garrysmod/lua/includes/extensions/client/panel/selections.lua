
if ( SERVER ) then return end

local StartX = 0
local StartY = 0
local SelectionCanvas = nil

local meta = FindMetaTable( "Panel" )

function meta:SetSelectionCanvas( bSet )

	self.m_bSelectionCanvas = bSet
	self:SetMouseInputEnabled( true )

end

function meta:IsSelectionCanvas()

	return self.m_bSelectionCanvas

end

function meta:SetSelectable( bSet )

	self.m_bSelectable = bSet

end

function meta:ToggleSelection()

	self:SetSelected( !self.m_bSelected )

end

function meta:UnselectAll()

	self:SetSelected( false )

	for k, v in ipairs( self:GetChildren() ) do
		v:UnselectAll()
	end

end



function meta:SetSelected( bSet )

	if ( self.m_bSelected == bSet ) then return end

	self.m_bSelected = bSet

	if ( self.ApplySchemeSettings ) then
		self:ApplySchemeSettings()
	end

end

function meta:IsSelected( bSet )

	if ( !self:IsSelectable() ) then return false end
	return self.m_bSelected == true

end

function meta:IsSelectable()

	return self.m_bSelectable == true

end

local function GetSelectionRect()

	if ( !SelectionCanvas ) then
		debug.Trace()
		return
	end

	local CurX, CurY = SelectionCanvas:ScreenToLocal( gui.MouseX(), gui.MouseY() )

	local x = math.min( CurX, StartX )
	local y = math.min( CurY, StartY )

	local w = math.abs( CurX - StartX )
	local h = math.abs( CurY - StartY )

	return x, y, w, h

end

function meta:DrawSelections()

	if ( !self.m_bSelectable ) then return end
	if ( !self.m_bSelected ) then return end

	local w, h = self:GetSize()

	surface.SetDrawColor( 255, 0, 255, 100 )
	surface.DrawRect( 0, 0, w, h )

end

local function PaintSelectionBox( self )

	if ( !IsValid( SelectionCanvas ) ) then return end
	local x, y, w, h = GetSelectionRect()

	surface.SetDrawColor( 255, 0, 255, 50 )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( 255, 200, 255, 200 )
	surface.DrawOutlinedRect( x, y, w, h )

end

function meta:GetSelectionCanvas()

	if ( !self.m_bSelectionCanvas ) then

		local parent = self:GetParent()
		if ( IsValid( parent ) ) then
			return parent:GetSelectionCanvas()
		end

		return nil

	end

	return self

end


function meta:StartBoxSelection()

	if ( !self.m_bSelectionCanvas ) then

		local parent = self:GetParent()
		if ( IsValid( parent ) ) then
			return parent:StartBoxSelection()
		end

		return

	end

	self:MouseCapture( true )

	if ( !input.IsShiftDown() && !input.IsControlDown() ) then
		self:UnselectAll()
	end

	SelectionCanvas = self

	StartX, StartY = self:ScreenToLocal( gui.MouseX(), gui.MouseY() )

	self.PaintOver_Old = self.PaintOver
	self.PaintOver = PaintSelectionBox

end

function meta:GetChildrenInRect( x, y, w, h )

	local tab = {}

	for k, v in ipairs( self:GetChildren() ) do

		local vw, vh = v:GetSize()

		if ( !self:IsVisible() ) then continue end
		if ( x > v.x + vw ) then continue end
		if ( y > v.y + vh ) then continue end
		if ( v.x > x + w ) then continue end
		if ( v.y > y + h ) then continue end

		if ( v.m_bSelectable ) then
			table.insert( tab, v )
		end

		table.Add( tab, v:GetChildrenInRect( x - v.x, y - v.y, w, h ) )

	end


	return tab

end

function meta:GetSelectedChildren()

	local tab = {}

	for k, v in ipairs( self:GetChildren() ) do

		if ( v:IsSelected() ) then
			table.insert( tab, v )
		end

		table.Add( tab, v:GetSelectedChildren() )

	end

	return tab

end

function meta:NumSelectedChildren()

	local i = 0

	for k, v in ipairs( self:GetChildren() ) do

		if ( v:IsSelected() ) then
			i = i + 1
		end

	end

	return i

end

function meta:EndBoxSelection()

	if ( SelectionCanvas != self ) then return false end

	self:MouseCapture( false )

	self.PaintOver = self.PaintOver_Old
	self.PaintOver_Old = nil

	for k, v in ipairs( self:GetChildrenInRect( GetSelectionRect() ) ) do

		-- If player is holding shift, add new planels to existing selections, do not toggle
		-- This mimics already familiar behavior of Windows Explorer, etc
		if ( input.IsShiftDown() ) then
			v:SetSelected( true )
		else
			v:ToggleSelection()
		end

	end

	SelectionCanvas = nil
	StartX, StartY = 0, 0

	return true

end
