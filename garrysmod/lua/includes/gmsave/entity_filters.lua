
local ClassInfo = {} 

ClassInfo[ "scene_manager" ]				= { ['save'] = false }
ClassInfo[ "predicted_viewmodel" ]			= { ['save'] = false }
ClassInfo[ "player" ]						= { ['save'] = false }
ClassInfo[ "physgun_beam" ]					= { ['save'] = false }
ClassInfo[ "worldspawn" ]					= { ['save'] = false }
ClassInfo[ "player_manager" ]				= { ['save'] = false }
ClassInfo[ "bodyque" ]						= { ['save'] = false }
ClassInfo[ "info_player_start" ]			= { ['save'] = false }
ClassInfo[ "ai_hint" ]						= { ['save'] = false }
ClassInfo[ "ai_network" ]					= { ['save'] = false }
ClassInfo[ "light" ]						= { ['save'] = false }
ClassInfo[ "ai_network" ]					= { ['save'] = false }
ClassInfo[ "env_tonemap_controller" ]		= { ['save'] = false }
ClassInfo[ "path_corner" ]					= { ['save'] = false }
ClassInfo[ "point_spotlight" ]				= { ['save'] = false }
ClassInfo[ "func_brush" ]					= { ['save'] = false }
ClassInfo[ "water_lod_control" ]			= { ['save'] = false }
ClassInfo[ "spotlight_end" ]				= { ['save'] = false }
ClassInfo[ "beam" ]							= { ['save'] = false }
ClassInfo[ "lua_run" ]						= { ['save'] = false }
ClassInfo[ "trigger_multiple" ]				= { ['save'] = false }
ClassInfo[ "func_button" ]					= { ['save'] = false }
ClassInfo[ "soundent" ]						= { ['save'] = false }
ClassInfo[ "sky_camera" ]					= { ['save'] = false }
ClassInfo[ "env_fog_controller" ]			= { ['save'] = false }
ClassInfo[ "env_sun" ]						= { ['save'] = false }
ClassInfo[ "phys_constraintsystem" ]		= { ['save'] = false }
ClassInfo[ "keyframe_rope" ]				= { ['save'] = false }
ClassInfo[ "logic_auto" ]					= { ['save'] = false }
ClassInfo[ "physics_npc_solver" ]			= { ['save'] = false }
ClassInfo[ "env_sun" ]						= { ['save'] = false }
ClassInfo[ "env_wind" ]						= { ['save'] = false }
ClassInfo[ "env_fog_controller" ]			= { ['save'] = false }
ClassInfo[ "infodecal" ]					= { ['save'] = false }
ClassInfo[ "info_projecteddecal" ]			= { ['save'] = false }
ClassInfo[ "info_node" ]					= { ['save'] = false }
ClassInfo[ "info_map_parameters" ]			= { ['save'] = false }
ClassInfo[ "info_ladder" ]					= { ['save'] = false }
ClassInfo[ "path_corner" ]					= { ['save'] = false }
ClassInfo[ "point_viewcontrol" ]			= { ['save'] = false }
ClassInfo[ "scene_manager" ]				= { ['save'] = false }
ClassInfo[ "shadow_control" ]				= { ['save'] = false }
ClassInfo[ "sky_camera" ]					= { ['save'] = false }
ClassInfo[ "soundent" ]						= { ['save'] = false }

function gmsave.ShouldSaveEntity( ent, t )

	local info = ClassInfo[ t.classname ]

	--
	-- Filtered out - we don't want to save these entity types!
	--
	if ( info && info.save == false ) then return false end

	--
	-- Should we save the parent entity?
	-- If not, don't save this!
	--
	local parent = ent:GetParent()
	if ( IsValid( parent ) ) then
		if ( !gmsave.ShouldSaveEntity( parent, parent:GetSaveTable() ) ) then return false end
	end

	--
	-- If this is a weapon, and it has a valid owner.. don't save it!
	--
	if ( ent:IsWeapon() && IsValid( ent:GetOwner() ) ) then
		return false
	end

	--
	-- Default action is to save..
	--
	return true

end
