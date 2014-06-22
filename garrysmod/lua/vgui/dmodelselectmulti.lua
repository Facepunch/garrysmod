--[[ _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DModelSelectMulti
TAD2020
]]
local PANEL = {}


--[[-------------------------------------------------------
   Name: Init
---------------------------------------------------------]]
function PANEL:Init()

	self.ModelPanels = {}
	self:SetTall( 66 * 2 + 26 )
	
end


--[[-------------------------------------------------------
   Name: SetHeight
---------------------------------------------------------]]
function PANEL:SetHeight( numHeight )

	self:SetTall( 66 * (numHeight or 2) + 26 )
	
end


--[[-------------------------------------------------------
   Name: AddModelList
---------------------------------------------------------]]
function PANEL:AddModelList( Name, ModelList, strConVar, bDontSort, bDontCallListConVars )

	local ModelSelect = vgui.Create( "DModelSelect", self )
	
	ModelSelect:SetModelList( ModelList, strConVar, bDontSort, bDontCallListConVars )
	
	self:AddSheet( Name, ModelSelect )
	
	self.ModelPanels[Name] = ModelSelect
	
	return ModelSelect
	
end


derma.DefineControl( "DModelSelectMulti", "", PANEL, "DPropertySheet" )
