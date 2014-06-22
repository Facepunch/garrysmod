
TOOL.Category = "Poser"
TOOL.Name = "#tool.finger.name"

TOOL.RequiresTraceHit = true

local VarsOnHand = 15
local FingerVars = VarsOnHand * 2

--[[------------------------------------------------------------
	Name: HasTF2Hands
	Desc: Returns true if it has TF2 hands
--------------------------------------------------------------]]
local function HasTF2Hands( pEntity )
	return pEntity:LookupBone( "bip_hand_L" ) != nil
end

--[[------------------------------------------------------------
	Name: HasZenoHands
	Desc: Returns true if it has Zeno Clash hands
--------------------------------------------------------------]]
local function HasZenoHands( pEntity )
	return pEntity:LookupBone( "Bip01_L_Hand" ) != nil
end

local TranslateTable_TF2 = {}
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger0" ] = "bip_thumb_0_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger01" ] = "bip_thumb_1_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger02" ] = "bip_thumb_2_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger1" ] = "bip_index_0_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger11" ] = "bip_index_1_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger12" ] = "bip_index_2_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger2" ] = "bip_middle_0_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger21" ] = "bip_middle_1_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger22" ] = "bip_middle_2_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger3" ] = "bip_ring_0_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger31" ] = "bip_ring_1_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger32" ] = "bip_ring_2_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger4" ] = "bip_pinky_0_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger41" ] = "bip_pinky_1_L"
TranslateTable_TF2[ "ValveBiped.Bip01_L_Finger42" ] = "bip_pinky_2_L"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger0" ] = "bip_thumb_0_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger01" ] = "bip_thumb_1_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger02" ] = "bip_thumb_2_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger1" ] = "bip_index_0_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger11" ] = "bip_index_1_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger12" ] = "bip_index_2_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger2" ] = "bip_middle_0_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger21" ] = "bip_middle_1_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger22" ] = "bip_middle_2_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger3" ] = "bip_ring_0_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger31" ] = "bip_ring_1_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger32" ] = "bip_ring_2_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger4" ] = "bip_pinky_0_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger41" ] = "bip_pinky_1_R"
TranslateTable_TF2[ "ValveBiped.Bip01_R_Finger42" ] = "bip_pinky_2_R"

local TranslateTable_Zeno = {}
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger0" ] = "Bip01_L_Finger0"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger01" ] = "Bip01_L_Finger01"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger02" ] = "Bip01_L_Finger02"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger1" ] = "Bip01_L_Finger1"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger11" ] = "Bip01_L_Finger11"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger12" ] = "Bip01_L_Finger12"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger2" ] = "Bip01_L_Finger2"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger21" ] = "Bip01_L_Finger21"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger22" ] = "Bip01_L_Finger22"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger3" ] = "Bip01_L_Finger3"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger31" ] = "Bip01_L_Finger31"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger32" ] = "Bip01_L_Finger32"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger4" ] = "Bip01_L_Finger4"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger41" ] = "Bip01_L_Finger41"
TranslateTable_Zeno[ "ValveBiped.Bip01_L_Finger42" ] = "Bip01_L_Finger42"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger0" ] = "Bip01_R_Finger0"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger01" ] = "Bip01_R_Finger01"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger02" ] = "Bip01_R_Finger02"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger1" ] = "Bip01_R_Finger1"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger11" ] = "Bip01_R_Finger11"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger12" ] = "Bip01_R_Finger12"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger2" ] = "Bip01_R_Finger2"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger21" ] = "Bip01_R_Finger21"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger22" ] = "Bip01_R_Finger22"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger3" ] = "Bip01_R_Finger3"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger31" ] = "Bip01_R_Finger31"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger32" ] = "Bip01_R_Finger32"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger4" ] = "Bip01_R_Finger4"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger41" ] = "Bip01_R_Finger41"
TranslateTable_Zeno[ "ValveBiped.Bip01_R_Finger42" ] = "Bip01_R_Finger42"

--[[---------------------------------------------------------
	Name: HandEntity
-----------------------------------------------------------]]
function TOOL:HandEntity()
	return self:GetWeapon():GetNetworkedEntity( "HandEntity" )
end

--[[---------------------------------------------------------
	Name: HandNum
-----------------------------------------------------------]]
function TOOL:HandNum()
	return self:GetWeapon():GetNetworkedInt( "HandNum" )
end

--[[---------------------------------------------------------
	Name: SetHand
-----------------------------------------------------------]]
function TOOL:SetHand( ent, iHand )
	self:GetWeapon():SetNetworkedEntity( "HandEntity", ent )
	self:GetWeapon():SetNetworkedInt( "HandNum", iHand )
end

