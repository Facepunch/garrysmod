
local PANEL = {}

function PANEL:Init()

	self:Dock( TOP )
	self:DockMargin( 0, 0, 0, 1 )

	self.CopyBtn = self:Add( "DImageButton" )
	self.CopyBtn:SetImage( "icon16/page_copy.png" )
	self.CopyBtn:SetSize( 16, 16 )
	self.CopyBtn.DoClick = function( btm )
		if ( !self.Problem ) then return end

		SetClipboardText( language.GetPhrase( self.Problem.text ) )
	end

	self.FixBtn = self:Add( "DButton" )
	self.FixBtn.DoClick = function( btm )
		if ( !self.Problem or !self.Problem.fix ) then return end

		self.Problem.fix()
	end

end

local severityWidth = 8
local severityOffset = severityWidth + 4
local textPaddingX = 5
local textPaddingY = 10
local copyIconPad = 8

local severityColors = {}
severityColors[ 0 ] = Color( 217, 217, 217 )
severityColors[ 1 ] = Color( 255, 200, 0 )
severityColors[ 2 ] = Color( 255, 64, 0 )

function PANEL:PerformLayout( w, h )

	self.Markup = markup.Parse( "<font=DermaDefault>" .. language.GetPhrase( self.Problem.text ) .. "</font>", w - self.CopyBtn:GetWide() - copyIconPad * 2 - severityOffset - textPaddingX * 2 )

	local targetH = textPaddingY

	if ( self.Problem ) then
		targetH = targetH + self.Markup:GetHeight() + textPaddingY
	end

	local fixW, fixH = self.FixBtn:GetSize()
	self.FixBtn:SetPos( textPaddingX + severityOffset, targetH )
	targetH = targetH + fixH + textPaddingY

	self:SetTall( targetH )

	local bW, bH = self.CopyBtn:GetSize()
	self.CopyBtn:SetPos( w - bW - copyIconPad, targetH / 2 - bH / 2 )

end

local bgClr = Color( 75, 75, 75, 255 )
function PANEL:Paint( w, h )

	bgClr.a = self:GetAlpha()

	-- No info yet
	if ( !self.Problem ) then
		draw.RoundedBox( 0, 0, 0, w, h, bgClr )
		return
	end

	-- Background
	local bgClrH = bgClr
	if ( self.Problem.lastOccurence ) then
		local add = 75 + math.max( 25 - ( SysTime() - self.Problem.lastOccurence ) * 25, 0 )
		bgClrH = Color( add, add, add, self:GetAlpha() )
	end

	draw.RoundedBox( 0, 0, 0, w, h, bgClrH )

	-- Severity indicator
	local color = severityColors[ self.Problem.severity ]
	if ( color == nil ) then color = severityColors[ 0 ] end
	draw.RoundedBox( 0, 0, 0, severityWidth, h, color )

	-- The error
	self.Markup:Draw( textPaddingX + severityOffset, textPaddingY, nil, nil, self:GetAlpha() )

end

function PANEL:Think()
end

function PANEL:Setup( problem )

	self.Problem = problem

	self.Markup = markup.Parse( "<font=DermaDefault>" .. language.GetPhrase( self.Problem.text ) .. "</font>", self:GetWide() - self.CopyBtn:GetWide() - copyIconPad * 2 - severityOffset - textPaddingX * 2 )

	self.FixBtn:SetEnabled( problem.fix != nil )
	self.FixBtn:SetText( problem.fix and "#problems.quick_fix" or "#problems.no_quick_fix" )
	self.FixBtn:SizeToContentsX( 10 )

end

vgui.Register( "GenericProblem", PANEL, "Panel" )

--[[
	ProblemGroup
]]

local PANEL = {}

local arrowMat = Material( "gui/point.png" )
local collapsedCache = {}

function PANEL:Init()

	self:Dock( TOP )
	self:SetTall( 20 )
	self:DockMargin( 0, 0, 0, 5	)

	self.ProblemPanels = {}

	self.ProblemList = self:Add( "Panel" )

	self.Collapsed = false

end

local white = Color( 255, 255, 255, 255 )
local bg = Color( 50, 50, 50, 255 )
function PANEL:Paint( w, h )

	white.a = self:GetAlpha()
	bg.a = self:GetAlpha()

	draw.RoundedBox( 4, 0, 0, w, h, bg )
	draw.SimpleText( language.GetPhrase( "problem_grp." .. self.Title ), "DermaLarge", 4, 2, white, draw.TEXT_ALIGN_LEFT, draw.TEXT_ALIGN_TOP )

	surface.SetMaterial( arrowMat )
	surface.SetDrawColor( white )
	surface.DrawTexturedRectRotated( w - 20, 20, 20, 20, self.Collapsed and 180 or 0 )

end

function PANEL:OnMousePressed()

	self.Collapsed = !self.Collapsed
	self:InvalidateLayout()

	collapsedCache[ self.Title ] = self.Collapsed

end

function PANEL:SetGroup( groupID )

	self.Title = groupID

end

function PANEL:PerformLayout( w, h )

	self.ProblemList:InvalidateLayout( true )
	self.ProblemList:SizeToChildren( false, true )

	surface.SetFont( "DermaLarge" )
	local _, headerSize = surface.GetTextSize( self.Title )

	self.ProblemList:SetPos( 4, 4 + headerSize )
	self.ProblemList:SetWide( self:GetWide() - 8 )

	if ( self.Collapsed ) then
		self:SetTall( headerSize + 5 )
		return
	end

	self:SetTall( self.ProblemList:GetTall() + ( 8 + headerSize ) )

end

function PANEL:ReceivedProblem( uid, prob )

	local pnl = self.ProblemPanels[ uid ]

	if ( !IsValid( pnl ) ) then
		pnl = self.ProblemList:Add( "GenericProblem" )
		self.ProblemPanels[ uid ] = pnl
		self:InvalidateLayout()
	end

	pnl:Setup( prob )

end

vgui.Register( "GenericProblemGroup", PANEL, "Panel" )
