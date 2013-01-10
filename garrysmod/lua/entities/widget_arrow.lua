
AddCSLuaFile()

local matArrow = Material( "widgets/arrow.png", "nocull alphatest smooth mips" )

DEFINE_BASECLASS( "widget_base" )

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
	local size = self:GetSize() * 0.5
	
	local c = self:GetColor()
	
	if ( !self:IsHovered() && !self:IsPressed() ) then
		c.r = c.r * 0.5
		c.g = c.g * 0.5
		c.b = c.b * 0.5
	end
	
	render.SetMaterial( matArrow )	
	
	render.DepthRange( 0, 0.01 )
	render.DrawBeam( self:GetPos(), self:GetPos() + fwd * size, 2, 1, 0, Color( c.r, c.g, c.b, c.a * 0.1 ) )
	render.DepthRange( 0, 1 * self:GetPriority() )
	render.DrawBeam( self:GetPos(), self:GetPos() + fwd * size, 2, 1, 0, Color( c.r, c.g, c.b, c.a ) )
	render.DepthRange( 0, 1 )
	
	
end

function ENT:TestCollision( startpos, delta, isbox, extents )

	if ( isbox ) then return end
	if ( !widgets.Tracing ) then return end
	
	local size = self:GetSize() * 0.5
	
	local mins = Vector( 0, -1, -1 )
	local maxs = Vector( size, 1, 1 )
	
	local hit, norm, fraction = util.IntersectRayWithOBB( startpos, delta, self:GetPos(), self:GetAngles(), mins, maxs )
	if ( !hit ) then return end
	
	--debugoverlay.BoxAngles( self:GetPos(), mins, maxs, self:GetAngles(), 0.5, Color( 255, 255, 0, 100 ) )
	
	return 
	{ 
		HitPos		= hit,
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
	local planenrm = (eye-planepos):GetNormal()
	
	local hitpos = util.IntersectRayWithPlane( eye, fwd, planepos, planenrm )
	if ( !hitpos ) then return end
	
	-- Get nearest point along the arrow where we touched it
	local fdist, vpos, falong = util.DistanceToLine( planepos - arrowdir * 1024, planepos + arrowdir * 1024, hitpos )
	
	return vpos;

end