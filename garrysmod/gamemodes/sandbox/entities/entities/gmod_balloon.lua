
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Balloon"
ENT.Editable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "Force", { KeyName = "force", Edit = { type = "Float", order = 1, min = -2000, max = 2000, title = "#tool.balloon.force" } } )

	if ( SERVER ) then
		self:NetworkVarNotify( "Force", function() self:PhysWake() end )
	end

end

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )

	-- Set up our physics object here
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then

		phys:SetMass( 100 )
		phys:Wake()
		phys:EnableGravity( false )

	end

	self:SetForce( 1 )
	self:StartMotionController()

end

function ENT:GetOverlayText()

	local txt = "Force: " .. math.floor( self:GetForce() )

	if ( txt == "" ) then return "" end
	if ( game.SinglePlayer() ) then return txt end

	return txt .. "\n(" .. self:GetPlayerName() .. ")"

end

function ENT:OnTakeDamage( dmginfo )

	if ( self.Indestructible ) then return end

	local c = self:GetColor()

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetStart( Vector( c.r, c.g, c.b ) )
	util.Effect( "balloon_pop", effectdata )

	if ( self.Explosive ) then

		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetScale( 1 )
		effectdata:SetMagnitude( 25 )
		util.Effect( "Explosion", effectdata, true, true )

	end

	local attacker = dmginfo:GetAttacker()
	if ( IsValid( attacker ) && attacker:IsPlayer() ) then
		attacker:SendLua( "achievements.BalloonPopped()" )
	end

	self:Remove()

end

function ENT:PhysicsSimulate( phys, deltatime )

	local vLinear = Vector( 0, 0, self:GetForce() * 5000 ) * deltatime
	local vAngular = vector_origin

	return vAngular, vLinear, SIM_GLOBAL_FORCE

end
