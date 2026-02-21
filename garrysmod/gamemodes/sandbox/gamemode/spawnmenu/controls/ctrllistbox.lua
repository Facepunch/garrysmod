
local PANEL = {}

function PANEL:Init()

	self.ConVars = {}
	self.Options = {}

end

function PANEL:AddOption( strName, tabConVars )

	self:AddChoice( strName, tabConVars )

	for k, v in pairs( tabConVars ) do
		self.ConVars[ k ] = 1
	end

end

function PANEL:OnSelect( index, value, data )

	for k, v in pairs( data ) do

		RunConsoleCommand( k, tostring( v ) )

	end

end

function PANEL:Think()

	self:CheckConVarChanges()

end

function PANEL:ConVarsChanged()

	for k, v in pairs( self.ConVars ) do

		if ( self[ k ] == nil ) then return true end
		if ( self[ k ] != GetConVarString( k ) ) then return true end

	end

	return false

end

function PANEL:CheckForMatch( cvars )

	if ( table.IsEmpty( cvars ) ) then return false end

	for k, v in pairs( cvars ) do

		if ( tostring(v) != GetConVarString( k ) ) then
			return false
		end

	end

	return true

end

function PANEL:CheckConVarChanges()

	if (!self:ConVarsChanged()) then return end

	for k, v in pairs( self.ConVars ) do
		self[ k ] = GetConVarString( k )
	end

	for k, v in pairs( self.Data ) do

		if ( self:CheckForMatch( v ) ) then
			self:SetText( self:GetOptionText(k) )
			return
		end

	end

end

vgui.Register( "CtrlListBox", PANEL, "DComboBox" )
