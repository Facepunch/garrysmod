
AddCSLuaFile()

properties.Add( "editentity", {
	MenuLabel = "#entedit",
	Order = 90001,
	PrependSpacer = true,
	MenuIcon = "icon16/pencil.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( !ent.Editable ) then return false end
		if ( !gamemode.Call( "CanProperty", ply, "editentity", ent ) ) then return false end

		return true

	end,

	Action = function( self, ent )

		local printName = ent.PrintName

		if ( !isstring( printName ) ) then
			printName = ent:GetClass()
		end

		printName = language.GetPhrase( printName )
		printName = string.format( "%s [%d]", printName, ent:EntIndex() )

		local window = g_ContextMenu:Add( "DFrame" )
		window:SetSize( 320, 400 )
		window:SetTitle( printName )
		window:Center()
		window:SetSizable( true )

		local control = window:Add( "DEntityProperties" )
		control:SetEntity( ent )
		control:Dock( FILL )

		control.OnEntityLost = function()

			window:Remove()

		end

	end
} )
