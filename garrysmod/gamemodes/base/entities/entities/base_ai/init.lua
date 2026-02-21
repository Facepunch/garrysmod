
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "schedules.lua" )
include( "tasks.lua" )

-- Variables

ENT.m_fMaxYawSpeed = 200 -- Max turning speed
ENT.m_iClass = CLASS_CITIZEN_REBEL -- NPC Class

AccessorFunc( ENT, "m_iClass", "NPCClass" )
AccessorFunc( ENT, "m_fMaxYawSpeed", "MaxYawSpeed" )

function ENT:Initialize()

	-- Some default calls to make the NPC function
	self:SetModel( "models/alyx.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX )
	self:SetMoveType( MOVETYPE_STEP )
	self:CapabilitiesAdd( bit.bor( CAP_MOVE_GROUND, CAP_OPEN_DOORS, CAP_ANIMATEDFACE, CAP_SQUAD, CAP_USE_WEAPONS, CAP_DUCK, CAP_MOVE_SHOOT, CAP_TURN_HEAD, CAP_USE_SHOT_REGULATOR, CAP_AIM_GUN ) )

	self:SetHealth( 100 )

end

--[[---------------------------------------------------------
	Name: OnTakeDamage
	Desc: Called when the NPC takes damage
-----------------------------------------------------------]]
function ENT:OnTakeDamage( dmginfo )

--[[
	Msg( tostring(dmginfo) .. "\n" )
	Msg( "Inflictor:\t" .. tostring(dmginfo:GetInflictor()) .. "\n" )
	Msg( "Attacker:\t" .. tostring(dmginfo:GetAttacker()) .. "\n" )
	Msg( "Damage:\t" .. tostring(dmginfo:GetDamage()) .. "\n" )
	Msg( "Base Damage:\t" .. tostring(dmginfo:GetBaseDamage()) .. "\n" )
	Msg( "Force:\t" .. tostring(dmginfo:GetDamageForce()) .. "\n" )
	Msg( "Position:\t" .. tostring(dmginfo:GetDamagePosition()) .. "\n" )
	Msg( "Reported Pos:\t" .. tostring(dmginfo:GetReportedPosition()) .. "\n" ) -- ??
--]]

	-- return 1

end



--[[---------------------------------------------------------
	Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller, type, value )
end

--[[---------------------------------------------------------
	Name: StartTouch
-----------------------------------------------------------]]
function ENT:StartTouch( entity )
end

--[[---------------------------------------------------------
	Name: EndTouch
-----------------------------------------------------------]]
function ENT:EndTouch( entity )
end

--[[---------------------------------------------------------
	Name: Touch
-----------------------------------------------------------]]
function ENT:Touch( entity )
end

--[[---------------------------------------------------------
	Name: GetRelationship
		Return the relationship between this NPC and the
		passed entity. If you don't return anything then
		the default disposition will be used.
-----------------------------------------------------------]]
function ENT:GetRelationship( entity )

	--return D_NU

end

--[[---------------------------------------------------------
	Name: ExpressionFinished
		Called when an expression has finished. Duh.
-----------------------------------------------------------]]
function ENT:ExpressionFinished( strExp )

end

--[[---------------------------------------------------------
	Name: OnChangeActivity
-----------------------------------------------------------]]
function ENT:OnChangeActivity( act )

end

--[[---------------------------------------------------------
	Name: Think
-----------------------------------------------------------]]
function ENT:Think()

end

-- Called to update which sounds the NPC should be able to hear
function ENT:GetSoundInterests()
	-- Hear thumper sound hints
	-- return 256
end

-- Called when NPC's movement fails
function ENT:OnMovementFailed()
end

-- Called when NPC's movement succeeds
function ENT:OnMovementComplete()
end

-- Called when the NPC's active weapon changes
function ENT:OnActiveWeaponChanged( old, new )
end

--[[---------------------------------------------------------
	Name: GetAttackSpread
		How good is the NPC with this weapon? Return the number
		of degrees of inaccuracy for the NPC to use.
-----------------------------------------------------------]]
function ENT:GetAttackSpread( Weapon, Target )
	return 0.1
end
