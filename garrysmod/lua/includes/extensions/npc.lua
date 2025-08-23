local meta = FindMetaTable( "NPC" )
if ( !meta ) then return end

if ( SERVER ) then
    function meta:HasCapability( cap )
        return bit.band( self:CapabilitiesGet(), cap ) == cap
    end
end
