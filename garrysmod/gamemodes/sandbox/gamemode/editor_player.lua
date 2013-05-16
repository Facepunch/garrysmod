
AddCSLuaFile()

local default_animations = { "pose_standing_01", "pose_standing_02", "pose_standing_03", "pose_standing_04" }

list.Set( "DesktopWindows", "PlayerEditor", {

	title		= "Player Model",
	icon		= "icon64/playermodel.png",
	width		= 960,
	height		= 700,
	onewindow	= true,
	init		= function( icon, window )

		local mdl = window:Add( "DModelPanel" )
		mdl:Dock( FILL )
		mdl:SetFOV( 45 )
		mdl:SetCamPos( Vector( 90, 0, 60 ) )
		mdl:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 64, 255 ) )
		mdl:SetDirectionalLight( BOX_LEFT, Color( 64, 160, 255, 255 ) )
		mdl:SetAmbientLight( Vector( 80, 80, 80 ) )
		mdl:SetAnimated( true )
		mdl.Angles = Angle( 0, 0, 0 )

		local sheet = window:Add( "DPropertySheet" )
		sheet:Dock( RIGHT )
		sheet:SetSize( 370, 0 )

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
		lbl:SetText( "Player Color:" )
		lbl:SetTextColor( Color( 0, 0, 0, 255 ) )
		lbl:Dock( TOP )

		local plycol = controls:Add( "DColorMixer" )
		plycol:SetAlphaBar( false )
		plycol:SetPalette( false )
		plycol:Dock( TOP )
		plycol:SetSize( 200, 250 )

		local lbl = controls:Add( "DLabel" )
		lbl:SetText( "Weapon Color:" )
		lbl:SetTextColor( Color( 0, 0, 0, 255 ) )
		lbl:DockMargin( 0, 32, 0, 0 )
		lbl:Dock( TOP )

		local wepcol = controls:Add( "DColorMixer" )
		wepcol:SetAlphaBar( false )
		wepcol:SetPalette( false )
		wepcol:Dock( TOP )
		wepcol:SetSize( 200, 250 )
		wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) );

		sheet:AddSheet( "Colors", controls )

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

		local function UpdateFromConvars()

			local model = LocalPlayer():GetInfo( "cl_playermodel" )
			local modelname = player_manager.TranslatePlayerModel( model )
			util.PrecacheModel( modelname )
			mdl:SetModel( modelname )
			mdl.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end

			plycol:SetVector( Vector( GetConVarString( "cl_playercolor" ) ) );
			wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) );

			PlayPreviewAnimation( mdl, model )

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

		function PanelSelect:OnActivePanelChanged() timer.Simple( 0.1, UpdateFromConvars ) end

	end
} )

list.Set( "PlayerOptionsAnimations", "css_arctic", {
	"pose_ducking_01", "pose_ducking_02"
} )

list.Set( "PlayerOptionsAnimations", "zombine", {
	"taunt_zombie_original"
} )

list.Set( "PlayerOptionsAnimations", "zombiefast", {
	"taunt_zombie_original"
} )

list.Set( "PlayerOptionsAnimations", "zombie", {
	"taunt_zombie_original"
} )
