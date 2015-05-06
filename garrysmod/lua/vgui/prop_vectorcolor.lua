
--
-- prop_generic is the base for all other properties. 
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

DEFINE_BASECLASS( "DProperty_Generic" )

local PANEL = {}

function PANEL:Init()
end

--
-- Called by this control, or a derived control, to alert the row of the change
--
function PANEL:ValueChanged( newval, bForce )

	BaseClass.ValueChanged( self, newval, bForce )

	self.VectorValue = Vector( newval )

end

function PANEL:Setup( vars )

	vars = vars or {}

	BaseClass.Setup( self, vars )

	local __SetValue = self.SetValue

	local btn = self:Add( "DButton" )
	btn:Dock( LEFT )
	btn:DockMargin( 0, 2, 4, 2 )
	btn:SetWide( 20 - 4 )
	btn:SetText( "" )

	btn.Paint = function( btn, w, h )

		if ( self.VectorValue ) then
			surface.SetDrawColor( 255 * self.VectorValue.x, 255 * self.VectorValue.y, 255 * self.VectorValue.z, 255 )
			surface.DrawRect( 2, 2, w-4, h-4 )
		end

		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawOutlinedRect( 0, 0, w, h )

	end

	--
	-- Pop up a colour selector when we click on the button
	--
	btn.DoClick = function()

		local color = vgui.Create( "DColorCombo", self )
		color:SetupCloseButton( function() CloseDermaMenus() end )
		color.OnValueChanged = function( color, newcol )
			
			-- convert color to vector
			local vec = Vector( newcol.r / 255, newcol.g / 255, newcol.b / 255 )

			self:ValueChanged( tostring( vec ), true )

		end

		local col = Color( 255 * self.VectorValue.r, 255 * self.VectorValue.g, 255 * self.VectorValue.b, 255 )
		color:SetColor( col )

		local menu = DermaMenu()
			menu:AddPanel( color )
			menu:SetDrawBackground( false )
		menu:Open( gui.MouseX() + 8, gui.MouseY() + 10 )

	end

	-- Set the value
	self.SetValue = function( self, val )
		__SetValue( self, val )
		self.VectorValue = val
	end

end

derma.DefineControl( "DProperty_VectorColor", "", PANEL, "DProperty_Generic" )