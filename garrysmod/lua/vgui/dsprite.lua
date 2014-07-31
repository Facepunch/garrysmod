--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DSprite

--]]

function CreateSprite( mat )
	local sprite = vgui.Create( "DSprite" )
	sprite:SetMaterial( mat )
	return sprite
end

local PANEL = {}

AccessorFunc( PANEL, "m_Material", 		"Material" )
AccessorFunc( PANEL, "m_Color", 		"Color" )
AccessorFunc( PANEL, "m_Rotation", 		"Rotation" )
AccessorFunc( PANEL, "m_Handle", 		"Handle" )

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self:SetColor( Color( 255, 255, 255, 255 ) )
	self:SetRotation( 0 )
	self:SetHandle( Vector(0.5, 0.5, 0) )
	
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	
	self:NoClipping( true )
	
end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Paint()

	local Mat = self.m_Material
	if (!Mat) then return true end

	surface.SetMaterial( Mat )
	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )
	
	local w, h = self:GetSize()
	local x, y = 0, 0
	surface.DrawTexturedRectRotated( x, y, w, h, self.m_Rotation )
	return true

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetMaterial( Material( "brick/brick_model" ) )
		ctrl:SetSize( 200, 200 )
		
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DSprite", "A sprite", PANEL, "DPanel" )