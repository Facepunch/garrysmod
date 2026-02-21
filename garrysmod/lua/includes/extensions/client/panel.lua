
include ( "panel/animation.lua" )
include ( "panel/dragdrop.lua" )
include ( "panel/selections.lua" )
include ( "panel/scriptedpanels.lua" )

local meta = FindMetaTable( "Panel" )

AccessorFunc( meta, "m_strCookieName", "CookieName" )

meta.SetFGColorEx = meta.SetFGColor
meta.SetBGColorEx = meta.SetBGColor

--[[---------------------------------------------------------
	Name: SetFGColor
	Desc: Override to make it possible to pass Color's
-----------------------------------------------------------]]
function meta:SetFGColor( r, g, b, a )

	if ( istable( r ) ) then
		return self:SetFGColorEx( r.r, r.g, r.b, r.a )
	end

	return self:SetFGColorEx( r, g, b, a )

end

--[[---------------------------------------------------------
	Name: SetBGColor
	Desc: Override to make it possible to pass Color's
-----------------------------------------------------------]]
function meta:SetBGColor( r, g, b, a )

	if ( istable( r ) ) then
		return self:SetBGColorEx( r.r, r.g, r.b, r.a )
	end

	return self:SetBGColorEx( r, g, b, a )

end

--[[---------------------------------------------------------
	Name: SetHeight
-----------------------------------------------------------]]
function meta:SetHeight( h )
	self:SetSize( self:GetWide(), h )
end
meta.SetTall = meta.SetHeight

--[[---------------------------------------------------------
	Name: SetHeight
-----------------------------------------------------------]]
function meta:SetWidth( w )
	self:SetSize( w, self:GetTall() )
end
meta.SetWide = meta.SetWidth


--[[---------------------------------------------------------
	Name: Set/GetX/Y
-----------------------------------------------------------]]
function meta:GetX()
	local x, y = self:GetPos()
	return x
end
function meta:GetY()
	local x, y = self:GetPos()
	return y
end
function meta:SetX( x )
	self:SetPos( x, self:GetY() )
end
function meta:SetY( y )
	self:SetPos( self:GetX(), y )
end

--[[---------------------------------------------------------
	Name: StretchToParent (borders)
-----------------------------------------------------------]]
function meta:StretchToParent( l, u, r, d )

	local w, h = self:GetParent():GetSize()

	if ( l != nil ) then
		self.x = l
	end

	if ( u != nil ) then
		self.y = u
	end

	if ( r != nil ) then
		self:SetWide( w - self.x - r )
	end

	if ( d != nil ) then
		self:SetTall( h - self.y - d )
	end

	--self:SetPos( l, u )
	--self:SetSize( w - (r + l), h - (d + u) )

end

--[[---------------------------------------------------------
	Name: CopyHeight
-----------------------------------------------------------]]
function meta:CopyHeight( pnl )
	self:SetTall( pnl:GetTall() )
end

--[[---------------------------------------------------------
	Name: CopyWidth
-----------------------------------------------------------]]
function meta:CopyWidth( pnl )
	self:SetWide( pnl:GetWide() )
end

--[[---------------------------------------------------------
	Name: CopyPos
-----------------------------------------------------------]]
function meta:CopyPos( pnl )
	self:SetPos( pnl:GetPos() )
end

--[[---------------------------------------------------------
	Name: Align with the edge of the parent
-----------------------------------------------------------]]
function meta:AlignBottom( m ) self:SetPos( self.x, self:GetParent():GetTall() - self:GetTall() - ( m or 0 ) ) end
function meta:AlignRight( m ) self:SetPos( self:GetParent():GetWide() - self:GetWide() - ( m or 0 ), self.y ) end
function meta:AlignTop( m ) self:SetPos( self.x, m or 0 ) end
function meta:AlignLeft( m ) self:SetPos( m or 0, self.y ) end

