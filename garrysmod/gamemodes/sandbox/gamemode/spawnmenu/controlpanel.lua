
--
--	Note: This is only really here as a layer between the spawnmenu
--			and the DForm Derma control. You shouldn't ever really be
--			calling AddControl. If you're writing new code - don't call
--			AddControl!! Add stuff directly using the DForm member functions!
--

include( "controls/manifest.lua" )

local PANEL = {}

AccessorFunc( PANEL, "m_bInitialized", "Initialized" )

function PANEL:Init()
	self:SetInitialized( false )
end

function PANEL:ClearControls()
	self:Clear()
end

function PANEL:GetEmbeddedPanel()

	return self

end

function PANEL:AddPanel( pnl )

	self:AddItem( pnl, nil )
	self:InvalidateLayout()

end

function PANEL:MatSelect( strConVar, tblOptions, bAutoStretch, iWidth, iHeight )

	local MatSelect = vgui.Create( "MatSelect", self )
	Derma_Hook( MatSelect.List, "Paint", "Paint", "Panel" )

	MatSelect:SetConVar( strConVar )

	if ( bAutoStretch != nil ) then MatSelect:SetAutoHeight( bAutoStretch ) end
	if ( iWidth != nil ) then MatSelect:SetItemWidth( iWidth ) end
	if ( iHeight != nil ) then MatSelect:SetItemHeight( iHeight ) end

	if ( tblOptions != nil ) then
		for k, v in pairs( tblOptions ) do
			local nam = isnumber( k ) and v or k
			MatSelect:AddMaterial( nam, v )
		end
	end

	self:AddPanel( MatSelect )
	return MatSelect

end

function PANEL:RopeSelect( strConVar )

	local ctrl = vgui.Create( "RopeMaterial", self )
	ctrl:SetConVar( strConVar )
	self:AddPanel( ctrl )

	return ctrl

end

function PANEL:PropSelect( label, strConVar, mdlList, height )

	local PropSelect = vgui.Create( "PropSelect", self )

	PropSelect:SetConVar( strConVar )
	PropSelect.Label:SetText( label or "" )
	PropSelect.Height = height or 2

	local firstKey, firstVal = next( mdlList )
	if ( istable( firstVal ) and isstring( firstVal.model ) ) then
		-- Special case for Balloon tool
		local tmp = {}
		for k, v in SortedPairsByMemberValue( mdlList, "model" ) do
			tmp[ k ] = v.model:lower() .. ( v.skin or 0 )
		end

		for k, v in SortedPairsByValue( tmp ) do
			v = mdlList[ k ]
			PropSelect:AddModelEx( k, v.model, v.skin or 0 )
		end
	else
		for k, v in SortedPairs( mdlList ) do
			PropSelect:AddModel( k, v )
		end
	end

	self:AddPanel( PropSelect )
	return PropSelect

end

function PANEL:ToolPresets( group, cvarlist )

	local preset = vgui.Create( "ControlPresets", self )

	preset:SetPreset( group )
	preset:AddOption( "#preset.default", cvarlist )

	for k, v in pairs( cvarlist ) do
		preset:AddConVar( k )
	end

	self:AddItem( preset )

	return preset

end

function PANEL:KeyBinder( label1, convar1, label2, convar2 )

	local binder = vgui.Create( "CtrlNumPad", self )

	binder:SetLabel1( label1 )
	binder:SetConVar1( convar1 )

	if ( label2 != nil and convar2 != nil ) then
		binder:SetLabel2( label2 )
		binder:SetConVar2( convar2 )
	end

	self:AddPanel( binder )

	return binder

end

function PANEL:ColorPicker( label, convarR, convarG, convarB, convarA )

	local color = vgui.Create( "CtrlColor", self )

	color:Dock( TOP )
	color:SetLabel( label )

	color:SetConVarR( convarR )
	color:SetConVarG( convarG )
	color:SetConVarB( convarB )

	if ( convarA != nil ) then
		color:SetConVarA( convarA )
	end

	self:AddPanel( color )

	return color

