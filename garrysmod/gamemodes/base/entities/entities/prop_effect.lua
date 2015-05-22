
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

		-- Get the attached entity so that clientside functions like properties can interact with it
		local tab = ents.FindByClassAndParent( "prop_dynamic", self )
		if ( tab ) and ( IsValid( tab[ 1 ] ) ) then self.AttachedEntity = tab[ 1 ] end

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
	
	if ( CLIENT ) then return end


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


	-- Store the attached entity's modifiers, bodygroups, and bone manipulations so we can reapply them after being pasted
	if ( self.AttachedEntity.EntityMods ) then

		tab.AttachedEntityMods = table.Copy( self.AttachedEntity.EntityMods )

	end

	local bg = self.AttachedEntity:GetBodyGroups()
	if ( bg ) then

		for k, v in pairs( bg ) do
		
			if ( self.AttachedEntity:GetBodygroup( v.id ) > 0 ) then
	
				tab.AttachedEntityBodygroups = tab.AttachedEntityBodygroups or {}
				tab.AttachedEntityBodygroups[ v.id ] = self.AttachedEntity:GetBodygroup( v.id )
	
			end
		
		end

	end

	if ( self.AttachedEntity:HasBoneManipulations() ) then
	
		tab.AttachedEntityBoneManip = {}
	
		for i=0, self.AttachedEntity:GetBoneCount() do
		
			local t = {}
			
			local s = self.AttachedEntity:GetManipulateBoneScale( i )
			local a = self.AttachedEntity:GetManipulateBoneAngles( i )
			local p = self.AttachedEntity:GetManipulateBonePosition( i )
			
			if ( s != Vector( 1, 1, 1 ) ) then t[ 's' ] = s end -- scale
			if ( a != Angle( 0, 0, 0 ) ) then t[ 'a' ] = a end -- angle
			if ( p != Vector( 0, 0, 0 ) ) then t[ 'p' ] = p end -- position
		
			if ( table.Count( t ) > 0 ) then
				tab.AttachedEntityBoneManip[ i ] = t
			end
		
		end
	
	end


	-- Do NOT store the attached entity itself in our table!
	-- Otherwise, if we copy-paste the prop with the duplicator, its AttachedEntity value will point towards the original prop's attached entity instead, and that'll break stuff
	tab.AttachedEntity = nil

end


--[[---------------------------------------------------------
   Name: PostEntityPaste
-----------------------------------------------------------]]
function ENT:PostEntityPaste( ply )

	-- If we have any stored entity modifiers, bodygroups, or bone manipulations for our attached entity, then reapply them
	if IsValid( self.AttachedEntity ) then

		if ( self.AttachedEntityMods ) then

			self.AttachedEntity.EntityMods = table.Copy( self.AttachedEntityMods )
			duplicator.ApplyEntityModifiers( ply, self.AttachedEntity )
			self.AttachedEntityMods = nil
	
		end

		if ( self.AttachedEntityBodygroups ) then

			for k, v in pairs( self.AttachedEntityBodygroups ) do
				self.AttachedEntity:SetBodygroup( k, v )
			end
			self.AttachedEntityBodygroups = nil

		end

		if ( self.AttachedEntityBoneManip ) then

			duplicator.DoBoneManipulator( self.AttachedEntity, self.AttachedEntityBoneManip )
			self.AttachedEntityBoneManip = nil

		end

	end

end
