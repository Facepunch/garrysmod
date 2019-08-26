
AddCSLuaFile()

local matBone = Material( "widgets/bone.png", "smooth" )
local matBoneSmall = Material( "widgets/bone_small.png", "smooth" )

local widget_bone = {
	Base = "widget_base",
	a = 255,

	GetParentPos = function( self )

		local p = self:GetParent()
		if ( !IsValid( p ) ) then return end

		local bp = p:GetBoneParent( self:GetParentAttachment() )
		if ( bp <= 0 ) then return end

		return p:GetBonePosition( bp )

	end,

	OverlayRender = function( self )

		local pp = self:GetParentPos()
		if ( !pp ) then return end

		local fwd = self:GetAngles():Forward()
		local len = self:GetSize() / 2
		local w = len * 0.2

		if ( len > 10 ) then
			render.SetMaterial( matBone )
		else
			render.SetMaterial( matBoneSmall )
		end

		local c = Color( 255, 255, 255, 255 )

		if ( self:IsHovered() ) then
			self.a = math.Approach( self.a, 255, FrameTime() * 255 * 10 )
		elseif ( self:SomethingHovered() ) then
			self.a = math.Approach( self.a, 20, FrameTime() * 255 * 10 )
		else
			self.a = math.Approach( self.a, 255, FrameTime() * 255 * 10 )
		end

		cam.IgnoreZ( true )
			render.DrawBeam( self:GetPos(), pp, w, 0, 1, Color( c.r, c.g, c.b, self.a * 0.5 ) )
		cam.IgnoreZ( false )

		render.DrawBeam( self:GetPos(), pp, w, 0, 1, Color( c.r, c.g, c.b, self.a ) )

	end,

	TestCollision = function( self, startpos, delta, isbox, extents )

		if ( isbox ) then return end
		if ( !widgets.Tracing ) then return end

		local pp = self:GetParentPos()
		if ( !pp ) then return end

		local fwd = ( pp - self:GetPos() ):GetNormal()
		local ang = fwd:Angle()
		local len = self:GetSize() / 2
		local w = len * 0.2

		local mins = Vector( 0, w * -0.5, w * -0.5 )
		local maxs = Vector( len, w * 0.5, w * 0.5 )

		local hit, norm, fraction = util.IntersectRayWithOBB( startpos, delta, self:GetPos(), ang, mins, maxs )
		if ( !hit ) then return end

		--debugoverlay.BoxAngles( self:GetPos(), mins, maxs, ang, 0.1, Color( 0, 255, 0, 64 ) )

		return {
			HitPos		= hit,
			Fraction	= fraction * self:GetPriority()
		}

	end,

	Think = function( self )

		if ( !SERVER ) then return end
		if ( !IsValid( self:GetParent() ) ) then return end

		--
		-- Because the bone length changes (with the manipulator)
		-- we need to update the bones pretty regularly
		--

		local size = self:GetParent():BoneLength( self:GetParentAttachment() ) * 2
		size = math.ceil( size )

		self:SetSize( size )

	end,

	CalcAbsolutePosition = function( self, v, a )

		local ent = self:GetParent()
		if ( !IsValid( ent ) ) then return end

		local bone = self:GetParentAttachment()
		if ( bone <= 0 ) then return end

		return ent:GetBonePosition( bone )

	end
}

scripted_ents.Register( widget_bone, "widget_bone" )

DEFINE_BASECLASS( "widget_base" )

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Target" )

	self.BaseClass.SetupDataTables( self )

end

--
-- Set our dimensions etc
--
function ENT:Initialize()

	self.BaseClass.Initialize( self )

	self:SetCollisionBounds( Vector( -1, -1, -1 ), Vector( 1, 1, 1 ) )
	self:SetSolid( SOLID_NONE )

end

function ENT:Setup( ent )

	self:SetTarget( ent )
	self:SetParent( ent )
	self:SetLocalPos( vector_origin )

	for k = 0, ent:GetBoneCount() - 1 do

		if ( ent:GetBoneParent( k ) <= 0 ) then continue end
		if ( !ent:BoneHasFlag( k, BONE_USED_BY_VERTEX_LOD0 ) ) then continue end

		local btn = ents.Create( "widget_bone" )
		btn:FollowBone( ent, k )
		btn:SetLocalPos( vector_origin )
		btn:SetLocalAngles( angle_zero )
		btn:Spawn()
		btn:SetSize( ent:BoneLength( k ) * 2 )

		btn.OnClick = function( x, ply )
			self:OnBoneClick( k, ply )
		end

		self:DeleteOnRemove( btn )

	end

end

function ENT:OnBoneClick( boneid, ply )
end

function ENT:OverlayRender()
end
