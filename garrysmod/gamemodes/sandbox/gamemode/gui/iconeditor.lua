
local PANEL = {}

AccessorFunc( PANEL, "m_strModel", "Model" )
AccessorFunc( PANEL, "m_pOrigin", "Origin" )
AccessorFunc( PANEL, "m_bCustomIcon", "CustomIcon" )

function PANEL:Init()

	self:SetSize( 762, 502 )
	self:SetTitle( "#smwidget.icon_editor" )

	local left = self:Add( "Panel" )
	left:Dock( LEFT )
	left:SetWide( 400 )
	self.LeftPanel = left

		local bg = left:Add( "DPanel" )
		bg:Dock( FILL )
		bg:DockMargin( 0, 0, 0, 4 )
		bg.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 128 ) ) end

		self.SpawnIcon = bg:Add( "SpawnIcon" )
		--self.SpawnIcon.DoClick = function() self:RenderIcon() end

		self.ModelPanel = bg:Add( "DAdjustableModelPanel" )
		self.ModelPanel:Dock( FILL )
		self.ModelPanel.FarZ = 32768

		local mat_wireframe = Material( "models/wireframe" )
		function self.ModelPanel.PostDrawModel( mdlpnl, ent )
			if ( self.ShowOrigin ) then
				render.DrawLine( Vector( 0, 0, 0 ), Vector( 0, 0, 100 ), Color( 0, 0, 255 ) )
				render.DrawLine( Vector( 0, 0, 0 ), Vector( 0, 100, 0 ), Color( 0, 255, 0 ) )
				render.DrawLine( Vector( 0, 0, 0 ), Vector( 100, 0, 0 ), Color( 255, 0, 0 ) )
			end

			if ( self.ShowBBox ) then
				local mins, maxs = ent:GetRenderBounds()
				local scale = 1
				mat_wireframe:SetVector( "$color", Vector( 1, 1, 1 ) )
				render.SetMaterial( mat_wireframe )

				render.DrawBox( ent:GetPos(), ent:GetAngles(), mins * scale, maxs * scale )
			end

		end

	local controls = left:Add( "Panel" )
	controls:SetTall( 64 )
	controls:Dock( BOTTOM )

		local controls_anim = controls:Add( "Panel" )
		controls_anim:SetTall( 20 )
		controls_anim:Dock( TOP )
		controls_anim:DockMargin( 0, 0, 0, 4 )
		controls_anim:MoveToBack()

			self.AnimTrack = controls_anim:Add( "DSlider" )
			self.AnimTrack:Dock( FILL )
			self.AnimTrack:SetNotches( 100 )
			self.AnimTrack:SetTrapInside( true )
			self.AnimTrack:SetLockY( 0.5 )

			self.AnimPause = controls_anim:Add( "DImageButton" )
			self.AnimPause:SetImage( "icon16/control_pause_blue.png" )
			self.AnimPause:SetStretchToFit( false )
			self.AnimPause:SetPaintBackground( true )
			self.AnimPause:SetIsToggle( true )
			self.AnimPause:SetToggle( false )
			self.AnimPause:Dock( LEFT )
			self.AnimPause:SetWide( 32 )

		local BestGuess = controls:Add( "DImageButton" )
		BestGuess:SetImage( "icon32/wand.png" )
		BestGuess:SetStretchToFit( false )
		BestGuess:SetPaintBackground( true )
		BestGuess.DoClick = function() self:BestGuessLayout() end
		BestGuess:Dock( LEFT )
		BestGuess:DockMargin( 0, 0, 0, 0 )
		BestGuess:SetWide( 50 )
		BestGuess:SetTooltip( "Best Guess" )

		local FullFrontal = controls:Add( "DImageButton" )
		FullFrontal:SetImage( "icon32/hand_point_090.png" )
		FullFrontal:SetStretchToFit( false )
		FullFrontal:SetPaintBackground( true )
		FullFrontal.DoClick = function() self:FullFrontalLayout() end
		FullFrontal:Dock( LEFT )
		FullFrontal:DockMargin( 2, 0, 0, 0 )
		FullFrontal:SetWide( 50 )
		FullFrontal:SetTooltip( "Front" )

		local Above = controls:Add( "DImageButton" )
		Above:SetImage( "icon32/hand_property.png" )
		Above:SetStretchToFit( false )
		Above:SetPaintBackground( true )
		Above.DoClick = function() self:AboveLayout() end
		Above:Dock( LEFT )
		Above:DockMargin( 2, 0, 0, 0 )
		Above:SetWide( 50 )
		Above:SetTooltip( "Above" )

		local Right = controls:Add( "DImageButton" )
		Right:SetImage( "icon32/hand_point_180.png" )
		Right:SetStretchToFit( false )
		Right:SetPaintBackground( true )
		Right.DoClick = function() self:RightLayout() end
		Right:Dock( LEFT )
		Right:DockMargin( 2, 0, 0, 0 )
		Right:SetWide( 50 )
		Right:SetTooltip( "Right" )

		local Origin = controls:Add( "DImageButton" )
		Origin:SetImage( "icon32/hand_point_090.png" )
		Origin:SetStretchToFit( false )
		Origin:SetPaintBackground( true )
		Origin.DoClick = function() self:OriginLayout() end
		Origin:Dock( LEFT )
		Origin:DockMargin( 2, 0, 0, 0 )
		Origin:SetWide( 50 )
		Origin:SetTooltip( "Center" )

		local Render = controls:Add( "DButton" )
		Render:SetText( "RENDER" )
		Render.DoClick = function() self:RenderIcon() end
		Render:Dock( RIGHT )
		Render:DockMargin( 2, 0, 0, 0 )
		Render:SetWide( 50 )
		Render:SetTooltip( "Render Icon" )

		local Picker = controls:Add( "DImageButton" )
		Picker:SetImage( "icon32/color_picker.png" )
		Picker:SetStretchToFit( false )
		Picker:SetPaintBackground( true )
		Picker:Dock( RIGHT )
		Picker:DockMargin( 2, 0, 0, 0 )
		Picker:SetWide( 50 )
		Picker.DoClick = function()

			self:SetVisible( false )

			util.worldpicker.Start( function( tr )

				self:SetVisible( true )

				if ( !IsValid( tr.Entity ) ) then return end

				self:SetFromEntity( tr.Entity )

			end )
		end

	local right = self:Add( "DPropertySheet" )
	right:Dock( FILL )
	right:SetPadding( 0 )
	right:DockMargin( 4, 0, 0, 0 )
	self.PropertySheet = right

	-- Animations

	local anims = right:Add( "Panel" )
	anims:Dock( FILL )
	anims:DockPadding( 2, 0, 2, 2 )
	right:AddSheet( "#smwidget.animations", anims, "icon16/monkey.png" )

		self.AnimList = anims:Add( "DListView" )
		self.AnimList:AddColumn( "name" )
		self.AnimList:Dock( FILL )
		self.AnimList:SetMultiSelect( false )
		self.AnimList:SetHideHeaders( true )

	-- Bodygroups

	local pnl = right:Add( "Panel" )
	pnl:Dock( FILL )
	pnl:DockPadding( 7, 0, 7, 7 )

	self.BodygroupTab = right:AddSheet( "#smwidget.bodygroups", pnl, "icon16/brick.png" )

		self.BodyList = pnl:Add( "DScrollPanel" )
		self.BodyList:Dock( FILL )

			--This kind of works but they don't move their stupid mouths. So fuck off.
			--[[
			self.Scenes = pnl:Add( "DTree" )
			self.Scenes:Dock( BOTTOM )
			self.Scenes:SetSize( 200, 200 )
			self.Scenes.DoClick = function( _, node )

				if ( !node.FileName ) then return end
				local ext = string.GetExtensionFromFilename( node.FileName )
				if( ext != "vcd" ) then return end

				self.ModelPanel:StartScene( node.FileName )
				MsgN( node.FileName )

			end

			local materials = self.Scenes.RootNode:AddFolder( "Scenes", "scenes/", true )
			materials:SetIcon( "icon16/photos.png" )--]]

	-- Settings

	local settings = right:Add( "Panel" )
	settings:Dock( FILL )
	settings:DockPadding( 7, 0, 7, 7 )
	right:AddSheet( "#smwidget.settings", settings, "icon16/cog.png" )

		local bbox = settings:Add( "DCheckBoxLabel" )
		bbox:SetText( "Show Bounding Box" )
		bbox:Dock( TOP )
		bbox:DockMargin( 0, 0, 0, 3 )
		bbox:SetDark( true )
		bbox.OnChange = function( p, b )
			self.ShowBBox = b
			p:SetCookie( "checkbox_checked", b && 1 or 0 )
		end
		bbox.LoadCookies = function( p ) local b = p:GetCookie( "checkbox_checked" ) p:SetChecked( b ) p:OnChange( tobool( b ) ) end
		bbox:SetCookieName( "model_editor_bbox" )

		local origin = settings:Add( "DCheckBoxLabel" )
		origin:SetText( "Show Origin" )
		origin:Dock( TOP )
		origin:DockMargin( 0, 0, 0, 3 )
		origin:SetDark( true )
		origin.OnChange = function( p, b )
			self.ShowOrigin = b
			p:SetCookie( "checkbox_checked", b && 1 or 0 )
		end
		origin.LoadCookies = function( p ) local b = p:GetCookie( "checkbox_checked" ) p:SetChecked( b ) p:OnChange( tobool( b ) ) end
		origin:SetCookieName( "model_editor_origin" )

		local angle = settings:Add( "DTextEntry" )
		angle:SetTooltip( "Entity Angles" )
		angle:Dock( TOP )
		angle:DockMargin( 0, 0, 0, 3 )
		angle:SetZPos( 100 )
		angle.OnChange = function( p, b )
			self.ModelPanel:GetEntity():SetAngles( Angle( angle:GetText() ) )
		end
		self.TargetAnglePanel = angle

		local cam_angle = settings:Add( "DTextEntry" )
		cam_angle:SetTooltip( "Camera Angles" )
		cam_angle:Dock( TOP )
		cam_angle:DockMargin( 0, 0, 0, 3 )
		cam_angle:SetZPos( 101 )
		cam_angle.OnChange = function( p, b )
			self.ModelPanel:SetLookAng( Angle( cam_angle:GetText() ) )
		end
		self.TargetCamAnglePanel = cam_angle

		local cam_pos = settings:Add( "DTextEntry" )
		cam_pos:SetTooltip( "Camera Position" )
		cam_pos:Dock( TOP )
		cam_pos:DockMargin( 0, 0, 0, 3 )
		cam_pos:SetZPos( 102 )
		cam_pos.OnChange = function( p, b )
			self.ModelPanel:SetCamPos( Vector( cam_pos:GetText() ) )
		end
		self.TargetCamPosPanel = cam_pos

