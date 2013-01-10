
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.RenderGroup 		= RENDERGROUP_OPAQUE


--
-- Set up our data table
--
function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Toggle" );
	self:NetworkVar( "Float", 0, "Direction" );

end

--
--   Name: Initialize
--
function ENT:Initialize()

	if ( SERVER ) then

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	
		self:SetToggle( false )
	
		self.ToggleState = false
		self.BaseTorque = 1
		self.TorqueScale = 1

	end
	
end

--
--   Sets the base torque
--
function ENT:SetBaseTorque( base )

	self.BaseTorque = base
	if ( self.BaseTorque == 0 ) then self.BaseTorque = 1 end
	self:UpdateOverlayText()

end

--
--  Refresh the entity overlay text
--
function ENT:UpdateOverlayText()
	
	self:SetOverlayText( "Torque: " .. math.floor( self.BaseTorque ) )

end

--[[---------------------------------------------------------
   Sets the axis (world space)
-----------------------------------------------------------]]
function ENT:SetAxis( vec )

	self.Axis = self:GetPos() + vec * 512
	self.Axis = self:NearestPoint( self.Axis )
	self.Axis = self:WorldToLocal( self.Axis )

end

--[[---------------------------------------------------------
   Name: OnTakeDamage
   Desc: Entity takes damage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )

	self:TakePhysicsDamage( dmginfo )

end


--
-- Set the motor constraint
--
function ENT:SetMotor( Motor )

	self.Motor = Motor

end

--
-- Get the motor constraint :)
--
function ENT:GetMotor()

	--
	-- Fuck knows why it's doing this here.
	--
	if ( !IsValid( self.Motor ) ) then

		self.Motor = constraint.FindConstraintEntity( self.Entity, "Motor" )

	end

	return self.Motor

end

--[[---------------------------------------------------------
   Forward key is pressed/released
-----------------------------------------------------------]]
function ENT:Forward( onoff, mul )

	--
	-- Is this entity invalid now? 
	-- If so return false to remove it
	--
	if ( !IsValid( self ) ) then return false end

	local Motor = self:GetMotor()
	if ( !IsValid( Motor ) ) then return false end
	
	local toggle = self:GetToggle()	
	
	--
	-- If we're toggle mode and the key has been 
	-- released then just return.
	--
	if ( toggle && !onoff ) then return true end
	
	mul = mul or 1
	local Speed = Motor.direction * mul * self.TorqueScale

	if ( !onoff ) then Speed = 0 end
	
	if ( toggle && onoff ) then
	
		self.ToggleState = !self.ToggleState
		
		if ( !self.ToggleState ) then
			Speed = 0
		end
	
	end
	
	Motor:Fire( "Scale", Speed, 0 )
	Motor.forcescale = Speed
	Motor:Fire( "Activate", "" , 0 )
	
	return true
	
end

--
-- Reverse key is pressed/released
--
function ENT:Reverse( onoff )
	return self:Forward( onoff, -1 )
end


--
-- Register numpad functions
--
if ( SERVER ) then 

	numpad.Register( "WheelForward", function( pl, ent, onoff )

		if ( !IsValid( ent) ) then return false end

		return ent:Forward( onoff )

	end )

	numpad.Register( "WheelReverse", function( pl, ent, onoff )

		if ( !IsValid( ent) ) then return false end

		return ent:Reverse( onoff )

	end )

end

--
--   Todo? Scale Motor.direction?
--
function ENT:SetTorque( torque )

	if ( self.BaseTorque == 0 ) then self.BaseTorque = 1 end
	
	self.TorqueScale = torque / self.BaseTorque
	
	local Motor = self:GetMotor()
	if (!Motor || !Motor:IsValid()) then return end
	Motor:Fire( "Scale", Motor.direction * Motor.forcescale * self.TorqueScale , 0 )
	
	self:SetOverlayText( "Torque: " .. math.floor( torque ) )

end

--
--   Creates the direction arrows on the wheel
--
function ENT:DoDirectionEffect()

	local Motor = self:GetMotor()

	if ( !IsValid( Motor ) ) then return end

	local effectdata = EffectData()

		effectdata:SetOrigin( self.Axis )
		effectdata:SetEntity( self.Entity )
		effectdata:SetScale( Motor.direction )

	util.Effect( "wheel_indicator", effectdata, true, true )	
	
end

--[[---------------------------------------------------------
   Reverse the wheel direction when a player uses the wheel
-----------------------------------------------------------]]
function ENT:Use( activator, caller, type, value )
		
	local Motor = self:GetMotor()
	local Owner = self:GetPlayer()
	
	if ( IsValid( Motor ) and (Owner == nil or Owner == activator) ) then

		if ( Motor.direction == 1 ) then
			Motor.direction = -1
		else
			Motor.direction = 1
		end

		Motor:Fire( "Scale", Motor.direction * Motor.forcescale * self.TorqueScale, 0 )
		self:SetDirection( Motor.direction )
	
		self:DoDirectionEffect()
		
	end
	
end

