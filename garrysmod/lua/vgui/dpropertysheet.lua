
local PANEL = {}

AccessorFunc( PANEL, "m_pPropertySheet", "PropertySheet" )
AccessorFunc( PANEL, "m_pPanel", "Panel" )

Derma_Hook( PANEL, "Paint", "Paint", "Tab" )

function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetContentAlignment( 7 )
	self:SetTextInset( 0, 4 )

end

function PANEL:Setup( label, pPropertySheet, pPanel, strMaterial )

	self:SetText( label )
	self:SetPropertySheet( pPropertySheet )
	self:SetPanel( pPanel )

	if ( strMaterial ) then

		self.Image = vgui.Create( "DImage", self )
		self.Image:SetImage( strMaterial )
		self.Image:SizeToContents()
		self:InvalidateLayout()

	end

end

function PANEL:IsActive()
	return self:GetPropertySheet():GetActiveTab() == self
end

function PANEL:DoClick()

	self:GetPropertySheet():SetActiveTab( self )

end

function PANEL:PerformLayout()

	self:ApplySchemeSettings()

	if ( !self.Image ) then return end

	self.Image:SetPos( 7, 3 )

	if ( !self:IsActive() ) then
		self.Image:SetImageColor( Color( 255, 255, 255, 155 ) )
	else
		self.Image:SetImageColor( color_white )
	end

end

function PANEL:UpdateColours( skin )

	if ( self:IsActive() ) then

		if ( self:GetDisabled() ) then return self:SetTextStyleColor( skin.Colours.Tab.Active.Disabled ) end
		if ( self:IsDown() ) then return self:SetTextStyleColor( skin.Colours.Tab.Active.Down ) end
		if ( self.Hovered ) then return self:SetTextStyleColor( skin.Colours.Tab.Active.Hover ) end

		return self:SetTextStyleColor( skin.Colours.Tab.Active.Normal )

	end

	if ( self:GetDisabled() ) then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Disabled ) end
	if ( self:IsDown() ) then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Down ) end
	if ( self.Hovered ) then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Normal )

end

function PANEL:GetTabHeight()

	if ( self:IsActive() ) then
		return 28
	else
		return 20
	end

end

function PANEL:ApplySchemeSettings()

	local ExtraInset = 10

	if ( self.Image ) then
		ExtraInset = ExtraInset + self.Image:GetWide()
	end

	self:SetTextInset( ExtraInset, 4 )
	local w, h = self:GetContentSize()
	h = self:GetTabHeight()

	self:SetSize( w + 10, h )

	DLabel.ApplySchemeSettings( self )

end

--
-- DragHoverClick
--
function PANEL:DragHoverClick( HoverTime )

	self:DoClick()

end

function PANEL:GenerateExample()

	-- Do nothing!

end

function PANEL:DoRightClick()

	if ( !IsValid( self:GetPropertySheet() ) ) then return end

	local tabs = DermaMenu()
	for k, v in pairs( self:GetPropertySheet().Items ) do
		if ( !v || !IsValid( v.Tab ) || !v.Tab:IsVisible() ) then continue end
		local option = tabs:AddOption( v.Tab:GetText(), function()
			if ( !v || !IsValid( v.Tab ) || !IsValid( self:GetPropertySheet() ) || !IsValid( self:GetPropertySheet().tabScroller ) ) then return end
			v.Tab:DoClick()
			self:GetPropertySheet().tabScroller:ScrollToChild( v.Tab )
		end )
		if ( IsValid( v.Tab.Image ) ) then option:SetIcon( v.Tab.Image:GetImage() ) end
	end
	tabs:Open()

end

derma.DefineControl( "DTab", "A Tab for use on the PropertySheet", PANEL, "DButton" )

--[[---------------------------------------------------------
	DPropertySheet
-----------------------------------------------------------]]

local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "PropertySheet" )

AccessorFunc( PANEL, "m_pActiveTab", "ActiveTab" )
AccessorFunc( PANEL, "m_iPadding", "Padding" )
AccessorFunc( PANEL, "m_fFadeTime", "FadeTime" )

AccessorFunc( PANEL, "m_bShowIcons", "ShowIcons" )

function PANEL:Init()

	self:SetShowIcons( true )

	self.tabScroller = vgui.Create( "DHorizontalScroller", self )
	self.tabScroller:SetOverlap( 5 )
	self.tabScroller:Dock( TOP )
	self.tabScroller:DockMargin( 3, 0, 3, 0 )

	self:SetFadeTime( 0.1 )
	self:SetPadding( 8 )

	self.animFade = Derma_Anim( "Fade", self, self.CrossFade )

	self.Items = {}

end

function PANEL:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )

	if ( !IsValid( panel ) ) then
		ErrorNoHalt( "DPropertySheet:AddSheet tried to add invalid panel!" )
		debug.Trace()
		return
	end

	local Sheet = {}

	Sheet.Name = label

	Sheet.Tab = vgui.Create( "DTab", self )
	Sheet.Tab:SetTooltip( Tooltip )
	Sheet.Tab:Setup( label, self, panel, material )

	Sheet.Panel = panel
	Sheet.Panel.NoStretchX = NoStretchX
	Sheet.Panel.NoStretchY = NoStretchY
	Sheet.Panel:SetPos( self:GetPadding(), 20 + self:GetPadding() )
	Sheet.Panel:SetVisible( false )

	panel:SetParent( self )

	table.insert( self.Items, Sheet )

	if ( !self:GetActiveTab() ) then
		self:SetActiveTab( Sheet.Tab )
		Sheet.Panel:SetVisible( true )
	end

	self.tabScroller:AddPanel( Sheet.Tab )

	return Sheet

