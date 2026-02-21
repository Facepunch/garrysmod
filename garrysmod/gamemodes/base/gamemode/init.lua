
include( 'shared.lua' )
include( 'player.lua' )
include( 'npc.lua' )
include( 'variable_edit.lua' )

--[[---------------------------------------------------------
	Name: gamemode:Initialize()
	Desc: Called immediately after starting the gamemode
-----------------------------------------------------------]]
function GM:Initialize()
end

--[[---------------------------------------------------------
	Name: gamemode:InitPostEntity()
	Desc: Called as soon as all map entities have been spawned
-----------------------------------------------------------]]
function GM:InitPostEntity()
end

--[[---------------------------------------------------------
	Name: gamemode:Think()
	Desc: Called every frame
-----------------------------------------------------------]]
function GM:Think()
end

--[[---------------------------------------------------------
	Name: gamemode:ShutDown()
	Desc: Called when the Lua system is about to shut down
-----------------------------------------------------------]]
function GM:ShutDown()
end

--[[---------------------------------------------------------
	Name: gamemode:DoPlayerDeath( )
	Desc: Carries out actions when the player dies
-----------------------------------------------------------]]
function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if ( !dmginfo:IsDamageType( DMG_REMOVENORAGDOLL ) ) then
		ply:CreateRagdoll()
	end

	ply:AddDeaths( 1 )

	if ( attacker:IsValid() && attacker:IsPlayer() ) then

		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end

	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerShouldTakeDamage
	Return true if this player should take damage from this attacker
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage( ply, attacker )
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:EntityTakeDamage( ent, info )
	Desc: The entity has received damage
-----------------------------------------------------------]]
function GM:EntityTakeDamage( ent, info )
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerHurt( )
	Desc: Called when a player is hurt.
-----------------------------------------------------------]]
function GM:PlayerHurt( player, attacker, healthleft, healthtaken )
end

--[[---------------------------------------------------------
	Name: gamemode:CreateEntityRagdoll( entity, ragdoll )
	Desc: A ragdoll of an entity has been created
-----------------------------------------------------------]]
function GM:CreateEntityRagdoll( entity, ragdoll )
end

-- Set the ServerName every 30 seconds in case it changes..
-- This is for backwards compatibility only - client can now use GetHostName()
local function HostnameThink()

	SetGlobalString( "ServerName", GetHostName() )

end

timer.Create( "HostnameThink", 30, 0, HostnameThink )

--[[---------------------------------------------------------
	Show the default team selection screen
-----------------------------------------------------------]]
function GM:ShowTeam( ply )

	if ( !GAMEMODE.TeamBased ) then return end

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return
	end

	-- For clientside see cl_pickteam.lua
	ply:SendLua( "GAMEMODE:ShowTeam()" )

end

--
-- CheckPassword( steamid, networkid, server_password, password, name )
--
-- Called every time a non-localhost player joins the server. steamid is their 64bit
-- steamid. Return false and a reason to reject their join. Return true to allow
-- them to join.
--
function GM:CheckPassword( steamid, networkid, server_password, password, name )

	-- The server has sv_password set
	if ( server_password != "" ) then

		-- The joining clients password doesn't match sv_password
		if ( server_password != password ) then
			return false
		end

	end

	--
	-- Returning true means they're allowed to join the server
	--
	return true

end

--[[---------------------------------------------------------
	Name: gamemode:FinishMove( player, movedata )
-----------------------------------------------------------]]
function GM:VehicleMove( ply, vehicle, mv )

	--
	-- On duck toggle third person view
	--
	if ( mv:KeyPressed( IN_DUCK ) && vehicle.SetThirdPersonMode ) then
		vehicle:SetThirdPersonMode( !vehicle:GetThirdPersonMode() )
	end

	--
	-- Adjust the camera distance with the mouse wheel
	--
	local iWheel = ply:GetCurrentCommand():GetMouseWheel()
	if ( iWheel != 0 && vehicle.SetCameraDistance ) then
		-- The distance is a multiplier
		-- Actual camera distance = ( renderradius + renderradius * dist )
		-- so -1 will be zero.. clamp it there.
		local newdist = math.Clamp( vehicle:GetCameraDistance() - iWheel * 0.03 * ( 1.1 + vehicle:GetCameraDistance() ), -1, 10 )
		vehicle:SetCameraDistance( newdist )
	end

end

--[[---------------------------------------------------------
	Name: gamemode:PreUndo( undo )
-----------------------------------------------------------]]
function GM:PreUndo( undo )
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:PreUndo( undo )
-----------------------------------------------------------]]
function GM:PostUndo( undo, count )
end