--[[------------------------------------------------------------
	Name: GetFingerBone
	Desc: Translate the fingernum, part and hand into an real bone number
--------------------------------------------------------------]]
local function GetFingerBone( self, fingernum, part, hand )

	---- START HL2 BONE LOOKUP ----------------------------------
	local Name = "ValveBiped.Bip01_L_Finger" .. fingernum
	if ( hand == 1 ) then Name = "ValveBiped.Bip01_R_Finger" .. fingernum end
	if ( part != 0 ) then Name = Name .. part end

	local bone = self:LookupBone( Name )
	if ( bone ) then return bone end
	---- END HL2 BONE LOOKUP ----------------------------------

	---- START TF BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_TF2[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END TF BONE LOOKUP ----------------------------------

	---- START Zeno BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_Zeno[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END Zeno BONE LOOKUP ----------------------------------

end

--[[------------------------------------------------------------
	Name: SetupFingers
	Desc: Cache the finger bone numbers for faster access
--------------------------------------------------------------]]
local function SetupFingers( self )

	if ( self.FingerIndex ) then return end
	
	self.FingerIndex = {}

	local i = 1
	
	for hand = 0, 1 do
		for finger = 0, 4 do
			for part = 0, 2 do
				
				self.FingerIndex[ i ] = GetFingerBone( self, finger, part, hand )
				
				i = i + 1
			
			end
		end
	end

end

--[[---------------------------------------------------------
	Name: Apply the current tool values to entity's hand
-----------------------------------------------------------]]
function TOOL:ApplyValues( pEntity, iHand )

	if ( CLIENT ) then return end

	SetupFingers( pEntity )

	local bTF2 = HasTF2Hands( pEntity )

	for i=0, VarsOnHand - 1 do
	
		local Var = self:GetClientInfo( i )
		local VecComp = string.Explode( " ", Var )
		
		local sin = math.sin( CurTime() * 10 ) * 10

		local Ang = nil

		if ( bTF2 ) then
					
			if ( i < 3 ) then
				Ang = Angle( 0, tonumber( VecComp[2] ), tonumber( VecComp[1] ) )
			else
				Ang = Angle( 0, tonumber( VecComp[1] ), -tonumber( VecComp[2] ) )
			end

		else
			if ( i < 3 ) then
				Ang = Angle( tonumber( VecComp[2] ), tonumber( VecComp[1] ), 0 )
			else
				Ang = Angle( tonumber( VecComp[1] ), tonumber( VecComp[2] ), 0 )
			end
		end

		local bone = pEntity.FingerIndex[ i + iHand * VarsOnHand + 1 ]
		if ( bone ) then
			pEntity:ManipulateBoneAngles( bone, Ang )
		end
		
	end

end

--[[------------------------------------------------------------
	Name: GetHandPositions
	Desc: Hope we don't have any one armed models
--------------------------------------------------------------]]
function TOOL:GetHandPositions( pEntity )

	local LeftHand = pEntity:LookupBone( "ValveBiped.Bip01_L_Hand" )
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "bip_hand_L" ) end
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "Bip01_L_Hand" ) end
	
	local RightHand = pEntity:LookupBone( "ValveBiped.Bip01_R_Hand" )
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "bip_hand_R" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "Bip01_R_Hand" ) end
	
	if ( !LeftHand || !RightHand ) then return false end
	
	local LeftHand = pEntity:GetBoneMatrix( LeftHand )
	local RightHand = pEntity:GetBoneMatrix( RightHand )
	if ( !LeftHand || !RightHand ) then return false end

	return LeftHand, RightHand
	
end

--[[------------------------------------------------------------
	Name: LeftClick
	Desc: Applies current convar hand to picked hand
--------------------------------------------------------------]]
function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( trace.Entity:GetClass() != "prop_ragdoll" && !trace.Entity:IsNPC() ) then return false end
	
	local LeftHand, RightHand = self:GetHandPositions( trace.Entity )
	
	if ( !LeftHand ) then return false end
	if ( CLIENT ) then return true end
	
	local LeftHand = ( LeftHand:GetTranslation() - trace.HitPos ):Length()
	local RightHand = ( RightHand:GetTranslation() - trace.HitPos ):Length()
	
	if ( LeftHand < RightHand ) then
	
		self:ApplyValues( trace.Entity, 0 )
	
	else
	
		self:ApplyValues( trace.Entity, 1 )
	
	end

	return true

end

