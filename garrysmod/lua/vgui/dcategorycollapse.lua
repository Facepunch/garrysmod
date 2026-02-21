
local PANEL = {

	Init = function( self )

		self:SetContentAlignment( 4 )
		self:SetTextInset( 5, 0 )
		self:SetFont( "DermaDefaultBold" )

	end,

	DoClick = function( self )

		self:GetParent():Toggle()

	end,

	UpdateColours = function( self, skin )

		if ( !self:GetParent():GetExpanded() ) then
			self:SetExpensiveShadow( 0, Color( 0, 0, 0, 200 ) )
			return self:SetTextStyleColor( skin.Colours.Category.Header_Closed )
		end

		self:SetExpensiveShadow( 1, Color( 0, 0, 0, 100 ) )
		return self:SetTextStyleColor( skin.Colours.Category.Header )

	end,

	Paint = function( self )

		-- Do nothing!

	end,

	GenerateExample = function()

		-- Do nothing!

	end

}

derma.DefineControl( "DCategoryHeader", "Category Header", PANEL, "DButton" )

local PANEL = {}

AccessorFunc( PANEL, "m_bSizeExpanded",		"Expanded", FORCE_BOOL )
AccessorFunc( PANEL, "m_iContentHeight",	"StartHeight" )
AccessorFunc( PANEL, "m_fAnimTime",			"AnimTime" )
AccessorFunc( PANEL, "m_bDrawBackground",	"PaintBackground", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDrawBackground",	"DrawBackground", FORCE_BOOL ) -- deprecated
AccessorFunc( PANEL, "m_iPadding",			"Padding" )
AccessorFunc( PANEL, "m_pList",				"List" )

function PANEL:Init()

	self.Header = vgui.Create( "DCategoryHeader", self )
	self.Header:Dock( TOP )
	self.Header:SetSize( 20, 20 )

	self:SetSize( 16, 16 )
	self:SetExpanded( true )
	self:SetMouseInputEnabled( true )

	self:SetAnimTime( 0.2 )
	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )

	self:SetPaintBackground( true )
	self:DockMargin( 0, 0, 0, 2 )
	self:DockPadding( 0, 0, 0, 0 )

end

function PANEL:Add( strName )

	local button = vgui.Create( "DButton", self )
	button.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	button.UpdateColours = function( panel, skin )

		if ( panel.AltLine ) then

			if ( !panel:IsEnabled() ) then						return panel:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Disabled ) end
			if ( panel.Depressed || panel.m_bSelected ) then	return panel:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Selected ) end
			if ( panel.Hovered ) then							return panel:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Hover ) end
			return panel:SetTextStyleColor( skin.Colours.Category.LineAlt.Text )

		end

		if ( !panel:IsEnabled() ) then						return panel:SetTextStyleColor( skin.Colours.Category.Line.Text_Disabled ) end
		if ( panel.Depressed || panel.m_bSelected ) then	return panel:SetTextStyleColor( skin.Colours.Category.Line.Text_Selected ) end
		if ( panel.Hovered ) then							return panel:SetTextStyleColor( skin.Colours.Category.Line.Text_Hover ) end
		return panel:SetTextStyleColor( skin.Colours.Category.Line.Text )

	end

	button:SetHeight( 17 )
	button:SetTextInset( 4, 0 )

	button:SetContentAlignment( 4 )
	button:DockMargin( 1, 0, 1, 0 )
	button.DoClickInternal = function()

		if ( self:GetList() ) then
			self:GetList():UnselectAll()
		else
			self:UnselectAll()
		end

		button:SetSelected( true )

	end

	button:Dock( TOP )
	button:SetText( strName )

	self:InvalidateLayout( true )
	self:UpdateAltLines()

	return button

end

function PANEL:UnselectAll()

	for k, v in ipairs( self:GetChildren() ) do

		if ( v.SetSelected ) then
			v:SetSelected( false )
		end

	end

end

function PANEL:UpdateAltLines()

	for k, v in ipairs( self:GetChildren() ) do
		v.AltLine = k % 2 != 1
	end

end

function PANEL:Think()

	self.animSlide:Run()

end

function PANEL:SetLabel( strLabel )

	self.Header:SetText( strLabel )