end

function PANEL:SetDefaultLighting()

	self.ModelPanel:SetAmbientLight( Color( 255 * 0.3, 255 * 0.3, 255 * 0.3 ) )

	self.ModelPanel:SetDirectionalLight( BOX_FRONT, Color( 255 * 1.3, 255 * 1.3, 255 * 1.3 ) )
	self.ModelPanel:SetDirectionalLight( BOX_BACK, Color( 255 * 0.2, 255 * 0.2, 255 * 0.2 ) )
	self.ModelPanel:SetDirectionalLight( BOX_RIGHT, Color( 255 * 0.2, 255 * 0.2, 255 * 0.2 ) )
	self.ModelPanel:SetDirectionalLight( BOX_LEFT, Color( 255 * 0.2, 255 * 0.2, 255 * 0.2 ) )
	self.ModelPanel:SetDirectionalLight( BOX_TOP, Color( 255 * 2.3, 255 * 2.3, 255 * 2.3 ) )
	self.ModelPanel:SetDirectionalLight( BOX_BOTTOM, Color( 255 * 0.1, 255 * 0.1, 255 * 0.1 ) )

end

function PANEL:BestGuessLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local ang = ent:GetAngles()

	local tab = PositionSpawnIcon( ent, pos, true )

	ent:SetAngles( ang )
	if ( tab ) then
		self.ModelPanel:SetCamPos( tab.origin )
		self.ModelPanel:SetFOV( tab.fov )
		self.ModelPanel:SetLookAng( tab.angles )
	end

