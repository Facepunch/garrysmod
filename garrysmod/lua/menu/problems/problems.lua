
include( "problems_pnl.lua" )

local ProblemsPanel
local ProblemsCount = 0
local ProblemSeverity = 0
local MenuUpdated = false

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
	ProblemSeverity = math.max( ProblemSeverity, severity or 0 )

	if ( IsValid( pnlMainMenu ) ) then
		pnlMainMenu:SetProblemCount( ProblemsCount, ProblemSeverity )
		MenuUpdated = true
	end

end

local function RecountProblems()

	ProblemsCount = 0
	ProblemSeverity = 0

	for id, err in pairs( ErrorLog ) do
		ProblemsCount = ProblemsCount + 1
		ProblemSeverity = math.max( err.severity or 0, ProblemSeverity )
	end

	for id, prob in pairs( Problems ) do
		ProblemsCount = ProblemsCount + 1
		ProblemSeverity = math.max( prob.severity or 0, ProblemSeverity )
	end

	if ( IsValid( pnlMainMenu ) ) then
		pnlMainMenu:SetProblemCount( ProblemsCount, ProblemSeverity )
		MenuUpdated = true
	end
end

timer.Create( "menu_problem_counter", 1, 0, function()
	if ( MenuUpdated ) then timer.Remove( "menu_problem_counter" ) return end

	RecountProblems()
end )

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

	local probID = prob.id or prob.text

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

	if ( !addontitle or addontitle == "" ) then addontitle = "Other" end

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
function FireProblemFromEngine( id, severity, params )
	if ( id == "menu_cleanupgmas" ) then
		local text = language.GetPhrase( "problem." .. id ) .. "\n\n" .. params:Replace( ";", "\n" )
		FireProblem( { id = id, text = text, severity = severity, type = "addons", fix = function() RunConsoleCommand( "menu_cleanupgmas" ) ClearProblem( id ) end } )
	elseif ( id == "readonly_file" ) then
		local text = params
		FireProblem( { id = id .. params, text = text, severity = severity, type = "config" } )
	else
		-- missing_addon_file
		-- addon_download_failed = title;reason
		local text = language.GetPhrase( "problem." .. id )
		text = text:format( unpack( string.Explode( ";", params ) ) )

		FireProblem( { id = id .. params, text = text, severity = severity, type = "addons" } )
	end
end

timer.Create( "menu_check_for_problems", 1, 0, function()

	if ( math.floor( GetConVarNumber( "mat_hdr_level" ) ) != 2 ) then
		FireProblem( { id = "mat_hdr_level", text = "#problem.mat_hdr_level", type = "config", fix = function() RunConsoleCommand( "mat_hdr_level", "2" ) end, severity = 1 } )
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
		FireProblem( { id = "voice_fadeouttime", text = "#problem.voice_fadeouttime", type = "config", fix = function() RunConsoleCommand( "voice_fadeouttime", "0.1" ) ClearProblem( "voice_fadeouttime" ) end } )
	else
		ClearProblem( "voice_fadeouttime" )
	end

	if ( GetConVarNumber( "mat_viewportscale" ) < 0.1 ) then
		FireProblem( { id = "mat_viewportscale", text = "#problem.mat_viewportscale", type = "config", fix = function() RunConsoleCommand( "mat_viewportscale", "1" ) ClearProblem( "mat_viewportscale" ) end } )
	else
		ClearProblem( "mat_viewportscale" )
	end

	if ( ScrW() < 1000 or ScrH() < 700 ) then
		FireProblem( { id = "screen_res", text = "#problem.screen_res", type = "config" } )
	else
		ClearProblem( "screen_res" )
	end

	-- These are not saved, but still affect gameplay
	if ( GetConVarNumber( "cl_forwardspeed" ) != 10000 or GetConVarNumber( "cl_sidespeed" ) != 10000 or GetConVarNumber( "cl_backspeed" ) != 10000 ) then
		FireProblem( { id = "cl_speeds", text = "#problem.cl_speeds", type = "config", fix = function()
			RunConsoleCommand( "cl_forwardspeed", "10000" )
			RunConsoleCommand( "cl_sidespeed", "10000" )
			RunConsoleCommand( "cl_backspeed", "10000" )
		end } )
	else
		ClearProblem( "cl_speeds" )
	end

	if ( render.GetDXLevel() != 95 and render.GetDXLevel() != 90 ) then
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



local AddonConflicts = {}

hook.Add( "OnNotifyAddonConflict", "AddonConflictNotification", function( addon1, addon2, fileName )

	local id  = addon1 .. "vs" .. addon2
	local id1 = addon2 .. "vs" .. addon1
	if ( AddonConflicts[ id1 ] ) then id = id1 end

	if ( AddonConflicts[ id ] == nil ) then
		AddonConflicts[ id ] = {
			addon1 = addon1,
			addon2 = addon2,
			files = {}
		}

		steamworks.FileInfo( addon1, function( result )

			if ( !result ) then return end

			AddonConflicts[ id ].addon1 = result.title
			RefreshAddonConflicts()

		end )

		steamworks.FileInfo( addon2, function( result )

			if ( !result ) then return end

			AddonConflicts[ id ].addon2 = result.title
			RefreshAddonConflicts()

		end )

	end

	AddonConflicts[ id ].files[ fileName ] = true

	RefreshAddonConflicts()

end )

function RefreshAddonConflicts()
	timer.Create( "addon_conflicts", 1, 1, FireAddonConflicts )
end

function FireAddonConflicts()

	for id, tbl in pairs( AddonConflicts ) do

		local files = ""
		for file, _ in pairs( tbl.files ) do
			files = files .. file .. "\n"
		end

		local text = language.GetPhrase( "problem.addon_conflict" )
		text = text:format( "<color=255,128,0>" .. tbl.addon1 .. "</color>", "<color=255,128,0>" .. tbl.addon2 .. "</color>", files )

		FireProblem( {
			id = id,
			type = "addons",
			severity = 0,
			text = text
		} )

	end

end
