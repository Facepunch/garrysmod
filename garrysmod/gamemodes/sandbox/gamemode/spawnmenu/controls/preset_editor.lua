
local PANEL = {}

AccessorFunc( PANEL, "m_strType", "Type" )
AccessorFunc( PANEL, "m_ConVars", "ConVars" )
AccessorFunc( PANEL, "m_PresetControl", "PresetControl" )

function PANEL:Init()

	self:SetSize( 450, 350 )
	self:SetMinWidth( 450 )
	self:SetMinHeight( 350 )
	self:SetSizable( true )
	self:SetTitle( "#preset.editor" )
	self:DockPadding( 6, 29, 6, 6 )

	local pnlTop = vgui.Create( "Panel", self )
	pnlTop:Dock( FILL )
	pnlTop:DockMargin( 0, 0, 0, 5 )

	self.PresetList = vgui.Create( "DListView", pnlTop )
	self.PresetList:Dock( LEFT )
	self.PresetList:DockMargin( 0, 0, 5, 0 )
	self.PresetList:SetWide( 150 )
	self.PresetList:SetMultiSelect( false )
	self.PresetList:SetSortable( false )
	self.PresetList.OnRowSelected = function( s, idx, pnl ) self:OnPresetSelected( pnl ) end

	local pnlEditor = vgui.Create( "DPanel", pnlTop )
	pnlEditor:Dock( FILL )

	self.pnlDetails = vgui.Create( "DProperties", pnlEditor )
	self.pnlDetails:Dock( FILL )
	self.pnlDetails:DockMargin( 5, 5, 5, 5 )

	----------

	local pnlModify = vgui.Create( "Panel", pnlEditor )
	pnlModify:Dock( BOTTOM )
	pnlModify:SetTall( 20 )
	pnlModify:DockMargin( 5, 0, 5, 5 )

	local btnDelete = vgui.Create( "DButton", pnlModify )
	btnDelete.DoClick = function() self:Delete() end
	btnDelete:SetTooltip( "#preset.delete" )
	btnDelete:SetImage( "icon16/bin.png" )
	btnDelete:SetText( "" )
	btnDelete:Dock( RIGHT )
	btnDelete:SetWide( 25 )
	btnDelete:SetEnabled( false )

	self.txtRename = vgui.Create( "DTextEntry", pnlModify )
	self.txtRename:Dock( FILL )
	self.txtRename:SetEnabled( false )
	self.txtRename:SetTooltip( "#preset.rename" )

	local btnRename = vgui.Create( "DButton", pnlModify )
	btnRename:SetTooltip( "#preset.save" )
	btnRename:SetImage( "icon16/disk.png" )
	btnRename:SetText( "" )
	btnRename:Dock( RIGHT )
	btnRename:DockMargin( 5, 0, 5, 0 )
	btnRename:SetWide( 24 )
	btnRename.DoClick = function() self:SaveChanges() end
	btnRename:SetEnabled( false )

	----------

	local bottom = vgui.Create( "Panel", self )
	bottom:Dock( BOTTOM )
	bottom:SetTall( 30 )

	self.pnlAdd = vgui.Create( "DPanel", bottom )
	self.pnlAdd:Dock( FILL )
	self.pnlAdd:DockPadding( 5, 5, 5, 5 )
	self.pnlAdd:DockMargin( 0, 0, 5, 0 )

	self.txtName = vgui.Create( "DTextEntry", self.pnlAdd )
	self.txtName:SetTooltip( "#preset.addnew_field" )
	self.txtName:Dock( FILL )
	self.txtName:DockMargin( 0, 0, 5, 0 )
	self.txtName.OnChange = function( s ) self.btnAdd:SetEnabled( s:GetText():Trim() != "" ) end

	self.btnAdd = vgui.Create( "DButton", self.pnlAdd )
	self.btnAdd:SetText( "#preset.addnew" )
	self.btnAdd:Dock( RIGHT )
	self.btnAdd:SetEnabled( false )
	self.btnAdd.DoClick = function() self:Add() end

	----------

	local pnlClose = vgui.Create( "DPanel", bottom )
	pnlClose:Dock( RIGHT )
	pnlClose:SetWide( 100 )
	pnlClose:DockPadding( 5, 5, 5, 5 )

	local btnCloseIt = vgui.Create( "DButton", pnlClose )
	btnCloseIt:SetText( "#preset.close" )
	btnCloseIt:Dock( FILL )
	btnCloseIt.DoClick = function() self:Remove() end

end

function PANEL:SetType( strType )

	self.m_strType = strType

	self.PresetList:AddColumn( self:GetType() )
	self:Update()

