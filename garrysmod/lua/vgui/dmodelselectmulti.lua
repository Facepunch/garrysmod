
local PANEL = {}

function PANEL:Init()

	self.ModelPanels = {}
	self:SetTall( 66 * 2 + 26 )

end

function PANEL:SetHeight( numHeight )

	self:SetTall( 66 * ( numHeight or 2 ) + 26 )

end

function PANEL:AddModelList( Name, ModelList, strConVar, bDontSort, bDontCallListConVars )

	local ModelSelect = vgui.Create( "DModelSelect", self )

	ModelSelect:SetModelList( ModelList, strConVar, bDontSort, bDontCallListConVars )

	self:AddSheet( Name, ModelSelect )

	self.ModelPanels[Name] = ModelSelect

	return ModelSelect

end

derma.DefineControl( "DModelSelectMulti", "", PANEL, "DPropertySheet" )
