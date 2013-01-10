--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
--										 
--

include( 'preset_editor.lua' )

local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.DropDown = vgui.Create( "DComboBox", self )
	self.DropDown.OnSelect = function( dropdown, index, value, data ) self:OnSelect( index, value, data ) end
	self.DropDown:SetText( "Presets" )
	self.DropDown:Dock( FILL )
	
	-- TODO: ICON!
	self.Button = vgui.Create( "DImageButton", self )
	self.Button.DoClick = function() self:OpenPresetEditor() end
	self.Button:Dock( RIGHT )
	self.Button:SetMaterial( "icon16/wrench.png" )
	self.Button:SetStretchToFit( false )
	self.Button:SetSize( 20, 20 )
	self.Button:DockMargin( 5, 0, 0, 0 )
	
	self:SetTall( 20 )
	
	self.Options = {}
	self.ConVars = {}
	
end


--[[---------------------------------------------------------
   Name: SetLabel
-----------------------------------------------------------]]
function PANEL:SetLabel( strName )

	self.Label:SetText( strName )

end


--[[---------------------------------------------------------
   Name: AddOption
-----------------------------------------------------------]]
function PANEL:AddOption( strName, data )
	
	self.DropDown:AddChoice( strName, data )
	
	self.Options[ strName ] = data 

end

--[[---------------------------------------------------------
   Name: SetOptions
    these are options given to by the CPanel (usually just defaults)
-----------------------------------------------------------]]
function PANEL:SetOptions( Options )
	if Options then
		table.Merge(self.Options, Options)
	end
end

--[[---------------------------------------------------------
   Name: OnSelect
-----------------------------------------------------------]]
function PANEL:OnSelect( index, value, data )

	if ( !data ) then return end
	
	for k, v in pairs( data ) do
		RunConsoleCommand( k, v )
	end

end


--[[---------------------------------------------------------
   Name: OpenPresetEditor
-----------------------------------------------------------]]
function PANEL:OpenPresetEditor()

	if (!self.m_strPreset) then return end

	self.Window = vgui.Create( "PresetEditor" )
	self.Window:MakePopup()
	self.Window:Center()
	self.Window:SetType( self.m_strPreset )
	self.Window:SetConVars( self.ConVars )
	self.Window:SetPresetControl( self )

end

--[[---------------------------------------------------------
   Add A ConVar to store
-----------------------------------------------------------]]
function PANEL:AddConVar( convar )

	table.insert( self.ConVars, convar )

end


--[[---------------------------------------------------------
   Name: GetConVars
-----------------------------------------------------------]]
function PANEL:GetConVars( convar )

	return self.ConVars

end


--[[---------------------------------------------------------
   Name: SetPreset
-----------------------------------------------------------]]
function PANEL:SetPreset( strName )

	self.m_strPreset = strName
	self:ReloadPresets()

end


--[[---------------------------------------------------------
   Name: ReloadPresets
-----------------------------------------------------------]]
function PANEL:ReloadPresets()
	self:Clear()
	
	--reload our given defaults
	self:SetOptions()
	
	local Presets = presets.GetTable( self.m_strPreset )
	local sortedPresets, i = {}, 1
	for name in pairs( Presets ) do
		sortedPresets[i] = name
		i = i + 1
	end
	table.sort( sortedPresets )
	
	for _, name in ipairs( sortedPresets ) do
		self:AddOption( name, Presets[name] )
	end

end

--[[---------------------------------------------------------
   Name: Update
-----------------------------------------------------------]]
function PANEL:Update()

	self:ReloadPresets()

end

--[[---------------------------------------------------------
   Name: Clear
-----------------------------------------------------------]]
function PANEL:Clear()
	
	self.DropDown:Clear()
	
end



vgui.Register( "ControlPresets", PANEL, "Panel" )