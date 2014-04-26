
AddCSLuaFile()

if ( CLIENT ) then
	CreateConVar( "cl_draweffectrings", "1", 0, "Should the effect green rings be visible?" )
end

ENT.Type = "anim"

ENT.PrintName			= ""
ENT.Author				= ""
ENT.Contact				= ""
ENT.Purpose				= ""
ENT.Instructions		= ""
ENT.Spawnable			= false
ENT.AdminOnly			= false


--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()
	
	local Radius = 4

	if ( SERVER ) then

		self.AttachedEntity = ents.Create( "prop_dynamic" )
		self.AttachedEntity:SetModel( self:GetModel() )
		self.AttachedEntity:SetAngles( self:GetAngles() )
		self.AttachedEntity:SetPos( self:GetPos() )
		self.AttachedEntity:SetSkin( self:GetSkin() )
		self.AttachedEntity:Spawn()
		self.AttachedEntity:SetParent( self.Entity )
		self.AttachedEntity:DrawShadow( false )

		self:SetModel( "models/props_junk/watermelon01.mdl" )
	
		self:DeleteOnRemove( self.AttachedEntity )

		local min = Vector( 1, 1, 1 ) * Radius * -0.5
		local max = Vector( 1, 1, 1 ) * Radius * 0.5
	
		-- Don't use the model's physics - create a box instead
		self:PhysicsInitBox( min, max )
	
		-- Set up our physics object here
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys) ) then
	
			phys:Wake()
			phys:EnableGravity( false )
			phys:EnableDrag( false )
		
		end
	
		-- Set collision bounds exactly
		self:SetCollisionBounds( min, max )
		self:DrawShadow( false )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	else

		self.GripMaterial = Material( "sprites/grip" )
		self:SetCollisionBounds( Vector( -Radius, -Radius, -Radius ), Vector( Radius, Radius, Radius ) )

	end

	
end


--[[---------------------------------------------------------
   Name: Draw
-----------------------------------------------------------]]
function ENT:Draw()

	if ( GetConVarNumber( "cl_draweffectrings" ) == 0 ) then return end
	
	-- Don't draw the grip if there's no chance of us picking it up
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ( !IsValid( wep ) ) then return end
	
	local weapon_name = wep:GetClass()
	
	if ( weapon_name != "weapon_physgun" 
		&& weapon_name != "weapon_physcannon" 
		&& weapon_name != "gmod_tool" ) then 

		return 

	end

	render.SetMaterial( self.GripMaterial )
	render.DrawSprite( self:GetPos(), 16, 16, color_white )

end


--[[---------------------------------------------------------
   Name: PhysicsUpdate
-----------------------------------------------------------]]
function ENT:PhysicsUpdate( physobj )

	-- Don't do anything if the player isn't holding us
	if ( !self:IsPlayerHolding() && !self:IsConstrained() ) then
		
		physobj:SetVelocity( Vector(0,0,0) )
		physobj:Sleep()
		
	end

end


--[[---------------------------------------------------------
   Name: Called after entity 'copy'
-----------------------------------------------------------]]
function ENT:OnEntityCopyTableFinish( tab )

	-- We need to store the model of the attached entity
	-- Not the one we have here.
	tab.Model = self.AttachedEntity:GetModel()

end
