
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
	for k, v in pairs( list.Get( "FingerPoserSkeletons" ) ) do
		if ( !v.hand_type || v.hand_type != "tf2" ) then continue end

		local bone = pEntity:LookupBone( v.left_hand )
		if ( bone ) then return true end
	end

	return false
end

-- Returns true if it has Portal 2 hands
local function HasP2Hands( pEntity )
	for k, v in pairs( list.Get( "FingerPoserSkeletons" ) ) do
		if ( !v.hand_type || v.hand_type != "portal2" ) then continue end

		local bone = pEntity:LookupBone( v.left_hand )
		if ( bone ) then
			-- A little bit of a hack for BallBot/Chell conflict
			local allGood = true
			for oldB, newB in pairs( v.bones ) do
				if ( !pEntity:LookupBone( newB ) ) then allGood = false end
			end
			
			if ( !allGood ) then continue end
			return true
		end
	end

	return false
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

local TranslateTable_ZenoToo = {}
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger0" ] = "Bip01 L Finger0"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger01" ] = "Bip01 L Finger01"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger02" ] = "Bip01 L Finger02"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger1" ] = "Bip01 L Finger1"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger11" ] = "Bip01 L Finger11"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger12" ] = "Bip01 L Finger12"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger2" ] = "Bip01 L Finger2"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger21" ] = "Bip01 L Finger21"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger22" ] = "Bip01 L Finger22"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger3" ] = "Bip01 L Finger3"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger31" ] = "Bip01 L Finger31"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger32" ] = "Bip01 L Finger32"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger4" ] = "Bip01 L Finger4"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger41" ] = "Bip01 L Finger41"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_L_Finger42" ] = "Bip01 L Finger42"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger0" ] = "Bip01 R Finger0"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger01" ] = "Bip01 R Finger01"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger02" ] = "Bip01 R Finger02"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger1" ] = "Bip01 R Finger1"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger11" ] = "Bip01 R Finger11"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger12" ] = "Bip01 R Finger12"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger2" ] = "Bip01 R Finger2"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger21" ] = "Bip01 R Finger21"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger22" ] = "Bip01 R Finger22"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger3" ] = "Bip01 R Finger3"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger31" ] = "Bip01 R Finger31"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger32" ] = "Bip01 R Finger32"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger4" ] = "Bip01 R Finger4"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger41" ] = "Bip01 R Finger41"
TranslateTable_ZenoToo[ "ValveBiped.Bip01_R_Finger42" ] = "Bip01 R Finger42"

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

local TranslateTable_P1_Chell = {}
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger0" ] = "thumb_base_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger01" ] = "thumb_mid_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger02" ] = "thumb_end_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger1" ] = "index_base_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger11" ] = "index_mid_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger12" ] = "index_end_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger2" ] = "mid_base_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger21" ] = "mid_mid_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger22" ] = "mid_end_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger3" ] = "ring_base_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger31" ] = "ring_mid_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger32" ] = "ring_end_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger4" ] = "pinky_base_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger41" ] = "pinky_mid_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_L_Finger42" ] = "pinky_end_L"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger0" ] = "thumb_base_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger01" ] = "thumb_mid_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger02" ] = "thumb_end_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger1" ] = "index_base_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger11" ] = "index_mid_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger12" ] = "index_end_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger2" ] = "mid_base_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger21" ] = "mid_mid_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger22" ] = "mid_end_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger3" ] = "ring_base_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger31" ] = "ring_mid_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger32" ] = "ring_end_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger4" ] = "pinky_base_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger41" ] = "pinky_mid_R"
TranslateTable_P1_Chell[ "ValveBiped.Bip01_R_Finger42" ] = "pinky_end_R"

local TranslateTable_P2_EggBot = {}
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger0" ] = "thumb2_0_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger01" ] = "thumb2_1_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger02" ] = "thumb2_2_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger1" ] = "index2_0_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger11" ] = "index2_1_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger12" ] = "index2_2_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger2" ] = "mid2_0_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger21" ] = "mid2_1_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_L_Finger22" ] = "mid2_2_A_L"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger0" ] = "thumb3_0_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger01" ] = "thumb3_1_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger02" ] = "thumb3_2_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger1" ] = "index3_0_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger11" ] = "index3_1_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger12" ] = "index3_2_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger2" ] = "mid3_0_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger21" ] = "mid3_1_A_R"
TranslateTable_P2_EggBot[ "ValveBiped.Bip01_R_Finger22" ] = "mid3_2_A_R"

