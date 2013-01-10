

surface.CreateFont( "ContentHeader",
{
	font		= "Helvetica",
	size		= 50,
	weight		= 1000
})


local PANEL = {}

--[[--------------------------------------------------------
   Name: Init
---------------------------------------------------------]]

function PANEL:Init()

	self:SetFont( "ContentHeader" )
	self:SetBright( true )
	self:SetExpensiveShadow( 2, Color( 0, 0, 0, 130 ) )
	
	self:SetSize( 64, 64 )
	
	self.OwnLine = true

end

function PANEL:PerformLayout()

	self:SizeToContents();
	self:SetTall( 64 );

end

function PANEL:ToTable( bigtable )

	local tab = {}
	
	tab.type	= "header"
	tab.text	= self:GetText();

	table.insert( bigtable, tab )

end

function PANEL:Copy()

	local copy = vgui.Create( "ContentHeader", self:GetParent() )
	copy:SetText( self:GetText() )
	copy:CopyBounds( self )
	
	return copy;

end

function PANEL:PaintOver( w, h )

	self:DrawSelections()

end

vgui.Register( "ContentHeader", PANEL, "DLabelEditable" )


spawnmenu.AddContentType( "header", function( container, obj )

	if ( !obj.text || type(obj.text) != "string" ) then return end

	local label = vgui.Create( "ContentHeader", container )
	label:SetText( obj.text )
	
	container:Add( label )
	
end )