local meta = FindMetaTable( "NPC" )
if ( !meta ) then return end

if ( SERVER ) then
    function meta:CapabilitiesHas( cap )
        return bit.band( self:CapabilitiesGet(), cap ) == cap
    end
end
