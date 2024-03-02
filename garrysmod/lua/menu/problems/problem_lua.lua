
local realmColors = {}
realmColors[ "menu" ] = Color( 121, 221, 100 )
realmColors[ "client" ] = Color( 255, 222, 102 )
realmColors[ "server" ] = Color( 137, 222, 255 )

surface.CreateFont( "DermaMedium", {
	font		= "Roboto",
	size		= 24,
	weight		= 500
} )

local PANEL = {}

function PANEL:Init()

	self:Dock( TOP )
	self:DockMargin( 0, 0, 0, 1 )

	self.CopyBtn = self:Add( "DImageButton" )
	self.CopyBtn:SetImage( "icon16/page_copy.png" )
	self.CopyBtn:SetSize( 16, 16 )
	self.CopyBtn.DoClick = function( btm )
		if ( !self.Problem ) then return end

		local prepend = ""
		if ( self.Problem.title and self.Problem.title:len() > 0 and self.Problem.title != "Other" ) then prepend = "[" .. self.Problem.title .. "] " end
		SetClipboardText( prepend .. self.Problem.text )
	end

end

function PANEL:PerformLayout( w, h )

	surface.SetFont( "DermaDefault" )

	if ( self.Problem ) then
		local _, th = surface.GetTextSize( self.Problem.text )
		self:SetTall( th + 10 )
	end

	local bW, bH = self.CopyBtn:GetSize()
	self.CopyBtn:SetPos( w - bW - 8, h / 2 - bH / 2 )

end

local bgClr = Color( 75, 75, 75, 255 )
local fgClr = Color( 255, 255, 255, 255 )
function PANEL:Paint( w, h )

	bgClr.a = self:GetAlpha()

	-- No info yet
	if ( !self.Problem ) then
		draw.RoundedBox( 0, 0, 0, w, h, bgClr )
		return
	end

	-- Get the colors
	local clr = table.Copy( realmColors[ self.Problem.realm ] or fgClr )
	clr.a = self:GetAlpha()

	-- Background color
	local bgClrH = bgClr
	if ( self.Problem.lastOccurence ) then
		local add = 75 + math.max( 25 - ( SysTime() - self.Problem.lastOccurence ) * 25, 0 )
		bgClrH = Color( add, add, add, self:GetAlpha() )
	end

	draw.RoundedBox( 0, 0, 0, w, h, bgClrH )

	-- Draw background
	local count = 0
	if ( self.Problem and self.Problem.count ) then count = self.Problem.count end

	-- The error count
	if ( count > 0 ) then
		local txt = "x" .. count
		surface.SetFont( "DermaMedium" )
		local tW, tH = surface.GetTextSize( txt )
		tW = tW

		draw.SimpleText( txt, "DermaMedium", w - 16 - 16, h / 2, clr, draw.TEXT_ALIGN_RIGHT, draw.TEXT_ALIGN_CENTER )
	end

	-- The error
	draw.DrawText( self.Problem.text, "DermaDefault", 5, 5, clr )

end

function PANEL:Setup( problem )

	self.Problem = problem

end

vgui.Register( "LuaProblem", PANEL, "Panel" )

