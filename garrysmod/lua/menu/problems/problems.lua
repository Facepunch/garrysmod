
include( "problems_pnl.lua" )

local ProblemsPanel
local ProblemsCount = 0
local ProblemSeverity = 0
Problems = Problems or {}
ErrorLog = ErrorLog or {}

local function RefreshGenericProblemList()
	if ( IsValid( ProblemsPanel ) ) then
		ProblemsPanel.ProblemsList:Clear()
		ProblemsPanel.ProblemPanels = {}
		for id, prob in pairs( Problems ) do
			ProblemsPanel:ReceivedProblem( id, prob )
		end
		ProblemsPanel:InvalidateLayout()
	end
end

local function RefreshLuaErrorList()
	if ( IsValid( ProblemsPanel ) ) then
		ProblemsPanel.LuaErrorList:Clear()
		ProblemsPanel.ErrorPanels = {}
		for id, err in pairs( ErrorLog ) do
			ProblemsPanel:ReceivedError( id, err )
		end
		ProblemsPanel:InvalidateLayout()
	end
end

local function CountProblem( severity )

	ProblemsCount = ProblemsCount + 1
	ProblemSeverity = math.max( ProblemSeverity, severity || 0 )

	if ( IsValid( pnlMainMenu ) ) then
		pnlMainMenu:Call( "SetProblemCount(" .. ProblemsCount .. ", " .. tostring( ProblemSeverity > 0 ) .. ")" )
	end

end

local function RecountProblems()

	ProblemsCount = 0
	ProblemSeverity = 0

	for id, err in pairs( ErrorLog ) do
		ProblemsCount = ProblemsCount + 1
		ProblemSeverity = math.max( err.severity || 0, ProblemSeverity )
	end

	for id, prob in pairs( Problems ) do
		ProblemsCount = ProblemsCount + 1
		ProblemSeverity = math.max( prob.severity || 0, ProblemSeverity )
	end

	if ( IsValid( pnlMainMenu ) ) then
		pnlMainMenu:Call( "SetProblemCount(" .. ProblemsCount .. ", " .. tostring( ProblemSeverity > 0 ) .. ")" )
	end

end

function ClearLuaErrorGroup( group_id )

	-- pairs should guard us against changing the array we are looping through
	for id, err in pairs( ErrorLog ) do
		if ( err.type == group_id ) then
			ErrorLog[ id ] = nil
		end
	end

	RecountProblems()

	RefreshLuaErrorList()

end

function ClearProblem( id )

	if ( !Problems[ id ] ) then return end

	Problems[ id ] = nil

	RecountProblems()

	RefreshGenericProblemList()

end

function FireProblem( prob )

	local probID = prob.id || prob.text

	if ( !Problems[ probID ] ) then
		CountProblem( prob.severity )
	end

	Problems[ probID ] = prob
	if ( IsValid( ProblemsPanel ) ) then ProblemsPanel:ReceivedProblem( probID, prob ) end

end

local function FireError( str, realm, stack, addontitle, addonid )

	-- Reconstruct the stack trace
	local errorText = str
	errorText = string.Replace( errorText, "\t", ( " " ):rep( 12 ) ) -- Ew

	for i, t in pairs( stack ) do
		if ( !t.Function or t.Function == "" ) then t.Function = "unknown" end

		errorText = errorText .. "\n" .. ("    "):rep( i ) .. i .. ". " .. t.Function .. " - " .. t.File .. ":" .. t.Line
	end

	local errorUniqueID = errorText .. realm

	if ( !addontitle || addontitle == "" ) then addontitle = "Other" end

	if ( !ErrorLog[ errorUniqueID ] ) then
		local newErr = {
			text = errorText,
			realm = realm,
			addonid = addonid or "",
			title = addontitle,
			count = 1,
			severity = 1,
			lastOccurence = SysTime(),
			firstOccurence = SysTime()
		}
		newErr.type = newErr.title .. "-" .. newErr.addonid

		CountProblem( newErr.severity )
		ErrorLog[ errorUniqueID ] = newErr
	else
		ErrorLog[ errorUniqueID ].count = ErrorLog[ errorUniqueID ].count + 1
		ErrorLog[ errorUniqueID ].lastOccurence = SysTime()
	end

	if ( IsValid( ProblemsPanel ) ) then ProblemsPanel:ReceivedError( errorUniqueID, ErrorLog[ errorUniqueID ] ) end

end

hook.Add( "OnLuaError", "MenuErrorLogger", function( str, realm, stack, addontitle, addonid )

	local good, err = pcall( function()
		FireError( str, realm, stack, addontitle, addonid )
	end )

	if ( !good ) then
		print( "Failed to log a Lua error!\n", err)
	end

end )