--[[---------------------------------------------------------
	Name: Move relative to another panel
-----------------------------------------------------------]]
function meta:MoveAbove( pnl, m ) self:SetPos( self.x, pnl.y - self:GetTall() - ( m or 0 ) ) end
function meta:MoveBelow( pnl, m ) self:SetPos( self.x, pnl.y + pnl:GetTall() + ( m or 0 ) ) end
function meta:MoveRightOf( pnl, m ) self:SetPos( pnl.x + pnl:GetWide() + ( m or 0 ), self.y ) end
function meta:MoveLeftOf( pnl, m ) self:SetPos( pnl.x - self:GetWide() - ( m or 0 ), self.y ) end

--[[---------------------------------------------------------
	Name: StretchRightTo
-----------------------------------------------------------]]
function meta:StretchRightTo( pnl, m ) self:SetWide( pnl.x - self.x - ( m or 0 ) ) end
function meta:StretchBottomTo( pnl, m ) self:SetTall( pnl.y - self.y - ( m or 0 ) ) end

--[[---------------------------------------------------------
	Name: CenterVertical
-----------------------------------------------------------]]
function meta:CenterVertical( fraction )
	self:SetY( self:GetParent():GetTall() * ( fraction or 0.5 ) - self:GetTall() * 0.5 )
end

--[[---------------------------------------------------------
	Name: CenterHorizontal
-----------------------------------------------------------]]
function meta:CenterHorizontal( fraction )
	self:SetX( self:GetParent():GetWide() * ( fraction or 0.5 ) - self:GetWide() * 0.5 )
end

--[[---------------------------------------------------------
	Name: CenterHorizontal
-----------------------------------------------------------]]
function meta:Center()

	self:CenterVertical()
	self:CenterHorizontal()

end

--[[---------------------------------------------------------
	Name: CopyBounds
-----------------------------------------------------------]]
function meta:CopyBounds( pnl )

	local x, y, w, h = pnl:GetBounds()

	self:SetPos( x, y )
	self:SetSize( w, h )

end

--[[---------------------------------------------------------
	Name: GetCookieNumber
-----------------------------------------------------------]]
function meta:SetCookieName( cookiename )

	self.m_strCookieName = cookiename

	-- If we have a loadcookies function, call it.
	if ( self.LoadCookies ) then
		self:LoadCookies()
		self:InvalidateLayout()
	end

end

--[[---------------------------------------------------------
	Name: GetCookieNumber
-----------------------------------------------------------]]
function meta:GetCookieNumber( cookiename, default )

	local name = self:GetCookieName()
	if ( !name ) then return default end

	return cookie.GetNumber( name .. "." .. cookiename, default )

end

--[[---------------------------------------------------------
	Name: GetCookie
-----------------------------------------------------------]]
function meta:GetCookie( cookiename, default )

	local name = self:GetCookieName()
	if ( !name ) then return default end

	return cookie.GetString( name .. "." .. cookiename, default )

end

--[[---------------------------------------------------------
	Name: SetCookie
-----------------------------------------------------------]]
function meta:SetCookie( cookiename, value )

	local name = self:GetCookieName()
	if ( !name ) then return end

	return cookie.Set( name .. "." .. cookiename, value )

end

--[[---------------------------------------------------------
	Name: DeleteCookie
-----------------------------------------------------------]]
function meta:DeleteCookie( cookiename )

	local name = self:GetCookieName()
	if ( !name ) then return end

	return cookie.Delete( name .. "." .. cookiename )

end

--[[---------------------------------------------------------
	Name: InvalidateParent
-----------------------------------------------------------]]
function meta:InvalidateParent( layoutnow )

	local parent = self:GetParent()
	if ( !parent ) then return end
	if ( self.LayingOutParent ) then return end

	self.LayingOutParent = true
	parent:InvalidateLayout( layoutnow )
	self.LayingOutParent = false

end

--[[---------------------------------------------------------
	Name: PositionLabel
-----------------------------------------------------------]]
function meta:PositionLabel( labelWidth, x, y, lbl, ctrl )

	lbl:SetWide( labelWidth )
	lbl:SetPos( x, y )

	ctrl.y = y
	ctrl:MoveRightOf( lbl, 0 )

	return y + math.max( lbl:GetTall(), ctrl:GetTall() )

