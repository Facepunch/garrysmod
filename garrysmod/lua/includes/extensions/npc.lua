local meta = FindMetaTable("NPC")
if ( !meta ) then return end

function meta:HasCapability( cap )
    return bit.band( self:CapabilitiesGet(), cap ) == cap
end