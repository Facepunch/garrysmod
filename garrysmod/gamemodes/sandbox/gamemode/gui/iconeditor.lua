
local PANEL = {}

AccessorFunc( PANEL, "m_strModel",		"Model" )
AccessorFunc( PANEL, "m_pOrigin",		"Origin" )
AccessorFunc( PANEL, "m_bCustomIcon",	"CustomIcon" )

function PANEL:Init()

	self:SetSize( 650, 502 )
	self:SetTitle( "Icon Editor" )

	local pnl = self:Add( "Panel" )
	pnl:SetSize( 400, 400 )
	pnl:Dock( FILL )
	pnl:DockMargin( 0, 0, 4, 0 )

		self.AnimList = pnl:Add( "DListView" )
		self.AnimList:AddColumn( "name" )
		self.AnimList:Dock( FILL )
		self.AnimList:SetSize( 200, 300 )
		self.AnimList:SetMultiSelect( true )
		self.AnimList:SetHideHeaders( true )

	local pnl = pnl:Add( "Panel" )
	pnl:Dock( BOTTOM )
	pnl:SetTall( 140 )

		self.BodyList = pnl:Add( "DListLayout" )
		self.BodyList:Dock( FILL )
		pnl:DockMargin( 0, 4, 0, 0 )

/*
		This kind of works but they don't move their stupid mouths. So fuck off.

		self.Scenes = pnl:Add( "DTree" )
		self.Scenes:Dock( BOTTOM )
		self.Scenes:SetSize( 200, 200 )
		self.Scenes.DoClick = function( _, node )

			if ( !node.FileName ) then return end
			local ext = string.GetExtensionFromFilename( node.FileName );
			if( ext != "vcd" ) then return end

			self.ModelPanel:StartScene( node.FileName );
			MsgN( node.FileName )

		end

		local materials = self.Scenes.RootNode:AddFolder( "Scenes", "scenes/", true );
		materials:SetIcon( "icon16/photos.png" )
*/

	local pnl = self:Add( "Panel" )
	pnl:SetSize( 400, 400 )
	pnl:Dock( RIGHT )

		local bg = pnl:Add( "DPanel" )
		bg:Dock( TOP )
		bg:SetSize( 400, 400 )
		bg:DockMargin( 0, 0, 0, 4 )
		bg.Paint = function( self, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 128 ) ) end

		self.SpawnIcon = bg:Add( "SpawnIcon" )
		//self.SpawnIcon.DoClick = function() self:RenderIcon() end

		self.ModelPanel = bg:Add( "DAdjustableModelPanel" )
		self.ModelPanel:Dock( FILL )
		self.ModelPanel.FarZ = 32768

	local pnl2 = pnl:Add( "Panel" )
	pnl2:SetSize( 400, 64 )
	pnl2:Dock( FILL )

		local BestGuess = pnl2:Add( "DImageButton" )
		BestGuess:SetImage( "icon32/wand.png" )
		BestGuess:SetStretchToFit( false )
		BestGuess:SetPaintBackground( true )
		BestGuess.DoClick = function() self:BestGuessLayout() end
		BestGuess:Dock( LEFT )
		BestGuess:DockMargin( 0, 0, 0, 0 )
		BestGuess:SetWide( 50 )
		BestGuess:SetTooltip( "Best Guess" )

		local FullFrontal = pnl2:Add( "DImageButton" )
		FullFrontal:SetImage( "icon32/hand_point_090.png" )
		FullFrontal:SetStretchToFit( false )
		FullFrontal:SetPaintBackground( true )
		FullFrontal.DoClick = function() self:FullFrontalLayout() end
		FullFrontal:Dock( LEFT )
		FullFrontal:DockMargin( 2, 0, 0, 0 )
		FullFrontal:SetWide( 50 )
		FullFrontal:SetTooltip( "Front" )

		local Above = pnl2:Add( "DImageButton" )
		Above:SetImage( "icon32/hand_property.png" )
		Above:SetStretchToFit( false )
		Above:SetPaintBackground( true )
		Above.DoClick = function() self:AboveLayout() end
		Above:Dock( LEFT )
		Above:DockMargin( 2, 0, 0, 0 )
		Above:SetWide( 50 )
		Above:SetTooltip( "Above" )

		local Right = pnl2:Add( "DImageButton" )
		Right:SetImage( "icon32/hand_point_180.png" )
		Right:SetStretchToFit( false )
		Right:SetPaintBackground( true )
		Right.DoClick = function() self:RightLayout() end
		Right:Dock( LEFT )
		Right:DockMargin( 2, 0, 0, 0 )
		Right:SetWide( 50 )
		Right:SetTooltip( "Right" )

		local Origin = pnl2:Add( "DImageButton" )
		Origin:SetImage( "icon32/hand_point_090.png" )
		Origin:SetStretchToFit( false )
		Origin:SetPaintBackground( true )
		Origin.DoClick = function() self:OriginLayout() end
		Origin:Dock( LEFT )
		Origin:DockMargin( 2, 0, 0, 0 )
		Origin:SetWide( 50 )
		Origin:SetTooltip( "Center" )

		local Render = pnl2:Add( "DButton" )
		Render:SetText( "RENDER" )
		Render.DoClick = function() self:RenderIcon() end
		Render:Dock( RIGHT )
		Render:DockMargin( 2, 0, 0, 0 )
		Render:SetWide( 50 )
		Render:SetTooltip( "Render Icon" )

		local Picker = pnl2:Add( "DImageButton" )
		Picker:SetImage( "icon32/color_picker.png" )
		Picker:SetStretchToFit( false )
		Picker:SetPaintBackground( true )
		Picker.DoClick = function()

			self:SetVisible( false )

			util.worldpicker.Start( function( tr )

				self:SetVisible( true )

				if ( !IsValid( tr.Entity ) ) then return end

				self:SetFromEntity( tr.Entity )

			end )
		end

		Picker:Dock( RIGHT )
		Picker:DockMargin( 2, 0, 0, 0 )
		Picker:SetWide( 50 )

	local pnl3 = pnl2:Add( "Panel" )
	pnl3:SetSize( 400, 20 )
	pnl3:Dock( TOP )
	pnl3:DockMargin( 0, 0, 0, 4 )
	pnl3:MoveToBack()

		self.AnimTrack = pnl3:Add( "DSlider" )
		self.AnimTrack:Dock( FILL )
		self.AnimTrack:SetNotches( 100 )
		self.AnimTrack:SetTrapInside( true )
		self.AnimTrack:SetLockY( 0.5 )

		self.AnimPause = pnl3:Add( "DImageButton" )
		self.AnimPause:SetImage( "icon16/control_pause_blue.png" )
		self.AnimPause:SetStretchToFit( false )
		self.AnimPause:SetPaintBackground( true )
		self.AnimPause:SetIsToggle( true )
		self.AnimPause:SetToggle( false )
		self.AnimPause:Dock( LEFT )
		self.AnimPause:SetWide( 32 )

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

	local tab = PositionSpawnIcon( ent, pos )

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
	self.ModelPanel:SetLookAng( (campos * -1):Angle() )

