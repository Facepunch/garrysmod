
TOOL.AddToMenu = false
TOOL.ClientConVar[ "type" ] = "0"
TOOL.ClientConVar[ "name" ] = "0"

TOOL.Information = { { name = "left" } }

function TOOL:LeftClick( trace, attach )

	local type = self:GetClientNumber( "type", 0 )
	local name = self:GetClientInfo( "name" )

	if ( CLIENT ) then return true end

	if ( type == 0 ) then

		Spawn_SENT( self:GetOwner(), name, trace )

	elseif ( type == 1 ) then

		Spawn_Vehicle( self:GetOwner(), name, trace )

	elseif ( type == 2 ) then

		-- Load a weapon just like left clicking would
		local weapon = ""
		local gmod_npcweapon = self:GetOwner():GetInfo( "gmod_npcweapon" )
		if ( gmod_npcweapon != "" ) then
			weapon = gmod_npcweapon
		else
			local NPCinfo = list.Get( "NPC" )[ name ]
			weapon = table.Random( NPCinfo and NPCinfo.Weapons or {} ) or ""
		end

		Spawn_NPC( self:GetOwner(), name, weapon, trace )

	elseif ( type == 3 ) then

		Spawn_Weapon( self:GetOwner(), name, trace )

	elseif ( type == 4 ) then

		CCSpawn( self:GetOwner(), nil, { name } ) -- Props

	end

	return true

end
