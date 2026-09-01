
if ( SERVER ) then AddCSLuaFile() return end

local default_animations = { "idle_all_01", "menu_walk" }

local function SetDefaultColorFromConVar( panel, convarName )
	local color = Vector( GetConVar( convarName ):GetDefault() ):ToColor()
	if ( color ) then
		panel.HSV:SetDefaultColor( color )
	end
end

list.Set( "DesktopWindows", "PlayerEditor", {

	title		= "#smwidget.playermodel",
	icon		= "icon64/playermodel.png",
	width		= 960,
	height		= 700,
	onewindow	= true,
	init		= function( widgetIcon, window )

		window:SetTitle( "#smwidget.playermodel_title" )
		window:SetSize( math.max( ScrW() * 0.8, window:GetWide() ), math.max( ScrH() * 0.8, window:GetTall() ) )
		window:SetSizable( true )
		window:SetMinWidth( 400 )
		window:SetMinHeight( 250 )
		window:Center()

		local divider = window:Add( "DHorizontalDivider" )
		divider:Dock( FILL )
		divider:SetLeftWidth( window:GetWide() / 2 )
		divider:SetLeftMin( 150 )
		divider:SetRightMin( 250 )
		divider:SetCookieName( "PlayerModelSelectorDivider" )

		--
		-- Model preview
		--
		local mdl = divider:Add( "DModelPanel" )
		divider:SetLeft( mdl )

		-- Undo defaults
		mdl:SetDirectionalLight( BOX_FRONT, nil )
		mdl:SetDirectionalLight( BOX_TOP, nil )
		mdl:SetAmbientLight( Color( 32, 32, 32 ) ) -- Still show the phong a little

		mdl:SetAnimated( true )
		mdl.Angles = angle_zero
		mdl:SetLookAt( Vector( 0, 0, 37 ) )
		mdl:SetCamPos( Vector( 100, 0, 59 ) )

		local sheet = divider:Add( "DPropertySheet" )
		sheet:SetWide( window:GetWide() / 2 )
		divider:SetRight( sheet )

		--
		-- Model List
		--
		local modelListPnl = window:Add( "DPanel" )
		modelListPnl:DockPadding( 8, 8, 8, 8 )

		local SearchBar = modelListPnl:Add( "DTextEntry" )
		SearchBar:Dock( TOP )
		SearchBar:DockMargin( 0, 0, 0, 8 )
		SearchBar:SetUpdateOnType( true )
		SearchBar:SetPlaceholderText( "#spawnmenu.quick_filter" )

		local PanelSelect = modelListPnl:Add( "DPanelSelect" )
		PanelSelect:Dock( FILL )

		local cateorized = {}
		for name, info in pairs( player_manager.GetAllPlayerModels() ) do
			local catName = language.GetPhrase( info.category or "#spawnmenu.category.other" )
			cateorized[ catName ] = cateorized[ catName ] or {}
			table.insert( cateorized[ catName ], { title = language.GetPhrase( info.title ), model = info.model, name = name } )
		end

		for catName, items in SortedPairs( cateorized ) do

			local label = vgui.Create( "DLabel" )
			label:SetFont( "DermaLarge" )
			label:SetText( catName )
			label:SetTall( 32 )
			label:SetDark( true )
			label:SizeToContentsX()
			label.m_strLineState = "ownline"
			PanelSelect:AddPanel( label )
			label.DoClick = function () end -- Unselectable

			for _, info in SortedPairsByMemberValue( items, "title" ) do

				local icon = vgui.Create( "SpawnIcon" )
				icon:SetModel( info.model )
				icon:SetSize( 64, 64 )
				icon:SetTooltip( info.title )
				icon.playermodel = info.name
				icon.model_path = info.model
				icon.OpenMenu = function( button )
					local menu = DermaMenu()
					menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( info.model ) end ):SetIcon( "icon16/page_copy.png" )
					menu:Open()
				end

				PanelSelect:AddPanel( icon, { cl_playermodel = info.name } )

			end

		end

		SearchBar.OnValueChange = function( s, str )
			for id, pnl in pairs( PanelSelect:GetItems() ) do
				if ( pnl.playermodel == nil ) then pnl:SetVisible( str == "" ) continue end
				if ( !pnl.playermodel:lower():find( str, 1, true ) && !pnl.model_path:lower():find( str, 1, true ) && !pnl:GetTooltip():lower():find( str, 1, true ) ) then
					pnl:SetVisible( false )
				else
					pnl:SetVisible( true )
				end
			end
			PanelSelect:InvalidateLayout()
		end

		sheet:AddSheet( "#smwidget.model", modelListPnl, "icon16/user.png" )

		--
		-- Colors
		--
		local colorPickerSize = math.min( window:GetTall() / 3, 260 )

		local controlsTop = window:Add( "DPanel" )
		controlsTop:DockPadding( 8, 8, 8, 8 )

		local plycol = controlsTop:Add( "DColorMixer" )
		plycol:Dock( TOP )
		plycol:SetLabel( "#smwidget.color_plr" )
		plycol:SetTall( colorPickerSize )
		plycol:SetAlphaBar( false )
		plycol:SetPaletteName( "plrmdlslct_ply_clr" )
		SetDefaultColorFromConVar( plycol, "cl_playercolor" )

		local wepcol = controlsTop:Add( "DColorMixer" )
		wepcol:Dock( TOP )
		wepcol:DockMargin( 0, 32, 0, 0 )
		wepcol:SetLabel( "#smwidget.color_wep" )
		wepcol:SetTall( colorPickerSize )
		wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) )
		wepcol:SetAlphaBar( false )
		wepcol:SetPaletteName( "plrmdlslct_wep_clr" )
		SetDefaultColorFromConVar( wepcol, "cl_weaponcolor" )

		sheet:AddSheet( "#smwidget.colors", controlsTop, "icon16/color_wheel.png" )

		--
		-- Bodygroups
		--
		local bgControls = window:Add( "DPanel" )
		bgControls:DockPadding( 8, 8, 8, 8 )

		local bdcontrolspanel = bgControls:Add( "DPanelList" )
		bdcontrolspanel:EnableVerticalScrollbar()
		bdcontrolspanel:Dock( FILL )

		local bgTab = sheet:AddSheet( "#smwidget.bodygroups", bgControls, "icon16/cog.png" )

		-- Helper functions
		local function PlayPreviewAnimation( panel, playermodel )

			if ( !panel or !IsValid( panel.Entity ) ) then return end

			local anim = default_animations[ math.random( 1, #default_animations ) ]

			local anims = list.GetEntry( "PlayerOptionsAnimations", playermodel )
			if ( anims ) then
				anim = anims[ math.random( 1, #anims ) ]
			end

			local iSeq = panel.Entity:LookupSequence( anim )
			if ( iSeq > 0 ) then panel.Entity:ResetSequence( iSeq ) end

		end

		-- Updating
		local function UpdateBodyGroups( pnl, val )
			if ( pnl.type == "bgroup" ) then

				mdl.Entity:SetBodygroup( pnl.typenum, math.floor( val ) )

				local str = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
				if ( #str < pnl.typenum + 1 ) then for i = 1, pnl.typenum + 1 do str[ i ] = str[ i ] or 0 end end
				str[ pnl.typenum + 1 ] = math.floor( val )
				RunConsoleCommand( "cl_playerbodygroups", table.concat( str, " " ) )

			elseif ( pnl.type == "skin" ) then

				mdl.Entity:SetSkin( math.floor( val ) )
				RunConsoleCommand( "cl_playerskin", math.floor( val ) )

			end
		end

		local function RebuildBodygroupTab()
			bdcontrolspanel:Clear()

			bgTab.Tab:SetVisible( false )

			local nskins = mdl.Entity:SkinCount() - 1
			if ( nskins > 0 ) then
				local skins = vgui.Create( "DNumSlider" )
				skins:Dock( TOP )
				skins:SetText( "Skin" )
				skins:SetDark( true )
				skins:SetTall( 50 )
				skins:SetDecimals( 0 )
				skins:SetMax( nskins )
				skins:SetValue( GetConVarNumber( "cl_playerskin" ) )
				skins.type = "skin"
				skins.OnValueChanged = UpdateBodyGroups

				bdcontrolspanel:AddItem( skins )

				mdl.Entity:SetSkin( GetConVarNumber( "cl_playerskin" ) )

				bgTab.Tab:SetVisible( true )
			end

			local groups = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
			for k = 0, mdl.Entity:GetNumBodyGroups() - 1 do
				if ( mdl.Entity:GetBodygroupCount( k ) <= 1 ) then continue end

				local bgroup = vgui.Create( "DNumSlider" )
				bgroup:Dock( TOP )
				bgroup:SetText( string.NiceName( mdl.Entity:GetBodygroupName( k ) ) )
				bgroup:SetDark( true )
				bgroup:SetTall( 50 )
				bgroup:SetDecimals( 0 )
				bgroup.type = "bgroup"
				bgroup.typenum = k
				bgroup:SetMax( mdl.Entity:GetBodygroupCount( k ) - 1 )
				bgroup:SetValue( groups[ k + 1 ] or 0 )
				bgroup.OnValueChanged = UpdateBodyGroups

				bdcontrolspanel:AddItem( bgroup )

				mdl.Entity:SetBodygroup( k, groups[ k + 1 ] or 0 )

				bgTab.Tab:SetVisible( true )
			end

			sheet.tabScroller:InvalidateLayout()
		end

		local function UpdateFromConvars()

			if ( !IsValid( mdl ) ) then return end

			local model = LocalPlayer():GetInfo( "cl_playermodel" )
			local modelname = player_manager.TranslatePlayerModel( model )
			util.PrecacheModel( modelname )
			mdl:SetModel( modelname )
			mdl.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end

			plycol:SetVector( Vector( GetConVarString( "cl_playercolor" ) ) )
			wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) )

			PlayPreviewAnimation( mdl, model )
			RebuildBodygroupTab()

		end

		local function UpdateFromControls()

			RunConsoleCommand( "cl_playercolor", tostring( plycol:GetVector() ) )
			RunConsoleCommand( "cl_weaponcolor", tostring( wepcol:GetVector() ) )

		end

		plycol.ValueChanged = UpdateFromControls
		wepcol.ValueChanged = UpdateFromControls

		UpdateFromConvars()

		function PanelSelect:OnActivePanelChanged( old, new )

			if ( old != new ) then -- Only reset if we changed the model
				RunConsoleCommand( "cl_playerbodygroups", "0" )
				RunConsoleCommand( "cl_playerskin", "0" )
			end

			timer.Simple( 0.1, function() UpdateFromConvars() end )

		end

		-- Hold to rotate

		function mdl:DragMousePress( btnId )
			if ( btnId != MOUSE_LEFT and btnId != MOUSE_RIGHT and btnId != MOUSE_MIDDLE ) then return end

			self.PressX, self.PressY = input.GetCursorPos()
			self.Pressed = btnId
		end

		function mdl:DragMouseRelease() self.Pressed = nil end

		function mdl:PreDrawModel()
			self.LocalLights = {
				-- left
				{
					type = MATERIAL_LIGHT_POINT,
					pos = Vector( 0, -100, 72 + math.sin( CurTime() * 1 + 5 ) * 90 ) ,
					color = Vector( 0.3, 0.6, 1 )
				},
				-- right
				{
					type = MATERIAL_LIGHT_POINT,
					pos = Vector( 0, 100, 72 + math.sin( CurTime() * 1 + 9 ) * 90 ) ,
					color = Vector( 1, 0.6, 0.3 )
				},
				-- front
				{
					type = MATERIAL_LIGHT_POINT,
					pos = Vector( 100, 0, 60 + math.sin( CurTime() * 1 ) * 90 ),
					color = Vector( 1, 1, 1 )
				}
			}

			-- Use local lights as it produces much better looking rendering than the light box
			render.SetLocalModelLights( self.LocalLights )

			return true
		end

		mdl.StoredFOV = 47
		mdl:SetFOV( mdl.StoredFOV )
		function mdl:LayoutEntity( ent )
			if ( self.bAnimated ) then self:RunAnimation() end

			if ( self.Pressed ) then
				local mx, my = input.GetCursorPos()

				if ( self.Pressed == MOUSE_LEFT ) then
					self.Angles = self.Angles - Angle( 0, ( ( self.PressX or mx ) - mx ) / 2, 0 )
				end

				self.PressX, self.PressY = mx, my

			end

			ent:SetAngles( self.Angles )

			-- Not ideal, but handles resizing the panel well enough
			self:SetFOV( self.StoredFOV * math.min( mdl:GetWide() / mdl:GetTall(), 2.5 ) )

			mdl.Entity:SetEyeTarget( mdl:GetCamPos() )

		end

	end
} )

-- A bit hacky way to bring the widgets outside of the context menu
concommand.Add( "open_playermodel_selector", function()

	for id, icon in pairs( g_ContextMenu.DesktopWidgets:GetChildren() ) do
		if ( !icon.WidgetClass or icon.WidgetClass != "PlayerEditor" ) then continue end

		-- We gotta have this at the point of creation for some reason
		g_ContextMenu:SetMouseInputEnabled( true )

		-- Create the window
		icon:DoClick()

		-- Make it appear outside of the context menu
		icon.Window:SetParent()
		icon.Window:MakePopup()
		icon.Window:Center()

		break
	end

end )

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
