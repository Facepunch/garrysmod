
--[[---------------------------------------------------------
	Name: RunAI - Called from the engine every 0.1 seconds
-----------------------------------------------------------]]
function ENT:RunAI( strExp )

	-- If we're running an Engine Side behaviour
	-- then return true and let it get on with it.
	if ( self:IsRunningBehavior() ) then
		return true
	end

	-- If we're doing an engine schedule then return true
	-- This makes it do the normal AI stuff.
	if ( self:DoingEngineSchedule() ) then
		return true
	end

	-- If we're currently running a schedule then run it.
	if ( self.CurrentSchedule ) then
		self:DoSchedule( self.CurrentSchedule )
	end

	-- If we have no schedule (schedule is finished etc)
	-- Then get the derived NPC to select what we should be doing
	if ( !self.CurrentSchedule ) then
		self:SelectSchedule()
	end

	-- Do animation system
	self:MaintainActivity()

end

--[[---------------------------------------------------------
	Name: SelectSchedule - Set the schedule we should be
							playing right now.
-----------------------------------------------------------]]
function ENT:SelectSchedule( iNPCState )

	self:SetSchedule( SCHED_IDLE_WANDER )

end

--[[---------------------------------------------------------
	Name: StartSchedule - Start a Lua schedule. Not to be
		confused with SetSchedule which starts an Engine based
		schedule.
-----------------------------------------------------------]]
function ENT:StartSchedule( schedule )

	self.CurrentSchedule 	= schedule
	self.CurrentTaskID 		= 1
	self:SetTask( schedule:GetTask( 1 ) )

end



--[[---------------------------------------------------------
	Name: DoSchedule - Runs a Lua schedule.
-----------------------------------------------------------]]
function ENT:DoSchedule( schedule )

	if ( self.CurrentTask ) then
		self:RunTask( self.CurrentTask )
	end

	if ( self:TaskFinished() ) then
		self:NextTask( schedule )
	end

end



--[[---------------------------------------------------------
	Name: ScheduleFinished
-----------------------------------------------------------]]
function ENT:ScheduleFinished()

	self.CurrentSchedule 	= nil
	self.CurrentTask 		= nil
	self.CurrentTaskID 		= nil

end



--[[---------------------------------------------------------
	Name: DoSchedule - Set the current task.
-----------------------------------------------------------]]
function ENT:SetTask( task )

	self.CurrentTask 	= task
	self.bTaskComplete 	= false
	self.TaskStartTime 	= CurTime()

	self:StartTask( self.CurrentTask )

end



--[[---------------------------------------------------------
	Name: NextTask - Start the next task in specific schedule.
-----------------------------------------------------------]]
function ENT:NextTask( schedule )

	-- Increment task id
	self.CurrentTaskID = self.CurrentTaskID + 1

	-- If this was the last task then finish up.
	if ( self.CurrentTaskID > schedule:NumTasks() ) then

		self:ScheduleFinished( schedule )
		return

	end

	-- Switch to next task
	self:SetTask( schedule:GetTask( self.CurrentTaskID ) )

end

--[[---------------------------------------------------------
	Name: StartTask - called once on starting task
-----------------------------------------------------------]]
function ENT:StartTask( task )
	task:Start( self )
end

--[[---------------------------------------------------------
	Name: RunTask - called every think on running task.
			The actual task function should tell us when
			the task is finished.
-----------------------------------------------------------]]
function ENT:RunTask( task )
	task:Run( self )
end

--[[---------------------------------------------------------
	Name: TaskTime - Returns how many seconds we've been
						doing this current task
-----------------------------------------------------------]]
function ENT:TaskTime()
	return CurTime() - self.TaskStartTime
end

--[[---------------------------------------------------------
	Name: OnTaskComplete - Called from the engine when
			TaskComplete is called. This allows us to move
			onto the next task - even when TaskComplete was
			called from an engine side task.
-----------------------------------------------------------]]
function ENT:OnTaskComplete()

	self.bTaskComplete = true

end

--[[---------------------------------------------------------
	Name: TaskFinished - Returns true if the current
							running Task is finished.
-----------------------------------------------------------]]
function ENT:TaskFinished()
	return self.bTaskComplete
end

--[[---------------------------------------------------------
	Name: StartTask
		Start the task. You can use this to override engine
		side tasks. Return true to not run default stuff.
-----------------------------------------------------------]]
function ENT:StartEngineTask( iTaskID, TaskData )
end

--[[---------------------------------------------------------
	Name: RunTask
		Run the task. You can use this to override engine
		side tasks. Return true to not run default stuff.
-----------------------------------------------------------]]
function ENT:RunEngineTask( iTaskID, TaskData )
end

--[[---------------------------------------------------------
	These functions handle the engine schedules
	When an engine schedule is set the engine calls StartEngineSchedule
	Then when it's finished it calls EngineScheduleFinishHelp me decide
-----------------------------------------------------------]]
function ENT:StartEngineSchedule( scheduleID ) self:ScheduleFinished() self.bDoingEngineSchedule = true end
function ENT:EngineScheduleFinish() self.bDoingEngineSchedule = nil end
function ENT:DoingEngineSchedule()	return self.bDoingEngineSchedule end

function ENT:OnCondition( iCondition )

	--Msg( self, " Condition: ", iCondition, " - ", self:ConditionName(iCondition), "\n" )

end

function ENT:TranslateActivity( act )

	-- Return a value to translate the activity to a new one
	-- if ( act == ACT_WALK ) then return ACT_RUN end

end
