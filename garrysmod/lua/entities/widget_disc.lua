
AddCSLuaFile()

local matDisc = Material( "widgets/disc.png", "nocull alphatest smooth mips" )
local matDiscAlpha = Material( "widgets/disc.png", "nocull smooth mips" )

DEFINE_BASECLASS( "widget_arrow" )

--
-- Set our dimensions etc
--
function ENT:Initialize()

	BaseClass.Initialize( self )

	if ( SERVER ) then
		self:SetSize( 16 )
	end

end

function ENT:PressedShouldDraw( widget ) return widget == self end

function ENT:OverlayRender()

	local fwd = self:GetAngles():Forward()
	local size = self:GetSize()

	local c = self:GetColor()

	if ( !self:IsHovered() && !self:IsPressed() ) then
		c.r = c.r * 0.5
		c.g = c.g * 0.5
		c.b = c.b * 0.5
	end

	local ang = self:GetAngles().roll - 90

	render.DepthRange( 0, 0.01 )
	render.SetMaterial( matDiscAlpha )
	render.DrawQuadEasy( self:GetPos(), fwd, size, size, Color( c.r, c.g, c.b, c.a * 0.2 ), ang )
	render.DepthRange( 0, 1 )
	render.SetMaterial( matDisc )
	render.DrawQuadEasy( self:GetPos(), fwd, size, size, Color( c.r, c.g, c.b, c.a ), ang )
	render.DepthRange( 0, 1 )

end

function ENT:TestCollision( startpos, delta, isbox, extents )

	if ( isbox ) then return end
	if ( !widgets.Tracing ) then return end

	local fwd = self:GetAngles():Forward()
	local size = self:GetSize() * 0.5

	local hitpos = util.IntersectRayWithPlane( startpos, delta:GetNormal(), self:GetPos(), fwd )
	if ( !hitpos ) then return end

	local dist = self:GetPos():Distance( hitpos )
	if ( dist > size ) then return end
	if ( dist < size * 0.9 ) then return end

	--debugoverlay.Cross( hitpos, 0.5, 60 )

	local fraction = ( hitpos - startpos ):Length() / delta:Length()

	return {
		HitPos		= hitpos,
		Fraction	= fraction * self:GetPriority()
	}

end

function ENT:DragThink( pl, mv, dist )

	local d = dist.x * -1

	self:ArrowDragged( pl, mv, d )

end

function ENT:ArrowDragged( pl, mv, dist )

	-- MsgN( dist )

end

function ENT:GetGrabPos( Pos, Forward )

	local fwd = Forward
	local eye = Pos
	local arrowdir = self:GetAngles():Forward()

	local planepos = self:GetPos()
	local planenrm = ( eye - planepos ):GetNormal()

	local hitpos = util.IntersectRayWithPlane( eye, fwd, planepos, arrowdir )
	if ( !hitpos ) then return end

	-- The whole circle should be 360
	hitpos = self:WorldToLocal( hitpos )
	hitpos:Normalize()

	local angle = math.atan2( hitpos.y, hitpos.z ) + math.pi
	angle = math.deg( angle ) * -1

	return arrowdir * angle

end
