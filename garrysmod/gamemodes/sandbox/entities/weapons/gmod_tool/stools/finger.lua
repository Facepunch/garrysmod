
TOOL.Category = "Poser"
TOOL.Name = "#tool.finger.name"

TOOL.RequiresTraceHit = true

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

local VarsOnHand = 15

-- Returns true if it has TF2 hands
local function HasTF2Hands( pEntity )
	return pEntity:LookupBone( "bip_hand_L" ) != nil
end

-- Returns true if it has Portal 2 hands
local function HasP2Hands( pEntity )
	return pEntity:LookupBone( "wrist_A_L" ) != nil || pEntity:LookupBone( "index_1_L" ) != nil
end

-- Returns true if it has Zeno Clash hands
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

local TranslateTable_INS = {}
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger0" ] = "L Finger0"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger01" ] = "L Finger01"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger02" ] = "L Finger02"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger1" ] = "L Finger1"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger11" ] = "L Finger11"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger12" ] = "L Finger12"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger2" ] = "L Finger2"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger21" ] = "L Finger21"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger22" ] = "L Finger22"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger3" ] = "L Finger3"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger31" ] = "L Finger31"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger32" ] = "L Finger32"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger4" ] = "L Finger4"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger41" ] = "L Finger41"
TranslateTable_INS[ "ValveBiped.Bip01_L_Finger42" ] = "L Finger42"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger0" ] = "R Finger0"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger01" ] = "R Finger01"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger02" ] = "R Finger02"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger1" ] = "R Finger1"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger11" ] = "R Finger11"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger12" ] = "R Finger12"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger2" ] = "R Finger2"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger21" ] = "R Finger21"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger22" ] = "R Finger22"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger3" ] = "R Finger3"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger31" ] = "R Finger31"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger32" ] = "R Finger32"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger4" ] = "R Finger4"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger41" ] = "R Finger41"
TranslateTable_INS[ "ValveBiped.Bip01_R_Finger42" ] = "R Finger42"

local TranslateTable_Chell = {}
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger0" ] = "thumb_base_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger01" ] = "thumb_mid_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger02" ] = "thumb_end_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger1" ] = "index_base_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger11" ] = "index_mid_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger12" ] = "index_end_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger2" ] = "mid_base_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger21" ] = "mid_mid_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger22" ] = "mid_end_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger3" ] = "ring_base_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger31" ] = "ring_mid_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger32" ] = "ring_end_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger4" ] = "pinky_base_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger41" ] = "pinky_mid_L"
TranslateTable_Chell[ "ValveBiped.Bip01_L_Finger42" ] = "pinky_end_L"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger0" ] = "thumb_base_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger01" ] = "thumb_mid_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger02" ] = "thumb_end_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger1" ] = "index_base_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger11" ] = "index_mid_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger12" ] = "index_end_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger2" ] = "mid_base_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger21" ] = "mid_mid_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger22" ] = "mid_end_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger3" ] = "ring_base_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger31" ] = "ring_mid_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger32" ] = "ring_end_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger4" ] = "pinky_base_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger41" ] = "pinky_mid_R"
TranslateTable_Chell[ "ValveBiped.Bip01_R_Finger42" ] = "pinky_end_R"

local TranslateTable_EggBot = {}
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger0" ] = "thumb2_0_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger01" ] = "thumb2_1_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger02" ] = "thumb2_2_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger1" ] = "index2_0_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger11" ] = "index2_1_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger12" ] = "index2_2_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger2" ] = "mid2_0_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger21" ] = "mid2_1_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_L_Finger22" ] = "mid2_2_A_L"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger0" ] = "thumb3_0_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger01" ] = "thumb3_1_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger02" ] = "thumb3_2_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger1" ] = "index3_0_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger11" ] = "index3_1_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger12" ] = "index3_2_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger2" ] = "mid3_0_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger21" ] = "mid3_1_A_R"
TranslateTable_EggBot[ "ValveBiped.Bip01_R_Finger22" ] = "mid3_2_A_R"

