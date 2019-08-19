
AddCSLuaFile()

if ( CLIENT ) then
	CreateConVar( "cl_drawcameras", "1", 0, "Should the cameras be visible?" )
end

ENT.Type = "anim"
ENT.PrintName = "Camera"
ENT.RenderGroup = RENDERGROUP_BOTH

local CAMERA_MODEL = Model( "models/dav0r/camera.mdl" )

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Key" )
	self:NetworkVar( "Bool", 0, "On" )
	self:NetworkVar( "Vector", 0, "vecTrack" )
	self:NetworkVar( "Entity", 0, "entTrack" )
	self:NetworkVar( "Entity", 1, "Player" )

end

function ENT:Initialize()

	if ( SERVER ) then

		self:SetModel( CAMERA_MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )

		-- Don't collide with the player
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

		local phys = self:GetPhysicsObject()

		if ( IsValid( phys ) ) then
			phys:Sleep()
		end

	end

end

function ENT:SetTracking( Ent, LPos )

	if ( IsValid( Ent ) ) then

		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )

	else

		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )

	end

	self:NextThink( CurTime() )

	self:SetvecTrack( LPos )
	self:SetentTrack( Ent )

end

function ENT:SetLocked( locked )

	if ( locked == 1 ) then

		self.PhysgunDisabled = true

		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )

		self:SetCollisionGroup( COLLISION_GROUP_WORLD )

	else

		self.PhysgunDisabled = false

	end

	self.locked = locked

end

function ENT:OnTakeDamage( dmginfo )
	if ( self.locked ) then return end
	self:TakePhysicsDamage( dmginfo )
end

function ENT:OnRemove()

	if ( IsValid( self.UsingPlayer ) ) then

		self.UsingPlayer:SetViewEntity( self.UsingPlayer )

	end

end

if ( SERVER ) then

	numpad.Register( "Camera_On", function ( pl, ent )

		if ( !IsValid( ent ) ) then return false end

		pl:SetViewEntity( ent )
		pl.UsingCamera = ent
		ent.UsingPlayer = pl

	end )

	numpad.Register( "Camera_Toggle", function ( pl, ent, idx, buttoned )

		-- The camera was deleted or something - return false to remove this entry
		if ( !IsValid( ent ) ) then return false end
		if ( !IsValid( pl ) ) then return false end

		-- Something else changed players view entity
		if ( pl.UsingCamera && pl.UsingCamera == ent && pl:GetViewEntity() != ent ) then
			pl.UsingCamera = nil
			ent.UsingPlayer = nil
		end

		if ( pl.UsingCamera && pl.UsingCamera == ent ) then

			pl:SetViewEntity( pl )
			pl.UsingCamera = nil
			ent.UsingPlayer = nil

		else

			pl:SetViewEntity( ent )
			pl.UsingCamera = ent
			ent.UsingPlayer = pl

		end

	end )

	numpad.Register( "Camera_Off", function( pl, ent )

		if ( !IsValid( ent ) ) then return false end

		if ( pl.UsingCamera && pl.UsingCamera == ent ) then
			pl:SetViewEntity( pl )
			pl.UsingCamera = nil
			ent.UsingPlayer = nil
		end

	end )

end

function ENT:Think()

	if ( CLIENT ) then

		self:TrackEntity( self:GetentTrack(), self:GetvecTrack() )

	end

end

function ENT:TrackEntity( ent, lpos )

	if ( !IsValid( ent ) ) then return end

	local WPos = ent:LocalToWorld( lpos )

	if ( ent:IsPlayer() ) then
		WPos = WPos + ent:GetViewOffset() * 0.85
	end

	local CamPos = self:GetPos()
	local Ang = WPos - CamPos

	Ang = Ang:Angle()
	self:SetAngles( Ang )

end

function ENT:CanTool( ply, trace, mode )

	if ( self:GetMoveType() == MOVETYPE_NONE ) then return false end

	return true

end

function ENT:Draw()

	if ( GetConVarNumber( "cl_drawcameras" ) == 0 ) then return end

	-- Don't draw the camera if we're taking pics
	local wep = LocalPlayer():GetActiveWeapon()
	if ( IsValid( wep ) ) then
		if ( wep:GetClass() == "gmod_camera" ) then return end
	end

	self:DrawModel()

end
