
local tblOpenMenus = {}

function GetOpenDermaMenus()

	--
	-- Clear the table of any removed derma menus
	-- Each option in a derma menu is another derma menu itself
	--
	for k, menu in ipairs( tblOpenMenus ) do

		if ( !IsValid( menu ) ) then

			table.remove( tblOpenMenus, k )

		end
		
	end

	return tblOpenMenus

end

function RegisterDermaMenuForClose( dmenu )

	table.insert( tblOpenMenus, dmenu )

end

function DermaMenu( parentmenu, parent )

	if ( !parentmenu ) then CloseDermaMenus() end

	local dmenu = vgui.Create( "DMenu", parent )

	return dmenu

end

function CloseDermaMenus()

	for k, dmenu in pairs( tblOpenMenus ) do

		if ( IsValid( dmenu ) ) then

			dmenu:SetVisible( false )
			if ( dmenu:GetDeleteSelf() ) then
				dmenu:Remove()
			end

		end

		tblOpenMenus[ k ] = nil

	end

	hook.Run( "CloseDermaMenus" )

end

--
-- Here we detect when the mouse is pressed on another panel
-- This allows us to close the menus.
--
local function DermaDetectMenuFocus( panel, mousecode )

	if ( IsValid( panel ) ) then

		if ( panel.m_bIsMenuComponent ) then return end

		-- Is the parent a menu?
		return DermaDetectMenuFocus( panel:GetParent(), mousecode )

	end

	CloseDermaMenus()

end

hook.Add( "VGUIMousePressed", "DermaDetectMenuFocus", DermaDetectMenuFocus )