end

function PANEL:OnPresetSelected( item )

	local name = item:GetValue( 1 )

	self.txtRename:SetText( name )
	for id, pnl in ipairs( self.txtRename:GetParent():GetChildren() ) do pnl:SetEnabled( true ) end

	self.pnlDetails:Clear()
	for cvar, val in SortedPairs( item:GetTable().Data ) do
		local Row = self.pnlDetails:CreateRow( name, cvar:lower() )

		if ( tonumber( val ) != nil && false ) then
			Row:Setup( "Float", { min = 0, max = 1000 } )
			Row:SetValue( val )
		else
			Row:Setup( "Generic" )
		end

		Row:SetValue( val )
		Row.__Value = val
		Row.DataChanged = function( s, value ) Row.__Value = value end
	end

end

function PANEL:Update()

	self.PresetList:Clear()
	self.pnlDetails:Clear()
	self.txtRename:SetText( "" )

	local Presets = presets.GetTable( self:GetType() )
	local sortedPresets, i = {}, 1
	for name in pairs( Presets ) do
		sortedPresets[i] = name
		i = i + 1
	end
	table.sort( sortedPresets )

	for _, name in ipairs( sortedPresets ) do
		local item = self.PresetList:AddLine( name )
		item.Data = Presets[ name ]
	end

end

function PANEL:SelectPresetByName( name )

	for id, line in pairs( self.PresetList:GetLines() ) do
		if ( line:GetValue( 1 ) != name ) then continue end
		self.PresetList:SelectItem( line )
	end

end

function PANEL:Delete()

	if ( !self.PresetList:GetSelectedLine() || !IsValid( self.PresetList:GetLine( self.PresetList:GetSelectedLine() ) ) ) then return end

	local Selected = self.PresetList:GetLine( self.PresetList:GetSelectedLine() ):GetValue( 1 ):Trim()
	if ( Selected == "" ) then return end

	presets.Remove( self:GetType(), Selected )
	self:Update()

	if ( self:GetPresetControl() ) then self:GetPresetControl():Update() end

end

function PANEL:SaveChangesInternal( Selected, ToName )

	local tabValues = {}
	local cat = self.pnlDetails:GetCategory( Selected )

	-- WARNING: This will discard ConVars in the preset that no longer exist on the tool/whatever this preset is for
	for k, v in pairs( self:GetConVars() ) do
		if ( cat:GetRow( v:lower() ) ) then
			tabValues[ v:lower() ] = cat:GetRow( v:lower() ).__Value
		end
	end

	presets.Rename( self:GetType(), Selected, ToName ) -- Raname the preset if necessary
	presets.Add( self:GetType(), ToName, tabValues ) -- Update the values

	self:Update()

	self.txtRename:SetText( "" )
	self:SelectPresetByName( ToName )

	if ( self:GetPresetControl() ) then self:GetPresetControl():Update() end

end

function PANEL:SaveChanges()

	if ( !self.PresetList:GetSelectedLine() || !IsValid( self.PresetList:GetLine( self.PresetList:GetSelectedLine() ) ) ) then return end

	local Selected = self.PresetList:GetLine( self.PresetList:GetSelectedLine() ):GetValue( 1 ):Trim()
	if ( Selected == "" ) then return end

	local ToName = self.txtRename:GetValue():Trim()
	if ( !ToName || ToName == "" ) then presets.BadNameAlert() return end

	if ( presets.Exists( self:GetType(), ToName ) && Selected != ToName ) then
		presets.OverwritePresetPrompt( function()
			self:SaveChangesInternal( Selected, ToName )
		end )
		return
	end

	self:SaveChangesInternal( Selected, ToName )

end

function PANEL:InternalAdd( ToName )

	local tabValues = {}
	for k, v in pairs( self:GetConVars() ) do
		tabValues[ v ] = GetConVarString( v:lower() )
	end

	presets.Add( self:GetType(), ToName, tabValues )
	self:Update()

	self.txtName:SetText( "" )
	self:SelectPresetByName( ToName )

	if ( self:GetPresetControl() ) then self:GetPresetControl():Update() end

end

function PANEL:Add()

	if ( !self:GetConVars() ) then return end

	local ToName = self.txtName:GetValue():Trim()
	if ( !ToName || ToName == "" ) then presets.BadNameAlert() return end

	if ( presets.Exists( self:GetType(), ToName ) ) then
		presets.OverwritePresetPrompt( function()
			self:InternalAdd( ToName )
		end )
		return
	end

	self:InternalAdd( ToName )

end

vgui.Register( "PresetEditor", PANEL, "DFrame" )