end

--[[---------------------------------------------------------
	Name: GetTooltip
-----------------------------------------------------------]]
function meta:GetTooltip()
	return self.strTooltipText
end

--[[---------------------------------------------------------
	Name: GetTooltipPanel
-----------------------------------------------------------]]
function meta:GetTooltipPanel()
	return self.pnlTooltipPanel
end

--[[---------------------------------------------------------
	Name: GetTooltipDelay
-----------------------------------------------------------]]
function meta:GetTooltipDelay()
	return self.numTooltipDelay
end

--[[---------------------------------------------------------
	Name: SetTooltip
-----------------------------------------------------------]]
function meta:SetTooltip( tooltip )
	self.strTooltipText = tooltip
end
meta.SetToolTip = meta.SetTooltip

--[[---------------------------------------------------------
	Name: SetTooltipPanel
-----------------------------------------------------------]]
function meta:SetTooltipPanel( panel )
	self.pnlTooltipPanel = panel
	if ( IsValid( panel ) ) then panel:SetVisible( false ) end
end
meta.SetToolTipPanel = meta.SetTooltipPanel

-- Override which panel will be created instead of DTooltip
function meta:SetTooltipPanelOverride( panel )
	self.pnlTooltipPanelOverride = panel
end

--[[---------------------------------------------------------
	Name: SetTooltipDelay
-----------------------------------------------------------]]
function meta:SetTooltipDelay( delay )
	self.numTooltipDelay = delay
end

--[[---------------------------------------------------------
	Name: SizeToContentsY (Only works on Labels)
-----------------------------------------------------------]]
function meta:SizeToContentsY( addval )

	local w, h = self:GetContentSize()
	if ( !w || !h ) then return end

	self:SetTall( h + ( addval or 0 ) )

end

--[[---------------------------------------------------------
	Name: SizeToContentsX (Only works on Labels)
-----------------------------------------------------------]]
function meta:SizeToContentsX( addval )

	local w, h = self:GetContentSize()
	if ( !w || !h ) then return end

	self:SetWide( w + ( addval or 0 ) )

end

-- Make sure all children update their skin, if SOMEHOW they cached their skin before the parent
local function InvalidateSkinRecurse( self )

	for id, pnl in pairs( self:GetChildren() ) do
		InvalidateSkinRecurse( pnl )
		pnl.m_iSkinIndex = nil
	end

end

--[[---------------------------------------------------------
	Name: SetSkin
-----------------------------------------------------------]]
function meta:SetSkin( strSkin )

	if ( self.m_ForceSkinName == strSkin ) then return end

	self.m_ForceSkinName = strSkin
	self.m_iSkinIndex = nil

	InvalidateSkinRecurse( self )

end

--[[---------------------------------------------------------
	Name: GetSkin
-----------------------------------------------------------]]
function meta:GetSkin()

	local skin = nil

	if ( derma.SkinChangeIndex() == self.m_iSkinIndex ) then

		skin = self.m_Skin
		if ( skin ) then return skin end

	end

	-- We have a default skin
	if ( !skin && self.m_ForceSkinName ) then
		skin = derma.GetNamedSkin( self.m_ForceSkinName )
	end

	-- No skin, inherit from parent
	local parent = self:GetParent()
	if ( !skin && IsValid( parent ) ) then
		skin = parent:GetSkin()
	end

	-- Parent had no skin, use default
	if ( !skin ) then
		skin = derma.GetDefaultSkin()
	end

	-- Save skin details on us so we don't have to keep looking up
	self.m_Skin = skin
	self.m_iSkinIndex = derma.SkinChangeIndex()

	self:InvalidateLayout( false )

	return skin

end

--[[---------------------------------------------------------
	Name: ToggleVisible
-----------------------------------------------------------]]
function meta:ToggleVisible()
	self:SetVisible( !self:IsVisible() )
end

