---------------
	SPAWNMENU ICON PRE-CACHER (Inspired by a local performance addon i've been progressivley working on over last couple months)

	Pre-generates model thumbnails in the background after
	joining a server. Eliminates the stutter when opening
	the Q menu for the first time by warming the icon cache.

	Processes models in small batches per frame to avoid
	any FPS impact during the pre-cache phase.

	ConVars:
		cl_precache 1           - Enable spawnlist pre-caching
		cl_precache_batch 6     - Models to process per frame
		cl_precache_delay 8     - Seconds after spawn before starting

	Console Commands:
		lua_precache_now        - Force start pre-caching
----------------

if ( SERVER ) then return end

CreateClientConVar( "cl_precache", "1", true, false, "Enable spawnlist icon pre-caching" )
CreateClientConVar( "cl_precache_batch", "6", true, false, "Models to pre-cache per frame", 1, 20 )
CreateClientConVar( "cl_precache_delay", "8", true, false, "Seconds after spawn before pre-caching", 1, 30 )

local Queue = {}
local Index = 0
local Total = 0
local Panel = nil
local StartTime = 0
local LastProgress = 0


---------------
	COLLECT MODELS FROM SPAWNLISTS
----------------

local function CollectModels()

	local models = {}
	local seen = {}

	-- Parse spawnlist .txt files
	local spawnlistDir = "settings/spawnlist/"
	local files = file.Find( spawnlistDir .. "*.txt", "MOD" )

	for _, fileName in ipairs( files or {} ) do
		local contents = file.Read( spawnlistDir .. fileName, "MOD" )
		if ( contents ) then
			for model in string.gmatch( contents, '"(models/[^"]+%.mdl)"' ) do
				local lower = string.lower( model )
				if ( !seen[ lower ] ) then
					seen[ lower ] = true
					table.insert( models, model )
				end
			end
		end
	end

	-- Check subdirectories too
	local subFiles = file.Find( spawnlistDir .. "*/*.txt", "MOD" )
	for _, fileName in ipairs( subFiles or {} ) do
		local contents = file.Read( spawnlistDir .. fileName, "MOD" )
		if ( contents ) then
			for model in string.gmatch( contents, '"(models/[^"]+%.mdl)"' ) do
				local lower = string.lower( model )
				if ( !seen[ lower ] ) then
					seen[ lower ] = true
					table.insert( models, model )
				end
			end
		end
	end

	-- Spawnable entities list
	local propList = list.Get( "SpawnableEntities" )
	if ( propList ) then
		for _, data in pairs( propList ) do
			if ( data.SpawnName and string.EndsWith( data.SpawnName, ".mdl" ) ) then
				local lower = string.lower( data.SpawnName )
				if ( !seen[ lower ] ) then
					seen[ lower ] = true
					table.insert( models, data.SpawnName )
				end
			end
		end
	end

	return models

end


---------------
	PRE-CACHE TICK
----------------

local function Cleanup()

	if ( IsValid( Panel ) ) then Panel:Remove() end
	Panel = nil
	hook.Remove( "Think", "SpawnPrecache_Tick" )
	MsgN( "[SpawnPrecache] Complete." )

end

local function PrecacheTick()

	if ( !GetConVar( "cl_precache" ):GetBool() ) then
		Cleanup()
		return
	end

	local batchSize = GetConVar( "cl_precache_batch" ):GetInt()

	for i = 1, batchSize do

		Index = Index + 1

		if ( Index > Total ) then
			local elapsed = math.Round( SysTime() - StartTime, 2 )
			MsgN( "[SpawnPrecache] Done! " .. Total .. " models in " .. elapsed .. "s" )
			Cleanup()
			return
		end

		local model = Queue[ Index ]

		if ( !IsValid( Panel ) ) then
			Panel = vgui.Create( "DPanel" )
			Panel:SetSize( 64, 64 )
			Panel:SetPos( -200, -200 )
			Panel:SetVisible( false )
			Panel:SetMouseInputEnabled( false )
			Panel:SetKeyboardInputEnabled( false )
		end

		local icon = vgui.Create( "ModelImage", Panel )
		if ( IsValid( icon ) ) then
			icon:SetSize( 64, 64 )
			icon:SetModel( model )
			timer.Simple( 0, function()
				if ( IsValid( icon ) ) then icon:Remove() end
			end )
		end

	end

	-- Progress every 10%
	local progress = math.floor( ( Index / Total ) * 100 )
	if ( progress >= LastProgress + 10 ) then
		LastProgress = progress
		MsgN( "[SpawnPrecache] " .. progress .. "% (" .. Index .. "/" .. Total .. ")" )
	end

end


---------------
	INIT
----------------

hook.Add( "InitPostEntity", "SpawnPrecache_Init", function()

	if ( !GetConVar( "cl_precache" ):GetBool() ) then return end

	local delay = GetConVar( "cl_precache_delay" ):GetInt()

	timer.Simple( delay, function()

		if ( !GetConVar( "cl_precache" ):GetBool() ) then return end

		Queue = CollectModels()
		Total = #Queue
		Index = 0
		LastProgress = -1
		StartTime = SysTime()

		if ( Total == 0 ) then
			MsgN( "[SpawnPrecache] No spawnlist models found." )
			return
		end

		MsgN( "[SpawnPrecache] Starting: " .. Total .. " models (" .. GetConVar( "cl_precache_batch" ):GetInt() .. " per frame)" )
		hook.Add( "Think", "SpawnPrecache_Tick", PrecacheTick )

	end )

end )


-- Manual trigger
concommand.Add( "lua_precache_now", function()

	Queue = CollectModels()
	Total = #Queue
	Index = 0
	LastProgress = -1
	StartTime = SysTime()

	if ( Total == 0 ) then
		MsgN( "[SpawnPrecache] No models found." )
		return
	end

	MsgN( "[SpawnPrecache] Manual start: " .. Total .. " models" )
	hook.Add( "Think", "SpawnPrecache_Tick", PrecacheTick )

end )

MsgN( "[SpawnPrecache] Spawnmenu icon pre-cacher loaded." )
