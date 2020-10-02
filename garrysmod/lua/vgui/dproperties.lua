
--
-- The row - contained in a category.
--
local tblRow = vgui.RegisterTable( {

	Init = function( self )

		self:Dock( TOP )

		self.Label = self:Add( "DLabel" )
		self.Label:Dock( LEFT )
		self.Label:DockMargin( 4, 2, 2, 2 )

		self.Container = self:Add( "Panel" )
		self.Container:Dock( FILL )

	end,

	PerformLayout = function( self )

		self:SetTall( 20 )
		self.Label:SetWide( self:GetWide() * 0.45 )

	end,

	Setup = function( self, type, vars )

		self.Container:Clear()

		local Name = "DProperty_" .. type

		self.Inner = self.Container:Add( Name )
		if ( !IsValid( self.Inner ) ) then self.Inner = self.Container:Add( "DProperty_Generic" ) end

		self.Inner:SetRow( self )
		self.Inner:Dock( FILL )
		self.Inner:Setup( vars )

		-- First copy the value if it was somehow set before Setup() was
		self.Inner:SetEnabled( self:IsEnabled() )

		-- Then override our methods so they affect Inner element instead
		self.IsEnabled = function( self )
			return self.Inner:IsEnabled()
		end
		self.SetEnabled = function( self, b )
			self.Inner:SetEnabled( b )
		end

	end,

	SetValue = function( self, val )

		--
		-- Don't update the value if our cache'd value is the same.
		--
		if ( self.CacheValue && self.CacheValue == val ) then return end
		self.CacheValue = val

		if ( IsValid( self.Inner ) ) then
			self.Inner:SetValue( val )
		end

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Inner ) ) then return end

		local Skin = self:GetSkin()
		local editing = self.Inner:IsEditing()
		local disabled = !self.Inner:IsEnabled() || !self:IsEnabled()

		if ( disabled ) then
			surface.SetDrawColor( Skin.Colours.Properties.Column_Disabled )
			surface.DrawRect( w * 0.45, 0, w, h )
		elseif ( editing ) then
			surface.SetDrawColor( Skin.Colours.Properties.Column_Selected )
			surface.DrawRect( 0, 0, w * 0.45, h )
		end

		surface.SetDrawColor( Skin.Colours.Properties.Border )
		surface.DrawRect( w - 1, 0, 1, h )
		surface.DrawRect( w * 0.45, 0, 1, h )
		surface.DrawRect( 0, h - 1, w, 1 )

		if ( disabled ) then
			self.Label:SetTextColor( Skin.Colours.Properties.Label_Disabled )
		elseif ( editing ) then
			self.Label:SetTextColor( Skin.Colours.Properties.Label_Selected )
		else
			self.Label:SetTextColor( Skin.Colours.Properties.Label_Normal )
		end

	end

}, "Panel" )

--
-- The category - contained in a dproperties
--
local tblCategory = vgui.RegisterTable( {

	Init = function( self )

		self:Dock( TOP )
		self.Rows = {}

		self.Header = self:Add( "Panel" )

		self.Label = self.Header:Add( "DLabel" )
		self.Label:Dock( FILL )
		self.Label:SetContentAlignment( 4 )

		self.Expand = self.Header:Add( "DExpandButton" )
		self.Expand:Dock( LEFT )
		self.Expand:SetSize( 16, 16 )
		self.Expand:DockMargin( 0, 4, 0, 4 )
		self.Expand:SetExpanded( true )
		self.Expand.DoClick = function()

			self.Container:SetVisible( !self.Container:IsVisible() )
			self.Expand:SetExpanded( self.Container:IsVisible() )
			self:InvalidateLayout()

		end

		self.Header:Dock( TOP )

		self.Container = self:Add( "Panel" )
		self.Container:Dock( TOP )
		self.Container:DockMargin( 16, 0, 0, 0 )
		self.Container.Paint = function( pnl, w, h )
			surface.SetDrawColor( color_white )
			surface.DrawRect( 0, 0, w, h )
		end

	end,

	PerformLayout = function( self )

		self.Container:SizeToChildren( false, true )
		self:SizeToChildren( false, true )

		local Skin = self:GetSkin()
		self.Label:SetTextColor( Skin.Colours.Properties.Title )
		self.Label:DockMargin( 4, 0, 0, 0 )

	end,

	GetRow = function( self, name, bCreate )

		if ( IsValid( self.Rows[ name ] ) ) then return self.Rows[ name ] end
		if ( !bCreate ) then return end

		local row = self.Container:Add( tblRow )

		row.Label:SetText( name )

		self.Rows[ name ] = row

		return row

	end,

	Paint = function( self, w, h )

		local Skin = self:GetSkin()
		surface.SetDrawColor( Skin.Colours.Properties.Border )
		surface.DrawRect( 0, 0, w, h )

	end

}, "Panel" )

--[[---------------------------------------------------------
	DProperties
-----------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()

	self.Categories = {}

end

--
-- Size to children vertically
--
function PANEL:PerformLayout()

	self:SizeToChildren( false, true )

end

function PANEL:Clear()
	self:GetCanvas():Clear()
end

function PANEL:GetCanvas()

	if ( !IsValid( self.Canvas ) ) then

		self.Canvas = self:Add( "DScrollPanel" )
		self.Canvas:Dock( FILL )

	end

	return self.Canvas

end

--
-- Get or create a category
--
function PANEL:GetCategory( name, bCreate )

	local cat = self.Categories[ name ]
	if ( IsValid( cat ) ) then return cat end

	if ( !bCreate ) then return end

	cat = self:GetCanvas():Add( tblCategory )
	cat.Label:SetText( name )
	self.Categories[ name ] = cat
	return cat

end

--
-- Creates a row under the specified category.
-- You should then call :Setup on the row.
--
function PANEL:CreateRow( category, name )

	local cat = self:GetCategory( category, true )
	return cat:GetRow( name, true )

end

derma.DefineControl( "DProperties", "", PANEL, "Panel" )