end

function PANEL:ComboBoxMulti( label, list )

	local labelPnl = vgui.Create( "DLabel", self )
	labelPnl:SetText( label )
	labelPnl:SetDark( true )

	local cbox = vgui.Create( "CtrlListBox", self )
	cbox:SetHeight( 25 )
	cbox:Dock( TOP )
	if ( list ) then
		for k, v in pairs( list ) do
			cbox:AddOption( k, v )
		end
	end

	self:AddItem( labelPnl, cbox )

	return cbox, labelPnl

end

function PANEL:FillViaTable( Table )

	self:SetInitialized( true )

	self:SetName( Table.Text )

	--
	-- If we have a function to create the control panel, use that
	--
	if ( Table.ControlPanelBuildFunction ) then

		Table.ControlPanelBuildFunction( self )

	end

end

function PANEL:FillViaFunction( func )

	func( self )

end

function PANEL:ControlValues( data )
	if ( data.label) then
		self:SetLabel( data.label )
	end
	if ( data.closed ) then
		self:SetExpanded( false )
	end
end


function PANEL:AddControl( control, data )

	local data = table.LowerKeyNames( data )
	local original = control
	control = string.lower( control )

	-- Retired
	if ( control == "header" ) then

		if ( data.description ) then
			local ctrl = self:Help( data.description )
			return ctrl
		end

		return
	end

	if ( control == "textbox" ) then

		local ctrl = self:TextEntry( data.label or "Untitled", data.command )
		return ctrl

	end

	if ( control == "label" ) then

		local ctrl = self:Help( data.text )
		return ctrl

	end

	if ( control == "checkbox" or control == "toggle" ) then

		local ctrl = self:CheckBox( data.label or "Untitled", data.command )

		if ( data.help ) then
			self:ControlHelp( data.label .. ".help" )
		end

		return ctrl

	end

	if ( control == "slider" ) then

		local Decimals = 0
		if ( data.type and string.lower(data.type) == "float" ) then Decimals = 2 end

		local ctrl = self:NumSlider( data.label or "Untitled", data.command, data.min or 0, data.max or 100, Decimals )

		if ( data.help ) then
			self:ControlHelp( data.label .. ".help" )
		end

		if ( data.default ) then
			ctrl:SetDefaultValue( data.default )
		end

		return ctrl

	end

	if ( control == "propselect" ) then

		local ctrl = vgui.Create( "PropSelect", self )
		ctrl:ControlValues( data ) -- Yack.
		self:AddPanel( ctrl )
		return ctrl

	end

	if ( control == "matselect" ) then

		local ctrl = vgui.Create( "MatSelect", self )
		ctrl:ControlValues( data ) -- Yack.
		self:AddPanel( ctrl )

		Derma_Hook( ctrl.List, "Paint", "Paint", "Panel" )

		return ctrl

	end

	if ( control == "ropematerial" ) then

		local ctrl = vgui.Create( "RopeMaterial", self )
		ctrl:SetConVar( data.convar )
		self:AddPanel( ctrl )

		return ctrl

	end

	if ( control == "button" ) then

		local ctrl = vgui.Create( "DButton", self )

		-- Note: Buttons created this way use the old method of calling commands,
		-- via LocalPlayer:ConCommand. This way is flawed. This way is legacy.
		-- The new way is to make buttons via controlpanel:Button( name, command, commandarg1, commandarg2 ) etc
		if ( data.command ) then
			function ctrl:DoClick() LocalPlayer():ConCommand( data.command ) end
		end

		ctrl:SetText( data.label or data.text or "No Label" )
		self:AddPanel( ctrl )
		return ctrl

	end

	if ( control == "numpad" ) then

		local ctrl = vgui.Create( "CtrlNumPad", self )
		ctrl:SetConVar1( data.command )
		ctrl:SetConVar2( data.command2 )
		ctrl:SetLabel1( data.label )
		ctrl:SetLabel2( data.label2 )

		self:AddPanel( ctrl )
		return ctrl

	end

	if ( control == "color" ) then

		local ctrl = vgui.Create( "CtrlColor", self )
		ctrl:SetLabel( data.label )
		ctrl:SetConVarR( data.red )
		ctrl:SetConVarG( data.green )
		ctrl:SetConVarB( data.blue )
		ctrl:SetConVarA( data.alpha )

		self:AddPanel( ctrl )
		return ctrl

	end


	if ( control == "combobox" ) then

		if ( tostring( data.menubutton ) == "1" ) then

			local ctrl = vgui.Create( "ControlPresets", self )
			ctrl:SetPreset( data.folder )
			if ( data.options ) then
				for k, v in pairs( data.options ) do
					ctrl:AddOption( k, v )
				end
			end

			if ( data.cvars ) then
				for k, v in pairs( data.cvars ) do
					ctrl:AddConVar( v )
				end
			end

			self:AddPanel( ctrl )
			return ctrl

		end

		control = "listbox"

	end

	if ( control == "listbox" ) then

		if ( data.height ) then

			local ctrl = vgui.Create( "DListView" )
			ctrl:SetMultiSelect( false )
			ctrl:AddColumn( data.label or "unknown" )

			if ( data.options ) then

				for k, v in pairs( data.options ) do

					local line = ctrl:AddLine( k )
					line.data = v

					-- This is kind of broken because it only checks one convar
					-- instead of all of them. But this is legacy. It will do for now.
					for k, v in pairs( line.data ) do
						if ( GetConVarString( k ) == tostring( v ) ) then
							line:SetSelected( true )
						end
					end

				end

			end

			ctrl:SetTall( data.height )
			ctrl:SortByColumn( 1, false )

			function ctrl:OnRowSelected( LineID, Line )
				for k, v in pairs( Line.data ) do
					RunConsoleCommand( k, v )
				end
			end

			self:AddItem( ctrl )

			return ctrl

		else

			local left = vgui.Create( "DLabel", self )
			left:SetText( data.label )
			left:SetDark( true )

			local ctrl = vgui.Create( "CtrlListBox", self )
			ctrl:SetHeight( 25 )
			ctrl:Dock( TOP )
			if ( data.options ) then
				for k, v in pairs( data.options ) do
					ctrl:AddOption( k, v )
				end
			end

			self:AddItem( left, ctrl )

			return ctrl

		end

	end

	if ( control == "materialgallery" ) then

		local ctrl = vgui.Create( "MatSelect", self )
		--ctrl:ControlValues( data ) -- Yack.

		ctrl:SetItemWidth( data.width or 32 )
		ctrl:SetItemHeight( data.height or 32 )
		ctrl:SetNumRows( data.rows or 4 )
		ctrl:SetConVar( data.convar or nil )

		Derma_Hook( ctrl.List, "Paint", "Paint", "Panel" )

		for name, tab in pairs( data.options ) do

			local mat = tab.material
			local value = tab.value

			tab.material = nil
			tab.value = nil

			ctrl:AddMaterialEx( name, mat, value, tab )

		end

		self:AddPanel( ctrl )
		return ctrl

	end

	local ctrl = vgui.Create( original, self )
	-- Fallback for scripts that relied on the old behaviour
	if ( !ctrl ) then
		ctrl = vgui.Create( control, self )
	end
	if ( ctrl ) then

		if ( ctrl.ControlValues ) then
			ctrl:ControlValues( data )
		end

		self:AddPanel( ctrl )
		return ctrl

	end

	MsgN( "UNHANDLED CONTROL: ", control )
	PrintTable( data )
	MsgN( "\n\n" )

end

vgui.Register( "ControlPanel", PANEL, "DForm" )
