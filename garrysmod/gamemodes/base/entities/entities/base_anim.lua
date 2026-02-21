
AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

-- Defaulting this to OFF. This will automatically save bandwidth
-- on stuff that is already out there, but might break a few things
-- that are out there. I'm choosing to break those things because
-- there are a lot less of them that are actually using the animtime

ENT.AutomaticFrameAdvance = false

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end


function ENT:OnRemove()
end


function ENT:PhysicsCollide( data, physobj )
end


function ENT:PhysicsUpdate( physobj )
end

if ( CLIENT ) then

	function ENT:Draw( flags )

		self:DrawModel( flags )

	end

	function ENT:DrawTranslucent( flags )

		-- This is here just to make it backwards compatible.
		-- You shouldn't really be drawing your model here unless it's translucent

		self:Draw( flags )

	end

end

if ( SERVER ) then

	function ENT:OnTakeDamage( dmginfo )

	--[[
		Msg( tostring(dmginfo) .. "\n" )
		Msg( "Inflictor:\t" .. tostring(dmginfo:GetInflictor()) .. "\n" )
		Msg( "Attacker:\t" .. tostring(dmginfo:GetAttacker()) .. "\n" )
		Msg( "Damage:\t" .. tostring(dmginfo:GetDamage()) .. "\n" )
		Msg( "Base Damage:\t" .. tostring(dmginfo:GetBaseDamage()) .. "\n" )
		Msg( "Force:\t" .. tostring(dmginfo:GetDamageForce()) .. "\n" )
		Msg( "Position:\t" .. tostring(dmginfo:GetDamagePosition()) .. "\n" )
		Msg( "Reported Pos:\t" .. tostring(dmginfo:GetReportedPosition()) .. "\n" )	-- ??
	--]]

	end


	function ENT:Use( activator, caller, type, value )
	end


	function ENT:StartTouch( entity )
	end


	function ENT:EndTouch( entity )
	end


	function ENT:Touch( entity )
	end

	--[[---------------------------------------------------------
	   Name: Simulate
	   Desc: Controls/simulates the physics on the entity.
		Officially the most complicated callback in the whole mod.
		 Returns 3 variables..
		 1. A SIM_ enum
		 2. A vector representing the linear acceleration/force
		 3. A vector represending the angular acceleration/force
		If you're doing nothing you can return SIM_NOTHING
		Note that you need to call ent:StartMotionController to tell the entity
			to start calling this function..
	-----------------------------------------------------------]]
	function ENT:PhysicsSimulate( phys, deltatime )
		return SIM_NOTHING
	end

end
