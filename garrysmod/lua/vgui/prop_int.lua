--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DProperty_Int

--]]
--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

end

--[[---------------------------------------------------------
   Name: GetDecimals
-----------------------------------------------------------]]
function PANEL:GetDecimals()

	return 0

end

derma.DefineControl( "DProperty_Int", "", PANEL, "DProperty_Float" )