-- Return if there's nothing to add on to
if ( !util ) then return end

if ( CLIENT ) then
	include( "util/worldpicker.lua" );
end

--[[---------------------------------------------------------
   Name:	IsValidPhysicsObject
   Params: 	<ent> <num>
   Desc:	Returns true if physics object is valid, false if not
-----------------------------------------------------------]]   
function util.IsValidPhysicsObject( ent, num )

	-- Make sure the entity is valid
	if ( !ent || (!ent:IsValid() && !ent:IsWorld()) ) then return false end

	-- This is to stop attaching to walking NPCs.
	-- Although this is possible and `works', it can severly reduce the 
	-- performance of the server.. Plus they don't pay attention to constraints
	-- anyway - so we're not really losing anything.
	
	local MoveType = ent:GetMoveType()
	if ( !ent:IsWorld() && MoveType != MOVETYPE_VPHYSICS ) then return false end

	local Phys = ent:GetPhysicsObjectNum( num )
	return IsValid( Phys )

end

--[[---------------------------------------------------------
   Name: GetPlayerTrace( ply, dir )
   Desc: Returns a generic trace table for the player
		 (dir is optional, defaults to the player's aim)
-----------------------------------------------------------]]
function util.GetPlayerTrace( ply, dir )

	dir = dir or ply:GetAimVector()

	local trace = {}
	
	trace.start = ply:EyePos()
	trace.endpos = trace.start + (dir * (4096 * 8))
	trace.filter = ply
	
	return trace
	
end


--[[---------------------------------------------------------
   Name: QuickTrace( origin, offset, filter )
   Desc: Quick trace
-----------------------------------------------------------]]
function util.QuickTrace( origin, dir, filter )

	local trace = {}
	
	trace.start = origin
	trace.endpos = origin + dir
	trace.filter = filter
	
	return util.TraceLine( trace )
	
end


--[[---------------------------------------------------------
   Name: tobool( in )
   Desc: Turn variable into bool
-----------------------------------------------------------]]
util.tobool = tobool


--[[---------------------------------------------------------
   Name: LocalToWorld( ent, lpos, bone )
   Desc: Convert the local position on an entity to world pos
-----------------------------------------------------------]]
function util.LocalToWorld( ent, lpos, bone )
	bone = bone or 0
	if (ent:EntIndex() == 0) then
		return lpos
	else
		if (ent:GetPhysicsObjectNum(bone) ~= nil && ent:GetPhysicsObjectNum(bone):IsValid()) then
			return ent:GetPhysicsObjectNum(bone):LocalToWorld(lpos)
		else
			return ent:LocalToWorld(lpos)
		end
	end
	return nil
end


--[[---------------------------------------------------------
   Returns year, month, day and hour, minute, second in a formatted string.
-----------------------------------------------------------]]
function util.DateStamp()

	local t = os.date('*t')
	return t.year.."-"..t.month.."-"..t.day .." ".. Format( "%02i-%02i-%02i", t.hour, t.min, t.sec )
end

--[[---------------------------------------------------------
   Convert a string to a certain type
-----------------------------------------------------------]]
function util.StringToType( str, typename )

	typename = typename:lower()

	if ( typename == "vector" )	then return Vector( str ) end
	if ( typename == "angle" )	then return Angle( str ) end
	if ( typename == "float" )	then return tonumber( str ) end
	if ( typename == "int" )	then return math.Round( tonumber( str ) ) end
	if ( typename == "bool" )	then return tobool( str ) end
	if ( typename == "string" )	then return tostring( str ) end

	MsgN( "util.StringToType: unknown type \"", typename, "\"!" )

end

--
-- Convert a type to a (nice, but still parsable) string
--
function util.TypeToString( v )

	local t = type( v )
	t = t:lower()

	if ( t == "vector" ) then
		return string.format( "%.2f %.2f %.2f", v.x, v.y, v.z )
	end

	if ( t == "number" ) then
		return util.NiceFloat( v )
	end

	return tostring( v )

end


--
-- Formats a float by stripping off extra 0's and .'s
--
--	0.00	->		0
--	0.10	->		0.1
--	1.00	->		1
--	1.49	->		1.49
--	5.90	->		5.9
--
function util.NiceFloat( f )

	local str = string.format( "%f", f )

	str = str:TrimRight( "0" )
	str = str:TrimRight( "." )

	return str

end



--
-- Timer
--
--
local T = 
{

	--
	-- Resets the timer to nothing
	--
	Reset = function( self )

		self.endtime = nil

	end,

	--
	-- Starts the timer, call with end time
	--
	Start = function( self, time )

		self.endtime = CurTime() + time

	end,

	--
	-- Returns true if the timer has been started
	--
	Started = function( self )

		return self.endtime != nil

	end,

	--
	-- Returns true if the time has elapsed
	--
	Elapsed = function( self )

		return self.endtime == nil || self.endtime <= CurTime()

	end
}

T.__index = T

--
-- Create a new timer object
--
function util.Timer( startdelay )

	startdelay = startdelay or 0

	local t = {}
	setmetatable( t, T )
	t.endtime = CurTime() + startdelay
	return t

end


--
-- Stack
--
--
local T = 
{

	--
	-- Name: Stack:Push
	-- Desc: Push an item onto the stack
	-- Arg1: any|object|The item you want to push
	-- Ret1:
	--
	Push = function( self, obj )

		self.top = obj
		self.objs[ #self.objs + 1 ] = obj

	end,

	--
	-- Name: Stack:Pop
	-- Desc: Pop an item from the stack
	-- Arg1: number|amount|Optional amount of items you want to pop (defaults to 1)
	-- Ret1:
	--
	Pop = function( self, num )
		
		local num = num or 1

		if ( num > #self.objs ) then
			error( "Overpopped stack!" );
		end

		for i = num, 1, -1 do
			table.remove( self.objs )
		end

		self.top = self.objs[ #self.objs ]

	end,

	--
	-- Name: Stack:Top
	-- Desc: Get the item at the top of the stack
	-- Arg1:
	-- Ret1: any|The item
	--
	Top = function( self, time )

		return self.top

	end,

	--
	-- Name: Stack:Size
	-- Desc: Returns the size of the stack
	-- Arg1:
	-- Ret1: number|The size of the stack
	--
	Size = function( self, time )

		return #self.objs

	end,

}

T.__index = T

--
-- Name: util.Stack
-- Desc: Returns a new Stack object
-- Arg1:
-- Ret1: Stack|a brand new stack object
--
function util.Stack()

	local t = {}
	setmetatable( t, T )
	t.objs = {}
	return t

end

--Helper for the following functions.
local function GetUniqueID( sid )
	return util.CRC( "gm_"..sid.."_gm" )
end

--[[---------------------------------------------------------
   Name: GetPData( steamid, name, default )
   Desc: Gets the persistant data from a player by steamid
-----------------------------------------------------------]]
function util.GetPData( steamid, name, default )

	name = Format( "%s[%s]", GetUniqueID( steamid ), name )
	local val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr(name) .. " LIMIT 1" )
	if ( val == nil ) then return default end
	
	return val
	
end

--[[---------------------------------------------------------
   Name: SetPData( steamid, name, value )
   Desc: Sets the persistant data of a player by steamid
-----------------------------------------------------------]]
function util.SetPData( steamid, name, value )

	name = Format( "%s[%s]", GetUniqueID( steamid ), name )
	sql.Query( "REPLACE INTO playerpdata ( infoid, value ) VALUES ( "..SQLStr(name)..", "..SQLStr(value).." )" )
	
end

--[[---------------------------------------------------------
   Name: RemovePData( steamid, name )
   Desc: Removes the persistant data from a player by steamid
-----------------------------------------------------------]]
function util.RemovePData( steamid, name )

	name = Format( "%s[%s]", GetUniqueID( steamid ), name )
	sql.Query( "DELETE FROM playerpdata WHERE infoid = "..SQLStr(name) )
	
end
