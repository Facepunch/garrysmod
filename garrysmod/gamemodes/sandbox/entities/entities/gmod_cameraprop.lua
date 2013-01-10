
AddCSLuaFile()

if ( CLIENT ) then
	CreateConVar( "cl_drawcameras", "1", 0, "Should the cameras be visible?" )
end

ENT.Type = "anim"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_BOTH

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

local CAMERA_MODEL = Model( "models/dav0r/camera.mdl" )

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Key" );
	self:NetworkVar( "Bool", 0, "On" );
	self:NetworkVar( "Vector", 0, "vecTrack" );
	self:NetworkVar( "Entity", 0, "entTrack" );
	self:NetworkVar( "Entity", 1, "Player" );

end

--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
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
		
		if ( phys:IsValid() ) then
			phys:Sleep()
		end
		
	end
	
end

function ENT:SetTracking( Ent, LPos )

	if ( Ent:IsValid() ) then
	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
	
	else
	
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	
	end
	
	self:NextThink( CurTime() )
	
	self:SetvecTrack( LPos );
	self:SetentTrack( Ent );

end

function ENT:SetLocked( locked )

	if ( locked == 1 ) then
	
		self.PhysgunDisabled = true
		
		local phys = self:GetPhysicsObject()
		if ( phys:IsValid() ) then
			phys:EnableMotion( false )
		end
	
	else
	
		self.PhysgunDisabled = false
	
	end
	
	self.locked = locked

end

--[[---------------------------------------------------------
   Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

local function Toggle( player )

	local toggle = self:GetToggle()
	
	if ( player.UsingCamera && player.UsingCamera == self.Entity ) then
	
		player:SetViewEntity( player )
		player.UsingCamera = nil
		self.UsingPlayer = nil
		
	else
	
		player:SetViewEntity( self.Entity )
		player.UsingCamera = self.Entity
		self.UsingPlayer = player
		
	end
	
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

	if ( !ent || !ent:IsValid() ) then return end

	local WPos = ent:LocalToWorld( lpos )
	
	if ( ent:IsPlayer() ) then
		WPos = WPos + Vector( 0, 0, 54 )
	end
	
	local CamPos = self:GetPos()
	local Ang = WPos - CamPos
	
	Ang = Ang:Angle()
	self:SetAngles(Ang)

end

function ENT:CanTool( ply, trace, mode )

	if ( self:GetMoveType() == MOVETYPE_NONE ) then return false end
	
	return true

end

function ENT:Draw()	

	if ( self.ShouldDraw == 0 ) then return end

	-- Don't draw the camera if we're taking pics
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ( wep:IsValid() ) then 
		if ( wep:GetClass() == "gmod_camera" ) then return end
	end

	self:DrawModel()
	
end