end

function PANEL:SetHeaderHeight( height )

	self.Header:SetTall( height )

end

function PANEL:GetHeaderHeight()

	return self.Header:GetTall()

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "CollapsibleCategory", self, w, h )

	return false

end

function PANEL:SetContents( pContents )

	self.Contents = pContents
	self.Contents:SetParent( self )
	self.Contents:Dock( FILL )

	if ( !self:GetExpanded() ) then

		self.OldHeight = self:GetTall()

	elseif ( self:GetExpanded() && IsValid( self.Contents ) && self.Contents:GetTall() < 1 ) then

		self.Contents:SizeToChildren( false, true )
		self.OldHeight = self.Contents:GetTall()
		self:SetTall( self.OldHeight )

	end

	self:InvalidateLayout( true )

end

function PANEL:SetExpanded( expanded )

	self.m_bSizeExpanded = tobool( expanded )

	if ( !self:GetExpanded() ) then
		if ( !self.animSlide.Finished && self.OldHeight ) then return end
		self.OldHeight = self:GetTall()
	end

end

function PANEL:Toggle()

	self:SetExpanded( !self:GetExpanded() )

	self.animSlide:Start( self:GetAnimTime(), { From = self:GetTall() } )

	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

	local open = "1"
	if ( !self:GetExpanded() ) then open = "0" end
	self:SetCookie( "Open", open )

	self:OnToggle( self:GetExpanded() )

end

function PANEL:OnToggle( expanded )

	-- Do nothing / For developers to overwrite

end

function PANEL:DoExpansion( b )

	if ( self:GetExpanded() == b ) then return end
	self:Toggle()

end

function PANEL:PerformLayout()

	if ( IsValid( self.Contents ) ) then

		if ( self:GetExpanded() ) then
			self.Contents:InvalidateLayout( true )
			self.Contents:SetVisible( true )
		else
			self.Contents:SetVisible( false )
		end

	end

	if ( self:GetExpanded() ) then

		if ( IsValid( self.Contents ) && #self.Contents:GetChildren() > 0 ) then self.Contents:SizeToChildren( false, true ) end
		self:SizeToChildren( false, true )

	else

		if ( IsValid( self.Contents ) && !self.OldHeight ) then self.OldHeight = self.Contents:GetTall() end
		self:SetTall( self:GetHeaderHeight() )

	end

	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()

	self.animSlide:Run()
	self:UpdateAltLines()

end

function PANEL:OnMousePressed( mcode )

	if ( !self:GetParent().OnMousePressed ) then return end

	return self:GetParent():OnMousePressed( mcode )

end

function PANEL:AnimSlide( anim, delta, data )

	self:InvalidateLayout()
	self:InvalidateParent()

	if ( anim.Started ) then
		if ( !IsValid( self.Contents ) && ( self.OldHeight || 0 ) < self.Header:GetTall() ) then
			-- We are not using self.Contents and our designated height is less
			-- than the header size, something is clearly wrong, try to rectify
			self.OldHeight = 0
			for id, pnl in ipairs( self:GetChildren() ) do
				self.OldHeight = self.OldHeight + pnl:GetTall()
			end
		end

		if ( self:GetExpanded() ) then
			data.To = math.max( self.OldHeight, self:GetTall() )
		else
			data.To = self:GetTall()
		end
	end

	if ( IsValid( self.Contents ) ) then self.Contents:SetVisible( true ) end

	self:SetTall( Lerp( delta, data.From, data.To ) )

end

function PANEL:LoadCookies()

	local Open = self:GetCookieNumber( "Open", 1 ) == 1

	self:SetExpanded( Open )
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetLabel( "Category List Test Category" )
	ctrl:SetSize( 300, 300 )
	ctrl:SetPadding( 10 )
	ctrl:SetHeaderHeight( 32 )

	-- The contents can be any panel, even a DPanelList
	local Contents = vgui.Create( "DButton" )
	Contents:SetText( "This is the content of the control" )
	ctrl:SetContents( Contents )

	ctrl:InvalidateLayout( true )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DCollapsibleCategory", "Collapsable Category Panel", PANEL, "Panel" )
