--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DTab

--]]

local PANEL = {}

AccessorFunc( PANEL, "m_pPropertySheet", 			"PropertySheet" )
AccessorFunc( PANEL, "m_pPanel", 					"Panel" )

Derma_Hook( PANEL, "Paint", "Paint", "Tab" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetMouseInputEnabled( true )
	self:SetContentAlignment( 7 )
	self:SetTextInset( 0, 4 )
	
end

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:DoClick()

	self:GetPropertySheet():SetActiveTab( self )

end

function PANEL:PerformLayout()

	self:ApplySchemeSettings();
		
	if ( !self.Image ) then return end
		
	self.Image:SetPos( 7, 3 )
	
	if ( !self:IsActive() ) then
		self.Image:SetImageColor( Color( 255, 255, 255, 155 ) )
	else
		self.Image:SetImageColor( Color( 255, 255, 255, 255 ) )
	end
	
end

--[[---------------------------------------------------------
	UpdateColours
-----------------------------------------------------------]]
function PANEL:UpdateColours( skin )

	local Active = self:GetPropertySheet():GetActiveTab() == self
	
	if ( Active ) then
	
		if ( self:GetDisabled() )	then return self:SetTextStyleColor( skin.Colours.Tab.Active.Disabled ) end
		if ( self:IsDown() )		then return self:SetTextStyleColor( skin.Colours.Tab.Active.Down ) end
		if ( self.Hovered )			then return self:SetTextStyleColor( skin.Colours.Tab.Active.Hover ) end

		return self:SetTextStyleColor( skin.Colours.Tab.Active.Normal )
		
	end

	if ( self:GetDisabled() )	then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Disabled ) end
	if ( self:IsDown() )		then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Down ) end
	if ( self.Hovered )			then return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Tab.Inactive.Normal )

end

function PANEL:ApplySchemeSettings()

	local ExtraInset = 10

	if ( self.Image ) then
		ExtraInset = ExtraInset + self.Image:GetWide()
	end
	
	local Active = self:GetPropertySheet():GetActiveTab() == self
	
	self:SetTextInset( ExtraInset, 4 )
	local w, h = self:GetContentSize()
	h = 20
	if ( Active ) then h = 28 end

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

	// Do nothing!

end

derma.DefineControl( "DTab", "A Tab for use on the PropertySheet", PANEL, "DButton" )

--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DPropertySheet

--]]

local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "PropertySheet" )

AccessorFunc( PANEL, "m_pActiveTab", 			"ActiveTab" )
AccessorFunc( PANEL, "m_iPadding",	 			"Padding" )
AccessorFunc( PANEL, "m_fFadeTime", 			"FadeTime" )

AccessorFunc( PANEL, "m_bShowIcons", 			"ShowIcons" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()
	
	self:SetShowIcons( true )

	self.tabScroller 	= vgui.Create( "DHorizontalScroller", self )
	self.tabScroller:SetOverlap( 5 )
	self.tabScroller:Dock( TOP )

	self:SetFadeTime( 0.1 )
	self:SetPadding( 8 )
		
	self.animFade = Derma_Anim( "Fade", self, self.CrossFade )
	
	self.Items = {}
	
end

--[[---------------------------------------------------------
   Name: AddSheet
-----------------------------------------------------------]]
function PANEL:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}
	
	Sheet.Name = label;

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
	
	return Sheet;

end

--[[---------------------------------------------------------
   Name: SetActiveTab
-----------------------------------------------------------]]
function PANEL:SetActiveTab( active )

	if ( self.m_pActiveTab == active ) then return end
	
	if ( self.m_pActiveTab) then
	
		if ( self:GetFadeTime() > 0 ) then
		
			self.animFade:Start( self:GetFadeTime(), { OldTab = self.m_pActiveTab, NewTab = active } )
			
		else
		
			self.m_pActiveTab:GetPanel():SetVisible( false )
		
		end
	end

	self.m_pActiveTab = active
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	self.animFade:Run()

end


--[[---------------------------------------------------------
   Name: CrossFade
-----------------------------------------------------------]]
function PANEL:CrossFade( anim, delta, data )
	
	local old = data.OldTab:GetPanel()
	local new = data.NewTab:GetPanel()
	
	if ( anim.Finished ) then
	
		old:SetVisible( false )
		new:SetAlpha( 255 )
		
		old:SetZPos( 0 )
		new:SetZPos( 0 )
		
	return end
	
	if ( anim.Started ) then
	
		old:SetZPos( 0 )
		new:SetZPos( 1 )
		
		old:SetAlpha( 255 )
		new:SetAlpha( 0 )
		
	end
	
	old:SetVisible( true )
	new:SetVisible( true )
		
	new:SetAlpha( 255 * delta )

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local ActiveTab = self:GetActiveTab()
	local Padding = self:GetPadding()
	
	if ( !ActiveTab ) then return end
	
	-- Update size now, so the height is definitiely right.
	ActiveTab:InvalidateLayout( true )
		
	--self.tabScroller:StretchToParent( Padding, 0, Padding, nil )
	self.tabScroller:SetTall( ActiveTab:GetTall() )
	
	
	
	local ActivePanel = ActiveTab:GetPanel()
		
	for k, v in pairs( self.Items ) do
	
		if ( v.Tab:GetPanel() == ActivePanel ) then
		
			v.Tab:GetPanel():SetVisible( true )
			v.Tab:SetZPos( 100 )
		
		else
		
			v.Tab:GetPanel():SetVisible( false )	
			v.Tab:SetZPos( 1 )
		
		end
	
		v.Tab:ApplySchemeSettings()
			
	
	end
	
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

	-- Give the animation a chance
	self.animFade:Run()
	
end


--[[---------------------------------------------------------
   Name: SizeToContentWidth
-----------------------------------------------------------]]
function PANEL:SizeToContentWidth()

	local wide = 0

	for k, v in pairs( self.Items ) do
	
		if ( v.Panel ) then
			v.Panel:InvalidateLayout( true )
			wide = math.max( wide, v.Panel:GetWide()  + self.m_iPadding * 2 )
		end
	
	end
	
	self:SetWide( wide )

end

--[[---------------------------------------------------------
   Name: SwitchToName
-----------------------------------------------------------]]
function PANEL:SwitchToName( name )

	for k, v in pairs( self.Items ) do
		
		if ( v.Name == name ) then
			v.Tab:DoClick()
			return true
		end	
	
	end
	
	return false;

end

function PANEL:SetupCloseButton( func )

	self.CloseButton = self.tabScroller:Add( "DImageButton" )
	self.CloseButton:SetImage( "icon16/circlecross.png" )
	self.CloseButton:SetColor( Color( 10, 10, 10, 200 ) );
	self.CloseButton:DockMargin( 0, 0, 0, 8 )
	self.CloseButton:SetWide( 16 )
	self.CloseButton:Dock( RIGHT )
	self.CloseButton.DoClick = function() func() end

end

function PANEL:CloseTab( tab, bRemovePanelToo )

	for k, v in pairs( self.Items ) do
	
		if ( v.Tab != tab ) then continue end
		
		table.remove( self.Items, k )
		
	end
	
	for k, v in pairs(self.tabScroller.Panels) do
	
		if ( v != tab ) then continue end
		
		table.remove( self.tabScroller.Panels, k )
		
	end
	
	self.tabScroller:InvalidateLayout( true )
	 
	if ( tab == self:GetActiveTab() ) then
		self.m_pActiveTab = self.Items[#self.Items].Tab
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
