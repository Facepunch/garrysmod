
if ( !debug ) then return end

--[[---------------------------------------------------------
	Name: Trace
	Desc: Dumps a trace to the console..

Trace:
	1: Line 21	"Trace"			includes/extensions/debug.lua
	2: Line 222	"WriteTable"	includes/modules/saverestore.lua
	3: Line 170	"WriteVar"		includes/modules/saverestore.lua
	4: Line 259	"WriteTable"	includes/modules/saverestore.lua
	5: Line 170	"WriteVar"		includes/modules/saverestore.lua
	6: Line 259	"WriteTable"	includes/modules/saverestore.lua
	7: Line 272	"Func"			includes/extensions/entity_networkvars.lua
	8: Line 396	"(null)"		includes/modules/saverestore.lua

	This trace shows that the function was called from the engine (line 8) in save restore.
	Save restore then called something in entity_networkvars for some reason. Then
	that function called WriteTable(6), which called other functions until it got to the trace
	in 1 which was called by WriteTable in saverestore.lua

-----------------------------------------------------------]]
function debug.Trace()

	local level = 1

	Msg( "\nTrace:\n" )

	while true do

		local info = debug.getinfo( level, "Sln" )
		if ( !info ) then break end

		if ( info.what ) == "C" then

			Msg( string.format( "\t%i: C function\t\"%s\"\n", level, info.name ) )

		else

			Msg( string.format( "\t%i: Line %d\t\"%s\"\t\t%s\n", level, info.currentline, info.name, info.short_src ) )

		end

		level = level + 1

	end

	Msg( "\n" )

end
