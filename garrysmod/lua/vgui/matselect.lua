
local PANEL = {}

AccessorFunc( PANEL, "ItemWidth",			"ItemWidth", 	FORCE_NUMBER )
AccessorFunc( PANEL, "ItemHeight",			"ItemHeight", 	FORCE_NUMBER )
AccessorFunc( PANEL, "Height",				"NumRows", 		FORCE_NUMBER )
AccessorFunc( PANEL, "m_bSizeToContent",	"AutoHeight", 	FORCE_BOOL )

--[[---------------------------------------------------------
   Name: This function is used as the paint function for 
		   selected buttons.
-----------------------------------------------------------]]
local function HighlightedButtonPaint( self )

	surface.SetDrawColor( 255, 200, 0, 255 )
	
	for i=2, 3 do
		surface.DrawOutlinedRect( i, i, self:GetWide()-i*2, self:GetTall()-i*2 )
	end

end

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	-- A panellist is a panel that you shove other panels
	-- into and it makes a nice organised frame.
	self.List = vgui.Create( "DPanelList", self )
		self.List:EnableHorizontal( true )
		self.List:EnableVerticalScrollbar()
		self.List:SetSpacing( 1 )
		self.List:SetPadding( 3 )
	
	self.Controls 	= {}
	self.Height		= 2
	
	self:SetItemWidth( 128 )
	self:SetItemHeight( 128 )

end

--[[---------------------------------------------------------
   Name: SetAutoHeight
-----------------------------------------------------------]]
function PANEL:SetAutoHeight( bAutoHeight )

	self.m_bSizeToContent = bAutoHeight
	self.List:SetAutoSize( bAutoHeight )
	
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
   Name: AddMaterial
-----------------------------------------------------------]]
function PANEL:AddMaterial( label, value )

	-- Creeate a spawnicon and set the model
	local Mat = vgui.Create( "DImageButton", self )
	Mat:SetOnViewMaterial( value, "models/wireframe" )
	Mat.AutoSize = false
	Mat.Value = value
	Mat:SetSize( self.ItemWidth, self.ItemHeight )
	Mat:SetToolTip( label )
	
	-- Run a console command when the Icon is clicked
	Mat.DoClick = function( button ) 
		RunConsoleCommand( self:ConVar(), value )
	end

	-- Add the Icon us
	self.List:AddItem( Mat )
	table.insert( self.Controls, Mat )
	
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
   Name: SetItemSize
-----------------------------------------------------------]]
function PANEL:SetItemSize( pnl )

	local w = self.ItemWidth
	if ( w < 1 ) then w = ( self:GetWide() - self.List:GetPadding()*2 ) * w end
	
	local h = self.ItemHeight
	if ( h < 1 ) then h = ( self:GetWide() - self.List:GetPadding()*2 ) * h end
	
	pnl:SetSize( w, h )

end

--[[---------------------------------------------------------
   Name: AddMaterialEx
-----------------------------------------------------------]]
function PANEL:AddMaterialEx( label, material, value, convars )

	-- Creeate a spawnicon and set the model
	local Mat = vgui.Create( "DImageButton", self )
	Mat:SetImage( material )
	Mat.AutoSize = false
	Mat.Value = value
	Mat.ConVars = convars
	self:SetItemSize( Mat )
	Mat:SetToolTip( label )
	
	-- Run a console command when the Icon is clicked
	Mat.DoClick = 	function ( button ) 
	
						for k, v in pairs( convars ) do	RunConsoleCommand( k, v ) end

					end

	
	-- Add the Icon us
	self.List:AddItem( Mat )
	table.insert( self.Controls, Mat )
	
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
   Name: ControlValues
-----------------------------------------------------------]]
function PANEL:ControlValues( kv )

	self.BaseClass.ControlValues( self, kv )
	
	self.Height = kv.height or 2
	
	-- Load the list of models from our keyvalues file
	if (kv.options) then
	
		for k, v in pairs( kv.options ) do
			self:AddMaterial( k, v )
		end
		
	end
	
	self.ItemWidth = kv.itemwidth or 32
	self.ItemHeight = kv.itemheight or 32
	
	for k, v in pairs( self.Controls ) do
		v:SetSize( self.ItemWidth, self.ItemHeight )
	end
	
	self:InvalidateLayout()

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	self.List:SetPos( 0, 0 )
	
	for k, v in pairs( self.List:GetItems() ) do
		self:SetItemSize( v )
	end
	
	if ( self.m_bSizeToContent ) then
	
		self.List:SetWide( self:GetWide() )
		self.List:InvalidateLayout( true )
		self:SetTall( self.List:GetTall() )
		
	return end
	
	local h = self.ItemHeight
	if ( h < 1 ) then h = ( self:GetWide() - self.List:GetPadding()*2 ) * h end
	
	local Height = (h * self.Height) + (self.List:GetPadding() * 2) + self.List:GetSpacing() * (self.Height - 1)
	
	self.List:SetSize( self:GetWide(), Height )
	self:SetTall( Height + 5 )

end



--[[---------------------------------------------------------
   Name: FindAndSelectMaterial
-----------------------------------------------------------]]
function PANEL:FindAndSelectMaterial( Value )

	self.CurrentValue = Value

	for k, Mat in pairs( self.Controls ) do
	
		if ( Mat.Value == Value ) then
		
			-- Remove the old overlay
			if ( self.SelectedMaterial ) then
				self.SelectedMaterial.PaintOver = nil
			end
			
			-- Add the overlay to this button
			Mat.PaintOver = HighlightedButtonPaint;
			self.SelectedMaterial = Mat

		end
	
	end

end

--[[---------------------------------------------------------
   Name: TestForChanges
-----------------------------------------------------------]]
function PANEL:TestForChanges()

	local cvar = self:ConVar()
	if (!cvar) then return end
	
	local Value = GetConVarString( cvar )
	
	if ( Value == self.CurrentValue ) then return end
	
	self:FindAndSelectMaterial( Value )

end


vgui.Register( "MatSelect", PANEL, "ContextBase" )