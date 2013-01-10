
--[[---------------------------------------------------------
   Name: gamemode:PlayerTraceAttack( )
   Desc: A bullet has been fired and hit this player
		 Return true to completely override internals
-----------------------------------------------------------]]
function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )

	return false
end


--[[---------------------------------------------------------
   Name: gamemode:SetPlayerSpeed( )
   Desc: Sets the player's run/walk speed
-----------------------------------------------------------]]
function GM:SetPlayerSpeed( ply, walk, run )

	ply:SetWalkSpeed( walk )
	ply:SetRunSpeed( run )
	
end



--[[---------------------------------------------------------
   Name: gamemode:CanPlayerEnterVehicle( player, vehicle, role )
   Desc: Return true if player can enter vehicle
-----------------------------------------------------------]]
function GM:CanPlayerEnterVehicle( player, vehicle, role )
	return true
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerEnteredVehicle( player, vehicle, role )
   Desc: Player entered the vehicle fine
-----------------------------------------------------------]]
function GM:PlayerEnteredVehicle( player, vehicle, role )
end


--[[---------------------------------------------------------
   Name: gamemode:PlayerFootstep( ply, vPos, iFoot, strSoundName, fVolume, pFilter )
   Desc: Called when a player steps
		pFilter is the recipient filter to use for effects/sounds 
			and is only valid SERVERSIDE. Clientside needs no filter!
		Return true to not play normal sound
-----------------------------------------------------------]]
function GM:PlayerFootstep( ply, vPos, iFoot, strSoundName, fVolume, pFilter )
	
	
	--[[
	-- Draw effect on footdown
	local effectdata = EffectData()
		effectdata:SetOrigin( vPos )
	util.Effect( "phys_unfreeze", effectdata, true, pFilter )
	--]]
	
	--[[
	-- Don't play left foot
	if ( iFoot == 0 ) then return true end
	--]]
	
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerStepSoundTime( ply, iType, bWalking )
   Desc: Return the time between footsteps
-----------------------------------------------------------]]
function GM:PlayerStepSoundTime( ply, iType, bWalking )
	
	local fStepTime = 350
	local fMaxSpeed = ply:GetMaxSpeed()
	
	if ( iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT ) then
		
		if ( fMaxSpeed <= 100 ) then 
			fStepTime = 400
		elseif ( fMaxSpeed <= 300 ) then 
			fStepTime = 350
		else 
			fStepTime = 250 
		end
	
	elseif ( iType == STEPSOUNDTIME_ON_LADDER ) then
	
		fStepTime = 450 
	
	elseif ( iType == STEPSOUNDTIME_WATER_KNEE ) then
	
		fStepTime = 600 
	
	end
	
	-- Step slower if crouching
	if ( ply:Crouching() ) then
		fStepTime = fStepTime + 50
	end
	
	return fStepTime
	
end


--[[---------------------------------------------------------
   Name: gamemode:OnPlayerChat()
		Process the player's chat.. return true for no default
-----------------------------------------------------------]]
function GM:OnPlayerChat( player, strText, bTeamOnly, bPlayerIsDead )
	
	--
	-- I've made this all look more complicated than it is. Here's the easy version
	--
	-- chat.AddText( player, Color( 255, 255, 255 ), ": ", strText )
	--
	
	local tab = {}
	
	if ( bPlayerIsDead ) then
		table.insert( tab, Color( 255, 30, 40 ) )
		table.insert( tab, "*DEAD* " )
	end
	
	if ( bTeamOnly ) then
		table.insert( tab, Color( 30, 160, 40 ) )
		table.insert( tab, "(TEAM) " )
	end
	
	if ( IsValid( player ) ) then
		table.insert( tab, player )
	else
		table.insert( tab, "Console" )
	end
	
	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": "..strText )
	
	chat.AddText( unpack(tab) )

	return true
	
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerNoClip( player, bool )
   Desc: Player pressed the noclip key, return true if
		  the player is allowed to noclip, false to block
-----------------------------------------------------------]]
function GM:PlayerNoClip( pl, on )
	
	-- Allow noclip if we're in single player
	if ( game.SinglePlayer() ) then return true end
	
	-- Don't if it's not.
	return false
	
end

--[[---------------------------------------------------------
   Name: gamemode:FindUseEntity( ply, ent )
-----------------------------------------------------------]]
function GM:FindUseEntity( ply, ent )
	
	-- ent is what the game found to use by default
	-- return what you REALLY want it to use

	return ent
		
end

function GM:PlayerTick( ply, mv )
	
end

function GM:PlayerSwitchWeapon( ply, oldwep, newwep )
	
end

