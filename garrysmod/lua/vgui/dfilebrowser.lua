--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DSlider

--]]
local PANEL = {}

AccessorFunc( PANEL, "m_strName", 			"Name" )
AccessorFunc( PANEL, "m_strPath", 			"Path" )
AccessorFunc( PANEL, "m_strFilter", 		"Files" )
AccessorFunc( PANEL, "m_strCurrentFolder", 	"CurrentFolder" )
AccessorFunc( PANEL, "m_bModels", 			"Models" )

--[[---------------------------------------------------------
	
-----------------------------------------------------------]]
function PANEL:Init()

	self.Tree = self:Add( "DTree" )
	self.Tree:Dock( LEFT )
	self.Tree:SetWidth( 200 )
	
	self.Tree.DoClick = function( _, node )

		if ( !node:GetFolder() ) then return end
		self:ShowFolder( node:GetFolder() )
	
	end
	
	self.Icons = self:Add( "DIconBrowser" )
	self.Icons:SetManual( true )
	self.Icons:Dock( FILL )

end

function PANEL:Paint( w, h )

	DPanel.Paint( self, w, h )

	if ( !self.bSetup ) then
		self.bSetup = self:Setup()
	end

end

function PANEL:Setup()

	if ( !self.m_strName || !self.m_strPath ) then return false end

	local root = self.Tree.RootNode:AddFolder( self.m_strName, self.m_strPath, false )

	return true

end

function PANEL:ShowFolder( path )

	self.Icons:Clear()
	
	local files = file.Find( path .. "/" .. (self.m_strFilter or "*.*"), "GAME" )
	
	for k, v in pairs( files ) do
	
		if ( self.m_bModels ) then
		
			local button = self.Icons:Add( "SpawnIcon" )
			button:SetModel( path .. "/" .. v )
			button.DoClick = function()
				self:OnSelect( path .. "/" .. v, button )
			end
				
		else
	
			local button = self.Icons:Add( "DButton" )
			button:SetText( v )
			button:SetSize( 150, 20 )
			button.DoClick = function()
				self:OnSelect( path .. "/" .. v, button )
			end
			
		end
				
	end

end

function PANEL:OnSelect( path, button )

	-- Override

end

derma.DefineControl( "DFileBrowser", "", PANEL, "DPanel" )