--[[ ////////////////////////////////////////////////// GROUP ////////////////////////////////////////////////// ]] --

local PANEL = {}

local arrowMat = Material( "gui/point.png" )
local collapsedCache = {}

function PANEL:Init()

	self:Dock( TOP )
	self:SetTall( 20 )
	self:DockMargin( 0, 0, 0, 5	)

	self.ErrorPanels = {}

	self.LuaErrorList = self:Add( "Panel" )

	self.ClearButton = self:Add( "DImageButton" )
	self.ClearButton:SetImage( "gui/cross.png" )
	self.ClearButton:SetSize( 18, 18 )
	self.ClearButton.DoClick = function( s ) self:ClearThisGroup() end

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
	surface.DrawTexturedRectRotated( w - 20, 18, 20, 12, self.Collapsed and 180 or 0 )

	local h2 = self.LuaErrorList:GetTall()
	local _, lY = self.LuaErrorList:GetPos()

	draw.DrawText( self:GetExplainerText(), "DermaDefault", w / 2, lY + h2 + 5, white, draw.TEXT_ALIGN_CENTER )

end

function PANEL:ClearThisGroup()

	ClearLuaErrorGroup( self.GroupID )

end

function PANEL:OnMousePressed( code )

	if ( code != MOUSE_LEFT ) then return end

	self.Collapsed = !self.Collapsed
	self:InvalidateLayout()

	collapsedCache[ self.Title ] = self.Collapsed

end

function PANEL:GetExplainerText()

	if ( self.Title == "Other" and self.AddonID and self.AddonID:len() < 2 ) then
		return language.GetPhrase( "problems.generic_lua_error" )
	end

	-- Not a workshop addon, or a floating .gma (WSID=0)
	if ( self.AddonID and self.AddonID:len() < 2 ) then
		return language.GetPhrase( "problems.addon_lua_error" ):format( self.Title )
	end

	return language.GetPhrase( "problems.workshop_lua_error" ):format( self.Title )

end

function PANEL:SetTitleAndID( title, id, groupid )

	self.Title = title
	self.AddonID = id
	self.GroupID = groupid

	self.Collapsed = collapsedCache[ self.Title ]

	if ( self.AddonID and self.AddonID:len() > 1 ) then
		self.DisableBtn = self:Add( "DButton" )
		self.DisableBtn:SetText( "#problems.disable" )
		self.DisableBtn:SizeToContentsX( 10 )
		self.DisableBtn.DoClick = function() steamworks.SetShouldMountAddon( self.AddonID, false ) steamworks.ApplyAddons() end

		self.OpenWSBtn = self:Add( "DButton" )
		self.OpenWSBtn:SetText( "#problems.open_on_workshop" )
		self.OpenWSBtn:SizeToContentsX( 10 )
		self.OpenWSBtn.DoClick = function() steamworks.ViewFile( self.AddonID ) end

		self.UninstallBtn = self:Add( "DButton" )
		self.UninstallBtn:SetText( "#problems.uninstall" )
		self.UninstallBtn:SizeToContentsX( 10 )
		self.UninstallBtn.DoClick = function() steamworks.Unsubscribe( self.AddonID ) end

		local maxS = math.max( self.DisableBtn:GetWide(), self.OpenWSBtn:GetWide(), self.UninstallBtn:GetWide() )
		self.DisableBtn:SetWide( maxS )
		self.OpenWSBtn:SetWide( maxS )
		self.UninstallBtn:SetWide( maxS )
	end

end

function PANEL:PerformLayout( w, h )

	self.ClearButton:SetPos( w - 56, 9 )

	self.LuaErrorList:InvalidateLayout( true )
	self.LuaErrorList:SizeToChildren( false, true )

	surface.SetFont( "DermaLarge" )
	local _, headerSize = surface.GetTextSize( self.Title )

	self.LuaErrorList:SetPos( 4, 4 + headerSize )
	self.LuaErrorList:SetWide( self:GetWide() - 8 )


	surface.SetFont( "DermaDefault" )
	local _, etH = surface.GetTextSize( self:GetExplainerText() )

	if ( IsValid( self.DisableBtn ) ) then
		local h2 = self.LuaErrorList:GetTall()
		local _, lY = self.LuaErrorList:GetPos()
		local y = lY + h2 + 5 + etH + 5

		self.OpenWSBtn:SetPos( w * 0.25 - self.OpenWSBtn:GetWide() / 2, y )
		self.DisableBtn:SetPos( w * 0.5 - self.DisableBtn:GetWide() / 2, y )
		self.UninstallBtn:SetPos( w * 0.75 - self.UninstallBtn:GetWide() / 2, y )
		etH = etH + self.DisableBtn:GetTall() + 5
	end

	if ( self.Collapsed ) then
		self:SetTall( headerSize + 5 )
		return
	end

	self:SetTall( self.LuaErrorList:GetTall() + ( 8 + headerSize ) + ( etH + 5 ) )

end

function PANEL:Think()

	if ( IsValid( self.DisableBtn ) ) then
		self.DisableBtn:SetEnabled( steamworks.IsSubscribed( self.AddonID ) and steamworks.ShouldMountAddon( self.AddonID ) )
		self.UninstallBtn:SetEnabled( steamworks.IsSubscribed( self.AddonID ) )
	end

end

function PANEL:ReceivedError( uid, err )

	local pnl = self.ErrorPanels[ uid ]

	local shouldSort = false
	if ( !IsValid( pnl ) ) then
		pnl = self.LuaErrorList:Add( "LuaProblem" )
		self.ErrorPanels[ uid ] = pnl
		self:InvalidateLayout()

		shouldSort = true
	end

	pnl:Setup( err )

	if ( shouldSort ) then
		local sorted = {}
		for gid, epnl in pairs( self.ErrorPanels ) do
			sorted[ epnl.Problem.firstOccurence ] = epnl
		end

		local z = 0
		for sort, spnl in SortedPairs( sorted ) do
			spnl:SetZPos( z )
			z = z + 1
		end
	end

end

vgui.Register( "LuaProblemGroup", PANEL, "Panel" )
