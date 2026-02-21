
if ( SERVER ) then return end

local meta = FindMetaTable( "Entity" )
if ( !meta ) then return end


--
-- You can set the render angles and render origin on
-- any entity. It will then render the entity at that
-- origin using those angles.
--
-- Set them to nil if you don't want to override anything.
--

AccessorFunc( meta, "m_RenderAngles", "RenderAngles" )
AccessorFunc( meta, "m_RenderOrigin", "RenderOrigin" )
