local NPC = FindMetaTable("NPC")

function NPC:GiveSpawnFlag( flag )
    local spawnFlags = self:GetSpawnFlags()
    local newSpawnFlags = bit.bor( spawnFlags, flag )

    self:SetKeyValue( "spawnflags", newSpawnFlags )
end

function NPC:RemoveSpawnFlag( flag )
    local spawnFlags = self:GetSpawnFlags()
    local newSpawnFlags = bit.band( spawnFlags, bit.bnot( flag ) )

    self:SetKeyValue( "spawnflags", newSpawnFlags )
end