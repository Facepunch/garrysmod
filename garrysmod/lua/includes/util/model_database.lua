--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
--										 
--=============================================================================--

local DatabasedModels = {}

if ( !sql.TableExists( "modelinfo" ) ) then

	sql.Query( [[CREATE TABLE IF NOT EXISTS modelinfo ( name TEXT NOT NULL PRIMARY KEY, 
														poseparams INTEGER,
														numsequences INTEGER,
														numattachments INTEGER,
														numbonecontrollers INTEGER,
														numskins INTEGER,
														size INTEGER );]] )
	
end

--[[---------------------------------------------------------
    Called from the engine on model load to enable Lua to cache
	the model stats in a database, so that rather than building
	all in one go, they'll get updated as the player plays.
-----------------------------------------------------------]]
function OnModelLoaded( ModelName, NumPoseParams, NumSeq, NumAttachments, NumBoneControllers, NumSkins, Size )

	local ModelName = string.lower( string.gsub( ModelName, "\\", "/" ) )
	ModelName = "models/".. ModelName

	-- No need to store a model more than once per session
	if ( DatabasedModels[ ModelName ] ) then return end
	DatabasedModels[ ModelName ] = true
	
	-- Just in case. Don't want errors spewing all over 
	--  the place every time a model loads.
	if ( !sql.TableExists( "modelinfo" ) ) then return end
	
	local safeModelName = SQLStr( ModelName )
	
	--
	-- We delete the old entry because this model may have been updated.
	-- The chances are very slim, but there's no real harm in it.
	--
	sql.Query( "DELETE FROM modelinfo WHERE model = "..safeModelName )
	sql.Query( Format( [[INSERT INTO modelinfo ( name, 
												poseparams, 
												numsequences, 
												numattachments, 
												numbonecontrollers, 
												numskins, 
												size ) 
								
												VALUES 
							
												( %s, %i, %i, %i, %i, %i, %i ) ]], 
							
												safeModelName,
												NumPoseParams,
												NumSeq, 
												NumAttachments,
												NumBoneControllers, 
												NumSkins,
												Size							
												) )
	--[[
	MsgN( ModelName, 
		"\nNumPoseParams: ", NumPoseParams,
		"\nNumSeq: ", NumSeq, 
		"\nNumAttachments: ", NumAttachments, 
		"\nNumBoneControllers: ", NumBoneControllers, 
		"\nNumSkins: ", NumSkins, 
		"\nSize: ", Size )
	--]]

end

--[[---------------------------------------------------------
    Returns the number of skins this model has. If we don't
	know, it will return 0
-----------------------------------------------------------]]
function NumModelSkins( ModelName )

	local ModelName = string.lower( ModelName )
	local safeModelName = SQLStr( ModelName )
	local num = sql.QueryValue( "SELECT numskins FROM modelinfo WHERE name = " .. safeModelName )
	if ( num == nil ) then return 0 end
	
	return tonumber( num ) or 0

end
