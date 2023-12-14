
TOOL.Category = "Poser"
TOOL.Name = "#tool.faceposer.name"

local MAXSTUDIOFLEXCTRL = 96

TOOL.FaceTimer = 0

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

local function IsUselessFaceFlex( strName )

	if ( strName == "gesture_rightleft" ) then return true end
	if ( strName == "gesture_updown" ) then return true end
	if ( strName == "head_forwardback" ) then return true end
	if ( strName == "chest_rightleft" ) then return true end
	if ( strName == "body_rightleft" ) then return true end
	if ( strName == "eyes_rightleft" ) then return true end
	if ( strName == "eyes_updown" ) then return true end
	if ( strName == "head_tilt" ) then return true end
	if ( strName == "head_updown" ) then return true end
	if ( strName == "head_rightleft" ) then return true end

	return false

end

local function GenerateDefaultFlexValue( ent, flexID )
	local min, max = ent:GetFlexBounds( flexID )
	if ( !max || max - min == 0 ) then return 0 end
	return ( 0 - min ) / ( max - min )
end

function TOOL:FacePoserEntity()
	return self:GetWeapon():GetNWEntity( 1 )
end

function TOOL:SetFacePoserEntity( ent )
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end
	return self:GetWeapon():SetNWEntity( 1, ent )
end

local gLastFacePoseEntity = NULL
function TOOL:Think()

	-- If we're on the client just make sure the context menu is up to date
	if ( CLIENT ) then

		if ( self:FacePoserEntity() == gLastFacePoseEntity ) then return end

		gLastFacePoseEntity = self:FacePoserEntity()
		self:RebuildControlPanel( self:FacePoserEntity() )

		return
	end

	-- On the server we continually set the flex weights
	if ( self.FaceTimer > CurTime() ) then return end

	local ent = self:FacePoserEntity()
	if ( !IsValid( ent ) ) then return end

	local FlexNum = ent:GetFlexNum()
	if ( FlexNum <= 0 ) then return end

	for i = 0, FlexNum do

		local num = self:GetClientNumber( "flex" .. i )
		ent:SetFlexWeight( i, num )

	end

	local num = self:GetClientNumber( "scale" )
	ent:SetFlexScale( num )

end

--[[---------------------------------------------------------
	Alt fire sucks the facepose from the model's face
-----------------------------------------------------------]]
function TOOL:RightClick( trace )

	local ent = trace.Entity
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

	if ( SERVER ) then
		self:SetFacePoserEntity( ent )
	end

	if ( !IsValid( ent ) ) then return true end

	local FlexNum = ent:GetFlexNum()
	if ( FlexNum == 0 ) then return false end

	if ( SERVER ) then

		-- This stops it applying the current sliders to the newly selected face..
		-- it should probably be linked to the ping somehow.. but 1 second seems pretty safe
		self.FaceTimer = CurTime() + 1

		-- In multiplayer the rest is only done on the client to save bandwidth.
		-- We can't do that in single player because these functions don't get called on the client
		if ( !game.SinglePlayer() ) then return true end

	end

	for i = 0, FlexNum - 1 do

		local Weight = "0.0"

		if ( !ent:HasFlexManipulatior() ) then
			Weight = GenerateDefaultFlexValue( ent, i )
		elseif ( i <= FlexNum ) then
			Weight = ent:GetFlexWeight( i )
		end

		self:GetOwner():ConCommand( "faceposer_flex" .. i .. " " .. Weight )

	end

	self:GetOwner():ConCommand( "faceposer_scale " .. ent:GetFlexScale() )

	return true

end

--[[---------------------------------------------------------
	Just select as the current object
	Current settings will get applied
-----------------------------------------------------------]]
function TOOL:LeftClick( trace )

	local ent = trace.Entity
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

	if ( !IsValid( ent ) ) then return false end
	if ( ent:GetFlexNum() == 0 ) then return false end

	self.FaceTimer = 0
	self:SetFacePoserEntity( ent )

	return true