local TranslateTable_P2_BallBot = {}
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger0" ] = "thumb_0_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger01" ] = "thumb_1_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger02" ] = "thumb_2_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger1" ] = "index_0_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger11" ] = "index_1_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger12" ] = "index_2_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger2" ] = "mid_0_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger21" ] = "mid_1_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger22" ] = "mid_2_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger3" ] = "ring_0_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger31" ] = "ring_1_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_L_Finger32" ] = "ring_2_L"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger0" ] = "thumb_0_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger01" ] = "thumb_1_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger02" ] = "thumb_2_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger1" ] = "index_0_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger11" ] = "index_1_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger12" ] = "index_2_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger2" ] = "mid_0_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger21" ] = "mid_1_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger22" ] = "mid_2_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger3" ] = "ring_0_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger31" ] = "ring_1_R"
TranslateTable_P2_BallBot[ "ValveBiped.Bip01_R_Finger32" ] = "ring_2_R"
TranslateTable_P2_BallBot[ "unique_marker" ] = "piston_elbow1" -- Hack to not trigger this on P2 chell

local TranslateTable_P2_Chell = table.Copy( TranslateTable_P2_BallBot )
TranslateTable_P2_Chell[ "ValveBiped.Bip01_R_Finger4" ] = "pinky_0_R"
TranslateTable_P2_Chell[ "ValveBiped.Bip01_R_Finger41" ] = "pinky_1_R"
TranslateTable_P2_Chell[ "ValveBiped.Bip01_R_Finger42" ] = "pinky_2_R"
TranslateTable_P2_Chell[ "ValveBiped.Bip01_L_Finger4" ] = "pinky_0_L"
TranslateTable_P2_Chell[ "ValveBiped.Bip01_L_Finger41" ] = "pinky_1_L"
TranslateTable_P2_Chell[ "ValveBiped.Bip01_L_Finger42" ] = "pinky_2_L"
TranslateTable_P2_Chell[ "unique_marker" ] = nil

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

list.Set( "FingerPoserSkeletons", "tf2", { left_hand = "bip_hand_L", right_hand = "bip_hand_R", bones = TranslateTable_TF2, hand_type = "tf2" } )
list.Set( "FingerPoserSkeletons", "zeno_clash", { left_hand = "Bip01_L_Hand", right_hand = "Bip01_R_Hand", bones = TranslateTable_Zeno } )
list.Set( "FingerPoserSkeletons", "zeno_clash_too", { left_hand = "Left_hand", right_hand = "Right_hand", bones = TranslateTable_ZenoToo } )
list.Set( "FingerPoserSkeletons", "zeno_clash_too2", { left_hand = "Bip01 L Hand", right_hand = "Bip01 R Hand", bones = TranslateTable_ZenoToo } )
list.Set( "FingerPoserSkeletons", "hl2_dog", { left_hand = "Dog_Model.Hand_L", right_hand = "Dog_Model.Hand_R", bones = TranslateTable_DOG } )
list.Set( "FingerPoserSkeletons", "hl2_vortigaunt", { left_hand = "ValveBiped.Hand1_L", right_hand = "ValveBiped.Hand1_R", bones = TranslateTable_VORT } )
list.Set( "FingerPoserSkeletons", "portal1_chell", { left_hand = "wrist_L", right_hand = "wrist_R", bones = TranslateTable_P1_Chell } )
list.Set( "FingerPoserSkeletons", "portal2_chell", { left_hand = "wrist_L", right_hand = "wrist_R", bones = TranslateTable_P2_Chell, hand_type = "portal2" } )
list.Set( "FingerPoserSkeletons", "portal2_ballbot", { left_hand = "wrist_L", right_hand = "wrist_R", bones = TranslateTable_P2_BallBot, hand_type = "portal2" } )
list.Set( "FingerPoserSkeletons", "portal2_eggbot", { left_hand = "wrist_A_L", right_hand = "wrist_A_R", bones = TranslateTable_P2_EggBot, hand_type = "portal2" } )
list.Set( "FingerPoserSkeletons", "insurgency", { left_hand = "L Hand", right_hand = "R Hand", bones = TranslateTable_INS } )

