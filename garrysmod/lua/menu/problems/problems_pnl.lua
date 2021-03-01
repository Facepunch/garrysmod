
include( "problem_lua.lua" )

local PANEL = {}

function PANEL:Init()

	self:SetSize( ScrW(), ScrH() )
	self:MakePopup()

	self.ErrorPanels = {}

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

	-- Lua errors
	local luaErrorList = ProblemsFrame:Add( "DScrollPanel" )
	sheet:AddSheet( "Lua Errors", luaErrorList, "icon16/error.png" )
	self.LuaErrorList = luaErrorList

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
		self.NoErrorsLabel = self:AddEmptyWarning( "No Lua Errors reported so far", self.LuaErrorList )
	end

end

function PANEL:ReceivedError( uid, err )

	if ( IsValid( self.NoErrorsLabel ) ) then self.NoErrorsLabel:Remove() end

	-- Can't be just one of these
	-- TODO: 2 floating addons with the same name will have the same ID of 0
	local groupID = err.title .. "-" .. err.addonid

	local pnl = self.ErrorPanels[ groupID ]
	if ( !IsValid( pnl ) ) then
		pnl = self.LuaErrorList:Add( "LuaProblemGroup" )
		pnl:SetTitleAndID( err.title, err.addonid )
		self.ErrorPanels[ groupID ] = pnl

		-- Sort
		local z = 0
		for gid, pnl in SortedPairs( self.ErrorPanels ) do
			pnl:SetZPos( z )
			z = z + 1
		end
		self:InvalidateLayout()
	end

	pnl:ReceivedError( uid, err )

end

vgui.Register( "ProblemsPanel", PANEL, "EditablePanel" )
