
local PANEL = {}

local color_Error = Color( 255, 0, 255 )

AccessorFunc( PANEL, "m_ConVarR", "ConVarR" )
AccessorFunc( PANEL, "m_ConVarG", "ConVarG" )
AccessorFunc( PANEL, "m_ConVarB", "ConVarB" )
AccessorFunc( PANEL, "m_ConVarA", "ConVarA" )

AccessorFunc( PANEL, "m_buttonsize", "ButtonSize", FORCE_NUMBER )

AccessorFunc( PANEL, "m_NumRows", "NumRows", FORCE_NUMBER )

local function CreateColorTable( num_rows )

	local rows = num_rows or 8
	local index = 0
	local ColorTable = {}

	for i = 0, rows * 2 - 1 do -- HSV
		local col = math.Round( math.min( i * ( 360 / ( rows * 2 ) ), 359 ) )
		index = index + 1
		ColorTable[ index ] = HSVToColor( 360 - col, 1, 1 )
	end

	for i = 0, rows - 1 do -- HSV dark
		local col = math.Round( math.min( i * ( 360 / rows ), 359 ) )
		index = index + 1
		ColorTable[ index ] = HSVToColor( 360 - col, 1, 0.5 )
	end

	for i = 0, rows - 1 do -- HSV grey
		local col = math.Round( math.min( i * ( 360 / rows ), 359 ) )
		index = index + 1
		ColorTable[ index ] = HSVToColor( 360 - col, 0.5, 0.5 )
	end

	for i = 0, rows - 1 do -- HSV bright
		local col = math.min( i * ( 360 / rows ), 359 )
		index = index + 1
		ColorTable[ index ] = HSVToColor( 360 - col, 0.5, 1 )
	end

	for i = 0, rows - 1 do -- Greyscale
		local white = 255 - math.Round( math.min( i * ( 256 / ( rows - 1 ) ), 255 ) )
		index = index + 1
		ColorTable[ index ] = Color( white, white, white )
	end

	return ColorTable

end

local function AddButton( panel, color, size, id )

	local button = vgui.Create( "DColorButton", panel )
	button:SetSize( size or 10, size or 10 )
	button:SetID( id )

	--
	-- If the cookie value exists, then use it
	--
	local col_saved = panel:GetCookie( "col." .. id, nil )
	if ( col_saved != nil ) then
		color = col_saved:ToColor()
	end

	button:SetColor( color or color_Error )

	button.DoClick = function( self )
		local col = self:GetColor() or color_Error
		panel:OnValueChanged( col )
		panel:UpdateConVars( col )
		panel:DoClick( col, button )
	end

	button.DoRightClick = function( self )
		panel:OnRightClickButton( self )
	end

	return button

end

-- This stuff could be better
g_ColorPalettePanels = g_ColorPalettePanels or {}

function PANEL:Init()

	self:SetSize( 80, 120 )
	self:SetNumRows( 8 )
	self:Reset()
	self:SetCookieName( "palette" )

	self:SetButtonSize( 10 )

	table.insert( g_ColorPalettePanels, self )

end

-- This stuff could be better
function PANEL:NetworkColorChange()

	for id, pnl in pairs( g_ColorPalettePanels ) do
		if ( !IsValid( pnl ) ) then table.remove( g_ColorPalettePanels, id ) end
	end

	for id, pnl in pairs( g_ColorPalettePanels ) do
		if ( !IsValid( pnl ) or pnl == self ) then continue end
		if ( pnl:GetNumRows() != self:GetNumRows() or pnl:GetCookieName() != self:GetCookieName() ) then continue end
		local tab = {}
		for pid, p in ipairs( self:GetChildren() ) do
			tab[ p:GetID() ] = p:GetColor()
		end
		pnl:SetColorButtons( tab )
	end

end

function PANEL:DoClick( color, button )

	-- Override

end

function PANEL:Reset()

	self:SetColorButtons( CreateColorTable( self:GetNumRows() ) )

end

function PANEL:ResetSavedColors()

	local tab = CreateColorTable( self:GetNumRows() )

	for i, color in pairs( tab ) do
		local id = tonumber( i )
		if ( !id ) then break end

		self:SetCookie( "col." .. id, nil )
	end

	self:SetColorButtons( tab )

	self:NetworkColorChange()

end

function PANEL:PaintOver( w, h )

	surface.SetDrawColor( 0, 0, 0, 200 )

	local childW = 0
	for id, child in ipairs( self:GetChildren() ) do
		if ( childW + child:GetWide() > w ) then break end
		childW = childW + child:GetWide()
	end

	surface.DrawOutlinedRect( 0, 0, childW, h )

end

function PANEL:SetColorButtons( tab )

	self:Clear()

	for i, color in pairs( tab or {} ) do

		local id = tonumber( i )
		if ( !id ) then break end

		AddButton( self, color, self:GetButtonSize(), i )

	end

	self:InvalidateLayout()

end

function PANEL:SetButtonSize( val )

	self.m_buttonsize = math.floor( val )

	for k, v in ipairs( self:GetChildren() ) do
		v:SetSize( self:GetButtonSize(), self:GetButtonSize() )
	end

	self:InvalidateLayout()

end

function PANEL:UpdateConVar( strName, strKey, color )

	if ( !strName ) then return end

	RunConsoleCommand( strName, tostring( color[ strKey ] ) )

end

function PANEL:UpdateConVars( color )

	self:UpdateConVar( self:GetConVarR(), "r", color )
	self:UpdateConVar( self:GetConVarG(), "g", color )
	self:UpdateConVar( self:GetConVarB(), "b", color )
	self:UpdateConVar( self:GetConVarA(), "a", color )

end

function PANEL:SaveColor( btn, color )

	-- TODO: If something uses different palette size, consider that a separate palette?
	-- ( i.e. for each m_NumRows value, save to a different cookie prefix/suffix? )

	-- Avoid unintended color changing.
	color = table.Copy( color or color_Error )

	btn:SetColor( color )
	self:SetCookie( "col." .. btn:GetID(), string.FromColor( color ) )
	self:NetworkColorChange()

end

function PANEL:SetColor( newcol )
	-- TODO: This should mark this colour as selected..
end

function PANEL:OnValueChanged( newcol )
	-- For override
end

function PANEL:OnRightClickButton( btn )
	-- For override
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 160, 256 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DColorPalette", "", PANEL, "DIconLayout" )
