local NPC = FindMetaTable("NPC")

function NPC:AddSpawnFlag( flag )
    local spawnFlags = self:GetSpawnFlags()
    if bit.band( spawnFlags, flag ) == flag then return end

    local newSpawnFlags = bit.bor( spawnFlags, flag )
    self:SetKeyValue( "spawnflags", newSpawnFlags )
end

function NPC:RemoveSpawnFlag( flag )
    local spawnFlags = self:GetSpawnFlags()
    if bit.band( spawnFlags, flag ) == 0 then return end

    local newSpawnFlags = bit.band( spawnFlags, bit.bnot( flag ) )
    self:SetKeyValue( "spawnflags", newSpawnFlags )
end