
surface.CreateFont( "ContentHeader", {
	font	= "Helvetica",
	size	= 50,
	weight	= 1000
} )

local PANEL = {}

function PANEL:Init()

	self:SetFont( "ContentHeader" )
	self:SetBright( true )
	self:SetExpensiveShadow( 2, Color( 0, 0, 0, 130 ) )

	self:SetSize( 64, 64 )

	self.OwnLine = true
	self:SetAutoStretch( true )

end

function PANEL:PerformLayout()

	self:SizeToContents()

end

function PANEL:SizeToContents()

	local w = self:GetContentSize()

	-- Don't let the text overflow the parent's width
	if ( IsValid( self:GetParent() ) ) then
		w = math.min( w, self:GetParent():GetWide() - 32 )
	end

	-- Add a bit more room so it looks nice as a textbox :)
	-- And make sure it has at least some width
	self:SetSize( math.max( w, 64 ) + 16, 64 )

end

function PANEL:ToTable( bigtable )

	local tab = {}

	tab.type = "header"
	tab.text = self:GetText()

	table.insert( bigtable, tab )

end

function PANEL:Copy()

	local copy = vgui.Create( "ContentHeader", self:GetParent() )
	copy:SetText( self:GetText() )
	copy:CopyBounds( self )

	return copy

end

function PANEL:PaintOver( w, h )

	self:DrawSelections()

end

function PANEL:OnLabelTextChanged( txt )

	hook.Run( "SpawnlistContentChanged" )
	return txt

end

function PANEL:IsEnabled()

	-- This is a hack!
	return !IsValid( self:GetParent() ) || !self:GetParent().GetReadOnly || !self:GetParent():GetReadOnly()

end

function PANEL:DoRightClick()

	local pCanvas = self:GetSelectionCanvas()
	if ( IsValid( pCanvas ) && pCanvas:NumSelectedChildren() > 0 && self:IsSelected() ) then
		return hook.Run( "SpawnlistOpenGenericMenu", pCanvas )
	end

	self:OpenMenu()

end

function PANEL:UpdateColours( skin )

	if ( self:GetHighlight() ) then return self:SetTextStyleColor( skin.Colours.Label.Highlight ) end
	if ( self:GetBright() ) then return self:SetTextStyleColor( skin.Colours.Label.Bright ) end
	if ( self:GetDark() ) then return self:SetTextStyleColor( skin.Colours.Label.Dark ) end

	return self:SetTextStyleColor( skin.Colours.Label.Default )

end

function PANEL:OpenMenu()

	-- Do not allow removal from read only panels
	if ( IsValid( self:GetParent() ) && self:GetParent().GetReadOnly && self:GetParent():GetReadOnly() ) then return end

	local menu = DermaMenu()
	menu:AddOption( "#spawnmenu.menu.delete", function() self:Remove() hook.Run( "SpawnlistContentChanged" ) end ):SetIcon( "icon16/bin_closed.png" )
	menu:Open()

end

vgui.Register( "ContentHeader", PANEL, "DLabelEditable" )

spawnmenu.AddContentType( "header", function( container, obj )

	if ( !obj.text || !isstring( obj.text ) ) then return end

	local label = vgui.Create( "ContentHeader", container )
	label:SetText( obj.text )

	container:Add( label )

	return label

end )
