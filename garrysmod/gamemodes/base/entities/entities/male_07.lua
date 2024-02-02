AddCSLuaFile()

DEFINE_BASECLASS( "base_nextbot" )

ENT.Base = "base_nextbot"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Spawned")
end

function ENT:Initialize()
	self:SetModel( "models/humans/group01/male_07.mdl" )
	self:SetMaxHealth(40)
	self:SetHealth(self:GetMaxHealth())
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
end

-- Remove the NPC when a player interacts with it lol
function ENT:Use()
    self:Remove()
end

-- Always transmit, so we eat server resources YUM
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

-- Every time this entity thinks, we do 10000 useless calculations :)
function ENT:Think()
  for i = 1, 10000 do
    local a = math.sqrt(i^0.5)
  end
end

function ENT:RunBehaviour()
	while true do
    coroutine.wait(1)

    local rangeX = math.random(-100,100)
    local rangeZ = math.random(-100,100)
    local pos = self:GetPos() + Vector(rangeX,0,rangeZ)
    local area = navmesh.GetNearestNavArea( pos, nil, 600, true )
    if ( IsValid( area ) ) then
        self:StartActivity( ACT_RUN )
        self.loco:SetDesiredSpeed( 200 )
        self:MoveToPos( area:GetCenter() )
    end
		
		self:StartActivity( ACT_IDLE )
		
		coroutine.yield()
	end
end
