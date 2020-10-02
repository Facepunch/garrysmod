
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Dynamite"
ENT.Editable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "ShouldRemove", { KeyName = "sr", Edit = { type = "Boolean", order = 1, title = "#tool.dynamite.remove" } } )
	self:NetworkVar( "Float", 0, "Damage", { KeyName = "force", Edit = { type = "Float", order = 2, min = 0, max = 500, title = "#tool.dynamite.damage" } } )
	self:NetworkVar( "Float", 1, "Delay", { KeyName = "delay", Edit = { type = "Float", order = 3, min = 0, max = 10, title = "#tool.dynamite.delay" } } )

end

function ENT:Initialize()

	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	end

end

function ENT:Setup( damage )

	self:SetDamage( damage )

end

function ENT:GetOverlayText()

	local txt = string.format( "Damage: %g\nDelay: %g",  math.Clamp( self:GetDamage(), 0, 1500 ), self:GetDelay() )

	if ( game.SinglePlayer() ) then return txt end

	return txt .. "\n(" .. self:GetPlayerName() .. ")"

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

	ply = ply or self

	local _delay = delay or self:GetDelay()

	if ( _delay == 0 ) then

		local radius = 300

		util.BlastDamage( self, ply, self:GetPos(), radius, math.Clamp( self:GetDamage(), 0, 1500 ) )

		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", effectdata, true, true )

		if ( self:GetShouldRemove() ) then self:Remove() return end
		if ( self:GetMaxHealth() > 0 && self:Health() <= 0 ) then self:SetHealth( self:GetMaxHealth() ) end

	else

		timer.Simple( _delay, function() if ( !IsValid( self ) ) then return end self:Explode( 0, ply ) end )

	end

end
