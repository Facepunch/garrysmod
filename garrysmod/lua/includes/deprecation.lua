local function DEPRECATE( f, name, alternative )

	local error_locations = {}
	local format = "[ERROR] %s:%d: calling deprecated function '%s'\n"

	if ( alternative ) then
		format = "[ERROR] %s:%d: calling deprecated function '%s' (use '%s')\n"
	end

	return function( ... )

		local info = debug.getinfo( 2, "Sl" )

		if info then

			local source, currentline = info.short_src, info.currentline

			if ( not error_locations[source .. currentline] ) then

				error_locations[source .. currentline] = true
				ErrorNoHalt( string.format( format, source, currentline, name, alternative ) )

			end

		end

		return f( ... )

	end

end


local ENTITY = FindMetaTable( "Entity" )
local PLAYER = FindMetaTable( "Player" )

IncludeCS 									= DEPRECATE( IncludeCS, "IncludeCS", "include & AddCSLuaFile" )

math.Dist 									= DEPRECATE( math.Dist, "math.Dist", "math.Distance" )
math.Max 									= DEPRECATE( math.Max, "math.Max", "math.max" )
math.Min 									= DEPRECATE( math.Min, "math.Min", "math.min" )
math.mod 									= DEPRECATE( math.mod, "math.mod", "math.fmod" )

util.tobool 								= DEPRECATE( util.tobool, "util.tobool", "tobool" )
util.TraceEntityHull 						= DEPRECATE( util.TraceEntityHull, "util.TraceEntityHull" )

ENTITY.GetNetworkedAngle 					= DEPRECATE( ENTITY.GetNetworkedAngle, "ENTITY:GetNetworkedAngle", "ENTITY:GetNWAngle" )
ENTITY.GetNetworkedBool 					= DEPRECATE( ENTITY.GetNetworkedBool, "ENTITY:GetNetworkedBool", "ENTITY:GetNWBool" )
ENTITY.GetNetworkedEntity 					= DEPRECATE( ENTITY.GetNetworkedEntity, "ENTITY:GetNetworkedEntity", "ENTITY:GetNWEntity" )
ENTITY.GetNetworkedFloat 					= DEPRECATE( ENTITY.GetNetworkedFloat, "ENTITY:GetNetworkedFloat", "ENTITY:GetNWFloat" )
ENTITY.GetNetworkedInt 						= DEPRECATE( ENTITY.GetNetworkedInt, "ENTITY:GetNetworkedInt", "ENTITY:GetNWInt" )
ENTITY.GetNetworkedString 					= DEPRECATE( ENTITY.GetNetworkedString, "ENTITY:GetNetworkedString", "ENTITY:GetNWString" )
ENTITY.GetNetworkedVector 					= DEPRECATE( ENTITY.GetNetworkedVector, "ENTITY:GetNetworkedVector", "ENTITY:GetNWVector" )

ENTITY.SetNetworkedAngle 					= DEPRECATE( ENTITY.SetNetworkedAngle, "ENTITY:SetNetworkedAngle", "ENTITY:SetNWAngle" )
ENTITY.SetNetworkedBool 					= DEPRECATE( ENTITY.SetNetworkedBool, "ENTITY:SetNetworkedBool", "ENTITY:SetNWBool" )
ENTITY.SetNetworkedEntity 					= DEPRECATE( ENTITY.SetNetworkedEntity, "ENTITY:SetNetworkedEntity", "ENTITY:SetNWEntity" )
ENTITY.SetNetworkedFloat 					= DEPRECATE( ENTITY.SetNetworkedFloat, "ENTITY:SetNetworkedFloat", "ENTITY:SetNWFloat" )
ENTITY.SetNetworkedInt 						= DEPRECATE( ENTITY.SetNetworkedInt, "ENTITY:SetNetworkedInt", "ENTITY:SetNWInt" )
ENTITY.SetNetworkedString 					= DEPRECATE( ENTITY.SetNetworkedString, "ENTITY:SetNetworkedString", "ENTITY:SetNWString" )
ENTITY.SetNetworkedVector 					= DEPRECATE( ENTITY.SetNetworkedVector, "ENTITY:SetNetworkedVector", "ENTITY:SetNWVector" )

PLAYER.GetPunchAngle 						= DEPRECATE( PLAYER.GetPunchAngle, "PLAYER:GetPunchAngle", "PLAYER:GetViewPunchAngles" )

if SERVER then

	ENTITY.GetHitboxBone 					= DEPRECATE( ENTITY.GetHitboxBone, "ENTITY:GetHitboxBone", "ENTITY:GetHitBoxBone" )

else

	SScale 									= DEPRECATE( SScale, "SScale", "ScreenScale" )
	ValidPanel 								= DEPRECATE( ValidPanel, "ValidPanel", "IsValid" )

end