function meta:Distance( pnl )

	if ( !IsValid( pnl ) ) then return 0 end

	return self:DistanceFrom( pnl.x + pnl:GetWide() * 0.5, pnl.y + pnl:GetTall() * 0.5 )

end

function meta:DistanceFrom( x, y )

	local x = self.x + self:GetWide() * 0.5 - x
	local y = self.y + self:GetTall() * 0.5 - y

	return math.sqrt( x * x + y * y )

end

--[[---------------------------------------------------------
	Name: Retusn the child position on this panel. Even if its parented to children of children.
-----------------------------------------------------------]]
function meta:GetChildPosition( pnl )

	local x = 0
	local y = 0

	while ( IsValid( pnl ) && pnl != self ) do

		x = x + pnl.x
		y = y + pnl.y

		pnl = pnl:GetParent()

	end

	return x, y

end

--[[---------------------------------------------------------
	Name: Returns true if the panel is valid. This does not
		check the type. If the passed object is anything other
		than a panel or nil, this will error. (speed)
-----------------------------------------------------------]]
function ValidPanel( pnl )

	if ( !pnl ) then return false end

	return pnl:IsValid()

end

function meta:InvalidateChildren( bRecurse )

	for k, v in ipairs( self:GetChildren() ) do

		if ( bRecurse ) then
			v:InvalidateChildren( true )
		else
			v:InvalidateLayout( true )
		end

	end

	self:InvalidateLayout( true )

end

function meta:IsOurChild( child )

	if ( !IsValid( child ) ) then return false end

	return child:HasParent( self )

end

function meta:CopyBase( pnl )

	self:CopyBounds( pnl )
	self:Dock( pnl:GetDock() )

	// TODO. More.

end

function meta:Add( pnl )

	if ( isstring( pnl ) ) then
		local pnl = vgui.Create( pnl, self )
		return pnl
	end

	if ( istable( pnl ) ) then
		local pnl = vgui.CreateFromTable( pnl, self )
		return pnl
	end

	pnl:SetParent( self )
	return pnl

end

function meta:GetClosestChild( x, y )

	local distance = 9999
	local closest = nil

	for k, v in ipairs( self:GetChildren() ) do
		local dist = v:DistanceFrom( x, y )
		if ( dist < distance ) then
			distance = dist
			closest = v
		end
	end

	return closest, distance

end

function meta:LocalCursorPos()
	return self:ScreenToLocal( gui.MouseX(), gui.MouseY() )
end

function meta:MoveToAfter( pnl )

	local children = self:GetParent():GetChildren()

	-- remove us from the table
	table.RemoveByValue( children, self )

	-- find the key, where we want to be
	local key = table.KeyFromValue( children, pnl )

	if ( key ) then
		-- insert us where we wanna be
		table.insert( children, key + 1, self )
	else
		return false
	end

	for k, v in ipairs( children ) do
		v:SetZPos( k )
	end

end

function meta:MoveToBefore( pnl )

	local children = self:GetParent():GetChildren()

	-- remove us from the table
	table.RemoveByValue( children, self )

	-- find the key, where we want to be
	local key = table.KeyFromValue( children, pnl )

	if ( key ) then
		-- insert us where we wanna be
		table.insert( children, key, self )
	else
		return false
	end

	for k, v in ipairs( children ) do
		v:SetZPos( k )
	end

end

function meta:Clear()

	for k, panel in ipairs( self:GetChildren() ) do
		panel:Remove()
	end

end

function meta:IsHovered()
	return vgui.GetHoveredPanel() == self
end

function meta:Show()
	self:SetVisible( true )
end

function meta:Hide()
	self:SetVisible( false )
end

function meta:IsChildHovered( bImmediate )

	local Hovered = vgui.GetHoveredPanel()
	if ( !IsValid( Hovered ) ) then return false end
	if ( Hovered == self ) then return false end

	-- Check immediate child only (with support for old depth parameter)
	if ( bImmediate == true or bImmediate == 1 ) then return Hovered:GetParent() == self end

	return Hovered:HasParent( self )

end
