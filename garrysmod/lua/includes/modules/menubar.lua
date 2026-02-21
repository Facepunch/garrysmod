
menubar = {}

function menubar.Init()

	menubar.Control = vgui.Create( "DMenuBar" )
	menubar.Control:Dock( TOP )
	menubar.Control:SetVisible( false )
	
	hook.Run( "PopulateMenuBar", menubar.Control )

end

function menubar.ParentTo( pnl )

	// I don't like this
	if ( !IsValid( menubar.Control ) ) then
		menubar.Init()
	end

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
