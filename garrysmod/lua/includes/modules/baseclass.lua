

--
-- The baseclass module uses upvalues to give the impression of inheritence.
--
-- At the top of your class file add 
--
-- DEFINE_BASECLASS( "base_class_name" )
--
-- Now the local variable BaseClass will be available.
-- ( in engine DEFINE_BASECLASS is replaced with "local BaseClass = baseclass.Get" )
--
-- Baseclasses are added using baseclass.Set - this is done automatically for:
--
--		> widgets
--		> panels
--		> drive modes
--		> entities
--		> weapons
-- 
-- Classes don't have to be created in any particular order. The system is 
-- designed to work with whatever order the classes are defined.
--
-- The only caveat is that classnames must be unique. 
-- eg Creating a panel and widget with the same name will cause problems.
--

module( "baseclass", package.seeall )

local BaseClassTable = {}

function Get( name )

	if ( ENT )	then ENT.Base = name end
	if ( SWEP ) then SWEP.Base = name end
	
	BaseClassTable[name] = BaseClassTable[name] or {}
	
	return BaseClassTable[name]
	
end

function Set( name, tab )

	if ( !BaseClassTable[name] ) then

		BaseClassTable[name] =  tab

	else

		table.Merge( BaseClassTable[name], tab )
		setmetatable( BaseClassTable[name], getmetatable(tab) )

	end

	BaseClassTable[name].ThisClass = name

end