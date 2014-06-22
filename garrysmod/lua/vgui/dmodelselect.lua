--[[ _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DModelSelect
TAD2020
]]
local PANEL = {}


--[[-------------------------------------------------------
   Name: Init
---------------------------------------------------------]]
function PANEL:Init()

	self:EnableVerticalScrollbar()
	self:SetTall( 66 * 2 + 2 )
	
end


--[[-------------------------------------------------------
   Name: SetHeight
---------------------------------------------------------]]
function PANEL:SetHeight( numHeight )

	self:SetTall( 66 * (numHeight or 2) + 2 )
	
end


--[[-------------------------------------------------------
   Name: SetModelList
---------------------------------------------------------]]
function PANEL:SetModelList( ModelList, strConVar, bDontSort, bDontCallListConVars )
	
	for model,v in pairs( ModelList ) do
	
		local icon = vgui.Create( "SpawnIcon" )
		icon:SetModel( model )
		icon:SetSize( 64, 64 )
		icon:SetTooltip( model )
		icon.Model = model
		icon.ConVars = v
		
		local convars = {}
		
		-- some model lists, like from wheels, have extra convars in the ModelList
		-- we'll need to add those too
		if ( !bDontCallListConVars && istable(v) ) then
			table.Merge(convars, v) -- copy them in to new list
		end
		
		-- make strConVar optional so we can have everything in the ModelList instead, if we want to
		if strConVar then
			convars[strConVar] = model
		end
		
		self:AddPanel( icon, convars )
		
	end
	
	if not bDontSort then
		self:SortByMember( "Model", false )
	end
	
end


derma.DefineControl( "DModelSelect", "", PANEL, "DPanelSelect" )
