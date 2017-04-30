
local PANEL = {}

AccessorFunc( PANEL, "m_iOpenSize", "OpenSize" )
AccessorFunc( PANEL, "m_fOpenTime", "OpenTime" )

function PANEL:Init()

	self.m_bOpened = false

	self:SetOpenSize( 100 )
	self:SetOpenTime( 0.3 )
	self:SetPaintBackground( false )
	self:SetSize( 0, 0 )

	self.ToggleButton = vgui.Create( "DButton", self:GetParent() )
	self.ToggleButton:SetSize( 16, 16 )
	self.ToggleButton:SetText( "::" )
	self.ToggleButton.DoClick = function()

		self:Toggle()

	end

	self.ToggleButton.Think = function()

		self.ToggleButton:CenterHorizontal()
		self.ToggleButton.y = self.y - 8

	end

end

function PANEL:OnRemove()

	self.ToggleButton:Remove()

end

function PANEL:Think()

	local w, h = self:GetParent():GetSize()
	self:SetPos( 0, h - self:GetTall() )
	self:SetWide( w )

end

function PANEL:Toggle()

	if ( self.m_bOpened ) then
		self:Close()
	else
		self:Open()
	end

end

function PANEL:Open()

	if ( self.m_bOpened == true ) then return end

	self.m_bOpened = true
	self:SizeTo( self:GetWide(), self.m_iOpenSize, self.m_fOpenTime )
	self.ToggleButton:MoveToFront()

end

function PANEL:Close()

	if ( self.m_bOpened == false ) then return end

	self.m_bOpened = false
	self:SizeTo( self:GetWide(), 0, self.m_fOpenTime )
	self.ToggleButton:MoveToFront()

end

derma.DefineControl( "DDrawer", "", PANEL, "DPanel" )
