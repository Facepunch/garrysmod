
TOOL.Category = "Poser"
TOOL.Name = "#tool.inflator.name"

TOOL.LeftClickAutomatic = true
TOOL.RightClickAutomatic = true
TOOL.RequiresTraceHit = true

if ( CLIENT ) then

	function TOOL.BuildCPanel( CPanel )

		CPanel:AddControl( "Header", { Description = "#tool.inflator.desc" } )

	end

end

local ScaleYZ = {
	"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spinebut",

	-- Vortigaunt
	"ValveBiped.spine4",
	"ValveBiped.spine3",
	"ValveBiped.spine2",
	"ValveBiped.spine1",
	"ValveBiped.hlp_ulna_R",
	"ValveBiped.hlp_ulna_L",
	"ValveBiped.arm1_L",
	"ValveBiped.arm1_R",
	"ValveBiped.arm2_L",
	"ValveBiped.arm2_R",
	"ValveBiped.leg_bone1_L",
	"ValveBiped.leg_bone1_R",
	"ValveBiped.leg_bone2_L",
	"ValveBiped.leg_bone2_R",
	"ValveBiped.leg_bone3_L",
	"ValveBiped.leg_bone3_R",
	
	-- Team Fortress 2
	"bip_knee_L",
	"bip_knee_R",
	"bip_hip_R",
	"bip_hip_L",
}

local ScaleXZ = {
	"ValveBiped.Bip01_pelvis",

	-- Team Fortress 2
	"bip_upperArm_L",
	"bip_upperArm_R",
	"bip_lowerArm_L",
	"bip_lowerArm_R",
	"bip_forearm_L",
	"bip_forearm_R",
}

local function GetNiceBoneScale( name, scale )

	if ( table.HasValue( ScaleYZ, name ) || string.find( name:lower(), "leg" ) || string.find( name:lower(), "arm" ) ) then
		return Vector( 0, scale, scale )
	end

	if ( table.HasValue( ScaleXZ, name ) ) then
		return Vector( scale, 0, scale )
	end

	return Vector( scale, scale, scale )

end

--[[------------------------------------------------------------
	Scale the specified bone by Scale
--------------------------------------------------------------]]
local function ScaleBone( ent, bone, scale, type )

	if ( !bone ) then return false end

	local physBone = ent:TranslateBoneToPhysBone( bone )
	for i = 0, ent:GetBoneCount() do

		if ( ent:TranslateBoneToPhysBone( i ) != physBone ) then continue end

		-- Some bones are scaled only in certain directions (like legs don't scale on length)
		local v = GetNiceBoneScale( ent:GetBoneName( i ), scale ) * 0.1
		local TargetScale = ent:GetManipulateBoneScale( i ) + v * 0.1

		if ( TargetScale.x < 0 ) then TargetScale.x = 0 end
		if ( TargetScale.y < 0 ) then TargetScale.y = 0 end
		if ( TargetScale.z < 0 ) then TargetScale.z = 0 end

		ent:ManipulateBoneScale( i, TargetScale )
	end

end

--[[------------------------------------------------------------
	Scale UP
--------------------------------------------------------------]]
function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( !trace.Entity:IsNPC() && trace.Entity:GetClass() != "prop_ragdoll" ) then return false end

	local Bone = trace.Entity:TranslatePhysBoneToBone( trace.PhysicsBone )
	ScaleBone( trace.Entity, Bone, 1 )
	self:GetWeapon():SetNextPrimaryFire( CurTime() + 0.01 )

	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	util.Effect( "inflator_magic", effectdata )

	return false

end

--[[------------------------------------------------------------
	Scale DOWN
--------------------------------------------------------------]]
function TOOL:RightClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( !trace.Entity:IsNPC() && trace.Entity:GetClass() != "prop_ragdoll" ) then return false end

	local Bone = trace.Entity:TranslatePhysBoneToBone( trace.PhysicsBone )
	ScaleBone( trace.Entity, Bone, -1 )
	self:GetWeapon():SetNextSecondaryFire( CurTime() + 0.01 )

	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	util.Effect( "inflator_magic", effectdata )

	return false

end

--[[------------------------------------------------------------
	Remove Scaling
--------------------------------------------------------------]]
function TOOL:Reload( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( !trace.Entity:IsNPC() && trace.Entity:GetClass() != "prop_ragdoll" ) then return false end
	if ( CLIENT ) then return false end

	for i=0, trace.Entity:GetBoneCount() do
		trace.Entity:ManipulateBoneScale( i, Vector( 1, 1, 1 ) )
	end

	return true

end
