AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "ghostentity.lua" )
AddCSLuaFile( "object.lua" )
AddCSLuaFile( "stool.lua" )
AddCSLuaFile( "cl_viewscreen.lua" )
AddCSLuaFile( "stool_cl.lua" )

include('shared.lua')

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

--[[---------------------------------------------------------
   Desc: Convenience function to check object limits
-----------------------------------------------------------]]
function SWEP:CheckLimit( str ) 

	local ply = self.Weapon:GetOwner()
	return ply:CheckLimit( str )

end

--[[---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()
	return false
end

--[[---------------------------------------------------------
   Name: CC_GMOD_Tool
   Desc: Console Command to switch weapon/toolmode
-----------------------------------------------------------]]
function CC_GMOD_Tool( player, command, arguments )

	if ( arguments[1] == nil ) then return end
	if ( GetConVarNumber( "toolmode_allow_"..arguments[1] ) != 1 ) then return end
	
	player:ConCommand( "gmod_toolmode "..arguments[1] )
	
	local activeWep = player:GetActiveWeapon()
	local isTool = (activeWep && activeWep:IsValid() && activeWep:GetClass() == "gmod_tool")
	
	-- Switch weapons
	player:SelectWeapon( "gmod_tool")

	-- Get the weapon and send a fake deploy command
	local wep = player:GetWeapon("gmod_tool")
	
	if (wep:IsValid()) then
	
		-- Hmmmmm???
		if ( !isTool ) then
			wep.wheelModel = nil
		end
		
		-- Holster the old 'tool'
		if ( wep.Holster ) then
			wep:Holster()
		end
		
		wep.Mode = arguments[1]
		
		-- Deplot the new
		if ( wep.Deploy ) then
			wep:Deploy()
		end
		
	end
	
end

concommand.Add( "gmod_tool", CC_GMOD_Tool, nil, nil, { FCVAR_SERVER_CAN_EXECUTE } )
