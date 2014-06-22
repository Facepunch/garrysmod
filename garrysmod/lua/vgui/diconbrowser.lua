--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DIconBrowser

--]]

local local_IconList = nil

local PANEL = {}

AccessorFunc( PANEL, "m_strSelectedIcon", 		"SelectedIcon" )
AccessorFunc( PANEL, "m_bManual", 				"Manual" )

--[[---------------------------------------------------------
   Name: SelectIcon
-----------------------------------------------------------]]
function PANEL:SelectIcon( name )

	self.m_strSelectedIcon = name

	for k, v in pairs( self.IconLayout:GetChildren() ) do

		if ( v:GetImage() == name ) then
			self.m_pSelectedIcon = v
		end

	end

end

--[[---------------------------------------------------------
   Name: ScrollToSelected
-----------------------------------------------------------]]
function PANEL:ScrollToSelected()

	if ( !IsValid(self.m_pSelectedIcon) ) then return end

	self:ScrollToChild( self.m_pSelectedIcon )

end

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.m_strSelectedIcon = ""

	self.IconLayout = self:GetCanvas():Add( "DIconLayout" )
	self.IconLayout:SetSpaceX( 0 )
	self.IconLayout:SetSpaceY( 0 )
	self.IconLayout:SetBorder( 4 )
	self.IconLayout:Dock( TOP )

	self:SetPaintBackground( true )

end

--[[---------------------------------------------------------
   Name: Fill
-----------------------------------------------------------]]
function PANEL:Fill()

	self.Filled = true
	if ( self.m_bManual ) then return end

	if ( !local_IconList ) then
		 local_IconList = file.Find( "materials/icon16/*.png", "MOD" )
	end

	for k, v in SortedPairs( local_IconList ) do

		timer.Simple( k * 0.001, function()

				if ( !IsValid( self ) ) then return end
				if ( !IsValid( self.IconLayout ) ) then return end

				local btn = self.IconLayout:Add( "DImageButton" )
				btn.FilterText = string.lower( v )
				btn:SetOnViewMaterial( "icon16/" .. v )
				btn:SetSize( 22, 22 )
				btn:SetPos( -22, -22 )
				btn:SetStretchToFit( false )

				btn.DoClick = function()

					self.m_pSelectedIcon = btn
					self.m_strSelectedIcon = btn:GetImage()
					self:OnChangeInternal()

				end

				btn.Paint = function( btn, w, h )

					if ( self.m_pSelectedIcon != btn ) then return end

					derma.SkinHook( "Paint", "Selection", btn, w, h )

				end

				if ( !self.m_pSelectedIcon || self.m_strSelectedIcon == btn:GetImage() ) then
					self.m_pSelectedIcon = btn
					--self:ScrollToChild( btn )
				end

				self.IconLayout:Layout()

			end )

	end

end

--[[---------------------------------------------------------
   Name: FilterByText
-----------------------------------------------------------]]
function PANEL:FilterByText( text )

	local text = string.lower( text )

	for k, v in pairs( self.IconLayout:GetChildren() ) do

		v:SetVisible( v.FilterText:find( text ) != nil )

	end

	self.IconLayout:Layout()

end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	if ( !self.Filled ) then self:Fill() end

	derma.SkinHook( "Paint", "Tree", self, w, h )

end

--[[---------------------------------------------------------
   Name: OnChangeInternal
-----------------------------------------------------------]]
function PANEL:OnChangeInternal()

	self:OnChange()

end

--[[---------------------------------------------------------
   Name: Clear
-----------------------------------------------------------]]
function PANEL:Clear()

	self.IconLayout:Clear()

end

--[[---------------------------------------------------------
   Name: Add
-----------------------------------------------------------]]
function PANEL:Add( name )

	return self.IconLayout:Add( name )

end

--[[---------------------------------------------------------
   Name: OnChange
-----------------------------------------------------------]]
function PANEL:OnChange()

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetSize( 300, 300 )
		ctrl:SelectIcon( "icon16/heart.png" )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DIconBrowser", "", PANEL, "DScrollPanel" )