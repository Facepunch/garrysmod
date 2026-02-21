
--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local function ColorToString( col )
	return math.floor( col.r ) .. " " .. math.floor( col.g ) .. " " .. math.floor( col.b ) .. " " .. math.floor( col.a )
end

DEFINE_BASECLASS( "DProperty_Generic" )

local PANEL = {}

function PANEL:Init()
end

--
-- Called by this control, or a derived control, to alert the row of the change
--
function PANEL:ValueChanged( newval, bForce )

	BaseClass.ValueChanged( self, newval, bForce )

	if ( isvector( self.VectorValue ) ) then
		self.VectorValue = Vector( newval )
	else
		self.VectorValue = string.ToColor( newval )
	end

end

function PANEL:Setup( vars )

	vars = vars or {}

	BaseClass.Setup( self, vars )

	local __SetValue = self.SetValue

	local btn = self:Add( "DButton" )
	btn:Dock( LEFT )
	btn:DockMargin( 0, 2, 4, 2 )
	btn:SetWide( 16 )
	btn:SetText( "" )

	btn.Paint = function( btn_slf, w, h )

		if ( self.VectorValue ) then
			if ( isvector( self.VectorValue ) ) then
				local vectorColor = self.VectorValue:ToColor()
			
				surface.SetDrawColor( vectorColor.r, vectorColor.g, vectorColor.b, vectorColor.a )
			else
				surface.SetDrawColor( self.VectorValue.r, self.VectorValue.g, self.VectorValue.b, self.VectorValue.a )
			end
			surface.DrawRect( 2, 2, w - 4, h - 4 )
		end

		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawOutlinedRect( 0, 0, w, h )

	end

	--
	-- Pop up a colour selector when we click on the button
	--
	btn.DoClick = function()

		local color = vgui.Create( "DColorCombo", self )
		if ( istable( self.VectorValue ) ) then color.Mixer:SetAlphaBar( true ) end
		color:SetupCloseButton( function() CloseDermaMenus() end )
		color.OnValueChanged = function( colorCombo, newcol )

			if ( !IsValid( self ) ) then return end

			if ( isvector( self.VectorValue ) ) then
				-- convert color to vector
				local vec = Vector( newcol.r / 255, newcol.g / 255, newcol.b / 255 )
				self:ValueChanged( tostring( vec ), true )
			else
				self:ValueChanged( ColorToString( newcol ), true )
			end

		end

		local col = self.VectorValue
		if ( isvector( self.VectorValue ) ) then col = self.VectorValue:ToColor() end
		color:SetColor( col )

		-- Delete the popup if the edit window goes away
		btn.OnRemove = function() if ( IsValid( color ) ) then color:Remove() end end

		local menu = DermaMenu()
		menu:AddPanel( color )
		menu:SetPaintBackground( false )
		menu:Open( gui.MouseX() + 8, gui.MouseY() + 10 )

	end

	-- Set the value
	self.SetValue = function( slf, val )
		slf.VectorValue = val

		if ( isvector( slf.VectorValue ) ) then
			__SetValue( slf, val )
		else
			__SetValue( slf, ColorToString( val ) )
		end
	end

	-- Enabled/disabled support
	self.IsEnabled = function( slf )
		return btn:IsEnabled()
	end
	local oldSetEnabled = self.SetEnabled
	self.SetEnabled = function( slf, b )
		btn:SetEnabled( b )
		oldSetEnabled( b ) -- Also handle the text entry
	end

end

derma.DefineControl( "DProperty_VectorColor", "", PANEL, "DProperty_Generic" )