end

function PANEL:FullFrontalLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( -200, 0, 0 )

	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( ( campos * -1 ):Angle() )

end

function PANEL:AboveLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( 0, 0, 200 )

	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( ( campos * -1 ):Angle() )

end

function PANEL:RightLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( 0, 200, 0 )

	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( ( campos * -1 ):Angle() )

end

function PANEL:OriginLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( 0, 0, 0 )

	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( Angle( 0, -180, 0 ) )

end

function PANEL:UpdateEntity( ent )

	ent:SetEyeTarget( self.ModelPanel:GetCamPos() )

	if ( IsValid( self.TargetAnglePanel ) && !self.TargetAnglePanel:IsEditing() ) then
		self.TargetAnglePanel:SetText( tostring( ent:GetAngles() ) )
	end
	if ( IsValid( self.TargetCamAnglePanel ) && !self.TargetCamAnglePanel:IsEditing() ) then
		self.TargetCamAnglePanel:SetText( tostring( self.ModelPanel:GetLookAng() ) )
	end
	if ( IsValid( self.TargetCamPosPanel ) && !self.TargetCamPosPanel:IsEditing() ) then
		self.TargetCamPosPanel:SetText( tostring( self.ModelPanel:GetCamPos() ) )
	end

	if ( self.AnimTrack:GetDragging() ) then

		ent:SetCycle( self.AnimTrack:GetSlideX() )
		self.AnimPause:SetToggle( true )

	elseif ( ent:GetCycle() != self.AnimTrack:GetSlideX() ) then

		self.AnimTrack:SetSlideX( ent:GetCycle() )

	end

	if ( !self.AnimPause:GetToggle() ) then
		ent:FrameAdvance( FrameTime() )
	end

