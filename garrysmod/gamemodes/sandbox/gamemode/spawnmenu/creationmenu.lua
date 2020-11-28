
include( "creationmenu/manifest.lua" )

local PANEL = {}

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:Populate()
	self:SetFadeTime( 0 )

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Populate()

	local tabs = spawnmenu.GetCreationTabs()

	for k, v in SortedPairsByMemberValue( tabs, "Order" ) do

		if hook.Call("AddCreationTab", v, k) == false then continue end 
		
		--
		-- Here we create a panel and populate it on the first paint
		-- that way everything is created on the first view instead of
		-- being created on load.
		--
		local pnl = vgui.Create( "Panel" )

		self:AddSheet( k, pnl, v.Icon, nil, nil, v.Tooltip )

		-- Populate the panel
		-- We have to add the timer to make sure g_Spawnmenu is available
		-- in case some addon needs it ready when populating the creation tab.
		timer.Simple( 0, function()
			local childpnl = v.Function()
			childpnl:SetParent( pnl )
			childpnl:Dock( FILL )
		end )

	end

end

vgui.Register( "CreationMenu", PANEL, "DPropertySheet" )
