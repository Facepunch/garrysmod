---------------
	ENTITY UPDATE PRIORITY BY DISTANCE

	Reduces server bandwidth and CPU by hiding distant entities
	from players using SetPreventTransmit. Entities beyond a
	configurable range are not networked to the player.

	This effectively creates distance-based entity culling,
	which the engine does for rendering but NOT for networking.

	Convars:
		sv_entpriority_enable 1   - Enable/disable the system
		sv_entpriority_range 4000 - Distance in units (default 4000)
		sv_entpriority_rate 0.5   - How often to update (seconds)
		sv_entpriority_info       - Print current settings

	Excluded entity types (always transmitted):
		- Players
		- Weapons held by players
		- Worldspawn
		- Entities parented to players
----------------

if ( !SERVER ) then return end

local Enabled = false
local MaxRange = 4000
local UpdateRate = 0.5
local LastUpdate = 0

-- Classes to never cull (always transmit)
local NeverCull = {
	["worldspawn"] = true,
	["player"] = true,
	["gmod_hands"] = true,
	["predicted_viewmodel"] = true,
	["env_skypaint"] = true,
	["env_sun"] = true,
	["shadow_control"] = true,
	["env_tonemap_controller"] = true,
	["light_environment"] = true,
	["player_manager"] = true,
}

-- ConVars
concommand.Add( "sv_entpriority_enable", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local val = tonumber( args[ 1 ] )
	if ( val == nil ) then
		print( "[EntPriority] Currently " .. ( Enabled and "ENABLED" or "DISABLED" ) )
		return
	end
	Enabled = ( val == 1 )
	print( "[EntPriority] " .. ( Enabled and "ENABLED" or "DISABLED" ) )

	-- If disabling, clear all prevent transmit flags
	if ( !Enabled ) then
		for _, ent in ipairs( ents.GetAll() ) do
			if ( IsValid( ent ) and !ent:IsPlayer() ) then
				for _, ply in player.Iterator() do
					ent:SetPreventTransmit( ply, false )
				end
			end
		end
		MsgN( "[EntPriority] Cleared all transmit restrictions" )
	end
end )

concommand.Add( "sv_entpriority_range", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local val = tonumber( args[ 1 ] )
	if ( !val ) then
		print( "[EntPriority] Range = " .. MaxRange .. " units" )
		return
	end
	MaxRange = math.Clamp( val, 500, 32000 )
	print( "[EntPriority] Range set to " .. MaxRange .. " units" )
end )

concommand.Add( "sv_entpriority_rate", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	local val = tonumber( args[ 1 ] )
	if ( !val ) then
		print( "[EntPriority] Update rate = " .. UpdateRate .. "s" )
		return
	end
	UpdateRate = math.Clamp( val, 0.1, 5.0 )
	print( "[EntPriority] Update rate set to " .. UpdateRate .. "s" )
end )

concommand.Add( "sv_entpriority_info", function( ply, cmd, args )
	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	print( "========== ENTITY PRIORITY INFO ==========" )
	print( "  Enabled:      " .. tostring( Enabled ) )
	print( "  Range:        " .. MaxRange .. " units" )
	print( "  Update rate:  " .. UpdateRate .. "s" )
	print( "  Total ents:   " .. #ents.GetAll() )
	print( "  Players:      " .. player.GetCount() )
	print( "==========================================" )
end )


---------------
	Should this entity be culled by distance?
----------------
local function ShouldCull( ent )

	if ( !IsValid( ent ) ) then return false end

	local class = ent:GetClass()

	-- Never cull important entity types
	if ( NeverCull[ class ] ) then return false end

	-- Never cull weapons (parent check covers held weapons too)
	if ( ent:IsWeapon() ) then return false end

	-- Never cull entities parented to players
	local parent = ent:GetParent()
	if ( IsValid( parent ) and parent:IsPlayer() ) then return false end

	-- Never cull entities with FSOLID_NOT_STANDABLE flag or similar critical flags
	-- (This covers trigger brushes, func_ entities etc)
	if ( class:StartsWith( "func_" ) ) then return false end
	if ( class:StartsWith( "trigger_" ) ) then return false end
	if ( class:StartsWith( "logic_" ) ) then return false end
	if ( class:StartsWith( "info_" ) ) then return false end

	return true

end


---------------
	Main update loop — runs every UpdateRate seconds
----------------
hook.Add( "Think", "EntPriority_Update", function()

	if ( !Enabled ) then return end

	local now = SysTime()
	if ( now - LastUpdate < UpdateRate ) then return end
	LastUpdate = now

	local rangeSqr = MaxRange * MaxRange
	local players = player.GetAll()

	if ( #players == 0 ) then return end

	for _, ent in ipairs( ents.GetAll() ) do

		if ( !ShouldCull( ent ) ) then continue end

		local entPos = ent:GetPos()

		for _, ply in ipairs( players ) do

			if ( !IsValid( ply ) ) then continue end

			local distSqr = ply:GetPos():DistToSqr( entPos )
			local tooFar = distSqr > rangeSqr

			-- Only call SetPreventTransmit if state actually changes
			-- to avoid unnecessary engine calls
			ent:SetPreventTransmit( ply, tooFar )

		end

	end

end )

MsgN( "[EntPriority] Loaded. Use sv_entpriority_enable 1 to activate." )
