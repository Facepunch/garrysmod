
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.Spawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE

AccessorFunc( ENT, "m_ShouldRemove", "ShouldRemove" )

function ENT:Initialize()

	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	end

end

function ENT:Setup( damage )

	self.Damage = damage

	-- Wot no translation :(
	self:SetOverlayText( "Damage: " .. math.floor( self.Damage ) )

end

function ENT:OnTakeDamage( dmginfo )

	if ( dmginfo:GetInflictor():GetClass() == "gmod_dynamite" ) then return end

	self:TakePhysicsDamage( dmginfo )

end

--
-- Blow that mother fucker up, BAATCHH
--
function ENT:Explode( delay, ply )

	if ( !IsValid( self ) ) then return end

	ply = ply or self.Entity

	local _delay = delay or 0

	if ( _delay == 0 ) then

		local radius = 300

		util.BlastDamage( self, ply, self:GetPos(), radius, self.Damage )

		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", effectdata, true, true )

		if ( self:GetShouldRemove() ) then self:Remove() return end
		if ( self:GetMaxHealth() > 0 && self:Health() <= 0 ) then self:SetHealth( self:GetMaxHealth() ) end

	else

		timer.Simple( delay, function() if ( !IsValid( self ) ) then return end self:Explode( 0, ply ) end )

	end

end