end

if ( SERVER ) then

	local function CC_Face_Randomize( ply, command, arguments )

		for i = 0, MAXSTUDIOFLEXCTRL do
			local num = math.Rand( 0, 1 )
			ply:ConCommand( "faceposer_flex" .. i .. " " .. string.format( "%.3f", num ) )
		end

	end

	concommand.Add( "faceposer_randomize", CC_Face_Randomize )

end

-- The rest of the code is clientside only, it is not used on server
if ( SERVER ) then return end

for i = 0, MAXSTUDIOFLEXCTRL do
	TOOL.ClientConVar[ "flex" .. i ] = "0"
end

TOOL.ClientConVar[ "scale" ] = "1.0"

local ConVarsDefault = TOOL:BuildConVarList()

-- Make the internal flex names be more presentable, TODO: handle numbers
local function PrettifyName( name )
	name = name:Replace( "_", " " )

	-- Try to split text into words, where words would start with single uppercase character
	local newParts = {}
	for id, str in ipairs( string.Explode( " ", name ) ) do
		local wordStart = 1
		for i = 2, str:len() do
			local c = str[ i ]
			if ( c:upper() == c ) then
				local toAdd = str:sub( wordStart, i - 1 )
				if ( toAdd:upper() == toAdd ) then continue end
				table.insert( newParts, toAdd )
				wordStart = i
			end

		end

		table.insert( newParts, str:sub( wordStart, str:len() ) )
	end

	-- Uppercase all first characters
	for id, str in ipairs( newParts ) do
		if ( str:len() < 2 ) then continue end
		newParts[ id ] = str:Left( 1 ):upper() .. str:sub( 2 )
	end

	return table.concat( newParts, " " )
end

