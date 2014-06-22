
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
	"ValveBiped.Bip01_Spinebut"
}

local ScaleXZ = { "ValveBiped.Bip01_pelvis" }

local function GetNiceBoneScale( name, scale )

	if ( table.HasValue( ScaleYZ, name ) ) then
		return Vector( 0, scale, scale )
	end
	
	if ( table.HasValue( ScaleXZ, name ) ) then
		return Vector( scale, 0, scale )
	end
	
	return Vector( scale, scale, scale )

end

local ScaleBone = nil

local function ScaleNeighbourBones( Entity, Pos, Bone, Scale, type )

	if ( type == nil || type == 2 ) then

		local parent = Entity:GetBoneParent( Bone )
		if ( parent && parent >= 0 && parent != Bone ) then
			ScaleBone( Entity, Pos, parent, Scale, 2 )
		end

	end
	
	if ( type == nil || type == 1 ) then

		local children = Entity:GetChildBones( Bone )

		for k, v in pairs( children ) do
			ScaleBone( Entity, Pos, v, Scale, 1 )
		end

	end

end

--[[------------------------------------------------------------
	Scale the specified bone by Scale
--------------------------------------------------------------]]
ScaleBone = function( Entity, Pos, Bone, Scale, type )

	--local Bone, BonePos = Entity:FindNearestBone( Pos )
	if ( !Bone ) then return false end

	-- Some bones are scaled only in certain directions (like legs don't scale on length)
	local v = GetNiceBoneScale( Entity:GetBoneName( Bone ), Scale ) * 0.1
	local TargetScale = Entity:GetManipulateBoneScale( Bone ) + v * 0.1
	
	if ( TargetScale.x < 0 ) then TargetScale.x = 0 end
	if ( TargetScale.y < 0 ) then TargetScale.y = 0 end
	if ( TargetScale.z < 0 ) then TargetScale.z = 0 end

	Entity:ManipulateBoneScale( Bone, TargetScale )

	ScaleNeighbourBones( Entity, Pos, Bone, Scale * 0.5, type )

end

--[[------------------------------------------------------------
	Scale UP
--------------------------------------------------------------]]
function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( !trace.Entity:IsNPC() && trace.Entity:GetClass() != "prop_ragdoll" ) then return false end
	
	local Bone = trace.Entity:TranslatePhysBoneToBone( trace.PhysicsBone )
	ScaleBone( trace.Entity, trace.HitPos, Bone, 1 )
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
	ScaleBone( trace.Entity, trace.HitPos, Bone, -1 )
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
		trace.Entity:ManipulateBoneScale( i, Vector(1, 1, 1) )
	end
	
	return true
	
end
