
TOOL.Category		= "Poser"
TOOL.Name			= "#tool.faceposer.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

--local EYE_END = 11
local gLastFacePoseEntity = NULL
TOOL.FaceTimer = 0

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

--[[---------------------------------------------------------
-----------------------------------------------------------]]
function TOOL:FacePoserEntity()
	return self:GetWeapon():GetNetworkedEntity( 1 )
end

--[[---------------------------------------------------------
-----------------------------------------------------------]]
function TOOL:SetFacePoserEntity( ent )
	return self:GetWeapon():SetNetworkedEntity( 1, ent )
end

--[[---------------------------------------------------------
-----------------------------------------------------------]]
function TOOL:Think()

	-- If we're on the client just make sure the context menu is up to date
	if (CLIENT) then
	
		if ( self:FacePoserEntity() == gLastFacePoseEntity ) then return end
		gLastFacePoseEntity = self:FacePoserEntity();
		self:UpdateFaceControlPanel();
	
	return end
	
	-- On the server we continually set the flex weights
	if (self.FaceTimer > CurTime() ) then return end
	
	local ent = self:FacePoserEntity()
	if ( !IsValid( ent ) ) then return end
	
	local FlexNum = ent:GetFlexNum() - 1
	if (FlexNum <= 0) then return end
	
	for i=0, FlexNum-1 do
	
		local Name = ent:GetFlexName( i )
			
		if ( IsUselessFaceFlex(Name )  ) then
			
			ent:SetFlexWeight( i, 0 )
				
		else
	
			local num = self:GetClientNumber( "flex"..i )
			ent:SetFlexWeight( i, num )
			
		end
		
	end
	
	local num = self:GetClientNumber( "scale" )
	ent:SetFlexScale( num )
	
end



	--[[---------------------------------------------------------
		Alt fire sucks the facepose from the model's face
	-----------------------------------------------------------]]
	function TOOL:RightClick( trace )
	
		if ( SERVER ) then
			self:SetFacePoserEntity( trace.Entity )
		end
	
		if ( !IsValid( trace.Entity ) ) then return end
		if ( trace.Entity:GetFlexNum() == 0 ) then return end
		
		local ent = trace.Entity
		local FlexNum = ent:GetFlexNum()
		
		if ( SERVER ) then
				
			-- This stops it applying the current sliders to the newly selected face.. 
			-- it should probably be linked to the ping somehow.. but 1 second seems pretty safe
			self.FaceTimer = CurTime() + 1	
			
			-- In multiplayer the rest is only done on the client to save bandwidth.
			-- We can't do that in single player because these functions don't get called on the client
			if ( !game.SinglePlayer() ) then return end		
			
		end
		
		for i=0, FlexNum-1 do
		
			local Weight = '0.0'
			
			if ( i <= FlexNum ) then
				Weight = ent:GetFlexWeight( i )
			end
			
			self:GetOwner():ConCommand( "faceposer_flex"..i.." " .. Weight )
			
		end
		
		self:GetOwner():ConCommand( "faceposer_scale "..ent:GetFlexScale() )
			
	end
	
if ( SERVER ) then

	--[[---------------------------------------------------------
		Just select as the current object
		- Current settings will get applied
	-----------------------------------------------------------]]
	function TOOL:LeftClick( trace )
	
		if ( !IsValid( trace.Entity ) ) then return end
		if ( trace.Entity:GetFlexNum() == 0 ) then return end
		
		self.FaceTimer = 0;
		self:SetFacePoserEntity( trace.Entity )
		
	end
	
	function CC_Face_Randomize( pl, command, arguments )
	
		for i=0, 64 do
			local num = math.Rand( 0, 1 )
			pl:ConCommand( "faceposer_flex"..i.." " .. string.format( "%.3f", num ) )
		end

	end
	
	concommand.Add( "faceposer_randomize", CC_Face_Randomize )
	
end

