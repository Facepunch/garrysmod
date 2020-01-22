
if ( CLIENT ) then return end

ENT.Type = "point"

local DIR_BACKWARD = -1
local DIR_NONE = 0
local DIR_FORWARD = 1

local TYPE_NORMAL = 0
local TYPE_MUSCLE = 1

function ENT:Initialize()

	self.last_time = CurTime()
	self.init_time = CurTime()
	self.min_length = self.min_length or 1
	self.type = self.type or TYPE_NORMAL
	self.ctime = self.ctime or 0
	self.isexpanded = false

end

function ENT:KeyValue( key, value )
	if ( key == "minlength" ) then		self.min_length = tonumber( value )
	elseif ( key == "maxlength" ) then	self.max_length = tonumber( value )
	elseif ( key == "type" ) then		self.type = tonumber( value )
	end
end

function ENT:Think()

	self:NextThink( CurTime() + 0.01 )
	local TimeDiff = CurTime() - self.last_time
	self.last_time = CurTime()

	if ( !self.constraint ) then return true end
	if ( !self.direction ) then return true end
	if ( self.direction == DIR_NONE ) then return true end

	local old_length = self.current_length
	local current_length = self.current_length

	if ( self.type == TYPE_NORMAL ) then

		local speed = 0
		local dist = 0

		if ( self.direction == DIR_FORWARD ) then
			local speed = self.constraint.fwd_speed
			dist = speed * TimeDiff
		elseif ( self.direction == DIR_BACKWARD ) then
			local speed = self.constraint.bwd_speed
			dist = -speed * TimeDiff
		end

		if ( dist == 0 ) then return true end

		current_length = current_length + dist

		if ( self.min_length && current_length < self.min_length ) then

			current_length = self.min_length
			if ( self.toggle ) then self.direction = DIR_NONE end

		end

		if ( self.max_length ) then

			if ( current_length > self.max_length ) then

				current_length = self.max_length
				self.isexpanded = true
				if ( self.toggle ) then self.direction = DIR_NONE end

			else

				self.isexpanded = false

			end

		end

	elseif ( self.type == TYPE_MUSCLE ) then

		local amp = self.constraint.amplitude
		local per = self.constraint.period

		if ( per == 0 ) then return true end

		local spos = ( math.sin( ( self.ctime * math.pi * per ) ) + 1 ) * ( amp / 2 )

		if ( spos > amp ) then spos = amp end
		if ( spos < 0 ) then spos = 0 end

		if ( self.direction != DIR_NONE ) then
			current_length = self.min_length + spos
		end
		self.ctime = self.ctime + TimeDiff

	end

	self.current_length = current_length

	self.constraint:Fire( "SetSpringLength", current_length, 0 )
	if ( self.rope ) then self.rope:Fire( "SetLength", current_length, 0 ) end

	return true

end

function ENT:GetSomePos( ent, phys, lpos )

	if ( ent:EntIndex() == 0 ) then
		return lpos
	end

	if ( IsValid( phys ) ) then
		return phys:LocalToWorld( lpos )
	else
		return ent:LocalToWorld( lpos )
	end

end

function ENT:SetConstraint( c )

	self.constraint = c
	self.direction = DIR_NONE
	self.toggle = c.toggle

	local p1 = self:GetSomePos( c.Ent1, c.Phys1, c.LPos1 )
	local p2 = self:GetSomePos( c.Ent2, c.Phys2, c.LPos2 )
	local dist = ( p1 - p2 ):Length()

	self.current_length = dist

	if ( self.max_length ) then
		self.isexpanded = ( self.current_length >= self.max_length )
	end

	if ( self.type == TYPE_MUSCLE ) then
		local amp = self.constraint.amplitude
		local per = self.constraint.period
		local spos = self.current_length - self.min_length
		spos = spos / ( amp * 2 )
		spos = spos - 1
		spos = math.Clamp( spos, -1, 1 ) -- just in case!
		spos = math.asin( spos )
		spos = spos / ( per * math.pi )
		self.ctime = spos
	end

end

function ENT:SetRope( r )
	self.rope = r
end

function ENT:SetDirection( n )
	self.direction = n
end

function ENT:GetDirection()
	return self.direction
end

function ENT:IsExpanded()
	return self.isexpanded
end

--[[----------------------------------------------------------------------
	HydraulicToggle - Toggle hydraulic on and off
------------------------------------------------------------------------]]
local function HydraulicToggle( pl, hyd )

	if ( !IsValid( hyd ) ) then return false end

	-- I hate this, shouldn't we just be calling hyd:Toggle()

	if ( hyd:GetDirection() == 0 ) then
		if ( hyd:IsExpanded() ) then
			hyd:SetDirection( -1 )
		else
			hyd:SetDirection( 1 )
		end

	elseif ( hyd:GetDirection() == -1 ) then

		hyd:SetDirection( 1 )

	elseif ( hyd:GetDirection() == 1 ) then

		hyd:SetDirection( -1 )

	end

end
numpad.Register( "HydraulicToggle", HydraulicToggle )

--[[----------------------------------------------------------------------
	WinchOn - Called to switch the winch on
------------------------------------------------------------------------]]
local function WinchOn( pl, winch, dir )
	if ( !IsValid( winch ) ) then return false end
	winch:SetDirection( dir )
end
numpad.Register( "WinchOn", WinchOn )
numpad.Register( "HydraulicDir", WinchOn ) -- A little cheat

--[[----------------------------------------------------------------------
	WinchOff - Called to switch the winch off
------------------------------------------------------------------------]]
local function WinchOff( pl, winch )
	if ( !IsValid( winch ) ) then return false end
	winch:SetDirection( 0 )
end
numpad.Register( "WinchOff", WinchOff )

--[[----------------------------------------------------------------------
	WinchToggle - Called to toggle the winch
------------------------------------------------------------------------]]
local function WinchToggle( pl, winch, dir )
	if ( !IsValid( winch ) ) then return false end
	if ( winch:GetDirection() == dir ) then
		winch:SetDirection( 0 )
	else
		winch:SetDirection( dir )
	end
end
numpad.Register( "WinchToggle", WinchToggle )

--[[----------------------------------------------------------------------
	MuscleToggle - Called to toggle the muslce
------------------------------------------------------------------------]]
local function MuscleToggle( pl, hyd )

	if ( !IsValid( hyd ) ) then return false end

	if ( hyd:GetDirection() == 0 ) then
		hyd:SetDirection( 1 )
	else
		hyd:SetDirection( 0 )
	end

end
numpad.Register( "MuscleToggle", MuscleToggle )
