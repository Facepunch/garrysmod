
local PANEL = {}

function PANEL:Init()

	self:SetTitle( language.GetPhrase( "derma_controls.title" ) )
	self.ContentPanel = vgui.Create( "DPropertySheet", self )
	self.ContentPanel:Dock( FILL )

	self:InvalidateLayout( true )
	local w, h = self:GetSize()

	local Controls = table.Copy( derma.GetControlList() )

	for key, ctrl in SortedPairs( Controls ) do

		local Ctrls = _G[ key ]
		if ( Ctrls && Ctrls.GenerateExample ) then

			Ctrls:GenerateExample( key, self.ContentPanel, w, h )

		end

	end

	self:SetSize( 600, 450 )

	self.SearchControl = vgui.Create( "DTextEntry", self )
	self.SearchControl:Dock( TOP )
	self.SearchControl:SetUpdateOnType( true )
	self.SearchControl:SetPlaceholderText( language.GetPhrase( "derma_controls.search" ) )
	self.SearchControl.OnValueChange = function( _, str )
		if str == "" then
			for k, v in ipairs( self.ContentPanel:GetItems() ) do
				v.Tab:SetVisible( true )
			end
		else
			for k, v in ipairs( self.ContentPanel:GetItems() ) do
				if string.find( string.lower( v.Name ), string.lower( str ) ) then
					v.Tab:SetVisible( true )
				else
					v.Tab:SetVisible( false )
				end
			end
		end

		-- Force panel refresh (for size)
		self.ContentPanel.tabScroller:ScrollToChild( self.ContentPanel:GetActiveTab() )
	end

end

function PANEL:SwitchTo( name )
	self.ContentPanel:SwitchToName( name )
end

local vguiExampleWindow = vgui.RegisterTable( PANEL, "DFrame" )

--
-- This is all to open the actual window via concommand
--
local DermaExample = nil

local DermaControlsSuffix = ""

if ( MENU_DLL ) then -- Not all controls are available in menu state
	DermaControlsSuffix = "_menu"
end

concommand.Add( "derma_controls" .. DermaControlsSuffix, function( player, command, arguments, args )

	if ( IsValid( DermaExample ) ) then
		DermaExample:Remove()
		return 
	end

	DermaExample = vgui.CreateFromTable( vguiExampleWindow )
	DermaExample:SwitchTo( args )
	DermaExample:MakePopup()
	DermaExample:Center()

end, nil, "", { FCVAR_DONTRECORD } )