if ( CLIENT ) then

	for i=0,64 do
		TOOL.ClientConVar[ "flex"..i ] = "0"
	end
	
	TOOL.ClientConVar[ "scale" ] = "1.0"
	
	--[[---------------------------------------------------------
		Updates the spawn menu panel
	-----------------------------------------------------------]]
	function TOOL:UpdateFaceControlPanel( index )
	
		local CPanel = controlpanel.Get( "faceposer" )
		if ( !CPanel ) then Msg("Couldn't find faceposer panel!\n") return end
		
		CPanel:ClearControls()
		self.BuildCPanel( CPanel, self:FacePoserEntity() )
	
	end
	
	--[[---------------------------------------------------------
		Updates the Control Panel
	-----------------------------------------------------------]]
	function TOOL.BuildCPanel( CPanel, FaceEntity )
	
		if ( !IsValid( FaceEntity ) ) then return end

		local Presets = vgui.Create( "ControlPresets", CPanel )
			Presets:SetPreset( "face" )
			
			for i=0, 64 do
				Presets:AddConVar( "faceposer_flex"..i )
			end
			
		CPanel:AddItem( Presets )
		
		local QuickFace = vgui.Create( "MatSelect", CPanel )
				QuickFace:SetNumRows( 3 )
				QuickFace:SetItemWidth( 64 )
				QuickFace:SetItemHeight( 32 )
				
				-- Todo: These really need to be the name of the flex.
				
				local Clear = {}
				for i=0, 64 do
					Clear[ "faceposer_flex"..i ] = 0
				end
				
				QuickFace:AddMaterialEx( "Clear", "vgui/face/clear", nil, Clear )
				
				QuickFace:AddMaterialEx( "Open Eyes", "vgui/face/open_eyes", nil, 
					  { faceposer_flex0	= "1",
						faceposer_flex1	= "1",
						faceposer_flex2	= "0",
						faceposer_flex3	= "0",
						faceposer_flex4	= "0",
						faceposer_flex5	= "0",
						faceposer_flex6	= "0",
						faceposer_flex7	= "0",
						faceposer_flex8	= "0",
						faceposer_flex9	= "0"} )
						
				QuickFace:AddMaterialEx( "Close Eyes", "vgui/face/close_eyes", nil, 
					  { faceposer_flex0	= "0",
						faceposer_flex1	= "0",
						faceposer_flex2	= "1",
						faceposer_flex3	= "1",
						faceposer_flex4	= "1",
						faceposer_flex5	= "1",
						faceposer_flex6	= "1",
						faceposer_flex7	= "1",
						faceposer_flex8	= "1",
						faceposer_flex9	= "1"} )
						
				QuickFace:AddMaterialEx( "Angry Eyebrows", "vgui/face/angry_eyebrows", nil, 
					  { faceposer_flex10 = 		"0",
							faceposer_flex11 = 		"0",
							faceposer_flex12 = 		"1",
							faceposer_flex13 = 		"1",
							faceposer_flex14 = 		"0.5",
							faceposer_flex15 = 		"0.5"} )
							
				QuickFace:AddMaterialEx( "Normal Eyebrows", "vgui/face/normal_eyebrows", nil, 
					{			
						faceposer_flex10 = 		"0",
						faceposer_flex11 = 		"0",
						faceposer_flex12 = 		"0",
						faceposer_flex13 = 		"0",
						faceposer_flex14 = 		"0",
						faceposer_flex15 = 		"0"
					})
				
				QuickFace:AddMaterialEx( "Sorry Eyebrows", "vgui/face/sorry_eyebrows", nil, 
					{
						
						faceposer_flex10 = 		"1",
						faceposer_flex11 = 		"1",
						faceposer_flex12 = 		"0",
						faceposer_flex13 = 		"0",
						faceposer_flex14 = 		"0",
						faceposer_flex15 = 		"0"
					})
				
				QuickFace:AddMaterialEx( "Grin", "vgui/face/grin", nil, 
					{
						faceposer_flex20 =		"1",
						faceposer_flex21 =		"1",
						faceposer_flex22 =		"1",
						faceposer_flex23 =		"1",
						faceposer_flex24 =		"0",
						faceposer_flex25 =		"0",
						faceposer_flex26 =		"0",
						faceposer_flex27 =		"1",
						faceposer_flex28 =		"1",
						faceposer_flex29 =		"0",
						faceposer_flex30 =		"0",
						faceposer_flex31 =		"0",
						faceposer_flex32 =		"0",
						faceposer_flex33 =		"1",
						faceposer_flex34 =		"1",
						faceposer_flex35 =		"0",
						faceposer_flex36 =		"0",
						faceposer_flex37 =		"0",
						faceposer_flex38 =		"0",
						faceposer_flex39 =		"1",
						faceposer_flex40 =		"0",
						faceposer_flex41 =		"0",
						faceposer_flex42 =		"1",
						faceposer_flex43 =		"1"
					})
				
				QuickFace:AddMaterialEx( "Sad", "vgui/face/sad", nil, 
					{
						faceposer_flex20 =		"0",
						faceposer_flex21 =		"0",
						faceposer_flex22 =		"0",
						faceposer_flex23 =		"0",
						faceposer_flex24 =		"1",
						faceposer_flex25 =		"1",
						faceposer_flex26 =		"0.0",
						faceposer_flex27 =		"0",
						faceposer_flex28 =		"0",
						faceposer_flex29 =		"0",
						faceposer_flex30 =		"0",
						faceposer_flex31 =		"0",
						faceposer_flex32 =		"0",
						faceposer_flex33 =		"0",
						faceposer_flex34 =		"0",
						faceposer_flex35 =		"0",
						faceposer_flex36 =		"0",
						faceposer_flex37 =		"0",
						faceposer_flex38 =		"0.5",
						faceposer_flex39 =		"0",
						faceposer_flex40 =		"0",
						faceposer_flex41 =		"0",
						faceposer_flex42 =		"0",
						faceposer_flex43 =		"0"
					})
				
				QuickFace:AddMaterialEx( "Smile", "vgui/face/smile", nil, 
					{
						faceposer_flex20 =		"1",
						faceposer_flex21 =		"1",
						faceposer_flex22 =		"1",
						faceposer_flex23 =		"1",
						faceposer_flex24 =		"0",
						faceposer_flex25 =		"0",
						faceposer_flex26 =		"0",
						faceposer_flex27 =		"0.6",
						faceposer_flex28 =		"0.4",
						faceposer_flex29 =		"0",
						faceposer_flex30 =		"0",
						faceposer_flex31 =		"0",
						faceposer_flex32 =		"0",
						faceposer_flex33 =		"1",
						faceposer_flex34 =		"1",
						faceposer_flex35 =		"0",
						faceposer_flex36 =		"0",
						faceposer_flex37 =		"0",
						faceposer_flex38 =		"0",
						faceposer_flex39 =		"0",
						faceposer_flex40 =		"1",
						faceposer_flex41 =		"1",
						faceposer_flex42 =		"0",
						faceposer_flex43 =		"0",
						faceposer_flex44 =		"0",
					})
				
			CPanel:AddItem( QuickFace )
			
		
		
		local FlexNum = FaceEntity:GetFlexNum()
		
		local params = {}
			params.Label = "#tool.faceposer.scale"
			params.Help = true
			params.Type = "Float"
			params.Min = "-1"
			params.Max = "5"
			params.Command = "faceposer_scale"
		CPanel:AddControl( "Slider", params )
			
		local params = {}
			params.Text = "#tool.faceposer.randomize"
			params.Command = "faceposer_randomize"
		CPanel:AddControl( "Button", params )
		
		for i=0, FlexNum-1 do
		
			local Name = FaceEntity:GetFlexName( i )
			
			if ( !IsUselessFaceFlex(Name )  ) then
			
				local params = {}
				params.Label = Name
				params.Type = "Float"
				params.Min, params.Max = FaceEntity:GetFlexBounds( i )
				params.Command = "faceposer_flex"..i
				
				local ctrl = CPanel:AddControl( "Slider", params )

				--
				-- this makes the controls all bunched up like how we want
				--
				ctrl:SetHeight( 10 )
				
			end
			
		end
	
	end
	
	
	
	local FacePoser	= surface.GetTextureID( "gui/faceposer_indicator" )
	
	--[[---------------------------------------------------------
	   Draw a box indicating the face we have selected
	-----------------------------------------------------------]]
	function TOOL:DrawHUD()

		local selected = self:FacePoserEntity()
		
		if ( !IsValid( selected ) ) then return end
		if ( selected:IsWorld() ) then return end
		
		local vEyePos = selected:EyePos()
		
		local eyeattachment = selected:LookupAttachment( "eyes" )
		if (eyeattachment == 0) then return end
		
		local attachment = selected:GetAttachment( eyeattachment )
		local scrpos = attachment.Pos:ToScreen()
		if (!scrpos.visible) then return end
		
		-- Work out the side distance to give a rough headsize box..
		local player_eyes = LocalPlayer():EyeAngles()
		local side = (attachment.Pos + player_eyes:Right() * 20):ToScreen()
		local size = math.abs( side.x - scrpos.x )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( FacePoser )
		surface.DrawTexturedRect( scrpos.x-size, scrpos.y-size, size*2, size*2 )

	end
	
end