--[[------------------------------------------------------------
	Name: RightClick
	Desc: Selects picked hand and sucks off convars
--------------------------------------------------------------]]
function TOOL:RightClick( trace )

	local ent = trace.Entity

	if ( !IsValid( ent ) || ent:IsPlayer() ) then self:SetHand( NULL, 0 ) return true end
	if ( ent:GetClass() != "prop_ragdoll" && !ent:IsNPC() ) then return false end

	if ( CLIENT ) then return false end
	
	local LeftHand, RightHand = self:GetHandPositions( ent )
	if ( !LeftHand ) then return false end
	
	local LeftHand = ( LeftHand:GetTranslation() - trace.HitPos ):Length()
	local RightHand = ( RightHand:GetTranslation() - trace.HitPos ):Length()
	
	local Hand = 0
	if ( LeftHand < RightHand ) then
	
		self:SetHand( ent, 0 )
	
	else
	
		self:SetHand( ent, 1 )
		Hand = 1
	
	end
	
	--
	-- Make sure entity has fingers set up!
	--
	SetupFingers( ent )

	local bTF2 = HasTF2Hands( ent )

	--
	-- Rwead the variables from the angles of the fingers, into our convars
	--
	for i=0, VarsOnHand-1 do
	
		local bone = ent.FingerIndex[ i + Hand * VarsOnHand + 1 ]
		if ( bone ) then

			local Ang = ent:GetManipulateBoneAngles( bone )

			if ( bTF2 ) then

				if ( i < 3 ) then
					self:GetOwner():ConCommand( Format( "finger_%s %.1f %.1f", i, Ang.Roll, Ang.Yaw ) )
				else
					self:GetOwner():ConCommand( Format( "finger_%s %.1f %.1f", i, Ang.Yaw, -Ang.Roll ) )
				end
			else
				if ( i < 3 ) then
					self:GetOwner():ConCommand( Format( "finger_%s %.1f %.1f", i, Ang.Yaw, Ang.Pitch ) )
				else
					self:GetOwner():ConCommand( Format( "finger_%s %.1f %.1f", i, Ang.Pitch, Ang.Yaw ) )
				end
			end

		end
		
	end
	
	-- We don't want to send the finger poses to the client straight away
	-- because they will get the old poses that are currently in their convars
	-- We need to wait until they convars get updated with the sucked pose
	self.NextUpdate = CurTime() + 0.5
	
	return true
	
end

local OldHand = nil
local OldEntity = nil

--[[------------------------------------------------------------
	Name: Think
	Desc: Updates the selected entity with the values from the convars
			Also, on the client it rebuilds the control panel if we have
			selected a new entity or hand
--------------------------------------------------------------]]
function TOOL:Think()
	
	local selected = self:HandEntity()
	local hand = self:HandNum()
	
	if ( self.NextUpdate && self.NextUpdate > CurTime() ) then return end
	
	if ( CLIENT ) then
	
		if ( OldHand != hand || OldEntity != selected ) then
		
			OldHand = hand
			OldEntity = selected
			
			self:RebuildControlPanel( hand )
			
		end
	
	end

	if ( !IsValid( selected ) ) then return end
	if ( selected:IsWorld() ) then return end
	
	self:ApplyValues( selected, hand )

end

if ( SERVER ) then return end
-- Notice the return above.
-- The rest of this file CLIENT ONLY.

for i=0, VarsOnHand do
	TOOL.ClientConVar[ "" .. i ] = "0 0"
end

--[[------------------------------------------------------------
	Name: RebuildControlPanel
	Desc: Rebuilds the context menu based on the current selected entity/hand
--------------------------------------------------------------]]
function TOOL:RebuildControlPanel( hand )

	-- We've selected a new entity - rebuild the controls list
	local CPanel = controlpanel.Get( "finger" )
	if ( !CPanel ) then return end
	
	CPanel:ClearControls()
	self.BuildCPanel( CPanel, self:HandEntity() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel, ent )

	CPanel:AddControl( "Header", { Description = "#tool.finger.desc" } )

	if ( !IsValid( ent ) ) then return end

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "finger", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	SetupFingers( ent )

	if ( !ent.FingerIndex ) then return end
	
	-- Detect mitten hands
	local NumVars = table.Count( ent.FingerIndex )
	
	CPanel:AddControl( "fingerposer", { hand = hand, numvars = NumVars } )

	CPanel:AddControl( "Checkbox", { Label = "#tool.finger.restrict_axis", Command = "finger_restrict" } )

end

local FacePoser	= surface.GetTextureID( "gui/faceposer_indicator" )

--[[------------------------------------------------------------
	Name: DrawHUD
	Desc: Draw a circle around the selected hand
--------------------------------------------------------------]]
function TOOL:DrawHUD()

	local selected = self:HandEntity()
	local hand = self:HandNum()
	
	if ( !IsValid( selected ) ) then return end
	if ( selected:IsWorld() ) then return end
	
	local Bone = nil
	
	local lefthand, righthand = self:GetHandPositions( selected )
	
	local BoneMatrix = lefthand
	if ( hand == 1 ) then BoneMatrix = righthand end
	if ( !BoneMatrix ) then return end
	
	local vPos = BoneMatrix:GetTranslation()
	
	local scrpos = vPos:ToScreen()
	if ( !scrpos.visible ) then return end
	
	-- Work out the side distance to give a rough headsize box..
	local player_eyes = LocalPlayer():EyeAngles()
	local side = ( vPos + player_eyes:Right() * 20 ):ToScreen()
	local size = math.abs( side.x - scrpos.x )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( FacePoser )
	surface.DrawTexturedRect( scrpos.x - size, scrpos.y - size, size * 2, size * 2 )

end
