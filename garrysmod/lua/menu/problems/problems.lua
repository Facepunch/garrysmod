
include( "problems_pnl.lua" )

local ProblemsPanel
ErrorLog = ErrorLog or {}

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
		ErrorLog[ errorUniqueID ] = {
			text = errorText,
			realm = realm,
			addonid = addonid or "",
			title = addontitle,
			count = 1,
			lastOccurence = SysTime(),
			firstOccurence = SysTime()
		}
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
		print( "Failed to list a Lua error!\n", err)
	end

end )

function OpenProblemsPanel()

	if ( IsValid( ProblemsPanel ) ) then ProblemsPanel:Remove() end

	ProblemsPanel = vgui.Create( "ProblemsPanel" )

	for id, err in pairs( table.Copy( ErrorLog ) ) do
		ProblemsPanel:ReceivedError( id, ErrorLog[ id ] )
	end

end
