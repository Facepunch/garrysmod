
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false
ENT.AdminOnly = false
ENT.Editable = true

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel( "models/maxofs2d/cube_tool.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetUseType( ONOFF_USE )

end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:EnableForwardArrow()

	self:SetBodygroup( 1, 1 )

end
