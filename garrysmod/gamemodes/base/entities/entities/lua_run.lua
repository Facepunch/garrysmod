
ENT.Type = "point"
ENT.DisableDuplicator = true

AccessorFunc( ENT, "m_bDefaultCode", "DefaultCode" )

function ENT:Initialize()
	
end

function ENT:KeyValue( key, value )

	if ( key == "Code" ) then
		self:SetDefaultCode( value )
	end

end

function ENT:SetupGlobals( activator, caller, code )
	
	self.compiledCode = CompileString( value, tostring(self) )
	if ( not self.compiledCode ) then return end
	
	local meta = {
		__index = _G
	}
	
	local environment = {
		ACTIVATOR = activator,
		CALLER = caller
	}

	if ( IsValid( activator ) && activator:IsPlayer() ) then
		environment.TRIGGER_PLAYER = activator
	end
	
	setmetatable( environment, meta )
	self.compiledCode = setfenv( self.compiledCode, environment )

end

function ENT:RunCode( activator, caller, code )

	self:SetupGlobals( activator, caller, code )
	
	if ( not self.compiledCode ) then return end
	ProtectedCall( self.compiledCode )

end

function ENT:AcceptInput( name, activator, caller, data )

	if ( name == "RunCode" ) then self:RunCode( activator, caller, self:GetDefaultCode() ) return true end
	if ( name == "RunPassedCode" ) then self:RunCode( activator, caller, data ) return true end

	return false

end