function OpenProblemsPanel()

	if ( IsValid( ProblemsPanel ) ) then ProblemsPanel:Remove() end

	ProblemsPanel = vgui.Create( "ProblemsPanel" )

	local anyErrors = false
	for id, err in pairs( table.Copy( ErrorLog ) ) do
		ProblemsPanel:ReceivedError( id, err )
		anyErrors = true
	end

	for id, prob in pairs( Problems ) do
		ProblemsPanel:ReceivedProblem( id, prob )
	end

	if ( !anyErrors ) then
		ProblemsPanel.Tabs:SwitchToName( "#problems.problems" )
	end

end

-- Called from the engine to notify the player about a problem in a more user friendly way compared to a console message
function FireProblemFromEngine( id )
	if ( id == "menu_cleanupgmas" ) then
		FireProblem( { id = id, text = "#problem." .. id, type = "addons", fix = function() RunConsoleCommand( "menu_cleanupgmas" ) ClearProblem( id ) end } )
	else
		-- missing_addon_file
		FireProblem( { id = id, text = "#problem." .. id, type = "addons" } )
	end
end

timer.Create( "menu_check_for_problems", 1, 0, function()

	if ( math.floor( GetConVarNumber( "mat_hdr_level" ) ) != 2 ) then
		FireProblem( { id = "mat_hdr_level", text = "#problem.mat_hdr_level", type = "config", fix = function() RunConsoleCommand( "mat_hdr_level", "2" ) end } )
	else
		ClearProblem( "mat_hdr_level" )
	end

	if ( math.floor( math.abs( GetConVarNumber( "mat_bumpmap" ) ) ) == 0 ) then
		FireProblem( { id = "mat_bumpmap", text = "#problem.mat_bumpmap", type = "config", fix = function() RunConsoleCommand( "mat_bumpmap", "1" ) end } )
	else
		ClearProblem( "mat_bumpmap" )
	end

	if ( math.floor( math.abs( GetConVarNumber( "mat_specular" ) ) ) == 0 ) then
		FireProblem( { id = "mat_specular", text = "#problem.mat_specular", type = "config", fix = function() RunConsoleCommand( "mat_specular", "1" ) end } )
	else
		ClearProblem( "mat_specular" )
	end

	if ( math.floor( math.abs( GetConVarNumber( "gmod_mcore_test" ) ) ) != 0 ) then
		FireProblem( { id = "gmod_mcore_test", text = "#problem.gmod_mcore_test", type = "config" } )
	else
		ClearProblem( "gmod_mcore_test" )
	end

	if ( math.abs( GetConVarNumber( "voice_fadeouttime" ) - 0.1 ) > 0.001 ) then
		FireProblem( { id = "voice_fadeouttime", text = "#problem.voice_fadeouttime", type = "config", fix = function() RunConsoleCommand( "voice_fadeouttime", "0.1" ) end } )
	else
		ClearProblem( "voice_fadeouttime" )
	end

	if ( ScrW() < 1000 || ScrH() < 700 ) then
		FireProblem( { id = "screen_res", text = "#problem.screen_res", type = "config" } )
	else
		ClearProblem( "screen_res" )
	end

	-- These are not saved, but still affect gameplay
	if ( GetConVarNumber( "cl_forwardspeed" ) != 10000 || GetConVarNumber( "cl_sidespeed" ) != 10000 || GetConVarNumber( "cl_backspeed" ) != 10000 ) then
		FireProblem( { id = "cl_speeds", text = "#problem.cl_speeds", type = "config", fix = function()
			RunConsoleCommand( "cl_forwardspeed", "10000" )
			RunConsoleCommand( "cl_sidespeed", "10000" )
			RunConsoleCommand( "cl_backspeed", "10000" )
		end } )
	else
		ClearProblem( "cl_speeds" )
	end

	if ( render.GetDXLevel() != 95 && render.GetDXLevel() != 90 ) then
		FireProblem( { id = "mat_dxlevel", text = language.GetPhrase( "problem.mat_dxlevel" ):format( render.GetDXLevel() ), type = "config" } )
	else
		ClearProblem( "mat_dxlevel" )
	end

end )

-- Problems that we only need to check on startup
if ( !render.SupportsHDR() ) then FireProblem( { text = "#problem.no_hdr", type = "hardware" } ) end
if ( !render.SupportsPixelShaders_1_4() ) then FireProblem( { text = "#problem.no_ps14", type = "hardware" } ) end
if ( !render.SupportsPixelShaders_2_0() ) then FireProblem( { text = "#problem.no_ps20", type = "hardware" } ) end
if ( !render.SupportsVertexShaders_2_0() ) then FireProblem( { text = "#problem.no_vs20", type = "hardware" } ) end
