
AddCSLuaFile()

--
-- widget_axis_arrow
--

DEFINE_BASECLASS( "widget_arrow" )

local widget_axis_arrow = { Base = "widget_arrow" }

function widget_axis_arrow:Initialize()

	BaseClass.Initialize( self )

end

function widget_axis_arrow:SetupDataTables()

	BaseClass.SetupDataTables( self )
	self:NetworkVar( "Int", 0, "AxisIndex" )

end

function widget_axis_arrow:ArrowDragged( pl, mv, dist )

	self:GetParent():OnArrowDragged( self:GetAxisIndex(), dist, pl, mv )

end

scripted_ents.Register( widget_axis_arrow, "widget_axis_arrow" )

--
-- widget_axis_disc
--

DEFINE_BASECLASS( "widget_disc" )

local widget_axis_disc = { Base = "widget_disc" }

function widget_axis_disc:Initialize()

	BaseClass.Initialize( self )

end

function widget_axis_disc:SetupDataTables()

	BaseClass.SetupDataTables( self )
	self:NetworkVar( "Int", 0, "AxisIndex" )

end


function widget_axis_disc:ArrowDragged( pl, mv, dist )

	self:GetParent():OnArrowDragged( self:GetAxisIndex(), dist, pl, mv )

end

scripted_ents.Register( widget_axis_disc, "widget_axis_disc" )

DEFINE_BASECLASS( "widget_base" )

--
-- Set our dimensions etc
--
function ENT:Initialize()

	BaseClass.Initialize( self )

	self:SetCollisionBounds( Vector( -1, -1, -1 ), Vector( 1, 1, 1 ) )
	self:SetSolid( SOLID_NONE )

end

function ENT:Setup( ent, boneid, rotate )

	self:FollowBone( ent, boneid )
	self:SetLocalPos( vector_origin )
	self:SetLocalAngles( angle_zero )

	local EntName = "widget_axis_arrow"
	if ( rotate ) then EntName = "widget_axis_disc" end

	self.ArrowX = ents.Create( EntName )
	self.ArrowX:SetParent( self )
	self.ArrowX:SetColor( Color( 255, 0, 0, 255 ) )
	self.ArrowX:Spawn()
	self.ArrowX:SetLocalPos( vector_origin )
	self.ArrowX:SetLocalAngles( Vector( 1, 0, 0 ):Angle() )
	self.ArrowX:SetAxisIndex( 1 )

	self.ArrowY = ents.Create( EntName )
	self.ArrowY:SetParent( self )
	self.ArrowY:SetColor( Color( 0, 230, 50, 255 ) )
	self.ArrowY:Spawn()
	self.ArrowY:SetLocalPos( vector_origin )
	self.ArrowY:SetLocalAngles( Vector( 0, 1, 0 ):Angle() )
	self.ArrowY:SetAxisIndex( 2 )

	self.ArrowZ = ents.Create( EntName )
	self.ArrowZ:SetParent( self )
	self.ArrowZ:SetColor( Color( 50, 100, 255, 255 ) )
	self.ArrowZ:Spawn()
	self.ArrowZ:SetLocalPos( vector_origin )
	self.ArrowZ:SetLocalAngles( Vector( 0, 0, 1 ):Angle() )
	self.ArrowZ:SetAxisIndex( 3 )

	if ( self.IsScaleArrow && EntName == "widget_axis_arrow" ) then
		if ( IsValid( self.ArrowX ) ) then self.ArrowX:SetIsScaleArrow( true ) end
		if ( IsValid( self.ArrowY ) ) then self.ArrowY:SetIsScaleArrow( true ) end
		if ( IsValid( self.ArrowZ ) ) then self.ArrowZ:SetIsScaleArrow( true ) end
	end

end

function ENT:SetPriority( x )

	if ( IsValid( self.ArrowX ) ) then self.ArrowX:SetPriority( x ) end
	if ( IsValid( self.ArrowY ) ) then self.ArrowY:SetPriority( x ) end
	if ( IsValid( self.ArrowZ ) ) then self.ArrowZ:SetPriority( x ) end

end

function ENT:Draw()
end

function ENT:OnArrowDragged( num, dist, pl, mv )

	-- MsgN( num, dist, pl, mv )

end
