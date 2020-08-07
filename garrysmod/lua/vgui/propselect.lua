
local PANEL = {}

local border = 0
local border_w = 8
local matHover = Material( "gui/ps_hover.png", "nocull" )
local boxHover = GWEN.CreateTextureBorder( border, border, 64 - border * 2, 64 - border * 2, border_w, border_w, border_w, border_w, matHover )

-- This function is used as the paint function for selected buttons.
local function HighlightedButtonPaint( self, w, h )

	boxHover( 0, 0, w, h, color_white )

end

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

function PANEL:AddModel( model, ConVars )

	-- Creeate a spawnicon and set the model
	local Icon = vgui.Create( "SpawnIcon", self )
	Icon:SetModel( model )
	Icon:SetTooltip( model )
	Icon.Model = model
	Icon.ConVars = ConVars || {}

	local ConVarName = self:ConVar()

	-- Run a console command when the Icon is clicked
	Icon.DoClick = function ( self )

		for k, v in pairs( self.ConVars ) do
			LocalPlayer():ConCommand( Format( "%s \"%s\"\n", k, v ) )
		end

		-- Note: We run this command after all the optional stuff
		LocalPlayer():ConCommand( Format( "%s \"%s\"\n", ConVarName, model ) )

	end
	Icon.OpenMenu = function( button )
		local menu = DermaMenu()
		menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( model ) end ):SetIcon( "icon16/page_copy.png" )
		menu:Open()
	end

	-- Add the Icon us
	self.List:AddItem( Icon )
	table.insert( self.Controls, Icon )

	return Icon
end

function PANEL:AddModelEx( name, model, skin )

	-- Creeate a spawnicon and set the model
	local Icon = vgui.Create( "SpawnIcon", self )
	Icon:SetModel( model, skin )
	Icon:SetTooltip( model )
	Icon.Model = model
	Icon.Value = name
	Icon.ConVars = ConVars || {}

	local ConVarName = self:ConVar()

	-- Run a console command when the Icon is clicked
	Icon.DoClick = function ( self ) LocalPlayer():ConCommand( Format( "%s \"%s\"\n", ConVarName, Icon.Value ) ) end
	Icon.OpenMenu = function( button )
		local menu = DermaMenu()
		menu:AddOption( "Copy to Clipboard", function() SetClipboardText( model ) end ):SetIcon( "icon16/page_copy.png" )
		menu:Open()
	end

	-- Add the Icon us
	self.List:AddItem( Icon )
	table.insert( self.Controls, Icon )

	return Icon
end

function PANEL:ControlValues( kv )

	self.BaseClass.ControlValues( self, kv )

	self.Height = kv.height || 2

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
		local tmp = {} -- HACK: Order by skin too.
		for k, v in SortedPairsByMemberValue( kv.modelstable, "model" ) do
			tmp[ k ] = v.model .. ( v.skin || 0 )
		end

		for k, v in SortedPairsByValue( tmp ) do
			v = kv.modelstable[ k ]
			self:AddModelEx( k, v.model, v.skin || 0 )
		end
	end

	self:InvalidateLayout( true )

end

function PANEL:PerformLayout( w, h )

	local y = self.BaseClass.PerformLayout( self, w, h )

	if ( self.Height >= 1 ) then
		local Height = ( 64 + self.List:GetSpacing() ) * math.max( self.Height, 1 ) + self.List:GetPadding() * 2 - self.List:GetSpacing()

		self.List:SetPos( 0, y )
		self.List:SetSize( self:GetWide(), Height )

		y = y + Height

		self:SetTall( y + 5 )
	else -- Height is set to 0 or less, auto stretch
		self.List:SetWide( self:GetWide() )
		self.List:SizeToChildren( false, true )
		self:SetTall( self.List:GetTall() + 5 )
	end

end

function PANEL:FindAndSelectButton( Value )

	self.CurrentValue = Value

	for k, Icon in pairs( self.Controls ) do

		if ( Icon.Model == Value || Icon.Value == Value ) then

			-- Remove the old overlay
			if ( self.SelectedIcon ) then
				self.SelectedIcon.PaintOver = self.OldSelectedPaintOver
			end

			-- Add the overlay to this button
			self.OldSelectedPaintOver = Icon.PaintOver
			Icon.PaintOver = HighlightedButtonPaint
			self.SelectedIcon = Icon

		end

	end

end

function PANEL:TestForChanges()

	local Value = GetConVarString( self:ConVar() )

	if ( Value == self.CurrentValue ) then return end

	self:FindAndSelectButton( Value )

end

vgui.Register( "PropSelect", PANEL, "ContextBase" )
