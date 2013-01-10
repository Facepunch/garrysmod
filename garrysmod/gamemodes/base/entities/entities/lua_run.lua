
ENT.Type				= "point"
ENT.DisableDuplicator	= true

AccessorFunc( ENT, "m_bDefaultCode", "DefaultCode" )

--[[---------------------------------------------------------
   Name: Initialize
   Desc:
-----------------------------------------------------------]]
function ENT:Initialize()
end

--[[---------------------------------------------------------
   Name: KeyValue
   Desc:
-----------------------------------------------------------]]
function ENT:KeyValue( key, value )

	if ( key == "Code" ) then
		self:SetDefaultCode( value )
	end

end

--[[---------------------------------------------------------
   Name: SetupGlobals
   Desc: Create globals for use in code running
-----------------------------------------------------------]]
function ENT:SetupGlobals( activator, caller )

	ACTIVATOR = activator
	CALLER = caller
	
	if ( IsValid( activator ) && activator:IsPlayer() ) then
		TRIGGER_PLAYER = activator
	end

end

--[[---------------------------------------------------------
   Name: KillGlobals
   Desc: Remove those globals
-----------------------------------------------------------]]
function ENT:KillGlobals(  )

	ACTIVATOR 			= nil
	CALLER 				= nil
	TRIGGER_PLAYER 		= nil

end

--[[---------------------------------------------------------
   Name: RunCode
   Desc: 
-----------------------------------------------------------]]
function ENT:RunCode( activator, caller, code )

	self:SetupGlobals( activator, caller )
	
		RunString( code )
	
	self:KillGlobals()

end

--[[---------------------------------------------------------
   Name: AcceptInput
   Desc:
-----------------------------------------------------------]]
function ENT:AcceptInput( name, activator, caller, data )

	if ( name == "RunCode" ) then self:RunCode( activator, caller, self:GetDefaultCode() ) return true end
	if ( name == "RunPassedCode" ) then self:RunCode( activator, caller, data ) return true end
	
	return false
	
end
