
local effects_freeze = CreateClientConVar( "effects_freeze", "1", true, false )

--[[---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	
	if ( effects_freeze:GetBool() == false ) then return end
	
	self.Target = data:GetEntity()
	self.StartTime	= CurTime()
	self.Length		= 0.3
		
end


--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )
	
	if ( effects_freeze:GetBool() == false ) then return false end
	return self.StartTime + self.Length > CurTime()
	
end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render()

	if ( !IsValid( self.Target ) ) then return end
	
	local delta = ((CurTime() - self.StartTime) / self.Length) ^ 0.5
	local idelta = 1-delta
	
	local size = 1
	effects.halo.Add( {self.Target}, Color( 0, 255, 0, 255 * idelta ), size, size, 1, true, false )

end
