
gmsave = {}

if ( CLIENT ) then

	hook.Add( "LoadGModSaveFailed", "LoadGModSaveFailed", function( str )
		Derma_Message( str, "Failed to load save!", "OK" )
	end )

	return

end

include( "gmsave/entity_filters.lua" )
include( "gmsave/player.lua" )

local g_WavSound = 1

function gmsave.LoadMap( strMapContents, ply )

	-- TODO: Do this in engine before sending it to this function.

	-- Strip off any crap before the start char..
	local startchar = string.find( strMapContents, '' )
	if ( startchar != nil ) then
		strMapContents = string.sub( strMapContents, startchar )
	end

	-- Stip off any crap after the end char..
	strMapContents = strMapContents:reverse()
	local startchar = string.find( strMapContents, '' )
	if ( startchar != nil ) then
		strMapContents = string.sub( strMapContents, startchar )
	end
	strMapContents = strMapContents:reverse()

	-- END TODO

	local tab = util.JSONToTable( strMapContents )

	if ( !istable( tab ) ) then
		-- Error loading save!
		MsgN( "gm_load: Couldn't decode from json!" )
		return false
	end

	game.CleanUpMap()

	if ( IsValid( ply ) ) then

		ply:SendLua( "hook.Run( \"OnSpawnMenuClose\" )" )

		g_WavSound = g_WavSound + 1
		if ( g_WavSound > 4 ) then g_WavSound = 1 end

		ply:SendLua( "surface.PlaySound( \"garrysmod/save_load" .. g_WavSound .. ".wav\" )" )

		gmsave.PlayerLoad( ply, tab.Player )

	end

	timer.Simple( 0.1, function()

		DisablePropCreateEffect = true
		duplicator.RemoveMapCreatedEntities()
		duplicator.Paste( ply, tab.Entities, tab.Constraints )
		DisablePropCreateEffect = nil

		if ( IsValid( ply ) ) then
			gmsave.PlayerLoad( ply, tab.Player )
		end

	end )

end

function gmsave.SaveMap( ply )

	local Ents = ents.GetAll()

	for k, v in pairs( Ents ) do

		if ( !gmsave.ShouldSaveEntity( v, v:GetSaveTable() ) || v:IsConstraint() ) then
			Ents[ k ] = nil
		end

	end

	local tab = duplicator.CopyEnts( Ents )
	if ( !tab ) then return end

	tab.Player = gmsave.PlayerSave( ply )

	return util.TableToJSON( tab )

end
