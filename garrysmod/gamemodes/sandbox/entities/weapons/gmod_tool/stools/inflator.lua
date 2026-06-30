
TOOL.Category = "Poser"
TOOL.Name = "#tool.inflator.name"

TOOL.LeftClickAutomatic = true
TOOL.RightClickAutomatic = true
TOOL.RequiresTraceHit = true

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

local ScaleYZ = {
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] = true,
	["ValveBiped.Bip01_L_Thigh"] = true,
	["ValveBiped.Bip01_L_Calf"] = true,
	["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] = true,
	["ValveBiped.Bip01_R_Thigh"] = true,
	["ValveBiped.Bip01_R_Calf"] = true,
	["ValveBiped.Bip01_Spine2"] = true,
	["ValveBiped.Bip01_Spine1"] = true,
	["ValveBiped.Bip01_Spine"] = true,
	["ValveBiped.Bip01_Spinebut"] = true,

	-- Vortigaunt
	["ValveBiped.spine4"] = true,
	["ValveBiped.spine3"] = true,
	["ValveBiped.spine2"] = true,
	["ValveBiped.spine1"] = true,
	["ValveBiped.hlp_ulna_R"] = true,
	["ValveBiped.hlp_ulna_L"] = true,
	["ValveBiped.arm1_L"] = true,
	["ValveBiped.arm1_R"] = true,
	["ValveBiped.arm2_L"] = true,
	["ValveBiped.arm2_R"] = true,
	["ValveBiped.leg_bone1_L"] = true,
	["ValveBiped.leg_bone1_R"] = true,
	["ValveBiped.leg_bone2_L"] = true,
	["ValveBiped.leg_bone2_R"] = true,
	["ValveBiped.leg_bone3_L"] = true,
	["ValveBiped.leg_bone3_R"] = true,

	-- Team Fortress 2
	["bip_knee_L"] = true,
	["bip_knee_R"] = true,
	["bip_hip_R"] = true,
	["bip_hip_L"] = true,
}

local ScaleXZ = {
	["ValveBiped.Bip01_pelvis"] = true,

	-- Team Fortress 2
	["bip_upperArm_L"] = true,
	["bip_upperArm_R"] = true,
	["bip_lowerArm_L"] = true,
	["bip_lowerArm_R"] = true,
	["bip_forearm_L"] = true,
	["bip_forearm_R"] = true,
}

local function GetNiceBoneScale( name, scale )
	if ( ScaleYZ[ name ] or string.find( name:lower(), "leg" ) or string.find( name:lower(), "arm" ) ) then
		return Vector( 0, scale, scale )
	end

	if ( ScaleXZ[ name ] ) then
		return Vector( scale, 0, scale )
	end

	return Vector( scale, scale, scale )
end

--Scale the specified bone by Scale
local function ScaleBone( ent, bone, scale )

	if ( !bone or CLIENT ) then return false end

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

--Scale UP
function TOOL:LeftClick( trace, scale )

	if ( !IsValid( trace.Entity ) ) then return false end
	if ( !trace.Entity:IsNPC() and trace.Entity:GetClass() != "prop_ragdoll" /*&& !trace.Entity:IsPlayer()*/ ) then return false end
	if ( trace.HullTrace ) then return false end -- We hit the bounding box, not a specific bone (because of the hull trace)

	local bone = trace.Entity:TranslatePhysBoneToBone( trace.PhysicsBone )
	ScaleBone( trace.Entity, bone, scale or 1 )
	self:GetWeapon():SetNextPrimaryFire( CurTime() + 0.01 )

	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetAttachment( bone )
	effectdata:SetEntity( trace.Entity )
	effectdata:SetScale( scale or 1 )
	util.Effect( "inflator_magic", effectdata )

	return false

end

-- Scale DOWN
function TOOL:RightClick( trace )

	return self:LeftClick( trace, -1 )

end

-- Reset scaling
function TOOL:Reload( trace )

	if ( !IsValid( trace.Entity ) ) then return false end
	if ( !trace.Entity:IsNPC() and trace.Entity:GetClass() != "prop_ragdoll" /*&& !trace.Entity:IsPlayer()*/ ) then return false end

	if ( CLIENT ) then return true end

	for i = 0, trace.Entity:GetBoneCount() do
		trace.Entity:ManipulateBoneScale( i, Vector( 1, 1, 1 ) )
	end

	return true

end

function TOOL.BuildCPanel( CPanel )

	CPanel:Help( "#tool.inflator.desc" )

end
