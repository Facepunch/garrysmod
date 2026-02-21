
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

		self.QueuedExplosions = {}
	end

end

function ENT:Setup( damage )

	self:SetDamage( damage )

end

if ( SERVER ) then
	function ENT:Think()

		self:HandleQueuedExplosions()

		-- Only think often if we have any events queued (default was 0.2)
		-- We could also probably use the soonest timer as the delay here..
		self:NextThink( CurTime() + ( self.AnyQueued and 0.05 or 1 ) )
		return true

	end

	function ENT:HandleQueuedExplosions()

		for k, v in ipairs( self.QueuedExplosions ) do
			if ( v.when <= CurTime() ) then
				self:Explode( 0, v.player )
				table.remove( self.QueuedExplosions, k )
			end
		end

		self.AnyQueued = #self.QueuedExplosions > 0

	end
end

function ENT:GetOverlayText()

	local txt = string.format( "%s %g\n%s %g",
		language.GetPhrase( "#tool.dynamite.damage" ), math.Clamp( self:GetDamage(), 0, 1500 ),
		language.GetPhrase( "#tool.dynamite.delay" ), self:GetDelay() )

	if ( game.SinglePlayer() ) then return txt end

	return txt .. "\n(" .. self:GetPlayerName() .. ")"

end

function ENT:OnTakeDamage( dmginfo )

	local inflictor = dmginfo:GetInflictor()
	if ( IsValid( inflictor ) and inflictor:GetClass() == "gmod_dynamite" ) then return end

	self:TakePhysicsDamage( dmginfo )

end

--
-- Blow that mother fucker up, BAATCHH
--
function ENT:Explode( delayOverride, ply )

	if ( !IsValid( self ) ) then return end

	if ( !IsValid( ply ) ) then ply = self end

	local delay = delayOverride or self:GetDelay()

	-- You do not a timer longer than this.
	if ( delay > 3600 ) then delay = 3600 end

	if ( delay == 0 ) then

		local radius = 300

		util.BlastDamage( self, ply, self:GetPos(), radius, math.Clamp( self:GetDamage(), 0, 1500 ) )

		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "Explosion", effectdata, true, true )

		if ( self:GetShouldRemove() ) then self:Remove() return end
		if ( self:GetMaxHealth() > 0 && self:Health() <= 0 ) then self:SetHealth( self:GetMaxHealth() ) end

	else

		-- Queue the explosion
		table.insert( self.QueuedExplosions, { when = CurTime() + delay, player = ply } )
		self:NextThink( CurTime() )

	end

end
