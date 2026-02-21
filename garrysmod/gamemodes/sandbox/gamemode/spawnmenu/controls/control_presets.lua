
include( "preset_editor.lua" )

local PANEL = {}

function PANEL:Init()

	self.DropDown = vgui.Create( "DComboBox", self )
	self.DropDown.OnSelect = function( dropdown, index, value, data ) self:OnSelect( index, value, data ) end
	self.DropDown:SetText( "Presets" )
	self.DropDown:Dock( FILL )

	self.Button = vgui.Create( "DImageButton", self )
	self.Button.DoClick = function() self:OpenPresetEditor() end
	self.Button:Dock( RIGHT )
	self.Button:SetToolTip( "#preset.edit" )
	self.Button:SetImage( "icon16/wrench.png" )
	self.Button:SetStretchToFit( false )
	self.Button:SetSize( 20, 20 )
	self.Button:DockMargin( 0, 0, 0, 0 )

	self.AddButton = vgui.Create( "DImageButton", self )
	self.AddButton.DoClick = function()
		if ( !IsValid( self ) ) then return end

		self:QuickSavePreset()
	end
	self.AddButton:Dock( RIGHT )
	self.AddButton:SetToolTip( "#preset.add" )
	self.AddButton:SetImage( "icon16/add.png" )
	self.AddButton:SetStretchToFit( false )
	self.AddButton:SetSize( 20, 20 )
	self.AddButton:DockMargin( 2, 0, 0, 0 )

	self:SetTall( 20 )

	self.Options = {}
	self.ConVars = {}

end

function PANEL:SetLabel( strName )

	self.Label:SetText( strName )

end

function PANEL:AddOption( strName, data )

	self.DropDown:AddChoice( strName, data )

	self.Options[ strName ] = data

end

function PANEL:SetOptions( Options )
	if ( Options ) then
		table.Merge( self.Options, Options )
	end
end

function PANEL:OnSelect( index, value, data )

	if ( !data ) then return end

	for k, v in pairs( data ) do
		RunConsoleCommand( k, v )
	end

end

function PANEL:QuickSaveInternal( text )
	local tabValues = {}
	for k, v in pairs( self:GetConVars() ) do
		tabValues[ v ] = GetConVarString( v )
	end

	presets.Add( self.m_strPreset, text, tabValues )
	self:Update()
end

function PANEL:QuickSavePreset()
	Derma_StringRequest( "#preset.saveas_title", "#preset.saveas_desc", "", function( text )
		if ( !text || text:Trim() == "" ) then presets.BadNameAlert() return end

		if ( presets.Exists( self.m_strPreset, text ) ) then
			presets.OverwritePresetPrompt( function()
				self:QuickSaveInternal( text )
			end )
			return
		end

		self:QuickSaveInternal( text )
	end )
end

function PANEL:OpenPresetEditor()

	if ( !self.m_strPreset ) then return end

	self.Window = vgui.Create( "PresetEditor" )
	self.Window:MakePopup()
	self.Window:Center()
	self.Window:SetType( self.m_strPreset )
	self.Window:SetConVars( self:GetConVars() )
	self.Window:SetPresetControl( self )

end

function PANEL:AddConVar( convar )

	table.insert( self.ConVars, convar )

end

function PANEL:GetConVars()

	return self.ConVars

end

function PANEL:SetPreset( strName )

	self.m_strPreset = strName
	self:ReloadPresets()

end

function PANEL:ReloadPresets()

	self:Clear()

	for name, data in pairs( self.Options ) do
		self:AddOption( name, data )
	end

	local Presets = presets.GetTable( self.m_strPreset )
	local sortedPresets, i = {}, 1
	for name in pairs( Presets ) do
		sortedPresets[ i ] = name
		i = i + 1
	end
	table.sort( sortedPresets )

	for _, name in ipairs( sortedPresets ) do
		self.DropDown:AddChoice( name, Presets[ name ] )
	end

end

function PANEL:Update()

	self:ReloadPresets()

end

function PANEL:Clear()

	self.DropDown:Clear()

end

vgui.Register( "ControlPresets", PANEL, "Panel" )
