
--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

DEFINE_BASECLASS( "DProperty_Generic" )

local PANEL = {}

function PANEL:Init()
end

function PANEL:Setup( vars )

	vars = vars or {}

	BaseClass.Setup( self, vars )

	local btn = self:Add( "DButton" )
	btn:Dock( LEFT )
	btn:DockMargin( 0, 1, 4, 1 )
	btn:SetWide( 24 )
	btn:SetText( "" )
	btn:SetImage( "icon16/wand.png" )

	-- Use the world picked to select an entity
	btn.DoClick = function( s )

		-- Make it look different when selecting things
		s:SetEnabled( false )

		util.worldpicker.Start( function( tr )

			self:SetEnabled( true )

			if ( !IsValid( tr.Entity ) ) then return end

			-- TODO: Maybe this should be EntSerial()?
			self:ValueChanged( tr.Entity:EntIndex(), true )

		end )

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

derma.DefineControl( "DProperty_Entity", "", PANEL, "DProperty_Generic" )