function TOOL.BuildCPanel( CPanel, faceEntity )

	CPanel:AddControl( "Header", { Description = "#tool.faceposer.desc" } )

	if ( !IsValid( faceEntity ) || faceEntity:GetFlexNum() == 0 ) then return end

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "face", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	local QuickFace = vgui.Create( "MatSelect", CPanel )
	QuickFace:SetItemWidth( 64 )
	QuickFace:SetItemHeight( 32 )

	QuickFace.List:SetSpacing( 1 )
	QuickFace.List:SetPadding( 0 )

	QuickFace:SetAutoHeight( true )

	local Clear = {}
	for i = 0, MAXSTUDIOFLEXCTRL do
		Clear[ "faceposer_flex" .. i ] = GenerateDefaultFlexValue( faceEntity, i )
	end
	QuickFace:AddMaterialEx( "#faceposer.clear", "vgui/face/clear", nil, Clear )

	-- Todo: These really need to be the name of the flex.
	QuickFace:AddMaterialEx( "#faceposer.openeyes", "vgui/face/open_eyes", nil, {
		faceposer_flex0 = "1",
		faceposer_flex1 = "1",
		faceposer_flex2 = "0",
		faceposer_flex3 = "0",
		faceposer_flex4 = "0",
		faceposer_flex5 = "0",
		faceposer_flex6 = "0",
		faceposer_flex7 = "0",
		faceposer_flex8 = "0",
		faceposer_flex9 = "0"
	} )

	QuickFace:AddMaterialEx( "#faceposer.closeeyes", "vgui/face/close_eyes", nil, {
		faceposer_flex0 = "0",
		faceposer_flex1 = "0",
		faceposer_flex2 = "1",
		faceposer_flex3 = "1",
		faceposer_flex4 = "1",
		faceposer_flex5 = "1",
		faceposer_flex6 = "1",
		faceposer_flex7 = "1",
		faceposer_flex8 = "1",
		faceposer_flex9 = "1"
	} )

	QuickFace:AddMaterialEx( "#faceposer.angryeyebrows", "vgui/face/angry_eyebrows", nil, {
		faceposer_flex10 = "0",
		faceposer_flex11 = "0",
		faceposer_flex12 = "1",
		faceposer_flex13 = "1",
		faceposer_flex14 = "0.5",
		faceposer_flex15 = "0.5"
	} )

	QuickFace:AddMaterialEx( "#faceposer.normaleyebrows", "vgui/face/normal_eyebrows", nil, {
		faceposer_flex10 = "0",
		faceposer_flex11 = "0",
		faceposer_flex12 = "0",
		faceposer_flex13 = "0",
		faceposer_flex14 = "0",
		faceposer_flex15 = "0"
	} )

	QuickFace:AddMaterialEx( "#faceposer.sorryeyebrows", "vgui/face/sorry_eyebrows", nil, {
		faceposer_flex10 = "1",
		faceposer_flex11 = "1",
		faceposer_flex12 = "0",
		faceposer_flex13 = "0",
		faceposer_flex14 = "0",
		faceposer_flex15 = "0"
	} )

	QuickFace:AddMaterialEx( "#faceposer.grin", "vgui/face/grin", nil, {
		faceposer_flex20 = "1",
		faceposer_flex21 = "1",
		faceposer_flex22 = "1",
		faceposer_flex23 = "1",
		faceposer_flex24 = "0",
		faceposer_flex25 = "0",
		faceposer_flex26 = "0",
		faceposer_flex27 = "1",
		faceposer_flex28 = "1",
		faceposer_flex29 = "0",
		faceposer_flex30 = "0",
		faceposer_flex31 = "0",
		faceposer_flex32 = "0",
		faceposer_flex33 = "1",
		faceposer_flex34 = "1",
		faceposer_flex35 = "0",
		faceposer_flex36 = "0",
		faceposer_flex37 = "0",
		faceposer_flex38 = "0",
		faceposer_flex39 = "1",
		faceposer_flex40 = "0",
		faceposer_flex41 = "0",
		faceposer_flex42 = "1",
		faceposer_flex43 = "1"
	} )

	QuickFace:AddMaterialEx( "#faceposer.sad", "vgui/face/sad", nil, {
		faceposer_flex20 = "0",
		faceposer_flex21 = "0",
		faceposer_flex22 = "0",
		faceposer_flex23 = "0",
		faceposer_flex24 = "1",
		faceposer_flex25 = "1",
		faceposer_flex26 = "0.0",
		faceposer_flex27 = "0",
		faceposer_flex28 = "0",
		faceposer_flex29 = "0",
		faceposer_flex30 = "0",
		faceposer_flex31 = "0",
		faceposer_flex32 = "0",
		faceposer_flex33 = "0",
		faceposer_flex34 = "0",
		faceposer_flex35 = "0",
		faceposer_flex36 = "0",
		faceposer_flex37 = "0",
		faceposer_flex38 = "0.5",
		faceposer_flex39 = "0",
		faceposer_flex40 = "0",
		faceposer_flex41 = "0",
		faceposer_flex42 = "0",
		faceposer_flex43 = "0"
	} )

	QuickFace:AddMaterialEx( "#faceposer.smile", "vgui/face/smile", nil, {
		faceposer_flex20 = "1",
		faceposer_flex21 = "1",
		faceposer_flex22 = "1",
		faceposer_flex23 = "1",
		faceposer_flex24 = "0",
		faceposer_flex25 = "0",
		faceposer_flex26 = "0",
		faceposer_flex27 = "0.6",
		faceposer_flex28 = "0.4",
		faceposer_flex29 = "0",
		faceposer_flex30 = "0",
		faceposer_flex31 = "0",
		faceposer_flex32 = "0",
		faceposer_flex33 = "1",
		faceposer_flex34 = "1",
		faceposer_flex35 = "0",
		faceposer_flex36 = "0",
		faceposer_flex37 = "0",
		faceposer_flex38 = "0",
		faceposer_flex39 = "0",
		faceposer_flex40 = "1",
		faceposer_flex41 = "1",
		faceposer_flex42 = "0",
		faceposer_flex43 = "0",
		faceposer_flex44 = "0",
	} )

	CPanel:AddItem( QuickFace )

	CPanel:AddControl( "Slider", { Label = "#tool.faceposer.scale", Command = "faceposer_scale", Type = "Float", Min = -5, Max = 5, Help = true, Default = 1 } ):SetHeight( 16 )
	CPanel:AddControl( "Button", { Text = "#tool.faceposer.randomize", Command = "faceposer_randomize" } )

	local filter = CPanel:AddControl( "TextBox", { Label = "#spawnmenu.quick_filter_tool" } )
	filter:SetUpdateOnType( true )

	local flexControllers = {}
	for i = 0, faceEntity:GetFlexNum() - 1 do

		local name = faceEntity:GetFlexName( i )

		if ( !IsUselessFaceFlex( name ) ) then

			if ( i == MAXSTUDIOFLEXCTRL ) then
				CPanel:ControlHelp( "#tool.faceposer.too_many_flexes" ):DockMargin( 16, 16, 16, 4 )
			end

			local min, max = faceEntity:GetFlexBounds( i )

			local ctrl = CPanel:AddControl( "Slider", { Label = PrettifyName( name ), Command = "faceposer_flex" .. i, Type = "Float", Min = min, Max = max, Default = GenerateDefaultFlexValue( faceEntity, i ) } )
			ctrl:SetHeight( 11 ) -- This makes the controls all bunched up like how we want
			ctrl:DockPadding( 0, -6, 0, -4 ) -- Try to make the lower part of the text visible
			ctrl.originalName = name
			table.insert( flexControllers, ctrl )

			if ( i >= MAXSTUDIOFLEXCTRL ) then
				ctrl:SetEnabled( false )
			end

		end

	end

	-- Add some padding to the bottom of the list
	local padding = vgui.Create( "Panel", CPanel )
	padding:SetHeight( 7 )
	CPanel:AddItem( padding )

	-- Actual searching
	filter.OnValueChange = function( pnl, txt )
		for id, flxpnl in ipairs( flexControllers ) do
			if ( !flxpnl:GetText():lower():find( txt:lower(), nil, true ) && !flxpnl.originalName:lower():find( txt:lower(), nil, true ) ) then
				flxpnl:SetVisible( false )
			else
				flxpnl:SetVisible( true )
			end
		end
		CPanel:InvalidateChildren()
	end
