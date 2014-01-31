
AddCSLuaFile()

ENT.Base 			= "base_entity"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.RenderGroup		= RENDERGROUP_OPAQUE

function ENT:Initialize()
end

if ( SERVER ) then

	--
	-- All of the AI logic is serverside - so we derive it from a 
	-- specialized class on the server.
	--
	ENT.Type = "nextbot"
	include( "sv_nextbot.lua" )

else

	ENT.Type = "anim"

end
