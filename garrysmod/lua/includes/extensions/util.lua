-- Return if there's nothing to add on to
if ( !util ) then return end

if ( CLIENT ) then
	include( "util/worldpicker.lua" );
end

--[[---------------------------------------------------------
	Name:	TraceEntityOBB
	Params:	<table tracedata> <ent entity> <bool quick> <bool verbose>
	Returns: <table result> <table verboseresults>
	Desc:	Traces using an entity's bounding box offset along a line. 
	"Quick" parameter skips tracing through every corner and only traces between the start corner and end corner.
	"Verbose" parameter returns every trace performed in a table
	WARNING: This traces lines between an ent's bounding box corners. Small entities may "slip through".
	TraceData structure:
		Vector mins: Offset mins (lower back left corner). Optional.
		Vector maxs: Offset maxs (upper front right corner). Optional.
		Vector start: Traces from this position, if you /really/ want to. Optional.
		Vector endpos: Traces from the entity's position (or the starting position) to this position. Optional.
		Entity filter: Things the trace should not hit. Can also be a table of entities or a function with one argument.
		boolean ignoreworld: Should the trace ignore world or not
		table output: If set, the trace result will be written to the supplied table instead of returning a new table
-----------------------------------------------------------]]
function util.TraceEntityOBB(tracedata, ent, quick, verbose)
	local mins, maxs = ent:GetModelBounds()
	mins = mins + (tracedata.mins or Vector())
	maxs = maxs + (tracedata.maxs or Vector())
	local corners = {
		mins, --back left bottom
		Vector(mins[1], maxs[2], mins[3]), --back right bottom
		Vector(maxs[1], maxs[2], mins[3]), --front right bottom
		Vector(maxs[1], mins[2], mins[3]), --front left bottom
		Vector(mins[1], mins[2], maxs[3]), --back left top
		Vector(mins[1], maxs[2], maxs[3]), --back right top
		maxs, --front right top
		Vector(maxs[1], mins[2], maxs[3]), --front left top
	}
	local out = {}
	local tr = {}
	for i = 1, #corners do
		if quick then
			util.TraceLine{
				start = LocalToWorld(corners[i], Angle(), tracedata.start or ent:GetPos(), ent:GetAngles()),
				endpos = LocalToWorld(corners[i], Angle(), tracedata.endpos or ent:GetPos(), ent:GetAngles()),
				mask = tracedata.mask,
				filter = tracedata.filter,
				ignoreworld = tracedata.ignoreworld,
				output = tr,
			}
			if verbose then
				out[#out + 1] = {}
				table.CopyFromTo(tr, out[#out])
			else
				if tr.Hit then
					if tracedata.output then
						table.CopyFromTo(tr, tracedata.output)
						break
					end
					return tr
				end
			end
		else
			for j = 1, #corners do
				if corners[i] == corners[j] then continue end
				util.TraceLine{
					start = LocalToWorld(corners[i], Angle(), tracedata.start or ent:GetPos(), ent:GetAngles()),
					endpos = LocalToWorld(corners[j], Angle(), tracedata.endpos or ent:GetPos(), ent:GetAngles()),
					mask = tracedata.mask,
					filter = tracedata.filter,
					ignoreworld = tracedata.ignoreworld,
					output = tr,
				}
				if verbose then
					out[#out + 1] = {}
					table.CopyFromTo(tr, out[#out])
				else
					if tr.Hit then
						if tracedata.output then
							table.CopyFromTo(tr, tracedata.output)
							break
						end
						return tr
					end
				end
			end
		end
	end
	for i = 1, #out do
		if out[i].Hit then
			return tr, out
		end
	end
	return tr
end

--[[---------------------------------------------------------
	Name:	TraceOBB
	Params:	<table tracedata> <bool quick> <bool verbose>
	Returns: <table result> <table verboseresults>
	Desc:	Traces using a bounding box offset along a line. 
	"Quick" parameter skips tracing through every corner and only traces between the start corner and end corner.
	"Verbose" parameter returns every trace performed in a table
	WARNING: This traces lines between bounding box corners. Small entities may "slip through".
	TraceData structure:
		Vector mins: OBB mins (lower back left corner).
		Vector maxs: OBB maxs (upper front right corner).
		Angle angles: Angles of the OBB.
		Vector start: The start position of the trace.
		Vector endpos: The end position of the trace.
		Entity filter: Things the trace should not hit. Can also be a table of entities or a function with one argument.
		boolean ignoreworld: Should the trace ignore world or not
		table output: If set, the trace result will be written to the supplied table instead of returning a new table
-----------------------------------------------------------]]
function util.TraceOBB(tracedata, quick, verbose)
	local mins, maxs = tracedata.mins, tracedata.maxs
	local corners = {
		mins, --back left bottom
		Vector(mins[1], maxs[2], mins[3]), --back right bottom
		Vector(maxs[1], maxs[2], mins[3]), --front right bottom
		Vector(maxs[1], mins[2], mins[3]), --front left bottom
		Vector(mins[1], mins[2], maxs[3]), --back left top
		Vector(mins[1], maxs[2], maxs[3]), --back right top
		maxs, --front right top
		Vector(maxs[1], mins[2], maxs[3]), --front left top
	}
	local out = {}
	local tr = {}
	for i = 1, #corners do
		if quick then
			util.TraceLine{
				start = LocalToWorld(corners[i], Angle(), tracedata.start, tracedata.angles),
				endpos = LocalToWorld(corners[i], Angle(), tracedata.endpos, tracedata.angles),
				mask = tracedata.mask,
				filter = tracedata.filter,
				ignoreworld = tracedata.ignoreworld,
				output = tr,
			}
			if verbose then
				out[#out + 1] = {}
				table.CopyFromTo(tr, out[#out])
			else
				if tr.Hit then
					if tracedata.output then
						table.CopyFromTo(tr, tracedata.output)
						break
					end
					return tr
				end
			end
		else
			for j = 1, #corners do
				if corners[i] == corners[j] then continue end
				util.TraceLine{
					start = LocalToWorld(corners[i], Angle(), tracedata.start, tracedata.angles),
					endpos = LocalToWorld(corners[j], Angle(), tracedata.endpos, tracedata.angles),
					mask = tracedata.mask,
					filter = tracedata.filter,
					ignoreworld = tracedata.ignoreworld,
					output = tr,
				}
				if verbose then
					out[#out + 1] = {}
					table.CopyFromTo(tr, out[#out])
				else
					if tr.Hit then
						if tracedata.output then
							table.CopyFromTo(tr, tracedata.output)
							break
						end
						return tr
					end
				end
			end
		end
	end
	for i = 1, #out do
		if out[i].Hit then
			return tr, out
		end
	end
	return tr
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
