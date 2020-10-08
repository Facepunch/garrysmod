
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Emitter"
ENT.Editable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 1, "On", { KeyName = "on", Edit = { type = "Boolean", order = 1, title = "#entedit.enabled" } } )
	self:NetworkVar( "Bool", 0, "Toggle", { KeyName = "tg", Edit = { type = "Boolean", order = 1, title = "#tool.emitter.toggle" } } )
	self:NetworkVar( "Float", 0, "Delay", { KeyName = "dl", Edit = { type = "Float", order = 1, min = 0.01, max = 2, title = "#tool.emitter.delay" } } )
	self:NetworkVar( "Float", 1, "Scale", { KeyName = "sc", Edit = { type = "Float", order = 1, min = 0, max = 6, title = "#tool.emitter.scale" } } )
	self:NetworkVar( "String", 0, "Effect" )

end

function ENT:Initialize()

	if ( SERVER ) then

		self:SetModel( "models/props_lab/tpplug.mdl" ) -- TODO: Find something better than this shitty shit.
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

		self:DrawShadow( false )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end

	end

end

function ENT:Draw( flags )

	-- Don't draw if the player is holding Camera SWEP in their hands
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	if ( IsValid( wep ) ) then

		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera" ) then return end

	end

	BaseClass.Draw( self, flags )

end

function ENT:Think()

	if ( SERVER ) then return end

	BaseClass.Think( self )

	if ( !self:GetOn() ) then return end

	self.Delay = self.Delay or 0

	if ( self.Delay > CurTime() ) then return end
	self.Delay = CurTime() + self:GetDelay()

	--
	-- Find our effect table
	--
	local Effect = self:GetEffect()

	local EffectTable = list.Get( "EffectType" )[ Effect ]
	if ( !EffectTable ) then return end

	local Angle = self:GetAngles()
	EffectTable.func( self, self:GetPos() + Angle:Forward() * 12, Angle, self:GetScale() )

end

--[[---------------------------------------------------------
	Overridden because I want to show the name of the player that spawned it..
-----------------------------------------------------------]]
function ENT:GetOverlayText()

	return self:GetPlayerName()

end

if ( SERVER ) then

	numpad.Register( "Emitter_On", function ( pl, ent )

		if ( !IsValid( ent ) ) then return end

		if ( ent:GetToggle() ) then
			ent:SetOn( !ent:GetOn() )
		return end

		ent:SetOn( true )

	end )

	numpad.Register( "Emitter_Off", function ( pl, ent )

		if ( !IsValid( ent ) ) then return end
		if ( ent:GetToggle() ) then return end

		ent:SetOn( false )

	end )

end

game.AddParticles( "particles/gmod_effects.pcf" )
PrecacheParticleSystem( "generic_smoke" )

list.Set( "EffectType", "smoke", {
	print		= "#effecttype.smoke",
	material	= "gui/effects/smoke.png",
	func		= function( ent, pos, angle, scale )

		ParticleEffect( "generic_smoke", pos, angle, ent )

	end
} )

list.Set( "EffectType", "sparks", {
	print		= "#effecttype.sparks",
	material	= "gui/effects/sparks.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() * scale )
		effectdata:SetMagnitude( scale / 2 )
		effectdata:SetRadius( 8 - scale )
		util.Effect( "Sparks", effectdata, true, true )

	end
} )

list.Set( "EffectType", "stunstickimpact", {
	print		= "#effecttype.stunstick",
	material	= "gui/effects/stunstickimpact.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() )
		util.Effect( "stunstickimpact", effectdata, true, true )

	end
} )

list.Set( "EffectType", "manhacksparks", {
	print		= "#effecttype.manhack",
	material	= "gui/effects/manhacksparks.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() * scale )
		util.Effect( "manhacksparks", effectdata, true, true )

	end
} )

list.Set( "EffectType", "bloodspray", {
	print		= "#effecttype.blood",
	material	= "gui/effects/bloodspray.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() * math.max( 3, scale ) / 3 )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( scale + 9 )
		effectdata:SetColor( 0 )
		effectdata:SetFlags( 3 )
		util.Effect( "bloodspray", effectdata, true, true )

	end
} )

list.Set( "EffectType", "striderblood", {
	print		= "#effecttype.strider",
	material	= "gui/effects/striderblood.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() * ( 6 - scale ) / 2 )
		effectdata:SetScale( scale / 2 )
		util.Effect( "StriderBlood", effectdata, true, true )

	end
} )