end

local FacePoser = surface.GetTextureID( "gui/faceposer_indicator" )

-- Draw a box indicating the face we have selected
function TOOL:DrawHUD()

	if ( GetConVarNumber( "gmod_drawtooleffects" ) == 0 ) then return end

	local selected = self:FacePoserEntity()

	if ( !IsValid( selected ) || selected:IsWorld() || selected:GetFlexNum() == 0 ) then return end

	local pos = selected:GetPos()
	local eyeattachment = selected:LookupAttachment( "eyes" )
	if ( eyeattachment != 0 ) then
		local attachment = selected:GetAttachment( eyeattachment )
		pos = attachment.Pos
	else
		-- The model has no "eyes" attachment, try to find a bone with "head" in its name
		for i = 0, selected:GetBoneCount() - 1 do
			if ( selected:GetBoneName( i ) && selected:GetBoneName( i ):lower():find( "head" ) ) then
				pos = selected:GetBonePosition( i )
			end
		end
	end

	local scrpos = pos:ToScreen()
	if ( !scrpos.visible ) then return end

	-- Work out the side distance to give a rough headsize box..
	local player_eyes = LocalPlayer():EyeAngles()
	local side = ( pos + player_eyes:Right() * 20 ):ToScreen()
	local size = math.abs( side.x - scrpos.x )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( FacePoser )
	surface.DrawTexturedRect( scrpos.x - size, scrpos.y - size, size * 2, size * 2 )

end
