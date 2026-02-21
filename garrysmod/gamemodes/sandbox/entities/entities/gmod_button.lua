
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Button"
ENT.Editable = true

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "Key" )
	self:NetworkVar( "Bool", 0, "On" )
	self:NetworkVar( "Bool", 1, "IsToggle", { KeyName = "tg", Edit = { type = "Boolean", order = 1, title = "#tool.button.toggle" } } )
	self:NetworkVar( "String", 0, "Label", { KeyName = "lbl", Edit = { type = "Generic", order = 2, title = "#tool.button.text" } } )

	if ( SERVER ) then
		self:SetOn( false )
		self:SetIsToggle( false )
	end

end

function ENT:Initialize()

	if ( SERVER ) then

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( ONOFF_USE )

	else

		self.PosePosition = 0

	end

end

function ENT:GetOverlayText()

	local text = self:GetLabel()

	text = string.gsub( text, "\\", "" )
	text = string.sub( text, 0, 20 )

	if ( text == "" ) then return "" end

	local txt =  "\"" .. text .. "\""

	if ( txt == "" ) then return "" end
	if ( game.SinglePlayer() ) then return txt end

	return txt .. "\n(" .. self:GetPlayerName() .. ")"

end

function ENT:Use( activator, caller, type, value )

	if ( !activator:IsPlayer() ) then return end -- Who the frig is pressing this shit!?

	if ( self:GetIsToggle() ) then

		if ( type == USE_ON ) then
			self:Toggle( !self:GetOn(), activator )
		end
		return

	end

	if ( IsValid( self.LastUser ) ) then return end -- Someone is already using this button

	--
	-- Switch off
	--
	if ( self:GetOn() ) then
		self:Toggle( false, activator )
		return
	end

	--
	-- Switch on
	--
	self:Toggle( true, activator )
	self:NextThink( CurTime() )
	self.LastUser = activator

end

function ENT:Think()

	-- Add a world tip if the player is looking at it
	self.BaseClass.Think( self )

	-- Update the animation
	if ( CLIENT ) then

		self:UpdateLever()

	end

	--
	-- If the player looks away while holding down use it will stay on
	-- Lets fix that..
	--
	if ( SERVER && self:GetOn() && !self:GetIsToggle() ) then

		if ( !IsValid( self.LastUser ) || !self.LastUser:KeyDown( IN_USE ) ) then

			self:Toggle( false, self.LastUser )
			self.LastUser = nil

		end

		self:NextThink( CurTime() )

	end

end

--
-- Makes the button trigger the keys
--
function ENT:Toggle( bEnable, ply )

	-- If a button has a valid player on it, use that, if not, use activator
	local targetPly = self:GetPlayer()
	if ( !IsValid( targetPly ) ) then targetPly = ply end

	if ( bEnable ) then

		numpad.Activate( targetPly, self:GetKey(), true )
		self:SetOn( true )

	else

		numpad.Deactivate( targetPly, self:GetKey(), true )
		self:SetOn( false )

	end

end

--
-- Update the lever animation
--
function ENT:UpdateLever()

	local TargetPos = 0.0
	if ( self:GetOn() ) then TargetPos = 1.0 end

	self.PosePosition = math.Approach( self.PosePosition, TargetPos, FrameTime() * 5.0 )

	self:SetPoseParameter( "switch", self.PosePosition )
	self:InvalidateBoneCache()

end
