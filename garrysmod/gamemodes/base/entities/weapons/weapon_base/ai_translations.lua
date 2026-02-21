
--[[---------------------------------------------------------
	Name: SetupWeaponHoldTypeForAI
	Desc: Sets up ACT translations from generic activities to NPC specific activies. In a seperate file to clean up the init.lua
		Not all NPCs have support for all animations (for example Citizens don't have pistol animations)
		This only supports the holdtypes the default NPC models can support
		All of these are taken directly from IMPLEMENT_ACTTABLE() macro of the C++ weapons
-----------------------------------------------------------]]
function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}

	-- Default is pistol/revolver for reasons
	self.ActivityTranslateAI[ ACT_IDLE ]					= ACT_IDLE_PISTOL
	self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]				= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ ACT_RELOAD ]					= ACT_RELOAD_PISTOL
	self.ActivityTranslateAI[ ACT_WALK_AIM ]				= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_RUN_AIM ]					= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_GESTURE_RANGE_ATTACK1 ]	= ACT_GESTURE_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ ACT_RELOAD_LOW ]				= ACT_RELOAD_PISTOL_LOW

	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1_LOW ]		= ACT_RANGE_ATTACK_PISTOL_LOW
	self.ActivityTranslateAI[ ACT_COVER_LOW ]				= ACT_COVER_PISTOL_LOW
	self.ActivityTranslateAI[ ACT_RANGE_AIM_LOW ]			= ACT_RANGE_AIM_PISTOL_LOW
	self.ActivityTranslateAI[ ACT_GESTURE_RELOAD ]			= ACT_GESTURE_RELOAD_PISTOL

	self.ActivityTranslateAI[ ACT_WALK ]					= ACT_WALK_PISTOL
	self.ActivityTranslateAI[ ACT_RUN ]						= ACT_RUN_PISTOL

	self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]			= ACT_IDLE_PISTOL
	self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]			= ACT_IDLE_STIMULATED
	self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]			= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI[ ACT_IDLE_STEALTH ]			= ACT_IDLE_STEALTH_PISTOL

	self.ActivityTranslateAI[ ACT_WALK_RELAXED ]			= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_STIMULATED ]			= ACT_WALK_STIMULATED
	self.ActivityTranslateAI[ ACT_WALK_AGITATED ]			= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_WALK_STEALTH ]			= ACT_WALK_STEALTH_PISTOL

	self.ActivityTranslateAI[ ACT_RUN_RELAXED ]				= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_STIMULATED ]			= ACT_RUN_STIMULATED
	self.ActivityTranslateAI[ ACT_RUN_AGITATED ]			= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_RUN_STEALTH ]				= ACT_RUN_STEALTH_PISTOL

	self.ActivityTranslateAI[ ACT_IDLE_AIM_RELAXED ]		= ACT_IDLE_PISTOL
	self.ActivityTranslateAI[ ACT_IDLE_AIM_STIMULATED ]		= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI[ ACT_IDLE_AIM_AGITATED ]		= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI[ ACT_IDLE_AIM_STEALTH ]		= ACT_IDLE_STEALTH_PISTOL

	self.ActivityTranslateAI[ ACT_WALK_AIM_RELAXED ]		= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_AIM_STIMULATED ]		= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_WALK_AIM_AGITATED ]		= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_WALK_AIM_STEALTH ]		= ACT_WALK_AIM_STEALTH_PISTOL

	self.ActivityTranslateAI[ ACT_RUN_AIM_RELAXED ]			= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_STIMULATED ]		= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_RUN_AIM_AGITATED ]		= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI[ ACT_RUN_AIM_STEALTH ]			= ACT_RUN_AIM_STEALTH_PISTOL

	self.ActivityTranslateAI[ ACT_CROUCHIDLE_STIMULATED]		= ACT_CROUCHIDLE_STIMULATED
	self.ActivityTranslateAI[ ACT_CROUCHIDLE_AIM_STIMULATED ]	= ACT_RANGE_AIM_PISTOL_LOW
	self.ActivityTranslateAI[ ACT_CROUCHIDLE_AGITATED ]			= ACT_RANGE_AIM_PISTOL_LOW

	self.ActivityTranslateAI[ ACT_READINESS_RELAXED_TO_STIMULATED ]			= ACT_READINESS_PISTOL_RELAXED_TO_STIMULATED
	self.ActivityTranslateAI[ ACT_READINESS_RELAXED_TO_STIMULATED_WALK ]	= ACT_READINESS_PISTOL_RELAXED_TO_STIMULATED_WALK
	self.ActivityTranslateAI[ ACT_READINESS_AGITATED_TO_STIMULATED ]		= ACT_READINESS_PISTOL_AGITATED_TO_STIMULATED
	self.ActivityTranslateAI[ ACT_READINESS_STIMULATED_TO_RELAXED ]			= ACT_READINESS_PISTOL_STIMULATED_TO_RELAXED

	if ( t == "ar2" || t == "smg" ) then

		self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]		= ACT_RANGE_ATTACK_AR2
		self.ActivityTranslateAI[ ACT_RELOAD ]				= ACT_RELOAD_SMG1
		self.ActivityTranslateAI[ ACT_IDLE ]				= ACT_IDLE_SMG1
		self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]			= ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI[ ACT_WALK ]				= ACT_WALK_RIFLE
		self.ActivityTranslateAI[ ACT_WALK_AIM ]			= ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]		= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]		= ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]		= ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI[ ACT_WALK_RELAXED ]		= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_WALK_STIMULATED ]		= ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_WALK_AGITATED ]		= ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_RUN_RELAXED ]			= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_RUN_STIMULATED ]		= ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_RUN_AGITATED ]		= ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_IDLE_AIM_RELAXED ]		= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI[ ACT_IDLE_AIM_STIMULATED ]		= ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_IDLE_AIM_AGITATED ]		= ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI[ ACT_WALK_AIM_RELAXED ]		= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_WALK_AIM_STIMULATED ]		= ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_WALK_AIM_AGITATED ]		= ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_RUN_AIM_RELAXED ]			= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_RUN_AIM_STIMULATED ]		= ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_RUN_AIM_AGITATED ]		= ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_WALK_CROUCH ]				= ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI[ ACT_WALK_CROUCH_AIM ]			= ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ ACT_RUN ]						= ACT_RUN_RIFLE
		self.ActivityTranslateAI[ ACT_RUN_AIM ]					= ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI[ ACT_RUN_CROUCH ]				= ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI[ ACT_RUN_CROUCH_AIM ]			= ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ ACT_GESTURE_RANGE_ATTACK1 ]	= ACT_GESTURE_RANGE_ATTACK_AR2
		self.ActivityTranslateAI[ ACT_RANGE_ATTACK1_LOW ]		= ACT_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI[ ACT_COVER_LOW ]				= ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI[ ACT_RANGE_AIM_LOW ]			= ACT_RANGE_AIM_AR2_LOW
		self.ActivityTranslateAI[ ACT_RELOAD_LOW ]				= ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI[ ACT_GESTURE_RELOAD ]			= ACT_GESTURE_RELOAD_SMG1

		-- Extra overrides for SMG holdtype
		if ( t == "smg" ) then
			self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ ACT_GESTURE_RANGE_ATTACK1 ]	= ACT_GESTURE_RANGE_ATTACK_SMG1
			self.ActivityTranslateAI[ ACT_RANGE_AIM_LOW ]			= ACT_RANGE_AIM_SMG1_LOW
		end

		return
	end

	if ( t == "shotgun" || t == "crossbow" ) then
		self.ActivityTranslateAI[ ACT_IDLE ]			= ACT_IDLE_SMG1

		self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]	= ACT_RANGE_ATTACK_SHOTGUN
		self.ActivityTranslateAI[ ACT_RELOAD ]			= ACT_RELOAD_SHOTGUN
		self.ActivityTranslateAI[ ACT_WALK ]			= ACT_WALK_RIFLE
		self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]		= ACT_IDLE_ANGRY_SHOTGUN

		self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]	= ACT_IDLE_SHOTGUN_RELAXED
		self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]	= ACT_IDLE_SHOTGUN_STIMULATED
		self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]	= ACT_IDLE_SHOTGUN_AGITATED

		self.ActivityTranslateAI[ ACT_WALK_RELAXED ]	= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_WALK_STIMULATED ]	= ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_WALK_AGITATED ]	= ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_RUN_RELAXED ]		= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_RUN_STIMULATED ]	= ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_RUN_AGITATED ]	= ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_IDLE_AIM_RELAXED ]	= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI[ ACT_IDLE_AIM_STIMULATED ]	= ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_IDLE_AIM_AGITATED ]	= ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI[ ACT_WALK_AIM_RELAXED ]	= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_WALK_AIM_STIMULATED ]	= ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_WALK_AIM_AGITATED ]	= ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_RUN_AIM_RELAXED ]		= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI[ ACT_RUN_AIM_STIMULATED ]	= ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI[ ACT_RUN_AIM_AGITATED ]	= ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI[ ACT_WALK_AIM ]				= ACT_WALK_AIM_SHOTGUN
		self.ActivityTranslateAI[ ACT_WALK_CROUCH ]				= ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI[ ACT_WALK_CROUCH_AIM ]			= ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ ACT_RUN ]						= ACT_RUN_RIFLE
		self.ActivityTranslateAI[ ACT_RUN_AIM ]					= ACT_RUN_AIM_SHOTGUN
		self.ActivityTranslateAI[ ACT_RUN_CROUCH ]				= ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI[ ACT_RUN_CROUCH_AIM ]			= ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI[ ACT_GESTURE_RANGE_ATTACK1 ]	= ACT_GESTURE_RANGE_ATTACK_SHOTGUN
		self.ActivityTranslateAI[ ACT_RANGE_ATTACK1_LOW ]		= ACT_RANGE_ATTACK_SHOTGUN_LOW
		self.ActivityTranslateAI[ ACT_RELOAD_LOW ]				= ACT_RELOAD_SHOTGUN_LOW
		self.ActivityTranslateAI[ ACT_GESTURE_RELOAD ]			= ACT_GESTURE_RELOAD_SHOTGUN

		return
	end

	if ( t == "rpg" ) then
		self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]		= ACT_RANGE_ATTACK_RPG

		self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]		= ACT_IDLE_RPG_RELAXED
		self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]		= ACT_IDLE_ANGRY_RPG
		self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]		= ACT_IDLE_ANGRY_RPG

		self.ActivityTranslateAI[ ACT_IDLE ]				= ACT_IDLE_RPG
		self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]			= ACT_IDLE_ANGRY_RPG
		self.ActivityTranslateAI[ ACT_WALK ]				= ACT_WALK_RPG
		self.ActivityTranslateAI[ ACT_WALK_CROUCH ]			= ACT_WALK_CROUCH_RPG
		self.ActivityTranslateAI[ ACT_RUN ]					= ACT_RUN_RPG
		self.ActivityTranslateAI[ ACT_RUN_CROUCH ]			= ACT_RUN_CROUCH_RPG
		self.ActivityTranslateAI[ ACT_COVER_LOW ]			= ACT_COVER_LOW_RPG

		return
	end

end
