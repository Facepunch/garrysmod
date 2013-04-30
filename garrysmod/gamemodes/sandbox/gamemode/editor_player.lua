
AddCSLuaFile()

list.Set( "DesktopWindows", "PlayerEditor",
{
	title		= "Player Model",
	icon		= "icon64/playermodel.png",
	width		= 960,
	height		= 700,
	onewindow	= true,
	init		= function( icon, window )

		local mdl = window:Add( "DModelPanel" )
			mdl:Dock( FILL )
			mdl:SetFOV(45)
			mdl:SetCamPos(Vector(90,0,60))

		local sheet = window:Add( "DPropertySheet" )
			sheet:Dock( RIGHT )
			sheet:SetSize( 370, 0 )

			local PanelSelect = sheet:Add( "DPanelSelect" )
	
				for name, model in SortedPairs( list.Get( "PlayerOptionsModel" ) ) do
	
					local icon = vgui.Create( "SpawnIcon" )
					icon:SetModel( model )
					icon:SetSize( 64, 64 )
					icon:SetTooltip( name )
		
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

		local function UpdateFromConvars()

			local modelname = player_manager.TranslatePlayerModel( LocalPlayer():GetInfo( "cl_playermodel" ) )
			util.PrecacheModel( modelname )
			mdl:SetModel( modelname )
			mdl.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end

			plycol:SetVector( Vector( GetConVarString( "cl_playercolor" ) ) );
			wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) );

		end
			
		local function UpdateFromControls()

			RunConsoleCommand( "cl_playercolor", tostring( plycol:GetVector() ) )
			RunConsoleCommand( "cl_weaponcolor", tostring( wepcol:GetVector() ) )

		end

		UpdateFromConvars();

		plycol.ValueChanged					= UpdateFromControls
		wepcol.ValueChanged					= UpdateFromControls
		PanelSelect.OnActivePanelChanged	= function() timer.Simple( 0.1, UpdateFromConvars ) end

	end
} )

--
-- Default player models
--

list.Set( "PlayerOptionsModel", "combine", 		"models/player/combine_soldier.mdl" )
list.Set( "PlayerOptionsModel", "combineprison", "models/player/combine_soldier_prisonguard.mdl" )
list.Set( "PlayerOptionsModel", "combineelite", "models/player/combine_super_soldier.mdl" )
list.Set( "PlayerOptionsModel", "police", 		"models/player/police.mdl" )
list.Set( "PlayerOptionsModel", "stripped", 	"models/player/soldier_stripped.mdl" )

list.Set( "PlayerOptionsModel", "alyx", 		"models/player/alyx.mdl" )
list.Set( "PlayerOptionsModel", "barney", 		"models/player/barney.mdl" )
list.Set( "PlayerOptionsModel", "breen", 		"models/player/breen.mdl" )
list.Set( "PlayerOptionsModel", "eli", 		    "models/player/eli.mdl" )
list.Set( "PlayerOptionsModel", "gman", 		"models/player/gman_high.mdl" )
list.Set( "PlayerOptionsModel", "kleiner", 		"models/player/kleiner.mdl" )
list.Set( "PlayerOptionsModel", "magnusson", 	"models/player/magnusson.mdl" )
list.Set( "PlayerOptionsModel", "monk", 		"models/player/monk.mdl" )
list.Set( "PlayerOptionsModel", "mossman", 		"models/player/mossman.mdl" )
list.Set( "PlayerOptionsModel", "mossmanarctic", "models/player/mossman_arctic.mdl" )
list.Set( "PlayerOptionsModel", "odessa", 		"models/player/odessa.mdl" )

list.Set( "PlayerOptionsModel", "charple", 		"models/player/charple.mdl" )
list.Set( "PlayerOptionsModel", "corpse", 		"models/player/corpse1.mdl" )
list.Set( "PlayerOptionsModel", "zombie", 		"models/player/zombie_classic.mdl" )
list.Set( "PlayerOptionsModel", "zombiefast", 	"models/player/zombie_fast.mdl" )
list.Set( "PlayerOptionsModel", "zombine", 		"models/player/zombie_soldier.mdl" )
list.Set( "PlayerOptionsModel", "zombine",      "models/player/zombie_soldier.mdl" )

