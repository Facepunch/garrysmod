menubar = {}

function menubar.Init()
	
	if IsValid( menubar.Control ) then
		menubar.Control:Remove()
	end
	
	menubar.Control = vgui.Create( "DMenuBar" )
	menubar.Control:Dock( TOP )
	menubar.Control:SetVisible( false )
	
	hook.Run( "PopulateMenuBar", menubar.Control )
	
end

function menubar.ParentTo( pnl )

	menubar.Control:SetParent( pnl )
	menubar.Control:MoveToBack()
	menubar.Control:SetHeight( 30 )
	menubar.Control:SetVisible( true )

end

function menubar.IsParent( pnl )
	return menubar.Control:GetParent() == pnl
end


hook.Add( "OnGamemodeLoaded", "CreateMenuBar", function()

	menubar.Init()

end )

concommand.Add("menubar_reload",menubar.Init)