end

function PANEL:RenderIcon()

	local tab = {}
	tab.ent = self.ModelPanel:GetEntity()
	tab.cam_pos = self.ModelPanel:GetCamPos()
	tab.cam_ang = self.ModelPanel:GetLookAng()
	tab.cam_fov = self.ModelPanel:GetFOV()

	self.SpawnIcon:RebuildSpawnIconEx( tab )

end

function PANEL:SetIcon( icon )

	if ( !IsValid( icon ) ) then return end

	local model = icon:GetModelName()
	self:SetOrigin( icon )

	self.SpawnIcon:SetSize( icon:GetSize() )
	self.SpawnIcon:InvalidateLayout( true )

	local w, h = icon:GetSize()
	if ( w / h < 1 ) then
		self:SetSize( 700, 502 + 400 )
		self.LeftPanel:SetWide( 400 )
	elseif ( w / h > 1 ) then
		self:SetSize( 900, 502 - 100 )
		self.LeftPanel:SetWide( 600 )
	else
		self:SetSize( 700, 502 )
		self.LeftPanel:SetWide( 400 )
	end

	if ( !model or model == "" ) then

		self:SetModel( "error.mdl" )
		self.SpawnIcon:SetSpawnIcon( icon:GetIconName() )
		self:SetCustomIcon( true )

	else

		self:SetModel( model )
		self.SpawnIcon:SetModel( model, icon:GetSkinID(), icon:GetBodyGroup() )
		self:SetCustomIcon( false )

	end

end

