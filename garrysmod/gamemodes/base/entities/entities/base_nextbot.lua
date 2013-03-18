
ENT.Base 			= "base_entity"
ENT.Type 			= "nextbot"
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.RenderGroup		= RENDERGROUP_OPAQUE


function ENT:Initialize()

	
end

--
-- Name: ENT:Behave_Switch
-- Desc: wip
-- Arg1: 
-- Ret1:
--
function ENT:Behave_Switch( behaviour, init )

	local init = init or {}

	behaviour.__index = behaviour;
	setmetatable( init, behaviour )

	self.BehaveStack:Push( behaviour );

end

--
-- Name: ENT:BehaviourInit
-- Desc: Should be called in your child class to initialize the behaviour stuff
-- Arg1: behaviour|behaviour|The initial behaviour state to use
-- Ret1:
--
function ENT:BehaviourInit( behaviour )

	-- This should only be called once!
	if ( self.BehaveStack ) then
		error( "BehaviourInit called twice!" )
	end

	-- Create the Behaviour Stack
	self.BehaveStack = util.Stack()

	-- If they gave us a behaviour then add it
	if ( behaviour ) then
		self:Behave_Switch( behaviour )
	end	

end

--
-- Name: ENT:BehaveStart
-- Desc: Called to initialize the behaviour
-- Arg1: 
-- Ret1:
--
function ENT:BehaveStart()

	
end

--
-- Name: ENT:BehaveUpdate
-- Desc: Called to update the bot's behaviour
-- Arg1: number|interval|How long since the last update
-- Ret1:
--
function ENT:BehaveUpdate( fInterval )

	local behaviour = self.BehaveStack:Top()

	if ( !behaviour ) then return end

	--
	-- The behaviour isn't started yet - call Start
	--
	if ( !behaviour.bStarted ) then

		behaviour.bStarted = true
			
		if ( behaviour.Start ) then
			behaviour:Start( self )
		end

	end

	--
	-- Call Update if it exists
	--
	if ( behaviour.Update ) then
		behaviour:Update( self, fInterval )
	end

end

--
-- Name: ENT:BodyUpdate
-- Desc: Called to update the bot's animation
-- Arg1:
-- Ret1:
--
function ENT:BodyUpdate()

	--MsgN( "BodyUpdate" )

end

--
-- Name: ENT:OnLeaveGround
-- Desc: Called when the bot's feet leave the ground - for whatever reason
-- Arg1:
-- Ret1:
--
function ENT:OnLeaveGround()

	MsgN( "OnLeaveGround" )

end

--
-- Name: ENT:OnLeaveGround
-- Desc: Called when the bot's feet return to the ground
-- Arg1:
-- Ret1:
--
function ENT:OnLandOnGround()

	MsgN( "OnLandOnGround" )

end

--
-- Name: ENT:OnStuck
-- Desc: Called when the bot thinks it is stuck
-- Arg1:
-- Ret1:
--
function ENT:OnStuck()

	MsgN( "OnStuck" )

end

--
-- Name: ENT:OnUnStuck
-- Desc: Called when the bot thinks it is un-stuck
-- Arg1:
-- Ret1:
--
function ENT:OnUnStuck()

	MsgN( "OnUnStuck" )

end

--
-- Name: ENT:OnInjured
-- Desc: Called when the bot gets hurt
-- Arg1:
-- Ret1:
--
function ENT:OnInjured()

	MsgN( "OnInjured" )

end

--
-- Name: ENT:OnKilled
-- Desc: Called when the bot gets killed
-- Arg1:
-- Ret1:
--
function ENT:OnKilled()

	MsgN( "OnKilled" )

end

--
-- Name: ENT:OnOtherKilled
-- Desc: Called when someone else or something else has been killed
-- Arg1:
-- Ret1:
--
function ENT:OnOtherKilled()

	MsgN( "OnKilled" )

end