list.Set( "PlayerOptionsModel", "female01",		"models/player/Group01/female_01.mdl" )
list.Set( "PlayerOptionsModel", "female02",		"models/player/Group01/female_02.mdl" )
list.Set( "PlayerOptionsModel", "female03",		"models/player/Group01/female_03.mdl" )
list.Set( "PlayerOptionsModel", "female04",		"models/player/Group01/female_04.mdl" )
list.Set( "PlayerOptionsModel", "female05",		"models/player/Group01/female_05.mdl" )
list.Set( "PlayerOptionsModel", "female06",		"models/player/Group01/female_06.mdl" )
list.Set( "PlayerOptionsModel", "female07",		"models/player/Group03/female_01.mdl" )
list.Set( "PlayerOptionsModel", "female08",		"models/player/Group03/female_02.mdl" )
list.Set( "PlayerOptionsModel", "female09",		"models/player/Group03/female_03.mdl" )
list.Set( "PlayerOptionsModel", "female10",		"models/player/Group03/female_04.mdl" )
list.Set( "PlayerOptionsModel", "female11",		"models/player/Group03/female_05.mdl" )
list.Set( "PlayerOptionsModel", "female12",		"models/player/Group03/female_06.mdl" )

list.Set( "PlayerOptionsModel", "male01",		"models/player/Group01/male_01.mdl" )
list.Set( "PlayerOptionsModel", "male02",		"models/player/Group01/male_02.mdl" )
list.Set( "PlayerOptionsModel", "male03",		"models/player/Group01/male_03.mdl" )
list.Set( "PlayerOptionsModel", "male04",		"models/player/Group01/male_04.mdl" )
list.Set( "PlayerOptionsModel", "male05",		"models/player/Group01/male_05.mdl" )
list.Set( "PlayerOptionsModel", "male06",		"models/player/Group01/male_06.mdl" )
list.Set( "PlayerOptionsModel", "male07",		"models/player/Group01/male_07.mdl" )
list.Set( "PlayerOptionsModel", "male08",		"models/player/Group01/male_08.mdl" )
list.Set( "PlayerOptionsModel", "male09",		"models/player/Group01/male_09.mdl" )

list.Set( "PlayerOptionsModel", "male10",		"models/player/Group03/male_01.mdl" )
list.Set( "PlayerOptionsModel", "male11",		"models/player/Group03/male_02.mdl" )
list.Set( "PlayerOptionsModel", "male12",		"models/player/Group03/male_03.mdl" )
list.Set( "PlayerOptionsModel", "male13",		"models/player/Group03/male_04.mdl" )
list.Set( "PlayerOptionsModel", "male14",		"models/player/Group03/male_05.mdl" )
list.Set( "PlayerOptionsModel", "male15",		"models/player/Group03/male_06.mdl" )
list.Set( "PlayerOptionsModel", "male16",		"models/player/Group03/male_07.mdl" )
list.Set( "PlayerOptionsModel", "male17",		"models/player/Group03/male_08.mdl" )
list.Set( "PlayerOptionsModel", "male18",		"models/player/Group03/male_09.mdl" )

list.Set( "PlayerOptionsModel", "refugee01",	"models/player/Group02/male_02.mdl" )
list.Set( "PlayerOptionsModel", "refugee02",	"models/player/Group02/male_04.mdl" )
list.Set( "PlayerOptionsModel", "refugee03",	"models/player/Group02/male_06.mdl" )
list.Set( "PlayerOptionsModel", "refugee04",	"models/player/Group02/male_08.mdl" )

list.Set( "PlayerOptionsModel", "css_arctic",		"models/player/arctic.mdl" )
list.Set( "PlayerOptionsModel", "css_gasmask",		"models/player/gasmask.mdl" )
list.Set( "PlayerOptionsModel", "css_guerilla",		"models/player/guerilla.mdl" )
list.Set( "PlayerOptionsModel", "css_leet",			"models/player/leet.mdl" )
list.Set( "PlayerOptionsModel", "css_phoenix",		"models/player/phoenix.mdl" )
list.Set( "PlayerOptionsModel", "css_riot",			"models/player/riot.mdl" )
list.Set( "PlayerOptionsModel", "css_swat",			"models/player/swat.mdl" )
list.Set( "PlayerOptionsModel", "css_urban",		"models/player/urban.mdl" )

list.Set( "PlayerOptionsModel", "dod_american", "models/player/dod_american.mdl" )
list.Set( "PlayerOptionsModel", "dod_german", "models/player/dod_german.mdl" )