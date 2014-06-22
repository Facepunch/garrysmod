--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DTextEntry
	
	In Engine Commands:
	
	self:SetMultiline( bool )
	self:IsMultiline()

--]]

PANEL = {}

local strAllowedNumericCharacters = "1234567890.-"

AccessorFunc( PANEL, "m_bAllowEnter", 		"EnterAllowed", FORCE_BOOL )
AccessorFunc( PANEL, "m_bUpdateOnType", 	"UpdateOnType", FORCE_BOOL )	-- Update the convar as we type
AccessorFunc( PANEL, "m_bNumeric", 			"Numeric", FORCE_BOOL )
AccessorFunc( PANEL, "m_bHistory", 			"HistoryEnabled", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDisableTabbing", 	"TabbingDisabled", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_FontName", 			"Font" )
AccessorFunc( PANEL, "m_bBorder", 			"DrawBorder" )
AccessorFunc( PANEL, "m_bBackground", 		"DrawBackground" )

AccessorFunc( PANEL, "m_colText", 			"TextColor" )
AccessorFunc( PANEL, "m_colHighlight", 		"HighlightColor" )
AccessorFunc( PANEL, "m_colCursor", 		"CursorColor" )

AccessorFunc( PANEL, "m_bDisabled", 		"Disabled" )




Derma_Install_Convar_Functions( PANEL )

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self:SetHistoryEnabled( false )
	self.History = {}
	self.HistoryPos = 0
	
	--
	-- We're going to draw these ourselves in 
	-- the skin system - so disable them here.
	-- This will leave it only drawing text.
	--
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackgroundEnabled( false )
	
	--
	-- These are Lua side commands
	-- Defined above using AccessorFunc
	--
	self:SetDrawBorder( true )
	self:SetDrawBackground( true )
	self:SetEnterAllowed( true )
	self:SetUpdateOnType( false )
	self:SetNumeric( false )
	self:SetAllowNonAsciiCharacters( true )
		
	
	-- Nicer default height
	self:SetTall( 20 )
	
	-- Clear keyboard focus when we click away
	self.m_bLoseFocusOnClickAway = true
	
	-- Beam Me Up Scotty
	self:SetCursor( "beam" )
	
	-- Apply scheme settings now, allow the user to override them later.
	derma.SkinHook( "Scheme", "TextEntry", self )

	self:SetFont( "DermaDefault" )

end

function PANEL:IsEditing()
	return self == vgui.GetKeyboardFocus()
end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnKeyCodeTyped( code )

	self:OnKeyCode( code )

	if ( code == KEY_ENTER && !self:IsMultiline() && self:GetEnterAllowed() ) then
	
		if ( IsValid( self.Menu ) ) then
			self.Menu:Remove()
		end
	
		self:FocusNext()
		self:OnEnter()
		self.HistoryPos = 0
		
	end
	
	if ( self.m_bHistory || IsValid( self.Menu ) ) then
	
		if ( code == KEY_UP ) then
			self.HistoryPos = self.HistoryPos - 1;
			self:UpdateFromHistory()
		end
		
		if ( code == KEY_DOWN || code == KEY_TAB ) then	
			self.HistoryPos = self.HistoryPos + 1;
			self:UpdateFromHistory()
		end
	
	end
	
end

function PANEL:OnKeyCode( code )
	
end

function PANEL:ApplySchemeSettings()

	self:SetFontInternal( self.m_FontName )

end

