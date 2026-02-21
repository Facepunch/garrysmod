
if ( SERVER ) then return end

local meta = FindMetaTable( "Panel" )

--[[---------------------------------------------------------
	Name: SetTerm
	Desc: Kill the panel at this time
-----------------------------------------------------------]]
function meta:SetTerm( term )

	self.Term = SysTime() + term
	self:SetAnimationEnabled( true )

end

--[[---------------------------------------------------------
	Name: AnimationThinkInternal
-----------------------------------------------------------]]  
function meta:AnimationThinkInternal()

	local systime = SysTime()

	if ( self.Term && self.Term <= systime ) then self:Remove() return end
	if ( !self.m_AnimList ) then return end -- This can happen if we only have term

	for k, anim in pairs( self.m_AnimList ) do

		if ( systime >= anim.StartTime ) then

			local Fraction = math.TimeFraction( anim.StartTime, anim.EndTime, systime )
			Fraction = math.Clamp( Fraction, 0, 1 )

			if ( anim.Think ) then

				local Frac = Fraction ^ anim.Ease

				-- Ease of -1 == ease in out
				if ( anim.Ease < 0 ) then
					Frac = Fraction ^ ( 1.0 - ( ( Fraction - 0.5 ) ) )
				elseif ( anim.Ease > 0 && anim.Ease < 1 ) then
					Frac = 1 - ( ( 1 - Fraction ) ^ ( 1 / anim.Ease ) )
				end

				anim:Think( self, Frac )
			end

			if ( Fraction == 1 ) then

				if ( anim.OnEnd ) then anim:OnEnd( self ) end

				self.m_AnimList[k] = nil
			end

		end

	end

end

--[[---------------------------------------------------------
	Name: SetAnimationEnabled
	Desc: Enables animations on a panel
-----------------------------------------------------------]]  
function meta:SetAnimationEnabled( b )

	if ( !b ) then
		self.AnimationThink = nil
		return
	end

	if ( self.AnimationThink ) then return end

	self.AnimationThink = self.AnimationThinkInternal

end

function meta:Stop()

	self.m_AnimList = {}

end

function meta:Queue()

	self.m_AnimQueue = true

end

function meta:AnimTail()

	local last = SysTime()

	for k, anim in pairs( self.m_AnimList ) do
		last = math.max( last, anim.EndTime )
	end

	return last

end

--[[---------------------------------------------------------
	Name: NewAnimation
	Desc: Creates a new animation
-----------------------------------------------------------]]  
function meta:NewAnimation( length, delay, ease, callback )

	if ( delay == nil ) then delay = 0 end
	if ( ease == nil ) then ease = -1 end

	if ( self.m_AnimQueue ) then

		delay = delay + self:AnimTail()
		self.m_AnimQueue = false

	else

		delay = delay + SysTime()

	end

	local anim = {
		EndTime = delay + length,
		StartTime = delay,
		Ease = ease,
		OnEnd = callback
	}

	self:SetAnimationEnabled( true )
	if ( self.m_AnimList == nil ) then self.m_AnimList = {} end

	table.insert( self.m_AnimList, anim )

	return anim

end

local function MoveThink( anim, panel, fraction )

	if ( !anim.StartPos ) then anim.StartPos = Vector( panel.x, panel.y, 0 ) end
	local pos = LerpVector( fraction, anim.StartPos, anim.Pos )
	panel:SetPos( pos.x, pos.y )

end

--[[---------------------------------------------------------
	Name: MoveTo
-----------------------------------------------------------]]
function meta:MoveTo( x, y, length, delay, ease, callback )

	if ( self.x == x && self.y == y ) then return end

	local anim = self:NewAnimation( length, delay, ease, callback )
	anim.Pos = Vector( x, y, 0 )
	anim.Think = MoveThink

end

local function SizeThink( anim, panel, fraction )

	if ( !anim.StartSize ) then local w, h = panel:GetSize() anim.StartSize = Vector( w, h, 0 ) end

	local size = LerpVector( fraction, anim.StartSize, anim.Size )

	if ( anim.SizeX && anim.SizeY ) then
		panel:SetSize( size.x, size.y )
	elseif ( anim.SizeX ) then
		panel:SetWide( size.x )
	else
		panel:SetTall( size.y )
	end

	if ( panel:GetDock() > 0 ) then
		panel:InvalidateParent()
	end

end

--[[---------------------------------------------------------
	Name: SizeTo
-----------------------------------------------------------]]
function meta:SizeTo( w, h, length, delay, ease, callback )

	local anim = self:NewAnimation( length, delay, ease, callback )

	anim.SizeX = w != -1
	anim.SizeY = h != -1

	if ( !anim.SizeX ) then  w = self:GetWide() end
	if ( !anim.SizeY ) then  h = self:GetTall() end

	anim.Size = Vector( w, h, 0 )

	anim.Think = SizeThink
	return anim

