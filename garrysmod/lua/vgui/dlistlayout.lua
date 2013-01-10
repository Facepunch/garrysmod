--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 


--]]
local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDropPos( "82" )

end

function PANEL:OnModified()

	-- Override me

end

function PANEL:OnChildRemoved()

	self:InvalidateLayout()
	
end

function PANEL:PerformLayout()

	self:SizeToChildren( false, true )
	
end

function PANEL:OnChildAdded( child )
	
	child:Dock( TOP )
	
	local dn = self:GetDnD()
	if ( dn ) then
		child:Droppable( self:GetDnD() );			
	end
	
	if ( self:IsSelectionCanvas() ) then
		child:SetSelectable( true )
	end
	
end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local pnl = vgui.Create( ClassName )
	pnl:MakeDroppable( "ExampleDraggable", false )
	pnl:SetSize( 200, 200 )
	
	for i=1, 5 do
		
		local btn = pnl:Add( "DButton" )
		btn:SetText( "Button " .. i )
		
	end
	
	for i=1, 5 do
		
		local btn = pnl:Add( "DLabel" )
		btn:SetText( "Label " .. i )
		btn:SetMouseInputEnabled( true )
		
	end
		
	PropertySheet:AddSheet( ClassName, pnl, nil, true, true )

end

derma.DefineControl( "DListLayout", "", PANEL, "DDragBase" )
