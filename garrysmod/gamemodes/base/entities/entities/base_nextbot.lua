
ENT.Base 			= "base_entity"
ENT.Type 			= "nextbot"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.RenderGroup		= RENDERGROUP_OPAQUE


function ENT:Initialize()

	
end

--
-- Called to initialize behaviour
--
function ENT:BehaveStart()

	
end

--
-- Called like a think - to update the AI
--
function ENT:BehaveUpdate( fInterval )

	MsgN( self, fInterval )
	
end