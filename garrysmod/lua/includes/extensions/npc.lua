local NPC = FindMetaTable("NPC")

function NPC:GiveSpawnFlag( flag )
    if self:HasSpawnFlags( flag ) then return end

    local spawnFlags = self:GetSpawnFlags()
    local newSpawnFlags = bit.bor( spawnFlags, flag )

    self:SetKeyValue( "spawnflags", newSpawnFlags )
end

function NPC:RemoveSpawnFlag( flag )
    if !self:HasSpawnFlags( flag ) then return end

    local spawnFlags = self:GetSpawnFlags()
    local newSpawnFlags = bit.band( spawnFlags, bit.bnot( flag ) )

    self:SetKeyValue( "spawnflags", newSpawnFlags )
end