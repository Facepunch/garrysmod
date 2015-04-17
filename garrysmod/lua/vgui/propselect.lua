
local PANEL = {}

--[[---------------------------------------------------------
	Name: This function is used as the paint function for 
			selected buttons.
-----------------------------------------------------------]]
local function HighlightedButtonPaint( self )

	surface.SetDrawColor( 255, 200, 0, 255 )

	for i = 2, 3 do
		surface.DrawOutlinedRect( i, i, self:GetWide() - i * 2, self:GetTall() - i * 2 )
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

	Derma_Hook( self.List, "Paint", "Paint", "Panel" )

	self.Controls = {}
	self.Height = 2

end

--[[---------------------------------------------------------
	Name: ControlValues
-----------------------------------------------------------]]
function PANEL:AddModel( model, ConVars )

	-- Creeate a spawnicon and set the model
	local Icon = vgui.Create( "SpawnIcon", self )
	Icon:SetModel( model )
	Icon:SetToolTip( model )
	Icon.Model = model
	Icon.ConVars = ConVars or {}

	local ConVarName = self:ConVar()

	-- Run a console command when the Icon is clicked
	Icon.DoClick = function ( self ) 

		for k, v in pairs( self.ConVars ) do 
			LocalPlayer():ConCommand( Format( "%s \"%s\"\n", k, v ) ) 
		end 

		-- Note: We run this command after all the optional stuff
		LocalPlayer():ConCommand( Format( "%s \"%s\"\n", ConVarName, model ) ) 

	end

	-- Add the Icon us
	self.List:AddItem( Icon )
	table.insert( self.Controls, Icon )

end

--[[---------------------------------------------------------
	Name: ControlValues
-----------------------------------------------------------]]
function PANEL:AddModelEx( name, model, skin )

	-- Creeate a spawnicon and set the model
	local Icon = vgui.Create( "SpawnIcon", self )
	Icon:SetModel( model, skin )
	Icon:SetToolTip( model )
	Icon.Model = model
	Icon.Value = name
	Icon.ConVars = ConVars or {}

	local ConVarName = self:ConVar()

	-- Run a console command when the Icon is clicked
	Icon.DoClick = function ( self ) LocalPlayer():ConCommand( Format( "%s \"%s\"\n", ConVarName, Icon.Value ) ) end

	-- Add the Icon us
	self.List:AddItem( Icon )
	table.insert( self.Controls, Icon )

end

--[[---------------------------------------------------------
	Name: ControlValues
-----------------------------------------------------------]]
function PANEL:ControlValues( kv )

	self.BaseClass.ControlValues( self, kv )

	self.Height = kv.height or 2

	-- Load the list of models from our keyvalues file
	-- This is the old way

	if ( kv.models ) then
		for k, v in SortedPairs( kv.models ) do
			self:AddModel( k, v )
		end
	end

	--
	-- Passing in modelstable is the new way
	--
	if ( kv.modelstable ) then
		local tmp = {} // HACK: Order by skin too.
		for k, v in SortedPairsByMemberValue( kv.modelstable, "model" ) do
			tmp[ k ] = v.model .. ( v.skin or 0 )
		end

		for k, v in SortedPairsByValue( tmp ) do
			v = kv.modelstable[ k ]
			self:AddModelEx( k, v.model, v.skin or 0 )
		end
	end

	self:InvalidateLayout( true )

end

--[[---------------------------------------------------------
	Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local y = self.BaseClass.PerformLayout( self )

	local Height = 64 * self.Height + 6

	self.List:SetPos( 0, y )
	self.List:SetSize( self:GetWide(), Height )

	y = y + Height
	y = y + 5

	self:SetTall( y )

end

--[[---------------------------------------------------------
	Name: SelectButton
-----------------------------------------------------------]]
function PANEL:FindAndSelectButton( Value )

	self.CurrentValue = Value

	for k, Icon in pairs( self.Controls ) do

		if ( Icon.Model == Value || Icon.Value == Value ) then

			-- Remove the old overlay
			if ( self.SelectedIcon ) then
				self.SelectedIcon.PaintOver = nil
			end

			-- Add the overlay to this button
			Icon.PaintOver = HighlightedButtonPaint;
			self.SelectedIcon = Icon

		end

	end

end

--[[---------------------------------------------------------
	Name: TestForChanges
-----------------------------------------------------------]]
function PANEL:TestForChanges()

	local Value = GetConVarString( self:ConVar() )

	if ( Value == self.CurrentValue ) then return end

	self:FindAndSelectButton( Value )

end

vgui.Register( "PropSelect", PANEL, "ContextBase" )
