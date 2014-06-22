
--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DPropertySheet

--]]

local PANEL = {}

AccessorFunc( PANEL, "ActiveButton", 			"ActiveButton" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()
	
	self.Navigation 	= vgui.Create( "DScrollPanel", self )
	self.Navigation:Dock( LEFT )
	self.Navigation:SetWidth( 100 )
	self.Navigation:DockMargin( 10, 10, 10, 0 )
	
	self.Content 	= vgui.Create( "Panel", self )
	self.Content:Dock( FILL )

	self.Items = {}
	
end

function PANEL:UseButtonOnlyStyle()
	self.ButtonOnly = true
end

--[[---------------------------------------------------------
   Name: AddSheet
-----------------------------------------------------------]]
function PANEL:AddSheet( label, panel, material )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}
	
	if ( self.ButtonOnly ) then
		Sheet.Button = vgui.Create( "DImageButton", self.Navigation )
	else
		Sheet.Button = vgui.Create( "DButton", self.Navigation )
	end
	Sheet.Button:SetImage( material )
	Sheet.Button.Target = panel
	Sheet.Button:Dock( TOP )
	Sheet.Button:SetText( label )
	Sheet.Button:DockMargin( 0, 1, 0, 0 )
	
	Sheet.Button.DoClick = function ()

		self:SetActiveButton( Sheet.Button )
	
		end
	
	Sheet.Panel = panel
	Sheet.Panel:SetParent( self.Content )
	Sheet.Panel:SetVisible( false )
	
	if ( self.ButtonOnly ) then
		Sheet.Button:SizeToContents()
		Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
	end
	
	table.insert( self.Items, Sheet )
	
	if ( !IsValid( self.ActiveButton ) ) then
		self:SetActiveButton( Sheet.Button )
	end

end

--[[---------------------------------------------------------
   Name: SetActiveTab
-----------------------------------------------------------]]
function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end
	
	if ( self.ActiveButton && self.ActiveButton.Target ) then	
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetColor( Color( 150, 150, 150, 100 ) )
	end

	self.ActiveButton = active
	active.Target:SetVisible( true )
	active:SetSelected( true )
	active:SetColor( Color( 255, 255, 255, 255 ) )
	
	self.Content:InvalidateLayout()

end

derma.DefineControl( "DColumnSheet", "", PANEL, "Panel" )