function PANEL:UpdateFromHistory()

	if ( IsValid( self.Menu ) ) then
		return self:UpdateFromMenu()
	end


	local pos = self.HistoryPos
	-- Is the Pos within bounds?
	if ( pos < 0 ) then pos = #self.History end
	if ( pos > #self.History ) then pos = 0 end
	
	local text = self.History[ pos ]
	if ( !text ) then text = "" end
	
	self:SetText( text )
	self:SetCaretPos( text:len() )

	self:OnTextChanged()
	
	self.HistoryPos = pos

end

function PANEL:UpdateFromMenu()

	local pos = self.HistoryPos
	local num = self.Menu:ChildCount()
	
	self.Menu:ClearHighlights()

	if ( pos < 0 ) then pos = num end
	if ( pos > num ) then pos = 0 end
	
	local item = self.Menu:GetChild( pos )
	if ( !item ) then
		self:SetText( "" )
		self.HistoryPos = pos
	return end
	
	self.Menu:HighlightItem( item )
	
	local txt = item:GetText()
	
	self:SetText( txt )
	self:SetCaretPos( txt:len() )

	self:OnTextChanged(true)
	
	self.HistoryPos = pos

end

--[[---------------------------------------------------------
	OnTextChanged
-----------------------------------------------------------]]
function PANEL:OnTextChanged(noMenuRemoval)
	
	self.HistoryPos = 0
	
	if ( self:GetUpdateOnType() ) then
		self:UpdateConvarValue()
		self:OnValueChange( self:GetText() )
	end
	
	if ( IsValid( self.Menu ) and not noMenuRemoval ) then
		self.Menu:Remove()
	end
	
	local tab = self:GetAutoComplete( self:GetText() )
	if ( tab ) then
		self:OpenAutoComplete( tab )
	end
	
	self:OnChange()
	
end

--[[---------------------------------------------------------
	OnChange
-----------------------------------------------------------]]
function PANEL:OnChange()

	
		
end

function PANEL:OpenAutoComplete( tab )

	if ( !tab ) then return end
	if ( #tab == 0 ) then return end
	
	self.Menu = DermaMenu()
	
		for k, v in pairs( tab ) do
			
			self.Menu:AddOption( v, function() self:SetText( v ) self:SetCaretPos( v:len() ) self:RequestFocus() end )		

		end
	
	local x, y = self:LocalToScreen( 0, self:GetTall() )
	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, true, self )
	self.Menu:SetPos( x, y )
	self.Menu:SetMaxHeight( (ScrH() - y) - 10 )

end

--[[---------------------------------------------------------
	Think
-----------------------------------------------------------]]
function PANEL:Think()

	self:ConVarStringThink()

end

--[[---------------------------------------------------------
	OnEnter
-----------------------------------------------------------]]
function PANEL:OnEnter()

	-- For override
	self:UpdateConvarValue()
	self:OnValueChange( self:GetText() )

end

--[[---------------------------------------------------------
	UpdateConvarValue
-----------------------------------------------------------]]
function PANEL:UpdateConvarValue()

	-- This only kicks into action if this variable has
	-- a ConVar associated with it.
	self:ConVarChanged( self:GetValue() )

end


--[[---------------------------------------------------------
	Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "TextEntry", self, w, h )
	return false

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	derma.SkinHook( "Layout", "TextEntry", self )

end


--[[---------------------------------------------------------
   Name: SetValue ( A simple redirect for the ConVar stuff )
-----------------------------------------------------------]]
function PANEL:SetValue( strValue )

	-- Don't update if we're typing into it!
	-- I'm sure a lot of people will want to reverse this behaviour :(
	if ( vgui.GetKeyboardFocus() == self ) then return end

	local CaretPos = self:GetCaretPos()

	self:SetText( strValue )
	self:OnValueChange( strValue )
	
	self:SetCaretPos( CaretPos )

end


--[[---------------------------------------------------------
   Name: For Override
-----------------------------------------------------------]]
function PANEL:OnValueChange( strValue )

end

--[[---------------------------------------------------------
   Name: CheckNumeric
-----------------------------------------------------------]]
function PANEL:CheckNumeric( strValue )

	-- Not purely numeric, don't run the check
	if ( !self:GetNumeric() ) then return false end
	
	-- God I hope numbers look the same in every language
	if ( !string.find ( strAllowedNumericCharacters, strValue, 1, true ) ) then
	
		-- Noisy Error?
		return true
		
	end

	return false	

end

--[[---------------------------------------------------------
   Name: AllowInput
-----------------------------------------------------------]]
function PANEL:AllowInput( strValue )

	-- This is layed out like this so you can easily override and 
	-- either keep or remove this numeric check.
	if ( self:CheckNumeric( strValue ) ) then return true end

end

--[[---------------------------------------------------------
   Name: SetEditable
-----------------------------------------------------------]]
function PANEL:SetEditable( b )
	
	self:SetKeyboardInputEnabled( b )
	self:SetMouseInputEnabled( b )
	
end

--[[---------------------------------------------------------
   Name: OnGetFocus
-----------------------------------------------------------]]
function PANEL:OnGetFocus()
	
	--
	-- These hooks are here for the sake of things like the spawn menu
	--  which don't have key focus until you click on one of the text areas.
	--
	-- If you make a control for the spawnmenu that requires keyboard input
	-- You should have these 3 functions in your panel, so it can handle it.
	--

	hook.Run( "OnTextEntryGetFocus", self )
	
end

--[[---------------------------------------------------------
   Name: OnLoseFocus
-----------------------------------------------------------]]
function PANEL:OnLoseFocus()
	
	self:UpdateConvarValue()
	
	hook.Call( "OnTextEntryLoseFocus", nil, self )
	
end

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mcode )
	
	self:OnGetFocus()
	
end

--[[---------------------------------------------------------
   Name: AddHistory
-----------------------------------------------------------]]
function PANEL:AddHistory( txt )
	
	if ( !txt || txt == "" ) then return; end
	
	table.RemoveByValue( self.History, txt )	
	table.insert( self.History, txt )
	
end


--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:GetAutoComplete( txt )
	-- for override. Return a table of strings.
end

--[[---------------------------------------------------------
   Name: GetInt
-----------------------------------------------------------]]
function PANEL:GetInt()

	return math.floor( tonumber( self:GetText() ) + 0.5 )

end

--[[---------------------------------------------------------
   Name: GetFloat
-----------------------------------------------------------]]
function PANEL:GetFloat()

	return tonumber( self:GetText() )

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
		ctrl:SetText( "Edit Me!" )
		ctrl:SetWide( 150 )
		
		ctrl.OnEnter = function( self ) Derma_Message( "You Typed: "..self:GetValue() ) end
	
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end


derma.DefineControl( "DTextEntry", "A simple TextEntry control", PANEL, "TextEntry" )


--[[---------------------------------------------------------
   Clear the focus when we click away from us..
-----------------------------------------------------------]]
function TextEntryLoseFocus( panel, mcode )

	local pnl = vgui.GetKeyboardFocus()
	if ( !pnl ) then return end
	if ( pnl == panel ) then return end
	if ( !pnl.m_bLoseFocusOnClickAway ) then return end
	
	pnl:FocusNext()

end

hook.Add( "VGUIMousePressed", "TextEntryLoseFocus", TextEntryLoseFocus )