end

--[[---------------------------------------------------------
	Name: SlideUp
-----------------------------------------------------------]]
function meta:SlideUp( length )

	local height = self:GetTall()
	local anim = self:SizeTo( -1, 0, length )
	anim.OnEnd = function()
		self:SetVisible( false )
		self:SetTall( height )
	end

end

--[[---------------------------------------------------------
	Name: SlideDown
-----------------------------------------------------------]]
function meta:SlideDown( length )

	local height = self:GetTall()
	self:SetVisible( true )
	self:SetTall( 0 )

	local anim = self:SizeTo( -1, height, length )

end

local function ColorThink( anim, panel, fraction )

	if ( !anim.StartColor ) then anim.StartColor = panel:GetColor() end

	panel:SetColor( Color( Lerp( fraction, anim.StartColor.r, anim.Color.r ),
					Lerp( fraction, anim.StartColor.g, anim.Color.g ),
					Lerp( fraction, anim.StartColor.b, anim.Color.b ),
					Lerp( fraction, anim.StartColor.a, anim.Color.a ) ) )

end

--[[---------------------------------------------------------
	Name: ColorTo
-----------------------------------------------------------]]
function meta:ColorTo( col, length, delay, callback )

	-- We can only use this on specific panel types!
	if ( !self.SetColor ) then return end
	if ( !self.GetColor ) then return end

	local anim = self:NewAnimation( length, delay, nil, callback )
	anim.Color = col
	anim.Think = ColorThink

end

local function AlphaThink( anim, panel, fraction )

	if ( !anim.StartAlpha ) then anim.StartAlpha = panel:GetAlpha() end

	panel:SetAlpha( Lerp( fraction, anim.StartAlpha, anim.Alpha ) )

end

--[[---------------------------------------------------------
	Name: AlphaTo
-----------------------------------------------------------]]
function meta:AlphaTo( alpha, length, delay, callback )

	local anim = self:NewAnimation( length, delay, nil, callback )
	anim.Alpha = alpha
	anim.Think = AlphaThink

end

local function MoveByThink( anim, panel, fraction )

	if ( !anim.StartPos ) then
		anim.StartPos = Vector( panel.x, panel.y, 0 )
		anim.Pos = anim.StartPos + anim.Pos
	end

	local pos = LerpVector( fraction, anim.StartPos, anim.Pos )
	panel:SetPos( pos.x, pos.y )

end

--[[---------------------------------------------------------
	Name: MoveBy
-----------------------------------------------------------]]
function meta:MoveBy( x, y, length, delay, ease, callback )

	local anim = self:NewAnimation( length, delay, ease, callback )
	anim.Pos = Vector( x, y, 0 )
	anim.Think = MoveByThink

end

-- This code is bad and will run forever, never reaching the targetpos.
local function LerpPositions( anim, panel )

	if ( !panel.TargetPos ) then return end

	local Speed = FrameTime() * 100 * anim.Speed
	local Pos = Vector( panel.x, panel.y, 0 )
	local Distance = panel.TargetPos - Pos
	local Length = Distance:Length()

	if ( anim.UseGravity && Length > 1 ) then
		Speed = Speed * ( Length * 0.1 )
	else
		Speed = Speed * 10
	end

	if ( Length < Speed ) then
		panel:SetPosReal( panel.TargetPos.x, panel.TargetPos.y )
		panel.TargetPos = nil
		return
	end

	Distance:Normalize()
	Distance = Pos + ( Distance * Speed )

	panel:SetPosReal( Distance.x, Distance.y )

end

local function NewSetPos( self, x, y )

	self.TargetPos = Vector( x, y )

end

local function NewGetPos( self )

	return self.TargetPos.x, self.TargetPos.y

end

--[[---------------------------------------------------------
	Name: LerpPositions
-----------------------------------------------------------]]
function meta:LerpPositions( speed, usegravity )

	if ( self.SetPosReal ) then return end

	NewSetPos( self, self:GetPos() )

	self.SetPosReal = self.SetPos
	self.SetPos = NewSetPos
	self.GetPosReal = self.GetPos
	self.GetPos = NewGetPos

	self.LerpAnim = self:NewAnimation( 86400 )
	self.LerpAnim.Speed = speed
	self.LerpAnim.UseGravity = usegravity
	self.LerpAnim.Think = LerpPositions

end

--
-- DisableLerp
--
function meta:DisableLerp()

	self.LerpAnim = nil
	self.SetPos = self.SetPosReal
	self.GetPos = self.GetPosReal

end
