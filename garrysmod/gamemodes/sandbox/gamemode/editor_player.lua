
AddCSLuaFile()

local default_animations = { "idle_all_01", "menu_walk" }

list.Set( "DesktopWindows", "PlayerEditor", {

	title		= "Player Model",
	icon		= "icon64/playermodel.png",
	width		= 960,
	height		= 700,
	onewindow	= true,
	init		= function( icon, window )

		local mdl = window:Add( "DModelPanel" )
		mdl:Dock( FILL )
		mdl:SetFOV( 36 )
		mdl:SetCamPos( Vector( 100, 0, 60 ) )
		mdl:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
		mdl:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
		mdl:SetAmbientLight( Vector( -64, -64, -64 ) )
		mdl:SetAnimated( true )
		mdl.Angles = Angle( 0, 0, 0 )

		local sheet = window:Add( "DPropertySheet" )
		sheet:Dock( RIGHT )
		sheet:SetSize( 430, 0 )

		local PanelSelect = sheet:Add( "DPanelSelect" )

		for name, model in SortedPairs( player_manager.AllValidModels() ) do

			local icon = vgui.Create( "SpawnIcon" )
			icon:SetModel( model )
			icon:SetSize( 64, 64 )
			icon:SetTooltip( name )
			icon.playermodel = name

			PanelSelect:AddPanel( icon, { cl_playermodel = name } )

		end

		sheet:AddSheet( "Model", PanelSelect )

		local controls = window:Add( "DPanel" )
		controls:DockPadding( 8, 8, 8, 8 )

		local lbl = controls:Add( "DLabel" )
		lbl:SetText( "Player color" )
		lbl:SetTextColor( Color( 0, 0, 0, 255 ) )
		lbl:Dock( TOP )

		local plycol = controls:Add( "DColorMixer" )
		plycol:SetAlphaBar( false )
		plycol:SetPalette( false )
		plycol:Dock( TOP )
		plycol:SetSize( 200, 260 )

		local lbl = controls:Add( "DLabel" )
		lbl:SetText( "Physgun color" )
		lbl:SetTextColor( Color( 0, 0, 0, 255 ) )
		lbl:DockMargin( 0, 32, 0, 0 )
		lbl:Dock( TOP )

		local wepcol = controls:Add( "DColorMixer" )
		wepcol:SetAlphaBar( false )
		wepcol:SetPalette( false )
		wepcol:Dock( TOP )
		wepcol:SetSize( 200, 260 )
		wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) );

		sheet:AddSheet( "Colors", controls )

		/* BODY GROUPS */

		local bdcontrols = window:Add( "DPanel" )
		bdcontrols:DockPadding( 8, 8, 8, 8 )

		sheet:AddSheet( "Bodygroups", bdcontrols )

		local function MakeNiceName( str )
			local newname = {}

			for _, s in pairs( string.Explode( "_", str ) ) do
				if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
				table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) -- Ugly way to capitalize first letters.
			end

			return string.Implode( " ", newname )
		end

		local function PlayPreviewAnimation( panel, playermodel )

			if ( !panel or !IsValid( panel.Entity ) ) then return end

			local anims = list.Get( "PlayerOptionsAnimations" )

			local anim = default_animations[ math.random( 1, #default_animations ) ]
			if ( anims[ playermodel ] ) then
				anims = anims[ playermodel ]
				anim = anims[ math.random( 1, #anims ) ]
			end

			local iSeq = panel.Entity:LookupSequence( anim )
			if (iSeq > 0) then panel.Entity:ResetSequence( iSeq ) end

		end

		local function UpdateBodyGroups( pnl, val )
			if pnl.type == "bgroup" then
				mdl.Entity:SetBodygroup( pnl.typenum, math.Round( val ) )
				local str = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
				if ( #str < pnl.typenum + 1 ) then for i = 1, pnl.typenum + 1 do str[ i ] = str[ i ] or 0 end end
				str[ pnl.typenum + 1 ] = math.Round( val )
				RunConsoleCommand( "cl_playerbodygroups", table.concat( str, " " ) )
			elseif pnl.type == "skin" then
				mdl.Entity:SetSkin( math.Round( val ) )
				RunConsoleCommand( "cl_playerskin", math.Round( val ) )
			end
		end

		local function RebuildBodygroups()
			bdcontrols:Clear()
			
			if ( mdl.Entity:GetNumBodyGroups() - 1 <= 0 && mdl.Entity:SkinCount() - 1 <= 0 ) then
				local skins = bdcontrols:Add( "DLabel" )
				skins:Dock( TOP )
				skins:SetDark( true )
				skins:SetText( "This model doesn't have any bodygroups or skins" )
				skins:SizeToContents()
				return
			end

			local nskins = mdl.Entity:SkinCount() - 1
			if ( nskins > 0 ) then
				local skins = bdcontrols:Add( "DNumSlider" )
				skins:Dock( TOP )
				skins:SetText( "Skin" )
				skins:SetDark( true )
				skins:SetTall( 50 )
				skins:SetDecimals( 0 )
				skins:SetMax( nskins )
				skins:SetValue( GetConVarNumber( "cl_playerskin" ) )
				skins.type = "skin"
				skins.OnValueChanged = UpdateBodyGroups

				mdl.Entity:SetSkin( GetConVarNumber( "cl_playerskin" ) )
			end

			local groups = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
			for k = 0, mdl.Entity:GetNumBodyGroups() - 1 do
				if ( mdl.Entity:GetBodygroupCount( k ) <= 1 ) then continue end

				local bgroup = bdcontrols:Add( "DNumSlider" )
				bgroup:Dock( TOP )
				bgroup:SetText( MakeNiceName( mdl.Entity:GetBodygroupName( k ) ) )
				bgroup:SetDark( true )
				bgroup:SetTall( 50 )
				bgroup:SetDecimals( 0 )
				bgroup.type = "bgroup"
				bgroup.typenum = k
				bgroup:SetMax( mdl.Entity:GetBodygroupCount( k ) - 1 )
				bgroup:SetValue( groups[ k + 1 ] or 0 )
				bgroup.OnValueChanged = UpdateBodyGroups
	
				mdl.Entity:SetBodygroup( k, groups[ k + 1 ] or 0 )
			end
		end

		local function UpdateFromConvars( haschanged )

			local model = LocalPlayer():GetInfo( "cl_playermodel" )
			local modelname = player_manager.TranslatePlayerModel( model )
			util.PrecacheModel( modelname )
			mdl:SetModel( modelname )
			mdl.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end

			plycol:SetVector( Vector( GetConVarString( "cl_playercolor" ) ) );
			wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) );

			if ( haschanged ) then
				RunConsoleCommand( "cl_playerbodygroups", 0 )
				RunConsoleCommand( "cl_playerskin", 0 )
			end
			
			PlayPreviewAnimation( mdl, model )
			RebuildBodygroups()

		end

		local function UpdateFromControls()

			RunConsoleCommand( "cl_playercolor", tostring( plycol:GetVector() ) )
			RunConsoleCommand( "cl_weaponcolor", tostring( wepcol:GetVector() ) )

		end

		UpdateFromConvars();

		plycol.ValueChanged = UpdateFromControls
		wepcol.ValueChanged = UpdateFromControls

		function mdl:DragMousePress()
			self.PressX, self.PressY = gui.MousePos()
			self.Pressed = true
		end

		function mdl:DragMouseRelease() self.Pressed = false end

		function mdl:LayoutEntity( Entity )
			if ( self.bAnimated ) then self:RunAnimation() end

			if ( self.Pressed ) then
				local mx, my = gui.MousePos()
				self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
				
				self.PressX, self.PressY = gui.MousePos()
			end

			Entity:SetAngles( self.Angles )
		end

		function PanelSelect:OnActivePanelChanged() timer.Simple( 0.1, function() UpdateFromConvars( true ) end ) end

	end
} )

list.Set( "PlayerOptionsAnimations", "gman", { "menu_gman" } )

list.Set( "PlayerOptionsAnimations", "hostage01", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage02", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage03", { "idle_all_scared" } )
list.Set( "PlayerOptionsAnimations", "hostage04", { "idle_all_scared" } )

list.Set( "PlayerOptionsAnimations", "zombine", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "corpse", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "zombiefast", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "zombie", { "menu_zombie_01" } )
list.Set( "PlayerOptionsAnimations", "skeleton", { "menu_zombie_01" } )

list.Set( "PlayerOptionsAnimations", "combine", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "combineprison", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "combineelite", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "police", { "menu_combine" } )
list.Set( "PlayerOptionsAnimations", "policefem", { "menu_combine" } )

list.Set( "PlayerOptionsAnimations", "css_arctic", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_gasmask", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_guerilla", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_leet", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_phoenix", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_riot", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_swat", { "pose_standing_02", "idle_fist" } )
list.Set( "PlayerOptionsAnimations", "css_urban", { "pose_standing_02", "idle_fist" } )