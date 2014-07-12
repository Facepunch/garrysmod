--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DShape

--]]

function VGUIRect( x, y, w, h )
	local shape = vgui.Create( "DShape" )
	shape:SetType( "Rect" )
	shape:SetPos( x, y )
	shape:SetSize( w, h )
	return shape
end

local PANEL = {}

AccessorFunc( PANEL, "m_Color", 		"Color" )
AccessorFunc( PANEL, "m_BorderColor", 	"BorderColor" )
AccessorFunc( PANEL, "m_Type", 		"Type" )

local RenderTypes = {}

function RenderTypes.Rect( pnl )
	surface.SetDrawColor( pnl:GetColor() )
	surface.DrawRect( 0, 0, pnl:GetSize() )
end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self:SetColor( Color( 255, 255, 255, 255 ) )
	
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	
end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Paint()

	RenderTypes[ self.m_Type ]( self )

end

derma.DefineControl( "DShape", "A shape", PANEL, "DPanel" )