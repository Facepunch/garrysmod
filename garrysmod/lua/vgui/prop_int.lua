
--
-- prop_generic is the base for all other properties.
-- All the business should be done in :Setup using inline functions.
-- So when you derive from this class - you should ideally only override Setup.
--

local PANEL = {}

function PANEL:Init()
end

function PANEL:GetDecimals()
	return 0
end

derma.DefineControl( "DProperty_Int", "", PANEL, "DProperty_Float" )
