
AddCSLuaFile()

if ( CLIENT ) then
	CreateConVar( "cl_draweffectrings", "1", 0, "Should the effect green rings be visible?" )
end

ENT.Type = "anim"

ENT.Spawnable = false

function ENT:Initialize()

	local Radius = 6
	local mins = Vector( 1, 1, 1 ) * Radius * -0.5
	local maxs = Vector( 1, 1, 1 ) * Radius * 0.5

	if ( SERVER ) then

		self.AttachedEntity = ents.Create( "prop_dynamic" )
		self.AttachedEntity:SetModel( self:GetModel() )
		self.AttachedEntity:SetAngles( self:GetAngles() )
		self.AttachedEntity:SetPos( self:GetPos() )
		self.AttachedEntity:SetSkin( self:GetSkin() )
		self.AttachedEntity:Spawn()
		self.AttachedEntity:SetParent( self )
		self.AttachedEntity:DrawShadow( false )

		self:SetModel( "models/props_junk/watermelon01.mdl" )

		self:DeleteOnRemove( self.AttachedEntity )
		self.AttachedEntity:DeleteOnRemove( self )

		-- Don't use the model's physics - create a box instead
		self:PhysicsInitBox( mins, maxs )
		self:SetSolid( SOLID_VPHYSICS )

		-- Set up our physics object here
		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:Wake()
			phys:EnableGravity( false )
			phys:EnableDrag( false )
		end

		self:DrawShadow( false )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	else

		-- So addons can override this
		self.GripMaterial = Material( "sprites/grip" )
		self.GripMaterialHover = Material( "sprites/grip_hover" )

		-- Get the attached entity so that clientside functions like properties can interact with it
		local tab = ents.FindByClassAndParent( "prop_dynamic", self )
		if ( tab && IsValid( tab[ 1 ] ) ) then self.AttachedEntity = tab[ 1 ] end

	end

	-- Set collision bounds exactly
	self:SetCollisionBounds( mins, maxs )

end

function ENT:Draw()

	if ( halo.RenderedEntity() == self ) then
		self.AttachedEntity:DrawModel()
		return
	end

	if ( GetConVarNumber( "cl_draweffectrings" ) == 0 ) then return end

	-- Don't draw the grip if there's no chance of us picking it up
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ( !IsValid( wep ) ) then return end

	local weapon_name = wep:GetClass()

	if ( weapon_name != "weapon_physgun" && weapon_name != "weapon_physcannon" && weapon_name != "gmod_tool" ) then
		return
	end

	if ( self:BeingLookedAtByLocalPlayer() ) then
		render.SetMaterial( self.GripMaterialHover )
	else
		render.SetMaterial( self.GripMaterial )
	end

	render.DrawSprite( self:GetPos(), 16, 16, color_white )

end

-- Copied from base_gmodentity.lua
ENT.MaxWorldTipDistance = 256
function ENT:BeingLookedAtByLocalPlayer()
	local ply = LocalPlayer()
	if ( !IsValid( ply ) ) then return false end

	local view = ply:GetViewEntity()
	local dist = self.MaxWorldTipDistance
	dist = dist * dist

	-- If we're spectating a player, perform an eye trace
	if ( view:IsPlayer() ) then
		return view:EyePos():DistToSqr( self:GetPos() ) <= dist && view:GetEyeTrace().Entity == self
	end

	-- If we're not spectating a player, perform a manual trace from the entity's position
	local pos = view:GetPos()

	if ( pos:DistToSqr( self:GetPos() ) <= dist ) then
		return util.TraceLine( {
			start = pos,
			endpos = pos + ( view:GetAngles():Forward() * dist ),
			filter = view
		} ).Entity == self
	end

	return false
end

function ENT:PhysicsUpdate( physobj )

	if ( CLIENT ) then return end

	-- Don't do anything if the player isn't holding us
	if ( !self:IsPlayerHolding() && !self:IsConstrained() ) then

		physobj:SetVelocity( vector_origin )
		physobj:Sleep()

	end

end

function ENT:OnEntityCopyTableFinish( tab )

	-- We need to store the model of the attached entity
	-- Not the one we have here.
	tab.Model = self.AttachedEntity:GetModel()

	-- Store the attached entity's table so we can restore it after being pasted
	tab.AttachedEntityInfo = table.Copy( duplicator.CopyEntTable( self.AttachedEntity ) )
	tab.AttachedEntityInfo.Pos = nil -- Don't even save angles and position, we are a parented entity
	tab.AttachedEntityInfo.Angle = nil

	-- Do NOT store the attached entity itself in our table!
	-- Otherwise, if we copy-paste the prop with the duplicator, its AttachedEntity value will point towards the original prop's attached entity instead, and that'll break stuff
	tab.AttachedEntity = nil

end

function ENT:PostEntityPaste( ply )

	-- Restore the attached entity using the information we've saved
	if ( IsValid( self.AttachedEntity ) && self.AttachedEntityInfo ) then

		-- Apply skin, bodygroups, bone manipulator, etc.
		duplicator.DoGeneric( self.AttachedEntity, self.AttachedEntityInfo )

		if ( self.AttachedEntityInfo.EntityMods ) then
			self.AttachedEntity.EntityMods = table.Copy( self.AttachedEntityInfo.EntityMods )
			duplicator.ApplyEntityModifiers( ply, self.AttachedEntity )
		end

		if ( self.AttachedEntityInfo.BoneMods ) then
			self.AttachedEntity.BoneMods = table.Copy( self.AttachedEntityInfo.BoneMods )
			duplicator.ApplyBoneModifiers( ply, self.AttachedEntity )
		end

		self.AttachedEntityInfo = nil

	end

end
