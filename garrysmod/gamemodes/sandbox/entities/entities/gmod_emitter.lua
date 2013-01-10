
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName			= ""
ENT.Author				= ""
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

local matLight 			= Material( "sprites/light_ignorez" )
local matBeam			= Material( "effects/lamp_beam" )

function ENT:SetupDataTables()

	self:NetworkVar( "Float",	0,	"Delay" );
	self:NetworkVar( "Bool",	0,	"Toggle" );
	self:NetworkVar( "Bool",	1,	"On" );
	self:NetworkVar( "String",	0,	"Effect" );

end

function ENT:Initialize()

	if ( SERVER ) then

		self:SetModel( "models/props_lab/tpplug.mdl" )	-- TODO: Find something better than this shitty shit.
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	
		self:DrawShadow( false )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end

	end
	
end

--[[---------------------------------------------------------
   Name: Draw
-----------------------------------------------------------]]
function ENT:Draw()

	-- Don't draw if we
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()

	if ( wep:IsValid() ) then 

		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera" ) then return end

	end
	
	BaseClass.Draw( self )
	
end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
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
	local list = list.Get( "EffectType" )
	local EffectTable = list[ Effect ]
	if ( !EffectTable ) then return end
	
	local Angle = self:GetAngles()
	EffectTable.func( self, self:GetPos() + Angle:Forward() * 12, Angle )
	
end

--[[---------------------------------------------------------
   Overridden because I want to show the name of the 
   player that spawned it..
-----------------------------------------------------------]]
function ENT:GetOverlayText()

	return self:GetPlayerName()	
	
end


if ( SERVER ) then

	numpad.Register( "Emitter_On", 	function ( pl, ent )

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


list.Set( "EffectType", "sparks", 
{
	print		=	"Sparks",
	material	=	"gui/effects/sparks.png",
	func		=	function( ent, pos, angle )

		local effectdata = EffectData()
			effectdata:SetOrigin( pos )
			effectdata:SetNormal( angle:Forward() * 2 )
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( 1 )
			effectdata:SetRadius( 2 )
		util.Effect( "Sparks", effectdata, true, true )

	end

});

game.AddParticles( "particles/gmod_effects.pcf" )

PrecacheParticleSystem( "generic_smoke" )

list.Set( "EffectType", "smoke", 
{
	print		=	"Generic Smoke",
	material	=	"gui/effects/smoke.png",
	func		=	function( ent, pos, angle )

		ParticleEffect( "generic_smoke", pos, angle, ent )

	end

});

list.Set( "EffectType", "bloodspray", 
{
	print		=	"bloodspray",
	material	=	"gui/effects/bloodspray.png",
	func		=	function( ent, pos, angle )

		local effectdata = EffectData()
			effectdata:SetOrigin( pos )
			effectdata:SetNormal( angle:Forward() * 1 )
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( 10 )
			effectdata:SetRadius( 1 )
			effectdata:SetColor( 0 )
			effectdata:SetFlags( 1 )
		util.Effect( "bloodspray", effectdata, true, true )

	end

});

list.Set( "EffectType", "striderblood", 
{
	print		=	"striderblood",
	material	=	"gui/effects/striderblood.png",
	func		=	function( ent, pos, angle )

		local effectdata = EffectData()
			effectdata:SetOrigin( pos )
			effectdata:SetNormal( angle:Forward() * 2 )
			effectdata:SetMagnitude( 1 )
			effectdata:SetScale( 2 )
			effectdata:SetRadius( 1 )
			effectdata:SetColor( 0 )
			effectdata:SetFlags( 0 )
		util.Effect( "StriderBlood", effectdata, true, true )

	end

});

list.Set( "EffectType", "shells", 
{
	print		=	"shells",
	material	=	"gui/effects/shells.png",
	func		=	function( ent, pos, angle )

		local effectdata = EffectData()
			effectdata:SetOrigin( pos )
			effectdata:SetAngles( angle )
		util.Effect( "ShellEject", effectdata, true, true )

	end

});
