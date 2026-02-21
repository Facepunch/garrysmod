
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "ghostentity.lua" )
AddCSLuaFile( "object.lua" )
AddCSLuaFile( "stool.lua" )
AddCSLuaFile( "cl_viewscreen.lua" )
AddCSLuaFile( "stool_cl.lua" )

include( "shared.lua" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

-- Should this weapon be dropped when its owner dies?
function SWEP:ShouldDropOnDie()
	return false
end

-- Console Command to switch weapon/toolmode
local function CC_GMOD_Tool( ply, command, arguments )

	local targetMode = arguments[1]

	if ( targetMode == nil ) then return end
	if ( GetConVarNumber( "toolmode_allow_" .. targetMode ) != 1 ) then return end

	ply:ConCommand( "gmod_toolmode " .. targetMode )

	-- Switch weapons
	ply:SelectWeapon( "gmod_tool" )

end
concommand.Add( "gmod_tool", CC_GMOD_Tool, nil, nil, { FCVAR_SERVER_CAN_EXECUTE } )
