-- Store holdtypes for registration by jump activity
-- This prevents having to change ACT_HL2MP_JUMP -> ACT_HL2MP_JUMP_SLAM manually
local JumpActs = {
	[ "pistol" ]		= ACT_HL2MP_JUMP_PISTOL,
	[ "smg" ]			= ACT_HL2MP_JUMP_SMG1,
	[ "grenade" ]		= ACT_HL2MP_JUMP_GRENADE,
	[ "ar2" ]			= ACT_HL2MP_JUMP_AR2,
	[ "shotgun" ]		= ACT_HL2MP_JUMP_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_JUMP_RPG,
	[ "physgun" ]		= ACT_HL2MP_JUMP_PHYSGUN,
	[ "crossbow" ]		= ACT_HL2MP_JUMP_CROSSBOW,
	[ "melee" ]			= ACT_HL2MP_JUMP_MELEE,
	[ "slam" ]			= ACT_HL2MP_JUMP_SLAM,
	[ "normal" ]		= ACT_HL2MP_JUMP_SLAM, -- "normal" jump animation/ACT_HL2MP_JUMP doesn't exist in m_anm
	[ "fist" ]			= ACT_HL2MP_JUMP_FIST,
	[ "melee2" ]		= ACT_HL2MP_JUMP_MELEE2,
	[ "passive" ]		= ACT_HL2MP_JUMP_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_JUMP_KNIFE,
	[ "duel" ]			= ACT_HL2MP_JUMP_DUEL,
	[ "camera" ]		= ACT_HL2MP_JUMP_CAMERA,
	[ "magic" ]			= ACT_HL2MP_JUMP_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_JUMP_REVOLVER
}

local HoldTypes = {}

for holdtype, jumpact in pairs( JumpActs ) do
	local acttbl = {}
	HoldTypes[ holdtype ] = acttbl
	local suffix = holdtype == "normal" && "" || holdtype == "smg" && "_SMG1" || "_" .. string.upper( holdtype )

	acttbl[ ACT_MP_STAND_IDLE ]						= _G[ "ACT_HL2MP_IDLE".. suffix ]
	acttbl[ ACT_MP_WALK ]							= _G[ "ACT_HL2MP_WALK".. suffix ]
	acttbl[ ACT_MP_CROUCH_IDLE ]					= _G[ "ACT_HL2MP_IDLE_CROUCH".. suffix ]
	acttbl[ ACT_MP_CROUCHWALK ]						= _G[ "ACT_HL2MP_WALK_CROUCH".. suffix ]
	acttbl[ ACT_MP_SWIM ]							= _G[ "ACT_HL2MP_SWIM" .. suffix ]
	acttbl[ ACT_MP_SWIM_IDLE ]						= _G[ "ACT_HL2MP_SWIM_IDLE" .. suffix ]

	acttbl[ ACT_MP_JUMP ]							= jumpact

	local sitact									= _G[ "ACT_HL2MP_SIT".. suffix ]
	acttbl[ ACT_BUSY_SIT_GROUND ]					= sitact
	acttbl[ ACT_BUSY_SIT_CHAIR ]					= sitact

	local runact									= _G[ "ACT_HL2MP_RUN".. suffix ]
	acttbl[ ACT_MP_RUN ]							= runact
	acttbl[ ACT_MP_SPRINT ]							= runact

	local attackact									= _G[ "ACT_HL2MP_GESTURE_RANGE_ATTACK" .. suffix ]
	acttbl[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]		= attackact
	acttbl[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]		= attackact
	acttbl[ ACT_MP_ATTACK_SWIM_PRIMARYFIRE ]		= attackact
	acttbl[ ACT_MP_ATTACK_AIRWALK_PRIMARYFIRE ]		= attackact
	acttbl[ ACT_MP_ATTACK_STAND_SECONDARYFIRE ]		= attackact
	acttbl[ ACT_MP_ATTACK_CROUCH_SECONDARYFIRE ]	= attackact
	acttbl[ ACT_MP_ATTACK_SWIM_SECONDARYFIRE ]		= attackact
	acttbl[ ACT_MP_ATTACK_AIRWALK_SECONDARYFIRE ]	= attackact

	-- Grenade attacking regardless of holdtype
	local grenadeact								= ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
	acttbl[ ACT_MP_ATTACK_STAND_GRENADE ]			= grenadeact
	acttbl[ ACT_MP_ATTACK_CROUCH_GRENADE ]			= grenadeact
	acttbl[ ACT_MP_ATTACK_SWIM_GRENADE ]			= grenadeact
	acttbl[ ACT_MP_ATTACK_AIRWALK_GRENADE ]			= grenadeact

	local reloadact									= _G[ "ACT_HL2MP_GESTURE_RELOAD" .. suffix ]
	acttbl[ ACT_MP_RELOAD_STAND ]					= reloadact
	acttbl[ ACT_MP_RELOAD_CROUCH ]					= reloadact
	acttbl[ ACT_MP_RELOAD_SWIM ]					= reloadact
	acttbl[ ACT_MP_RELOAD_AIRWALK ]					= reloadact
end

function SWEP:SetWeaponHoldType( holdtype )
	holdtype = string.lower( holdtype )
	local acttbl = HoldTypes[ holdtype ]

	if ( acttbl == nil ) then
		Msg( "SWEP:SetWeaponHoldType - invalid holdtype \"" .. holdtype .. "\", defaulting to \"normal\"\n" )
		holdtype = "normal"
		acttbl = HoldTypes[ holdtype ]
	end

	local ActivityTranslate = {}
	self.ActivityTranslate = ActivityTranslate

	-- Shallow copy
	for k, v in pairs( acttbl ) do
		ActivityTranslate[ k ] = v
	end

	self:SetupWeaponHoldTypeForAI( holdtype )
end

-- Default hold pos is the pistol
SWEP:SetWeaponHoldType( "pistol" )

function SWEP:TranslateActivity( act )
	local newact

	if ( self:GetOwner():IsNPC() ) then
		newact = self.ActivityTranslateAI[ act ]
	else
		newact = self.ActivityTranslate[ act ]
	end

	return newact || -1
end