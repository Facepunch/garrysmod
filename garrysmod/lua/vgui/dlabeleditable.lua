
local PANEL = {}

AccessorFunc( PANEL, "m_bStretch", "AutoStretch", FORCE_BOOL )

function PANEL:Init()

	self:SetAutoStretch( false )

end

function PANEL:SizeToContents()

	local w, h = self:GetContentSize()
	self:SetSize( w + 16, h ) -- Add a bit more room so it looks nice as a textbox :)

end

function PANEL:GetContentSize()

	local w, h = DLabel.GetContentSize( self )

	-- Expand the label to fit our text
	if ( self:IsEditing() && self:GetAutoStretch() ) then
		surface.SetFont( self:GetFont() )
		w, h = surface.GetTextSize( self._TextEdit:GetText() )
	end

	return w, h

end

function PANEL:DoDoubleClick()

	if ( !self:IsEnabled() ) then return end

	local TextEdit = vgui.Create( "DTextEntry", self )
	TextEdit:Dock( FILL )
	TextEdit:SetText( self:GetText() )
	TextEdit:SetFont( self:GetFont() )

	TextEdit.OnTextChanged = function()

		self:SizeToContents()

	end

	TextEdit.OnEnter = function()

		local text = self:OnLabelTextChanged( TextEdit:GetText() ) or TextEdit:GetText()
		if ( text:byte() == 35 ) then text = "#" .. text end -- Hack!

		self:SetText( text )
		hook.Run( "OnTextEntryLoseFocus", TextEdit )
		TextEdit:Remove()

	end

	TextEdit.OnLoseFocus = function()

		hook.Run( "OnTextEntryLoseFocus", TextEdit )
		TextEdit:Remove()

	end

	TextEdit:RequestFocus()
	TextEdit:OnGetFocus() -- Because the keyboard input might not be enabled yet! (spawnmenu)
	TextEdit:SelectAllText( true )

	self._TextEdit = TextEdit

end

function PANEL:IsEditing()

	if ( !IsValid( self._TextEdit ) ) then return false end

	return self._TextEdit:IsEditing()

end

function PANEL:OnLabelTextChanged( text )

	return text

end

derma.DefineControl( "DLabelEditable", "A Label", PANEL, "DLabel" )