local TranslateTable_Poral2 = {}
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger0" ] = "thumb_0_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger01" ] = "thumb_1_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger02" ] = "thumb_2_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger1" ] = "index_0_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger11" ] = "index_1_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger12" ] = "index_2_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger2" ] = "mid_0_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger21" ] = "mid_1_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger22" ] = "mid_2_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger3" ] = "ring_0_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger31" ] = "ring_1_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_L_Finger32" ] = "ring_2_L"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger0" ] = "thumb_0_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger01" ] = "thumb_1_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger02" ] = "thumb_2_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger1" ] = "index_0_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger11" ] = "index_1_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger12" ] = "index_2_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger2" ] = "mid_0_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger21" ] = "mid_1_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger22" ] = "mid_2_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger3" ] = "ring_0_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger31" ] = "ring_1_R"
TranslateTable_Poral2[ "ValveBiped.Bip01_R_Finger32" ] = "ring_2_R"

local TranslateTable_DOG = {}
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger0" ] = "Dog_Model.Thumb1_L"
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger01" ] = "Dog_Model.Thumb2_L"
--TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger02" ] = "Dog_Model.Thumb3_L"
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger1" ] = "Dog_Model.Index1_L"
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger11" ] = "Dog_Model.Index2_L"
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger12" ] = "Dog_Model.Index3_L"
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger4" ] = "Dog_Model.Pinky1_L"
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger41" ] = "Dog_Model.Pinky2_L"
TranslateTable_DOG[ "ValveBiped.Bip01_L_Finger42" ] = "Dog_Model.Pinky3_L"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger0" ] = "Dog_Model.Thumb1_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger01" ] = "Dog_Model.Thumb2_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger02" ] = "Dog_Model.Thumb3_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger1" ] = "Dog_Model.Index1_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger11" ] = "Dog_Model.Index2_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger12" ] = "Dog_Model.Index3_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger4" ] = "Dog_Model.Pinky1_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger41" ] = "Dog_Model.Pinky2_R"
TranslateTable_DOG[ "ValveBiped.Bip01_R_Finger42" ] = "Dog_Model.Pinky3_R"

local TranslateTable_VORT = {}
TranslateTable_VORT[ "ValveBiped.Bip01_L_Finger1" ] = "ValveBiped.index1_L"
TranslateTable_VORT[ "ValveBiped.Bip01_L_Finger11" ] = "ValveBiped.index2_L"
TranslateTable_VORT[ "ValveBiped.Bip01_L_Finger12" ] = "ValveBiped.index3_L"
TranslateTable_VORT[ "ValveBiped.Bip01_L_Finger4" ] = "ValveBiped.pinky1_L"
TranslateTable_VORT[ "ValveBiped.Bip01_L_Finger41" ] = "ValveBiped.pinky2_L"
TranslateTable_VORT[ "ValveBiped.Bip01_L_Finger42" ] = "ValveBiped.pinky3_L"
TranslateTable_VORT[ "ValveBiped.Bip01_R_Finger1" ] = "ValveBiped.index1_R"
TranslateTable_VORT[ "ValveBiped.Bip01_R_Finger11" ] = "ValveBiped.index2_R"
TranslateTable_VORT[ "ValveBiped.Bip01_R_Finger12" ] = "ValveBiped.index3_R"
TranslateTable_VORT[ "ValveBiped.Bip01_R_Finger4" ] = "ValveBiped.pinky1_R"
TranslateTable_VORT[ "ValveBiped.Bip01_R_Finger41" ] = "ValveBiped.pinky2_R"
TranslateTable_VORT[ "ValveBiped.Bip01_R_Finger42" ] = "ValveBiped.pinky3_R"

function TOOL:HandEntity()
	return self:GetWeapon():GetNWEntity( "HandEntity" )
end

function TOOL:HandNum()
	return self:GetWeapon():GetNWInt( "HandNum" )
end

function TOOL:SetHand( ent, iHand )
	self:GetWeapon():SetNWEntity( "HandEntity", ent )
	self:GetWeapon():SetNWInt( "HandNum", iHand )
end