function PANEL:Refresh()

	if ( !self:GetModel() ) then return end

	self.ModelPanel:SetModel( self:GetModel() )
	self.ModelPanel.LayoutEntity = function() self:UpdateEntity( self.ModelPanel:GetEntity() )  end

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()

	local tab = PositionSpawnIcon( ent, pos )

	ent:SetSkin( self.SpawnIcon:GetSkinID() )
	ent:SetBodyGroups( self.SpawnIcon:GetBodyGroup() )

	self:BestGuessLayout()
	self:FillAnimations( ent )
	self:SetDefaultLighting()

end

function PANEL:FillAnimations( ent )

	self.AnimList:Clear()

	for k, v in SortedPairsByValue( ent:GetSequenceList() or {} ) do

		local line = self.AnimList:AddLine( string.lower( v ) )

		line.OnSelect = function()

			ent:ResetSequence( v )
			ent:SetCycle( 0 )

		end

	end

	self.BodyList:Clear()
	local newItems = 0

	if ( ent:SkinCount() > 1 ) then

		local combo = self.BodyList:Add( "DComboBox" )
		combo:Dock( TOP )
		combo:DockMargin( 0, 0, 0, 3 )
		newItems = newItems + 1

		for l = 0, ent:SkinCount() - 1 do
			combo:AddChoice( "Skin " .. l, function()

				ent:SetSkin( l )

				if ( self:GetOrigin() ) then
					self:GetOrigin():SkinChanged( l )
				end

				-- If we're not using a custom, change our spawnicon
				-- so we save the new skin in the right place...
				if ( !self:GetCustomIcon() ) then
					self.SpawnIcon:SetModel( self.SpawnIcon:GetModelName(), l, self.SpawnIcon:GetBodyGroup() )
				end

			end )
		end

		combo:ChooseOptionID( ent:GetSkin( l ) + 1 )
		combo.OnSelect = function( pnl, index, value, data ) data()	end

	end

	for k = 0, ent:GetNumBodyGroups() - 1 do

		if ( ent:GetBodygroupCount( k ) <= 1 ) then continue end

		local combo = self.BodyList:Add( "DComboBox" )
		combo:Dock( TOP )
		combo:DockMargin( 0, 0, 0, 3 )
		newItems = newItems + 1

		for l = 0, ent:GetBodygroupCount( k ) - 1 do

			combo:AddChoice( ent:GetBodygroupName( k ) .. " " .. l, function()

				-- Body Group Changed..
				ent:SetBodygroup( k, l )

				if ( self:GetOrigin() ) then
					self:GetOrigin():BodyGroupChanged( k, l )
				end

				-- If we're not using a custom, change our spawnicon
				-- so we save the new skin in the right place...
				if ( !self:GetCustomIcon() ) then
					self.SpawnIcon:SetBodyGroup( k, l )
					self.SpawnIcon:SetModel( self.SpawnIcon:GetModelName(), self.SpawnIcon:GetSkinID(), self.SpawnIcon:GetBodyGroup() )
				end

			end )

		end

		combo:ChooseOptionID( ent:GetBodygroup( k ) + 1 )

		combo.OnSelect = function( pnl, index, value, data ) data() end

	end

	if ( newItems > 0 ) then
		self.BodygroupTab.Tab:SetVisible( true )
	else
		self.BodygroupTab.Tab:SetVisible( false )
	end
	local propertySheet = self.PropertySheet
	propertySheet.tabScroller:InvalidateLayout()

end

function PANEL:SetFromEntity( ent )

	if ( !IsValid( ent ) ) then return end

	local bodyStr = ""
	for i = 0, 8 do
		bodyStr = bodyStr .. math.min( ent:GetBodygroup( i ) or 0, 9 )
	end

	self.SpawnIcon:SetModel( ent:GetModel(), ent:GetSkin(), bodyStr )
	self:SetModel( ent:GetModel() )
	self:Refresh()

end

vgui.Register( "IconEditor", PANEL, "DFrame" )
