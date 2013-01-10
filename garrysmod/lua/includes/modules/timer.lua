
require( 'hook' )

-- Globals that we need.
local CurTime = CurTime
local UnPredictedCurTime = UnPredictedCurTime
local pairs = pairs
local table = table
local ErrorNoHalt = ErrorNoHalt
local hook = hook
local tostring = tostring
local debug = debug
local isnumber = isnumber
local isfunction = isfunction
local isstring = isstring
local error = error

--[[---------------------------------------------------------
   Name: timer
   Desc: A module implementing timed execution of functions.
-----------------------------------------------------------]]
module("timer")

-- Some definitions
local PAUSED = -1
local STOPPED = 0
local RUNNING = 1

-- Declare our locals
local Timer = {}
local TimerSimple = {}

local function CreateTimer( name )

	if ( Timer[name] == nil ) then
		Timer[name] = {}
		Timer[name].Status = STOPPED
		return true
	end

	return false

end

--[[---------------------------------------------------------
   Name: Exists( name )
   Desc: Returns boolean whether or not name is a timer.
-----------------------------------------------------------]]
function Exists( name )

	return Timer[name] != nil

end

--[[---------------------------------------------------------
   Name: Create( name, delay, reps, func )
   Desc: Setup and start a timer by name.
-----------------------------------------------------------]]
function Create( name, delay, reps, func, a, b, c )

	if ( !isstring( name ) || !isfunction( func ) || a != nil || b != nil || c != nil || !isnumber( delay ) || !isnumber( reps ) ) then
		error( "timer.Create - called wrong!\n" )
		return
	end

	if ( Exists( name ) ) then
		Destroy( name )
	end

	Adjust( name, delay, reps, func )
	Start( name )

end

--[[---------------------------------------------------------
   Name: Start( name )
   Desc: (Re)start the timer by name.
-----------------------------------------------------------]]
function Start( name )
	if ( !Exists( name ) ) then return false; end
	Timer[name].n = 0
	Timer[name].Status = RUNNING
	Timer[name].Last = CurTime()
	return true;
end

--[[---------------------------------------------------------
   Name: Adjust( name, delay, reps, func )
   Desc: Adjust a running, stopped or paused timer by name.
-----------------------------------------------------------]]
function Adjust( name, delay, reps, func )
	CreateTimer( name )
	Timer[name].Delay = delay
	Timer[name].Repetitions = reps
	if ( func != nil ) then Timer[name].Func = func end
	return true;
end

--[[---------------------------------------------------------
   Name: Pause( name )
   Desc: Pause a running timer by name.
-----------------------------------------------------------]]
function Pause( name )
	if ( !Exists( name ) ) then return false; end
	if ( Timer[name].Status == RUNNING ) then
		Timer[name].Diff = CurTime() - Timer[name].Last
		Timer[name].Status = PAUSED
		return true
	end
	return false
end

--[[---------------------------------------------------------
   Name: UnPause( name )
   Desc: Unpause a paused timer by name.
-----------------------------------------------------------]]
function UnPause( name )
	if ( !Exists( name ) ) then return false; end
	if ( Timer[name].Status == PAUSED ) then
		Timer[name].Diff = nil
		Timer[name].Status = RUNNING
		return true
	end
	return false
end

--[[---------------------------------------------------------
   Name: Toggle( name )
   Desc: Toggle a timer's pause state by name.
-----------------------------------------------------------]]
function Toggle( name )
	if ( Exists( name ) ) then
		if ( Timer[name].Status == PAUSED ) then
			return UnPause( name )
		elseif ( Timer[name].Status == RUNNING ) then
			return Pause( name )
		end
	end
	return false
end

--[[---------------------------------------------------------
   Name: Stop( name )
   Desc: Stop a running or paused timer by name.
-----------------------------------------------------------]]
function Stop( name )
	if ( !Exists( name ) ) then return false; end
	if ( Timer[name].Status != STOPPED ) then
		Timer[name].Status = STOPPED
		return true
	end
	return false
end

--[[---------------------------------------------------------
   Name: Check()
   Desc: Check all timers and complete any tasks needed.
		This should be run every frame.
-----------------------------------------------------------]]
function Check()

	for key, value in pairs( Timer ) do
	
		if ( value.Status == PAUSED ) then
		
			value.Last = CurTime() - value.Diff
			
		elseif ( value.Status == RUNNING && ( value.Last + value.Delay ) <= CurTime() ) then
				
			value.Last = CurTime()
			value.n = value.n + 1 
			
			if ( value.n >= value.Repetitions && value.Repetitions != 0) then
				Stop( key )
			end

			value.Func()
				
		end
		
	end
	
	-- Run Simple timers
	for key, value in pairs( TimerSimple ) do

		if ( value.Finish <= CurTime() ) then
			
			table.remove( TimerSimple, key )
			
			value.Func()
						
		end
	end
	
end

--[[---------------------------------------------------------
   Name: Destroy( name )
   Desc: Destroy the timer by name and remove all evidence.
-----------------------------------------------------------]]
function Destroy( name )
	Timer[ name ] = nil
end

Remove = Destroy

--[[---------------------------------------------------------
   Name: Simple( delay, func )
   Desc: Make a simple "create and forget" timer
-----------------------------------------------------------]]
function Simple( delay, func, a, b, c )
	
	if ( !isfunction(func) || a != nil || b != nil || c != nil || !isnumber( delay ) ) then
		error( "timer.Simple - called wrong!\n" )
		return
	end

	local new_timer = {}
	
	new_timer.Finish	= UnPredictedCurTime() + delay
	new_timer.Func		= func 
	new_timer.Debug		= debug.traceback()
	
	table.insert( TimerSimple, new_timer )
	
	return true;
	
end

hook.Add( "Think", "CheckTimers", Check )