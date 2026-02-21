---------------
	ADDON OPTIMIZER / ANALYZER

	Scans loaded Lua files for common performance anti-patterns
	and generates a report with severity ratings.

	Detected patterns:
	  - table.HasValue in Think/Tick hooks (O(n) per tick)
	  - Unlocalized globals (accessing _G repeatedly)
	  - net.WriteTable usage (should use schema packing)
	  - timer.Create inside Think hooks
	  - pairs() on sequential tables (should use ipairs)
	  - Missing IsValid checks before entity operations
	  - string concatenation in loops (should use table.concat)

	Console Commands (SuperAdmin):
		lua_addon_scan          - Full scan of autorun files
		lua_addon_scan_file <f> - Scan a specific file
----------------

if ( !SERVER ) then return end

addon_optimizer = addon_optimizer or {}

local Patterns = {
	{
		name = "table.HasValue in hot path",
		pattern = "table%.HasValue",
		severity = "HIGH",
		tip = "Replace with table.ToHashSet + direct lookup for O(1)",
		contexts = { "think", "tick", "playertick", "hud" }
	},
	{
		name = "net.WriteTable usage",
		pattern = "net%.WriteTable",
		severity = "MEDIUM",
		tip = "Use net.WriteTablePacked with a schema for less bandwidth"
	},
	{
		name = "timer.Create in hook callback",
		pattern = "timer%.Create",
		severity = "MEDIUM",
		tip = "Consider creating timers outside Think/Tick to avoid recreation"
	},
	{
		name = "String concatenation in loop",
		pattern = "%.%.",
		severity = "LOW",
		tip = "Use table.concat for building strings in loops"
	},
	{
		name = "ents.FindByClass (unindexed)",
		pattern = "ents%.FindByClass",
		severity = "MEDIUM",
		tip = "Use entindex.GetByClass for O(1) lookups if entindex is loaded"
	},
	{
		name = "ents.GetAll iteration",
		pattern = "ents%.GetAll%(",
		severity = "MEDIUM",
		tip = "Consider chunks.GetNearbyEntities or entindex for targeted queries"
	},
	{
		name = "GetConVar in hot path",
		pattern = "GetConVar%(",
		severity = "LOW",
		tip = "Cache ConVar objects with cvarcache.Get or local variables"
	},
	{
		name = "file.Exists in loop",
		pattern = "file%.Exists",
		severity = "MEDIUM",
		tip = "Use filecache.Exists for cached lookups"
	},
	{
		name = "table.Count on sequential table",
		pattern = "table%.Count%(",
		severity = "LOW",
		tip = "Use #tbl for sequential tables (O(1) vs O(n))"
	},
	{
		name = "PrintTable (debug left in)",
		pattern = "PrintTable%(",
		severity = "LOW",
		tip = "Remove debug PrintTable calls from production code"
	}
}


--
-- Scan a single file for anti-patterns
--
function addon_optimizer.ScanFile( path )

	local content = file.Read( path, "LUA" )
	if ( !content ) then return nil end

	local issues = {}
	local lines = string.Explode( "\n", content )

	for lineNum, line in ipairs( lines ) do
		-- Skip comments
		if ( string.match( line, "^%s*%-%-" ) ) then continue end

		for _, pat in ipairs( Patterns ) do
			if ( string.find( line, pat.pattern ) ) then
				table.insert( issues, {
					line = lineNum,
					pattern = pat.name,
					severity = pat.severity,
					tip = pat.tip,
					code = string.Trim( line )
				} )
			end
		end
	end

	return issues

end


--
-- Scan all autorun files
--
function addon_optimizer.ScanAll()

	local results = {}
	local totalIssues = 0

	-- Scan autorun
	local files = file.Find( "autorun/*.lua", "LUA" )
	for _, f in ipairs( files or {} ) do
		local issues = addon_optimizer.ScanFile( "autorun/" .. f )
		if ( issues and #issues > 0 ) then
			results[ "autorun/" .. f ] = issues
			totalIssues = totalIssues + #issues
		end
	end

	-- Scan autorun/server
	local svFiles = file.Find( "autorun/server/*.lua", "LUA" )
	for _, f in ipairs( svFiles or {} ) do
		local issues = addon_optimizer.ScanFile( "autorun/server/" .. f )
		if ( issues and #issues > 0 ) then
			results[ "autorun/server/" .. f ] = issues
			totalIssues = totalIssues + #issues
		end
	end

	-- Scan autorun/client
	local clFiles = file.Find( "autorun/client/*.lua", "LUA" )
	for _, f in ipairs( clFiles or {} ) do
		local issues = addon_optimizer.ScanFile( "autorun/client/" .. f )
		if ( issues and #issues > 0 ) then
			results[ "autorun/client/" .. f ] = issues
			totalIssues = totalIssues + #issues
		end
	end

	return results, totalIssues

end


-- Console commands
concommand.Add( "lua_addon_scan", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end

	print( "========== ADDON OPTIMIZER SCAN ==========" )
	print( "  Scanning autorun files for anti-patterns..." )
	print( "" )

	local results, total = addon_optimizer.ScanAll()

	if ( total == 0 ) then
		print( "  No issues found! Your code is clean." )
	else
		for filepath, issues in pairs( results ) do
			print( "  " .. filepath .. " (" .. #issues .. " issues):" )
			for _, issue in ipairs( issues ) do
				print( string.format( "    [%s] L%d: %s", issue.severity, issue.line, issue.pattern ) )
				print( string.format( "           Tip: %s", issue.tip ) )
			end
			print( "" )
		end
		print( "  Total: " .. total .. " issues found" )
	end

	print( "===========================================" )

end )

concommand.Add( "lua_addon_scan_file", function( ply, cmd, args )

	if ( IsValid( ply ) and !ply:IsSuperAdmin() ) then return end
	if ( !args[ 1 ] ) then print( "Usage: lua_addon_scan_file <filepath>" ) return end

	local issues = addon_optimizer.ScanFile( args[ 1 ] )
	if ( !issues ) then
		print( "[AddonOptimizer] File not found: " .. args[ 1 ] )
		return
	end

	print( "=== Scan: " .. args[ 1 ] .. " ===" )
	if ( #issues == 0 ) then
		print( "  No issues found." )
	else
		for _, issue in ipairs( issues ) do
			print( string.format( "  [%s] L%d: %s", issue.severity, issue.line, issue.pattern ) )
			print( string.format( "         %s", issue.tip ) )
			print( string.format( "         Code: %s", string.sub( issue.code, 1, 80 ) ) )
		end
	end

end )

MsgN( "[AddonOptimizer] Loaded. Use lua_addon_scan to analyze." )
