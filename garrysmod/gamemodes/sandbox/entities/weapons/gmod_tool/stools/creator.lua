
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
		local NPCinfo = list.Get( "NPC" )[ name ]
		local weapon = table.Random( NPCinfo.Weapons ) or ""
		local gmod_npcweapon = GetConVar( "gmod_npcweapon" )
		if ( gmod_npcweapon:GetString() != "" ) then weapon = gmod_npcweapon:GetString() end

		Spawn_NPC( self:GetOwner(), name, weapon, trace )

	elseif ( type == 3 ) then

		Spawn_Weapon( self:GetOwner(), name, trace )

	elseif ( type == 4 ) then

		CCSpawn( self:GetOwner(), nil, { name } ) -- Props

	end

	return true

end
