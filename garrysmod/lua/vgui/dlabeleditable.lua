
local PANEL = {}

function PANEL:Init()
end

function PANEL:SizeToContents()

	local w, h = self:GetContentSize()
	self:SetSize( w + 16, h ) -- Add a bit more room so it looks nice as a textbox :)

end

function PANEL:DoDoubleClick()

	local TextEdit = vgui.Create( "DTextEntry", self )
	TextEdit:Dock( FILL )
	TextEdit:SetText( self:GetText() )
	TextEdit:SetFont( self:GetFont() )

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

end

function PANEL:OnLabelTextChanged( text )
	return text
end

derma.DefineControl( "DLabelEditable", "A Label", PANEL, "DLabel" )
