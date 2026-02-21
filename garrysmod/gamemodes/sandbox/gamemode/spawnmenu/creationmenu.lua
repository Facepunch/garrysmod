
include( "creationmenu/manifest.lua" )

local PANEL = {}

function PANEL:Init()

	self.CreationTabs = {}

	self:SetFadeTime( 0 )
	self:Populate()

end

function PANEL:GetCreationTab( id )

	return self.CreationTabs[ id ]

end

function PANEL:GetCreationTabs()

	return self.CreationTabs

end

function PANEL:Populate()

	local tabs = spawnmenu.GetCreationTabs()

	for k, v in SortedPairsByMemberValue( tabs, "Order" ) do

		--
		-- Here we create a panel and populate it on the first paint
		-- that way everything is created on the first view instead of
		-- being created on load.
		--
		local pnl = vgui.Create( "Panel" )

		local tab = self:AddSheet( k, pnl, v.Icon, nil, nil, v.Tooltip )
		self.CreationTabs[ k ] = tab

		-- Populate the panel
		-- We have to add the timer to make sure g_Spawnmenu is available
		-- in case some addon needs it ready when populating the creation tab.
		timer.Simple( 0, function()
			if ( !IsValid( pnl ) ) then return end
			local childpnl = v.Function()
			childpnl:SetParent( pnl )
			childpnl:Dock( FILL )

			self.CreationTabs[ k ].ContentPanel = childpnl
		end )

	end

end

vgui.Register( "CreationMenu", PANEL, "DPropertySheet" )
