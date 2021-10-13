
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
		if ( !self.Problem || !self.Problem.fix ) then return end

		self.Problem.fix()
	end

end

function PANEL:PerformLayout( w, h )

	self.Markup = markup.Parse( "<font=DermaDefault>" .. language.GetPhrase( self.Problem.text ) .. "</font>", w - 32 )

	local targetH = 0

	if ( self.Problem ) then
		targetH = targetH + self.Markup:GetHeight() + 5
	end

	local fixW, fixH = self.FixBtn:GetSize()
	self.FixBtn:SetPos( 4, targetH + 5 )
	targetH = targetH + fixH + 10

	local bW, bH = self.CopyBtn:GetSize()
	self.CopyBtn:SetPos( w - bW - 8, targetH / 2 - bH / 2 )

	self:SetTall( targetH )

end

local bgClr = Color( 75, 75, 75, 255 )
function PANEL:Paint( w, h )

	bgClr.a = self:GetAlpha()

	-- No info yet
	if ( !self.Problem ) then
		draw.RoundedBox( 0, 0, 0, w, h, bgClr )
		return
	end

	-- Background color
	local bgClrH = bgClr
	if ( self.Problem.lastOccurence ) then
		local add = 75 + math.max( 25 - ( SysTime() - self.Problem.lastOccurence ) * 25, 0 )
		bgClrH = Color( add, add, add, self:GetAlpha() )
	end

	draw.RoundedBox( 0, 0, 0, w, h, bgClrH )

	-- Draw background
	local count = 0
	if ( self.Problem && self.Problem.count ) then count = self.Problem.count end

	-- The error
	self.Markup:Draw( 5, 5, nil, nil, self:GetAlpha() )

end

function PANEL:Think()
end

function PANEL:Setup( problem )

	self.Problem = problem

	self.Markup = markup.Parse( "<font=DermaDefault>" .. language.GetPhrase( self.Problem.text ) .. "</font>", self:GetWide() - 32 )

	self.FixBtn:SetEnabled( problem.fix != nil )
	self.FixBtn:SetText( problem.fix && "#problems.quick_fix" || "#problems.no_quick_fix" )
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
	surface.DrawTexturedRectRotated( w - 20, 20, 20, 20, self.Collapsed && 180 || 0 )

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
