
-- A spawnflag constant for addons
SF_LUA_RUN_ON_SPAWN = 1

ENT.Type = "point"
ENT.DisableDuplicator = true

AccessorFunc( ENT, "m_bDefaultCode", "DefaultCode" )

function ENT:Initialize()

	-- If the entity has its first spawnflag set, run the code automatically
	if ( self:HasSpawnFlags( SF_LUA_RUN_ON_SPAWN ) ) then
		self:RunCode( self, self, self:GetDefaultCode(), nil )
	end

end

function ENT:KeyValue( key, value )

	if ( key:lower() == "oncodeout" ) then
		self:StoreOutput( key, value )
	end

	if ( key:lower() == "code" ) then
		self:SetDefaultCode( value )
	end

end

function ENT:SetupGlobals( activator, caller, data )

	ACTIVATOR = activator
	CALLER = caller
	INPUT = data
	OUTPUT = nil

	if ( IsValid( activator ) && activator:IsPlayer() ) then
		TRIGGER_PLAYER = activator
	end

end

function ENT:KillGlobals()

	ACTIVATOR = nil
	CALLER = nil
	TRIGGER_PLAYER = nil
	INPUT = nil
	OUTPUT = nil

end

function ENT:RunCode( activator, caller, code, data )

	self:SetupGlobals( activator, caller, data )

		RunString( code, "lua_run#" .. self:EntIndex() )

		if ( OUTPUT != nil ) then
			self:TriggerOutput("OnCodeOut", activator, OUTPUT)
		end

	self:KillGlobals()

end

function ENT:AcceptInput( name, activator, caller, data )

	if ( name == "RunCode" ) then self:RunCode( activator, caller, self:GetDefaultCode(), data ) return true end
	if ( name == "RunPassedCode" ) then self:RunCode( activator, caller, data, nil ) return true end

	return false

end
