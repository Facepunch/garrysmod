
local KP_ENTER = 11
local KP_PERIOD = 10
local KP_PLUS = 12
local KP_MINUS = 13
local KP_STAR = 14
local KP_DIV = 15

local PANEL = {}

AccessorFunc( PANEL, "m_SelectedButton",	"Selected" )
AccessorFunc( PANEL, "m_iSelectedNumber",	"SelectedNumber" )
AccessorFunc( PANEL, "m_iPadding",			"Padding" )
AccessorFunc( PANEL, "m_bButtonSize",		"ButtonSize" )
AccessorFunc( PANEL, "m_bStickyKeys",		"StickyKeys" ) -- Should keys stay selected when pressed? (like the spawn menu)

Derma_Install_Convar_Functions( PANEL )

function PANEL:Init()

	self.Buttons = {}

	for i = 0, 15 do
		self.Buttons[ i ] = vgui.Create( "DButton", self )
		self.Buttons[ i ]:SetText( i )
		self.Buttons[ i ].DoClick = function( btn ) self:ButtonPressed( btn, i ) end
	end

	self.Buttons[KP_ENTER]:SetText( "" )
	self.Buttons[KP_PERIOD]:SetText( "." )
	self.Buttons[KP_PLUS]:SetText( "+" )
	self.Buttons[KP_MINUS]:SetText( "-" )
	self.Buttons[KP_STAR]:SetText( "*" )
	self.Buttons[KP_DIV]:SetText( "/" )

	self.Buttons[0]:SetContentAlignment( 4 )
	self.Buttons[0]:SetTextInset( 6, 0 )

	self:SetStickyKeys( true )
	self:SetButtonSize( 17 )
	self:SetPadding( 4 )

	self:SetSelectedNumber( -1 )

end

function PANEL:ButtonPressed( btn, iNum )

	-- Toggle off
	if ( self.m_bStickyKeys && self.m_SelectedButton && self.m_SelectedButton == btn ) then
		self.m_SelectedButton:SetSelected( false )
		self:SetSelected( -1 )

		return
	end

	self:SetSelected( iNum )
	self:OnButtonPressed( iNum, btn )

end

function PANEL:SetSelected( iNum )

	local btn = self.Buttons[ iNum ]

	self:SetSelectedNumber( iNum )

	self:ConVarChanged( iNum )

	if ( self.m_SelectedButton ) then
		self.m_SelectedButton:SetSelected( false )
	end

	self.m_SelectedButton = btn

	if ( btn && self.m_bStickyKeys ) then

		btn:SetSelected( true )

	end

end

function PANEL:OnButtonPressed( iButtonNumber, pButton )

	-- Override this.

end

function PANEL:PerformLayout()

	local ButtonSize = self:GetButtonSize()
	local Padding = self:GetPadding()

	self:SetSize( ButtonSize * 4 + Padding * 2, ButtonSize * 5 + Padding * 2 )

	self.Buttons[ 0 ]:SetSize( ButtonSize * 2, ButtonSize )
	self.Buttons[ 0 ]:AlignBottom( Padding )
	self.Buttons[ 0 ]:AlignLeft( Padding )

	self.Buttons[KP_PERIOD]:CopyBounds( self.Buttons[0] )
	self.Buttons[KP_PERIOD]:SetSize( ButtonSize, ButtonSize )
	self.Buttons[KP_PERIOD]:MoveRightOf( self.Buttons[0] )

	self.Buttons[1]:SetSize( ButtonSize, ButtonSize )
	self.Buttons[1]:AlignLeft( Padding )
	self.Buttons[1]:MoveAbove( self.Buttons[ 0 ] )

	self.Buttons[2]:CopyBounds( self.Buttons[1] )
	self.Buttons[2]:MoveRightOf( self.Buttons[1] )

	self.Buttons[3]:CopyBounds( self.Buttons[2] )
	self.Buttons[3]:MoveRightOf( self.Buttons[2] )

	self.Buttons[KP_ENTER]:SetSize( ButtonSize, ButtonSize * 2 )
	self.Buttons[KP_ENTER]:AlignBottom( Padding )
	self.Buttons[KP_ENTER]:AlignRight( Padding )

	self.Buttons[KP_PLUS]:CopyBounds( self.Buttons[KP_ENTER] )
	self.Buttons[KP_PLUS]:MoveAbove( self.Buttons[KP_ENTER] )

	self.Buttons[KP_MINUS]:CopyBounds( self.Buttons[KP_PLUS] )
	self.Buttons[KP_MINUS]:SetSize( ButtonSize, ButtonSize )
	self.Buttons[KP_MINUS]:MoveAbove( self.Buttons[KP_PLUS] )

	self.Buttons[KP_STAR]:CopyBounds( self.Buttons[KP_MINUS] )
	self.Buttons[KP_STAR]:MoveLeftOf( self.Buttons[KP_MINUS] )

	self.Buttons[KP_DIV]:CopyBounds( self.Buttons[KP_STAR] )
	self.Buttons[KP_DIV]:MoveLeftOf( self.Buttons[KP_STAR] )

	self.Buttons[4]:CopyBounds( self.Buttons[1] )
	self.Buttons[4]:MoveAbove( self.Buttons[1] )

	self.Buttons[5]:CopyBounds( self.Buttons[4] )
	self.Buttons[5]:MoveRightOf( self.Buttons[4] )

	self.Buttons[6]:CopyBounds( self.Buttons[5] )
	self.Buttons[6]:MoveRightOf( self.Buttons[5] )

	self.Buttons[7]:CopyBounds( self.Buttons[4] )
	self.Buttons[7]:MoveAbove( self.Buttons[4] )

	self.Buttons[8]:CopyBounds( self.Buttons[7] )
	self.Buttons[8]:MoveRightOf( self.Buttons[7] )

	self.Buttons[9]:CopyBounds( self.Buttons[8] )
	self.Buttons[9]:MoveRightOf( self.Buttons[8] )

end

function PANEL:Think()

	self:ConVarNumberThink()

end

function PANEL:SetValue( iNumValue )

	self:SetSelected( iNumValue )

end

function PANEL:GetValue()

	return self:GetSelectedNumber()

end

derma.DefineControl( "DNumPad", "", PANEL, "DPanel" )
