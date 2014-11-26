--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 
	DShape
--]]

local PANEL = {}

AccessorFunc( PANEL, "m_colColor", 			"Color" )
AccessorFunc( PANEL, "m_colBorderColor", 		"BorderColor" )
AccessorFunc( PANEL, "m_strType", 			"Type" )

AccessorFunc( PANEL, "m_intRadius", 		"Radius" )
AccessorFunc( PANEL, "m_strTexture", 		"Texture" )
AccessorFunc( PANEL, "m_strTextureID", 		"TextureID" )
AccessorFunc( PANEL, "m_intRotation", 		"Rotation" )


--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetColor( Color( 255, 255, 255, 255 ) )
	
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
	
end

--[[---------------------------------------------------------
	Texture
-----------------------------------------------------------]]
function PANEL:SetTexture( strMat )
	
	self:SetTextureID( surface.GetTextureID( strMat ) )

end

local RenderTypes = {} -- Create a table with the different shape types

function RenderTypes.Rect( pnl )

	surface.SetDrawColor( pnl:GetColor() )
	surface.DrawRect( 0, 0, pnl:GetSize() )
	
end

function RenderTypes.OutlinedRect( pnl )

	surface.SetDrawColor( pnl:GetColor() )
	surface.DrawOutlinedRect( 0, 0, pnl:GetSize() )

end

function RenderTypes.TexturedRect( pnl )

	surface.SetTexture( pnl.m_strTextureID )
	surface.SetDrawColor( pnl:GetColor() )
	surface.DrawTexturedRect( 0, 0, pnl:GetSize() )

end

function RenderTypes.TexturedRectRotated( pnl )

	local w, h = pnl:GetSize()
	surface.SetTexture( pnl:GetTextureID() )
	surface.SetDrawColor( pnl:GetColor() )
	surface.DrawTexturedRectRotated( 0, 0, w, h, pnl:GetRotation() )

end

function RenderTypes.Circle( pnl )

	-- Offset the X and Y otherwise the shape will always be cut off
	surface.DrawCircle( pnl:GetRadius(), pnl:GetRadius(), pnl:GetRadius(), pnl:GetColor() )	
	
end

--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint()
	
	RenderTypes[ self.m_strType ]( self )

end

derma.DefineControl( "DShape", "A shape", PANEL, "DPanel" )

function VGUIRect( x, y, w, h )
	local shape = vgui.Create( "DShape" )
	shape:SetType( "Rect" )
	shape:SetPos( x, y )
	shape:SetSize( w, h )
	return shape
end
