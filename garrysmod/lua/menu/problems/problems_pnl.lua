
include( "problem_lua.lua" )
include( "problem_generic.lua" )
include( "permissions.lua" )

local PANEL = {}

function PANEL:Init()

	self:SetSize( ScrW(), ScrH() )
	self:MakePopup()

	self.ErrorPanels = {}
	self.ProblemPanels = {}

	local ProblemsFrame = vgui.Create( "DFrame", self )
	ProblemsFrame:SetSize( ScrW() * 0.75, ScrH() * 0.75 )
	ProblemsFrame:Center()
	ProblemsFrame:SetTitle( "" )
	ProblemsFrame:SetDraggable( false )
	ProblemsFrame:SetBackgroundBlur( true )
	ProblemsFrame.OnRemove = function( frm ) self:Remove() end
	ProblemsFrame.Paint = function( frm ) end
	ProblemsFrame:DockPadding( 5, 3, 5, 0 )

	local sheet = vgui.Create( "DPropertySheet", ProblemsFrame )
	sheet:Dock( FILL )
	self.Tabs = sheet

	-- Lua errors
	local luaErrorList = ProblemsFrame:Add( "DScrollPanel" )
	sheet:AddSheet( "#problems.lua_errors", luaErrorList, "icon16/error.png" )
	self.LuaErrorList = luaErrorList

	-- Generic problems
	local problemsList = ProblemsFrame:Add( "DScrollPanel" )
	sheet:AddSheet( "#problems.problems", problemsList, "icon16/tick.png" )
	self.ProblemsList = problemsList

	-- Permissions
	local permissionList = ProblemsFrame:Add( "PermissionViewer" )
	permissionList.ParentFrame = self
	sheet:AddSheet( "#permissions.title", permissionList, "icon16/lock.png" )

	ProblemsFrame.btnClose:MoveToFront()
	ProblemsFrame.btnMaxim:MoveToFront()
	ProblemsFrame.btnMinim:MoveToFront()

end

function PANEL:AddEmptyWarning( txt, parent )

	local lab = parent:Add( "DLabel" )
	lab:SetText( txt )
	lab:SetBright( true )
	lab:SetFont( "DermaLarge" )
	lab:SetContentAlignment( 5 )
	lab:Dock( FILL )

	-- Horrible hack
	lab.Paint = function( s, w, h )
		s:SetTall( parent:GetTall() )
	end

	return lab

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 240 ) )

end

function PANEL:PerformLayout()

	if ( self.LuaErrorList:GetCanvas():ChildCount() < 1 ) then
		self.NoErrorsLabel = self:AddEmptyWarning( "#problems.no_lua_errors", self.LuaErrorList )
	end

	if ( self.ProblemsList:GetCanvas():ChildCount() < 1 ) then
		self.NoProblemsLabel = self:AddEmptyWarning( "#problems.no_problems", self.ProblemsList )
	end

end

function PANEL:ReceivedError( uid, err )

	if ( IsValid( self.NoErrorsLabel ) ) then self.NoErrorsLabel:Remove() end

	local groupID = err.type or "Other"
	local pnl = self.ErrorPanels[ groupID ]
	if ( !IsValid( pnl ) ) then
		pnl = self.LuaErrorList:Add( "LuaProblemGroup" )
		pnl:SetTitleAndID( err.title, err.addonid, groupID )
		self.ErrorPanels[ groupID ] = pnl

		-- Sort
		local z = 0
		for gid, epnl in SortedPairs( self.ErrorPanels ) do
			epnl:SetZPos( z )
			z = z + 1
		end
		self:InvalidateLayout()
	end

	pnl:ReceivedError( uid, err )

end

function PANEL:ReceivedProblem( uid, prob )

	if ( IsValid( self.NoProblemsLabel ) ) then self.NoProblemsLabel:Remove() end

	local groupID = prob.type or "other"
	local pnl = self.ProblemPanels[ groupID ]
	if ( !IsValid( pnl ) ) then
		pnl = self.ProblemsList:Add( "GenericProblemGroup" )
		pnl:SetGroup( groupID )
		self.ProblemPanels[ groupID ] = pnl

		self:InvalidateLayout()
	end

	pnl:ReceivedProblem( uid, prob )

end

vgui.Register( "ProblemsPanel", PANEL, "EditablePanel" )
