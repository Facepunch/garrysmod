--[[---------------------------------------------------------

  Sandbox Gamemode

  This is GMod's default gamemode

-----------------------------------------------------------]]

-- These files get sent to the client

AddCSLuaFile( "cl_hints.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_notice.lua" )
AddCSLuaFile( "cl_search_models.lua" )
AddCSLuaFile( "cl_spawnmenu.lua" )
AddCSLuaFile( "cl_worldtips.lua" )
AddCSLuaFile( "persistence.lua" )
AddCSLuaFile( "player_extension.lua" )
AddCSLuaFile( "save_load.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "gui/IconEditor.lua" )

include( 'shared.lua' )
include( 'commands.lua' )
include( 'player.lua' )
include( 'spawnmenu/init.lua' )

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )

--[[---------------------------------------------------------
	Name: gamemode:PlayerSpawn()
	Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn( pl, transiton )

	player_manager.SetPlayerClass( pl, "player_sandbox" )

	BaseClass.PlayerSpawn( self, pl, transiton )

end

--[[---------------------------------------------------------
	Name: gamemode:OnPhysgunFreeze( weapon, phys, ent, player )
	Desc: The physgun wants to freeze a prop
-----------------------------------------------------------]]
function GM:OnPhysgunFreeze( weapon, phys, ent, ply )

	-- Don't freeze persistent props (should already be frozen)
	if ( ent:GetPersistent() && GetConVarString( "sbox_persist" ):Trim() != "" ) then return false end

	BaseClass.OnPhysgunFreeze( self, weapon, phys, ent, ply )

	ply:SendHint( "PhysgunUnfreeze", 0.3 )
	ply:SuppressHint( "PhysgunFreeze" )

end

--[[---------------------------------------------------------
	Name: gamemode:OnPhysgunReload( weapon, player )
	Desc: The physgun wants to unfreeze
-----------------------------------------------------------]]
function GM:OnPhysgunReload( weapon, ply )

	local num = ply:PhysgunUnfreeze()

	if ( num > 0 ) then
		ply:SendLua( string.format( "GAMEMODE:UnfrozeObjects(%d)", num ) )
	end

	ply:SuppressHint( "PhysgunUnfreeze" )

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerShouldTakeDamage
	Return true if this player should take damage from this attacker
	Note: This is a shared function - the client will think they can
		damage the players even though they can't. This just means the
		prediction will show blood.
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage( ply, attacker )

	-- Global godmode, players can't be damaged in any way
	if ( cvars.Bool( "sbox_godmode", false ) ) then return false end

	-- No player vs player damage
	if ( attacker:IsValid() && attacker:IsPlayer() && ply != attacker ) then
		return cvars.Bool( "sbox_playershurtplayers", true )
	end

	-- Default, let the player be hurt
	return true

end

--[[---------------------------------------------------------
	Show the search when f1 is pressed
-----------------------------------------------------------]]
function GM:ShowHelp( ply )

	ply:SendLua( "hook.Run( 'StartSearch' )" )

end

--[[---------------------------------------------------------
	Called once on the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn( ply, transiton )

	BaseClass.PlayerInitialSpawn( self, ply, transiton )

end

--[[---------------------------------------------------------
	A ragdoll of an entity has been created
-----------------------------------------------------------]]
function GM:CreateEntityRagdoll( entity, ragdoll )

	-- Replace the entity with the ragdoll in cleanups etc
	undo.ReplaceEntity( entity, ragdoll )
	cleanup.ReplaceEntity( entity, ragdoll )

end

--[[---------------------------------------------------------
	Player unfroze an object
-----------------------------------------------------------]]
function GM:PlayerUnfrozeObject( ply, entity, physobject )

	local effectdata = EffectData()
	effectdata:SetOrigin( physobject:GetPos() )
	effectdata:SetEntity( entity )
	util.Effect( "phys_unfreeze", effectdata, true, true )

end

--[[---------------------------------------------------------
	Player froze an object
-----------------------------------------------------------]]
function GM:PlayerFrozeObject( ply, entity, physobject )

	if ( DisablePropCreateEffect ) then return end

	local effectdata = EffectData()
	effectdata:SetOrigin( physobject:GetPos() )
	effectdata:SetEntity( entity )
	util.Effect( "phys_freeze", effectdata, true, true )

end

--
-- Who can edit variables?
-- If you're writing prop protection or something, you'll
-- probably want to hook or override this function.
--
function GM:CanEditVariable( ent, ply, key, val, editor )

	-- Only allow admins to edit admin only variables!
	local isAdmin = ply:IsAdmin() || game.SinglePlayer()
	if ( editor.AdminOnly && !isAdmin ) then
		return false
	end

	-- This entity decides who can edit its variables
	if ( isfunction( ent.CanEditVariables ) ) then
		return ent:CanEditVariables( ply )
	end

	-- default in sandbox is.. anyone can edit anything.
	return true

end
