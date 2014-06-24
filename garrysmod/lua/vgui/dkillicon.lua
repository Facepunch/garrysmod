--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DKillIcon

--]]
PANEL = {}

AccessorFunc( PANEL, "m_Name", 				"Name" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.m_Name = ""
	self.m_fOffset = 0
	self:NoClipping( true )
	
end

--[[---------------------------------------------------------
   Name: SizeToContents
-----------------------------------------------------------]]
function PANEL:SizeToContents()

	local w, h = killicon.GetSize( self.m_Name )
	self.m_fOffset = h * 0.1
	self:SetSize( w, 5 )

end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint()

	killicon.Draw( self:GetWide() * 0.5, self.m_fOffset, self.m_Name, 255 )	
	
end

derma.DefineControl( "DKillIcon", "A kill icon", PANEL, "Panel" )