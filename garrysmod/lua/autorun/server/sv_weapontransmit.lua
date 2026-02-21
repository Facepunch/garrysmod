---------------
	SMART WEAPON TRANSMIT (inspired by HolyLib networking)

	HolyLib saves significant bandwidth by only networking the
	active weapon to other players while always sending all
	weapons to the owner. This replicates that in Lua using
	SetPreventTransmit.

	On a 40-player RP server where each player has 5 weapons,
	that's 200 weapon entities being networked to all 40 players.
	With this, only 40 active weapons are networked to others
	while each player still sees all their own weapons.

	Convars:
		sv_smartweapons 0       - Enable/disable (default off)
		sv_smartweapons_rate 1  - Update interval in seconds
----------------

if ( !SERVER ) then return end

local Enabled = false
local UpdateRate = 1
local LastUpdate = 0

CreateConVar( "sv_smartweapons", "0", FCVAR_ARCHIVE, "Only transmit active weapons to other players" )
CreateConVar( "sv_smartweapons_rate", "1", FCVAR_ARCHIVE, "Weapon transmit update interval" )

cvars.AddChangeCallback( "sv_smartweapons", function( name, old, new )
	Enabled = tonumber( new ) == 1

	-- Restore all weapons when disabled
	if ( !Enabled ) then
		for _, ply in ipairs( player.GetAll() ) do
			for _, wep in ipairs( ply:GetWeapons() ) do
				if ( IsValid( wep ) and wep._smartHidden ) then
					for _, other in ipairs( player.GetAll() ) do
						if ( other != ply ) then
							wep:SetPreventTransmit( other, false )
						end
					end
					wep._smartHidden = nil
				end
			end
		end
	end
end )

hook.Add( "Think", "SmartWeapons_Update", function()

	if ( !Enabled ) then return end

	local now = SysTime()
	if ( now - LastUpdate < UpdateRate ) then return end
	LastUpdate = now

	UpdateRate = GetConVar( "sv_smartweapons_rate" ):GetFloat()

	local players = player.GetAll()
	local playerCount = #players

	for i = 1, playerCount do
		local ply = players[ i ]

		if ( !IsValid( ply ) or !ply:Alive() ) then continue end

		local activeWep = ply:GetActiveWeapon()
		local weapons = ply:GetWeapons()

		for _, wep in ipairs( weapons ) do

			if ( !IsValid( wep ) ) then continue end

			local isActive = ( wep == activeWep )

			for j = 1, playerCount do
				local other = players[ j ]

				if ( other == ply ) then continue end
				if ( !IsValid( other ) ) then continue end

				if ( isActive ) then
					-- Active weapon — always show to everyone
					if ( wep._smartHidden ) then
						wep:SetPreventTransmit( other, false )
					end
				else
					-- Holstered weapon — hide from others
					wep:SetPreventTransmit( other, true )
					wep._smartHidden = true
				end
			end

		end

	end

end )

-- Cleanup on disconnect
hook.Add( "PlayerDisconnected", "SmartWeapons_Cleanup", function( ply )
	if ( !Enabled ) then return end
	-- Weapons are removed anyway, but clean our flags
end )

MsgN( "[SmartWeapons] Loaded. Use sv_smartweapons 1 to enable." )