end

function PANEL:SetActiveTab( active )

	if ( !IsValid( active ) || self.m_pActiveTab == active ) then return end

	if ( IsValid( self.m_pActiveTab ) ) then

		-- Only run this callback when we actually switch a tab, not when a tab is initially set active
		self:OnActiveTabChanged( self.m_pActiveTab, active )

		if ( self:GetFadeTime() > 0 ) then

			self.animFade:Start( self:GetFadeTime(), { OldTab = self.m_pActiveTab, NewTab = active } )

		else

			self.m_pActiveTab:GetPanel():SetVisible( false )

		end

	end

	self.m_pActiveTab = active
	self:InvalidateLayout()

end

function PANEL:OnActiveTabChanged( old, new )
	-- For override
end

function PANEL:Think()

	self.animFade:Run()

end

function PANEL:GetItems()

	return self.Items

end

function PANEL:CrossFade( anim, delta, data )

	if ( !data || !IsValid( data.OldTab ) || !IsValid( data.NewTab ) ) then return end

	local old = data.OldTab:GetPanel()
	local new = data.NewTab:GetPanel()

	if ( !IsValid( old ) && !IsValid( new ) ) then return end

	if ( anim.Finished ) then
		if ( IsValid( old ) ) then
			old:SetAlpha( 255 )
			old:SetZPos( 0 )
			old:SetVisible( false )
		end

		if ( IsValid( new ) ) then
			new:SetAlpha( 255 )
			new:SetZPos( 0 )
			new:SetVisible( true ) // In case new == old
		end

		return
	end

	if ( anim.Started ) then
		if ( IsValid( old ) ) then
			old:SetAlpha( 255 )
			old:SetZPos( 0 )
		end

		if ( IsValid( new ) ) then
			new:SetAlpha( 0 )
			new:SetZPos( 1 )
		end

	end

	if ( IsValid( old ) ) then
		old:SetVisible( true )
		if ( !IsValid( new ) ) then old:SetAlpha( 255 * ( 1 - delta ) ) end
	end

	if ( IsValid( new ) ) then
		new:SetVisible( true )
		new:SetAlpha( 255 * delta )
	end

end

function PANEL:PerformLayout()

	local ActiveTab = self:GetActiveTab()
	local Padding = self:GetPadding()

	if ( !IsValid( ActiveTab ) ) then return end

	-- Update size now, so the height is definitiely right.
	ActiveTab:InvalidateLayout( true )

	--self.tabScroller:StretchToParent( Padding, 0, Padding, nil )
	self.tabScroller:SetTall( ActiveTab:GetTall() )

	local ActivePanel = ActiveTab:GetPanel()

	for k, v in pairs( self.Items ) do

		if ( v.Tab:GetPanel() == ActivePanel ) then

			if ( IsValid( v.Tab:GetPanel() ) ) then v.Tab:GetPanel():SetVisible( true ) end
			v.Tab:SetZPos( 100 )

		else

			if ( IsValid( v.Tab:GetPanel() ) ) then v.Tab:GetPanel():SetVisible( false ) end
			v.Tab:SetZPos( 1 )

		end

		v.Tab:ApplySchemeSettings()

	end

	if ( IsValid( ActivePanel ) ) then
		if ( !ActivePanel.NoStretchX ) then
			ActivePanel:SetWide( self:GetWide() - Padding * 2 )
		else
			ActivePanel:CenterHorizontal()
		end

		if ( !ActivePanel.NoStretchY ) then
			local _, y = ActivePanel:GetPos()
			ActivePanel:SetTall( self:GetTall() - y - Padding )
		else
			ActivePanel:CenterVertical()
		end

		ActivePanel:InvalidateLayout()
	end

	-- Give the animation a chance
	self.animFade:Run()

end

function PANEL:SizeToContentWidth()

	local wide = 0

	for k, v in pairs( self.Items ) do

		if ( IsValid( v.Panel ) ) then
			v.Panel:InvalidateLayout( true )
			wide = math.max( wide, v.Panel:GetWide() + self:GetPadding() * 2 )
		end

	end

	self:SetWide( wide )

end

function PANEL:SwitchToName( name )

	for k, v in pairs( self.Items ) do

		if ( v.Name == name ) then
			v.Tab:DoClick()
			return true
		end

	end

	return false

end

function PANEL:SetupCloseButton( func )

	self.CloseButton = self.tabScroller:Add( "DImageButton" )
	self.CloseButton:SetImage( "icon16/circlecross.png" )
	self.CloseButton:SetColor( Color( 10, 10, 10, 200 ) )
	self.CloseButton:DockMargin( 1, 1, 1, 9 )
	self.CloseButton:SetWide( 18 )
	self.CloseButton:Dock( RIGHT )
	self.CloseButton.DoClick = function()
		if ( func ) then func() end
	end

end

function PANEL:CloseTab( tab, bRemovePanelToo )

	for k, v in pairs( self.Items ) do

		if ( v.Tab != tab ) then continue end

		table.remove( self.Items, k )

	end

	for k, v in pairs( self.tabScroller.Panels ) do

		if ( v != tab ) then continue end

		table.remove( self.tabScroller.Panels, k )

	end

	self.tabScroller:InvalidateLayout( true )

	if ( tab == self:GetActiveTab() ) then
		self.m_pActiveTab = self.Items[ #self.Items ].Tab
	end

	local pnl = tab:GetPanel()

	if ( bRemovePanelToo ) then
		pnl:Remove()
	end

	tab:Remove()

	self:InvalidateLayout( true )

	return pnl

end

derma.DefineControl( "DPropertySheet", "", PANEL, "Panel" )
