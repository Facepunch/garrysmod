
-- This is just a simple point entity.

-- We only use it to represent the position and angle of a spawn point
-- So we don't have to do anything here because the baseclass will
-- take care of the basics

-- This file only exists so that the entity is created

ENT.Type = "point"

function ENT:Initialize()

	if ( self.RedTeam or self.GreenTeam or self.YellowTeam or self.BlueTeam ) then

		-- If any of these are set to true then
		-- make sure that any that aren't setup are
		-- set to false.

		self.BlueTeam = self.BlueTeam or false
		self.GreenTeam = self.GreenTeam or false
		self.YellowTeam = self.YellowTeam or false
		self.RedTeam = self.RedTeam or false

	else

		-- If none are set then make it so that they all
		-- are set to true since any team can spawn here.
		-- This will also happen if we don't have the "spawnflags"
		-- keyvalue setup.

		self.BlueTeam = true
		self.GreenTeam = true
		self.YellowTeam = true
		self.RedTeam = true

	end

end

function ENT:KeyValue( key, value )

	if ( key == "spawnflags" ) then

		local sf = tonumber( value )

		for i = 15, 0, -1 do

			local bit = math.pow( 2, i )

			-- Quick bit if bitwise math to figure out if the spawnflags
			-- represent red/blue/green or yellow.
			-- We have to use booleans since the TEAM_ identifiers
			-- aren't setup at this point.
			-- (this would be easier if we had bitwise operators in Lua)

			if ( ( sf - bit ) >= 0 ) then

				if ( bit == 8 ) then self.RedTeam = true
				elseif ( bit == 4 ) then self.GreenTeam = true
				elseif ( bit == 2 ) then self.YellowTeam = true
				elseif ( bit == 1 ) then self.BlueTeam = true
				end

				sf = sf - bit

			else

				if ( bit == 8 ) then self.RedTeam = false
				elseif ( bit == 4 ) then self.GreenTeam = false
				elseif ( bit == 2 ) then self.YellowTeam = false
				elseif ( bit == 1 ) then self.BlueTeam = false
				end

			end

		end

	end

end

-- Maybe gamemodes want to use this list, maybe base gamemode should
ENT.SpawnPointClasses = {
	-- Generic
	"info_player_blue",
	"info_player_red",
	"info_player_coop", -- Synergy?
	"info_player_deathmatch",
	"info_player_zombiemaster", -- ZM
	"info_spawnpoint",

	"info_player_counterterrorist", -- CSS
	"info_player_terrorist",

	"info_player_allies", -- DODS
	"info_player_axis",

	"info_player_knight", -- PVKII
	"info_player_pirate",
	"info_player_viking",

	"info_survivor_position", -- L4D
	"info_survivor_rescue",

	"info_player_human", -- ZPS
	"info_player_zombie",

	"diprip_start_team_red", -- DIPRIP
	"diprip_start_team_blue",

	"info_player_fof", -- Firstful of Frags
	"info_player_desperado",
	"info_player_vigilante",

	"info_player_attacker", -- NEOTOKYO
	"info_player_defender",

	"info_coop_spawn", -- Portal 2 Coop
	"ins_spawnpoint", -- Insurgency
	"dys_spawn_point", -- Dystopia
	"aoc_spawnpoint", -- Age of Chivalry
	"info_ff_teamspawn", -- Fortress Forever
}

for _, className in pairs( ENT.SpawnPointClasses ) do
	local ent_cpy = table.Copy( ENT )
	ent_cpy.Base = "gmod_player_start"
	ent_cpy.Folder = "entities/" .. className
	ent_cpy.SpawnPointClasses = nil

	scripted_ents.Register( ent_cpy, className )
end