list.Set( "EffectType", "shells", {
	print		= "#effecttype.pistol",
	material	= "gui/effects/shells.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetAngles( angle )
		util.Effect( "ShellEject", effectdata, true, true )

	end
} )

list.Set( "EffectType", "rifleshells", {
	print		= "#effecttype.rifle",
	material	= "gui/effects/rifleshells.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetAngles( angle )
		util.Effect( "RifleShellEject", effectdata, true, true )

	end
} )

list.Set( "EffectType", "shotgunshells", {
	print		= "#effecttype.shotgun",
	material	= "gui/effects/shotgunshells.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetAngles( angle )
		util.Effect( "ShotgunShellEject", effectdata, true, true )

	end
} )

list.Set( "EffectType", "cball_explode", {
	print		= "#effecttype.cball_explode",
	material	= "gui/effects/cball_explode.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "cball_explode", effectdata, true, true )

	end
} )

list.Set( "EffectType", "cball_bounce", {
	print		= "#effecttype.cball_bounce",
	material	= "gui/effects/cball_bounce.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() * scale / 4 )
		effectdata:SetRadius( scale * 2 )
		util.Effect( "cball_bounce", effectdata, true, true )

	end
} )

list.Set( "EffectType", "thumperdust", {
	print		= "#effecttype.thumperdust",
	material	= "gui/effects/thumperdust.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetScale( scale * 24 )
		util.Effect( "ThumperDust", effectdata, true, true )

	end
} )

list.Set( "EffectType", "ar2impact", {
	print		= "#effecttype.ar2impact",
	material	= "gui/effects/ar2impact.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( angle:Forward() )
		util.Effect( "AR2Impact", effectdata, true, true )

	end
} )

list.Set( "EffectType", "ar2explosion", {
	print		= "#effecttype.ar2explosion",
	material	= "gui/effects/ar2explosion.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetRadius( scale * 4 )
		effectdata:SetNormal( angle:Forward() )
		util.Effect( "AR2Explosion", effectdata, true, true )

	end
} )

list.Set( "EffectType", "explosion", {
	print		= "#effecttype.explosion",
	material	= "gui/effects/explosion.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetFlags( 4 )
		util.Effect( "explosion", effectdata, true, true )

	end
} )

list.Set( "EffectType", "helicoptermegabomb", {
	print		= "#effecttype.helicoptermegabomb",
	material	= "gui/effects/helicoptermegabomb.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "helicoptermegabomb", effectdata, true, true )

	end
} )

list.Set( "EffectType", "underwaterexplosion", {
	print		= "#effecttype.waterexplosion",
	material	= "gui/effects/waterexplosion.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "WaterSurfaceExplosion", effectdata, true, true )

	end
} )

list.Set( "EffectType", "watersplash", {
	print		= "#effecttype.watersplash",
	material	= "gui/effects/watersplash.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetScale( scale * 2 )
		effectdata:SetFlags( 0 )
		util.Effect( "WaterSplash", effectdata, true, true )

	end
} )

list.Set( "EffectType", "dirtywatersplash", {
	print		= "#effecttype.dirtywatersplash",
	material	= "gui/effects/dirtywatersplash.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetScale( scale * 2 )
		effectdata:SetFlags( 1 )
		util.Effect( "WaterSplash", effectdata, true, true )

	end
} )

list.Set( "EffectType", "glassimpact", {
	print		= "#effecttype.glassimpact",
	material	= "gui/effects/glassimpact.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "GlassImpact", effectdata, true, true )

	end
} )

list.Set( "EffectType", "bloodimpact", {
	print		= "#effecttype.bloodimpact",
	material	= "gui/effects/bloodimpact.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "BloodImpact", effectdata, true, true )

	end
} )

list.Set( "EffectType", "muzzleeffect", {
	print		= "#effecttype.muzzleeffect",
	material	= "gui/effects/muzzleeffect.png",
	func		= function( ent, pos, angle, scale )

		local effectdata = EffectData()
		effectdata:SetOrigin( pos + angle:Forward() * 4 )
		effectdata:SetAngles( angle )
		effectdata:SetScale( scale )
		util.Effect( "MuzzleEffect", effectdata, true, true )

	end
} )
