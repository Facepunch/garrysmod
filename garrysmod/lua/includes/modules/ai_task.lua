
-- Serverside only.
if ( CLIENT ) then return end

local setmetatable	= setmetatable
--local table			= table
local ai			= ai

module( "ai_task" )

--[[---------------------------------------------------------
	ENUMs for which kind of task it is.
-----------------------------------------------------------]]
local TYPE_ENGINE	= 1
local TYPE_FNAME	= 2

--[[---------------------------------------------------------
	Keep track of created tasks
	UNDONE: There's no need for this right now.
-----------------------------------------------------------]]
--local Task_Index = {}

--[[---------------------------------------------------------
	Task metatable
-----------------------------------------------------------]]
local Task = {}
Task.__index = Task

function Task:Init()
	self.Type = nil
end

--[[---------------------------------------------------------
	Creates an engine based task
-----------------------------------------------------------]]
function Task:InitEngine( _taskname_, _taskdata_ )

	self.TaskName	= _taskname_
	self.TaskID		= nil
	self.TaskData	= _taskdata_
	self.Type		= TYPE_ENGINE

end

--[[---------------------------------------------------------
	Creates an engine based task
-----------------------------------------------------------]]
function Task:InitFunctionName( _start, _end, _taskdata_ )
	self.StartFunctionName	= _start
	self.FunctionName		= _end
	self.TaskData			= _taskdata_
	self.Type				= TYPE_FNAME
end

function Task:IsEngineType()
	return ( self.Type == TYPE_ENGINE )
end

function Task:IsFNameType()
	return ( self.Type == TYPE_FNAME )
end

function Task:Start( npc )

	if ( self:IsFNameType() ) then self:Start_FName( npc ) return end

	if ( self:IsEngineType() ) then

		if ( !self.TaskID ) then self.TaskID = ai.GetTaskID( self.TaskName ) end

		npc:StartEngineTask( self.TaskID, self.TaskData )
	end

end

--[[---------------------------------------------------------
	Start_FName (called from Task:Start)
-----------------------------------------------------------]]
function Task:Start_FName( npc )

	if ( !self.StartFunctionName ) then return end
	--if ( !npc[ self.StartFunctionName ] ) then return end

	-- Run the start function. Safely.
	npc[ self.StartFunctionName ]( npc, self.TaskData )

end

function Task:Run( npc )

	if ( self:IsFNameType() ) then self:Run_FName( npc ) return end

	if ( self:IsEngineType() ) then
		npc:RunEngineTask( self.TaskID, self.TaskData )
	end

end

function Task:Run_FName( npc )

	if ( !self.FunctionName ) then return end
	--if (!npc[ self.StartFunctionName ]) then return end

	-- Run the start function. Safely.
	npc[ self.FunctionName ]( npc, self.TaskData )

end

--[[---------------------------------------------------------
	Create a new empty task (this is ai_task.New )
-----------------------------------------------------------]]
function New()

	local pNewTask = {}
	setmetatable( pNewTask, Task )

	pNewTask:Init()

	--table.insert( Task_Index, pNewTask )

	return pNewTask

end