end

function PANEL:AboveLayout()

	local ent = self.ModelPanel:GetEntity()
	local pos = ent:GetPos()
	local campos = pos + Vector( 0, 0, 200 )

	self.ModelPanel:SetCamPos( campos )
	self.ModelPanel:SetFOV( 45 )
	self.ModelPanel:SetLookAng( (campos * -1):Angle() )

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

	if ( self.AnimTrack:GetDragging() ) then

		ent:SetCycle( self.AnimTrack:GetSlideX() )
		self.AnimPause:SetToggle( true )

	else

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

	local model = icon:GetModelName()
	self:SetOrigin( icon )

	self.SpawnIcon:SetSize( icon:GetSize() )
	self.SpawnIcon:InvalidateLayout( true )

	if ( !model || model == "" ) then

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

	for k, v in SortedPairsByValue( ent:GetSequenceList() ) do

		local line = self.AnimList:AddLine( string.lower( v ) )

		line.OnSelect = function()

			ent:ResetSequence( v )
			ent:SetCycle( 0 )

		end

	end

	self.BodyList:Clear()

	if ( ent:SkinCount() - 1 > 0 ) then

		local combo = self.BodyList:Add( "DComboBox" )

		for l=0, ent:SkinCount()-1 do
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

	for k=0, ent:GetNumBodyGroups()-1 do

		if ( ent:GetBodygroupCount( k ) <= 1 ) then continue end

		local combo = self.BodyList:Add( "DComboBox" )

		for l=0, ent:GetBodygroupCount( k )-1 do

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

end

function PANEL:SetFromEntity( ent )

	if ( !IsValid( ent ) ) then return end

	self.SpawnIcon:SetModel( ent:GetModel(), ent:GetSkin() )//, ent:GetBodyGroup() )
	self:SetModel( ent:GetModel() )
	self:Refresh()

end

vgui.Register( "IconEditor", PANEL, "DFrame" )
