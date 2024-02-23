
local PANEL = {}

function PANEL:Init()

	self:Dock( TOP )
	self:DockMargin( 0, 0, 0, 1 )

	self.RemoveBtn = self:Add( "DImageButton" )
	self.RemoveBtn:SetImage( "icon16/cross.png" )
	self.RemoveBtn:SetSize( 16, 16 )
	self.RemoveBtn.DoClick = function( btm )
		if ( !self.Permission ) then return end

		permissions.Revoke( self.Permission, self:GetParent():GetParent().Title )
	end

end

local textPaddingX = 5
local textPaddingY = 5
local buttonPad = 8

-- lua_run_cl permissions.AskToConnect( "da" )
function PANEL:PerformLayout( w, h )

	local txt = "<font=DermaLarge>" .. language.GetPhrase( "permission." .. self.Permission ) .. ( self.IsTemporary and " <color=255,128,0>(TEMPORARY)</color>" or "" ) .. "</font>\n <font=DermaDefault>" .. language.GetPhrase( "permission." .. self.Permission .. ".help" ) .. "</font>"
	self.Markup = markup.Parse( txt, self:GetWide() - self.RemoveBtn:GetWide() - buttonPad * 2 - textPaddingX * 2 )

	self:SetTall( textPaddingY + self.Markup:GetHeight() + textPaddingY )

	local bW, bH = self.RemoveBtn:GetSize()
	self.RemoveBtn:SetPos( w - bW - buttonPad, self:GetTall() / 2 - bH / 2 )

end

local bgClr = Color( 75, 75, 75, 255 )
function PANEL:Paint( w, h )

	bgClr.a = self:GetAlpha()
	draw.RoundedBox( 0, 0, 0, w, h, bgClr )

	-- No info yet
	if ( !self.Permission ) then return end

	-- The error
	self.Markup:Draw( textPaddingX, textPaddingY, nil, nil, self:GetAlpha() )

end

function PANEL:Think()
end

function PANEL:SetPermission( perm, temp )

	self.Permission = perm
	self.IsTemporary = temp

	self:InvalidateLayout( true )

end

vgui.Register( "Permission", PANEL, "Panel" )







local PANEL = {}

local arrowMat = Material( "gui/point.png" )
local collapsedCache = {}

function PANEL:Init()

	self:Dock( TOP )
	self:SetTall( 20 )
	self:DockMargin( 0, 0, 0, 5	)

	self.PermissionPanels = {}

	self.PermissionList = self:Add( "Panel" )

	self.Collapsed = false

end

local white = Color( 255, 255, 255, 255 )
local bg = Color( 50, 50, 50, 255 )
function PANEL:Paint( w, h )

	white.a = self:GetAlpha()
	bg.a = self:GetAlpha()

	draw.RoundedBox( 4, 0, 0, w, h, bg )
	draw.SimpleText( self.Title, "DermaLarge", 4, 2, white, draw.TEXT_ALIGN_LEFT, draw.TEXT_ALIGN_TOP )

	surface.SetMaterial( arrowMat )
	surface.SetDrawColor( white )
	surface.DrawTexturedRectRotated( w - 20, 20, 20, 20, self.Collapsed and 180 or 0 )

end

function PANEL:OnMousePressed()

	self.Collapsed = !self.Collapsed
	self:InvalidateLayout()

	collapsedCache[ self.Title ] = self.Collapsed

end

function PANEL:SetGroup( groupID )

	self.Title = groupID

end

function PANEL:PerformLayout( w, h )

	self.PermissionList:InvalidateLayout( true )
	self.PermissionList:SizeToChildren( false, true )

	surface.SetFont( "DermaLarge" )
	local _, headerSize = surface.GetTextSize( self.Title )

	self.PermissionList:SetPos( 4, 4 + headerSize )
	self.PermissionList:SetWide( self:GetWide() - 8 )

	if ( self.Collapsed ) then
		self:SetTall( headerSize + 5 )
		return
	end

	self:SetTall( self.PermissionList:GetTall() + ( 8 + headerSize ) )

end

function PANEL:ReceivePerm( perm, temp )
	local pnl = self.PermissionPanels[ perm ]

	if ( !IsValid( pnl ) ) then
		pnl = self.PermissionList:Add( "Permission" )
		self.PermissionPanels[ perm ] = pnl
		self:InvalidateLayout()
	end

	pnl:SetPermission( perm, temp )
end

function PANEL:ReceivePerms( perms, temp )

	for id, str in pairs( string.Explode( ",", perms ) ) do
		self:ReceivePerm( str, temp )
	end

end

vgui.Register( "ServerPermissionsPanel", PANEL, "Panel" )







local PANEL = {}
local g_Permissions = nil

function PANEL:Init()

	self.ServerPanels = {}

	self:DoPermissions()

	g_Permissions = self

end

function PANEL:AddServerGroup( address, perms, temp )
	local pnl = self.ServerPanels[ address ]

	if ( !IsValid( pnl ) ) then
		pnl = self:Add( "ServerPermissionsPanel" )
		pnl:SetGroup( address )
		self.ServerPanels[ address ] = pnl

		self:InvalidateLayout()
	end

	pnl:ReceivePerms( perms, temp )
end

function PANEL:DoPermissions()

	for id, pnl in pairs( self.ServerPanels ) do
		pnl:Remove()
	end

	local perms = permissions.GetAll()
	for address, perm in pairs( perms.temporary ) do
		self:AddServerGroup( address, perm, true )
	end
	for address, perm in pairs( perms.permanent ) do
		self:AddServerGroup( address, perm )
	end

end

function PANEL:Think()

	if ( self:GetCanvas():ChildCount() < 1 and !IsValid( self.NoPermissionsLabel ) ) then
		self.NoPermissionsLabel = self.ParentFrame:AddEmptyWarning( "#permissions.none", self )
	elseif ( self:GetCanvas():ChildCount() > 1 and IsValid( self.NoPermissionsLabel ) ) then
		self.NoPermissionsLabel:Remove()
	end

end

vgui.Register( "PermissionViewer", PANEL, "DScrollPanel" )

hook.Add( "OnPermissionsChanged", "OnPermissionsChanged", function()

	if ( IsValid( g_Permissions ) ) then
		g_Permissions:DoPermissions()
	end

end )