-- Translate the fingernum, part and hand into an real bone number
local function GetFingerBone( self, fingernum, part, hand )

	local Name = "ValveBiped.Bip01_L_Finger" .. fingernum
	if ( hand == 1 ) then Name = "ValveBiped.Bip01_R_Finger" .. fingernum end
	if ( part != 0 ) then Name = Name .. part end

	-- Look for the nornal Half-Life 2 skeleton
	local boneid = self:LookupBone( Name )
	if ( boneid ) then return boneid end

	-- Try the others by translating bone names
	for k, v in pairs( list.Get( "FingerPoserSkeletons" ) ) do
		local TranslatedName = v.bones[ Name ]
		if ( TranslatedName ) then
			local bone = self:LookupBone( TranslatedName )
			if ( bone ) then return bone end
		end
	end
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

-- Apply the current tool values to entity's hand
function TOOL:ApplyValues( pEntity, iHand )

	if ( CLIENT ) then return end

	SetupFingers( pEntity )

	local bTF2 = HasTF2Hands( pEntity )
	local bP2 = HasP2Hands( pEntity )

	for i = 0, VarsOnHand - 1 do

		local Var = self:GetClientInfo( "" .. i )
		local VecComp = string.Split( Var, " " )

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
	for k, v in pairs( list.Get( "FingerPoserSkeletons" ) ) do
		if ( !LeftHand ) then LeftHand = pEntity:LookupBone( v.left_hand ) end
		if ( LeftHand ) then break end
	end

	local RightHand = pEntity:LookupBone( "ValveBiped.Bip01_R_Hand" )
	for k, v in pairs( list.Get( "FingerPoserSkeletons" ) ) do
		if ( !RightHand ) then RightHand = pEntity:LookupBone( v.right_hand ) end
		if ( RightHand ) then break end
	end

	if ( !LeftHand || !RightHand ) then return false end

	local LeftHandMatrix = pEntity:GetBoneMatrix( LeftHand )
	local RightHandMatrix = pEntity:GetBoneMatrix( RightHand )
	if ( !LeftHandMatrix || !RightHandMatrix ) then return false end

	return LeftHandMatrix, RightHandMatrix

end

-- Applies current convar hand to picked hand
function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	--if ( trace.Entity:GetClass() != "prop_ragdoll" && !trace.Entity:IsNPC() ) then return false end

	local LeftHandMatrix, RightHandMatrix = self:GetHandPositions( trace.Entity )

	if ( !LeftHandMatrix ) then return false end
	if ( CLIENT ) then return true end

	local LeftHand = ( LeftHandMatrix:GetTranslation() - trace.HitPos ):Length()
	local RightHand = ( RightHandMatrix:GetTranslation() - trace.HitPos ):Length()

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

	local LeftHandMatrix, RightHandMatrix = self:GetHandPositions( ent )
	if ( !LeftHandMatrix ) then return false end

	local LeftHand = ( LeftHandMatrix:GetTranslation() - trace.HitPos ):Length()
	local RightHand = ( RightHandMatrix:GetTranslation() - trace.HitPos ):Length()

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
local OldEntityValid = false

--[[
	Updates the selected entity with the values from the convars
	Also, on the client it rebuilds the control panel if we have
	selected a new entity or hand
]]
function TOOL:Think()

	local selected = self:HandEntity()
	local hand = self:HandNum()

	if ( self.NextUpdate && self.NextUpdate > CurTime() ) then return end

	if ( CLIENT && ( OldHand != hand || OldEntity != selected || IsValid( selected ) != OldEntityValid ) ) then

		OldHand = hand
		OldEntity = selected
		OldEntityValid = IsValid( selected )

		self:RebuildControlPanel( self:HandEntity(), self:HandNum() )

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

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel, ent, hand )

	CPanel:Help( "#tool.finger.desc" )

	if ( !IsValid( ent ) ) then return end

	CPanel:ToolPresets( "finger", ConVarsDefault )

	SetupFingers( ent )

	if ( !ent.FingerIndex ) then return end

	-- Detect mitten hands
	local NumVars = table.Count( ent.FingerIndex )

	local fingerPoser = vgui.Create( "fingerposer", CPanel )
	fingerPoser:ControlValues( { hand = hand, numvars = NumVars } )
	CPanel:AddPanel( fingerPoser )

	CPanel:CheckBox( "#tool.finger.restrict_axis", "finger_restrict" )

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