-- Translate the fingernum, part and hand into an real bone number
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

	---- START DOG BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_DOG[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END DOG BONE LOOKUP ----------------------------------

	---- START VORT BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_VORT[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END VORT BONE LOOKUP ----------------------------------

	---- START Chell BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_Chell[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END Chell BONE LOOKUP ----------------------------------

	---- START EggBot ( Portal 2 ) BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_EggBot[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END EggBot BONE LOOKUP ----------------------------------

	---- START Portal 2 ( Ball Bot ) BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_Poral2[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END Portal 2 BONE LOOKUP ----------------------------------

	---- START Ins BONE LOOKUP ----------------------------------
	local TranslatedName = TranslateTable_INS[ Name ]
	if ( TranslatedName ) then
		local bone = self:LookupBone( TranslatedName )
		if ( bone ) then return bone end
	end
	---- END Insurgency BONE LOOKUP ----------------------------------

end

-- Cache the finger bone numbers for faster access
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

-- Apply the current tool values to entity's hand
function TOOL:ApplyValues( pEntity, iHand )

	if ( CLIENT ) then return end

	SetupFingers( pEntity )

	local bTF2 = HasTF2Hands( pEntity )
	local bP2 = HasP2Hands( pEntity )

	for i = 0, VarsOnHand - 1 do

		local Var = self:GetClientInfo( i )
		local VecComp = string.Explode( " ", Var )

		local Ang = nil

		if ( bP2 ) then
			if ( i < 3 ) then
				Ang = Angle( tonumber( VecComp[1] ), tonumber( VecComp[2] ), 0 )
			else
				Ang = Angle( -tonumber( VecComp[2] ), tonumber( VecComp[1] ), 0 )
			end

		elseif ( bTF2 ) then

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

-- Hope we don't have any one armed models
function TOOL:GetHandPositions( pEntity )

	local LeftHand = pEntity:LookupBone( "ValveBiped.Bip01_L_Hand" )
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "bip_hand_L" ) end
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "Bip01_L_Hand" ) end
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "Dog_Model.Hand_L" ) end -- DOG
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "ValveBiped.Hand1_L" ) end -- Vortigaunt
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "wrist_L" ) end -- Chell
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "L Hand" ) end -- Insurgency
	if ( !LeftHand ) then LeftHand = pEntity:LookupBone( "wrist_A_L" ) end -- Portal 2 Egg bot

	local RightHand = pEntity:LookupBone( "ValveBiped.Bip01_R_Hand" )
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "bip_hand_R" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "Bip01_R_Hand" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "Bip01_R_Hand" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "Dog_Model.Hand_R" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "ValveBiped.Hand1_R" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "wrist_R" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "R Hand" ) end
	if ( !RightHand ) then RightHand = pEntity:LookupBone( "wrist_A_R" ) end

	if ( !LeftHand || !RightHand ) then return false end

	local LeftHand = pEntity:GetBoneMatrix( LeftHand )
	local RightHand = pEntity:GetBoneMatrix( RightHand )
	if ( !LeftHand || !RightHand ) then return false end

	return LeftHand, RightHand

end

-- Applies current convar hand to picked hand
function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	--if ( trace.Entity:GetClass() != "prop_ragdoll" && !trace.Entity:IsNPC() ) then return false end

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

-- Selects picked hand and sucks off convars
function TOOL:RightClick( trace )

	local ent = trace.Entity
	if ( IsValid( ent ) && ent:GetClass() == "prop_effect" ) then ent = ent.AttachedEntity end

	if ( !IsValid( ent ) || ent:IsPlayer() ) then self:SetHand( NULL, 0 ) return true end
	--if ( ent:GetClass() != "prop_ragdoll" && ent:GetClass() != "prop_dynamic" && !ent:IsNPC() ) then return false end

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
	for i = 0, VarsOnHand-1 do

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

--[[
	Updates the selected entity with the values from the convars
	Also, on the client it rebuilds the control panel if we have
	selected a new entity or hand
]]
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

for i = 0, VarsOnHand do
	TOOL.ClientConVar[ "" .. i ] = "0 0"
end

-- Rebuilds the context menu based on the current selected entity/hand
function TOOL:RebuildControlPanel( hand )

	-- We've selected a new entity - rebuild the controls list
	local CPanel = controlpanel.Get( "finger" )
	if ( !CPanel ) then return end

	CPanel:ClearControls()
	self.BuildCPanel( CPanel, self:HandEntity(), self:HandNum() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel, ent, hand )

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

local FacePoser = surface.GetTextureID( "gui/faceposer_indicator" )

-- Draw a circle around the selected hand
function TOOL:DrawHUD()

	if ( GetConVarNumber( "gmod_drawtooleffects" ) == 0 ) then return end

	local selected = self:HandEntity()
	local hand = self:HandNum()

	if ( !IsValid( selected ) ) then return end
	if ( selected:IsWorld() ) then return end

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
