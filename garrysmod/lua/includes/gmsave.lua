
gmsave = {}

if ( CLIENT ) then return end

include( "gmsave/entity_filters.lua" )
include( "gmsave/player.lua" )

local g_WavSound = 1

function gmsave.LoadMap( strMapContents, ply, callback )

	-- TODO: Do this in engine before sending it to this function.

	-- Strip off any crap before the start char..
	local startchar = string.find( strMapContents, '' )
	if ( startchar != nil ) then
		strMapContents = string.sub( strMapContents, startchar )
	end

	-- Strip off any crap after the end char..
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

	-- Existing addons are forcing us to do this
	-- The issue is that some addons overwrite game.CleanUpMap
	-- Making the 3rd argument not exist
	hook.Add( "PostCleanupMap", "GMod_Load_Save", function()
		hook.Remove( "PostCleanupMap", "GMod_Load_Save" )

		if ( IsValid( ply ) ) then

			ply:SendLua( "hook.Run( \"OnSpawnMenuClose\" )" )

			g_WavSound = g_WavSound + 1
			if ( g_WavSound > 4 ) then g_WavSound = 1 end

			ply:SendLua( string.format( "surface.PlaySound( \"garrysmod/save_load%d.wav\" )", g_WavSound ) )

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

			-- Since this save system is inferior to Source's, we gotta make sure this entity is disabled on load of a save
			-- On maps like Portal's testchmb_a_00.bsp this entity takes away player control and will not restore it
			-- if the player is not in a very specific place.
			timer.Simple( 1, function()
				for id, ent in ipairs( ents.FindByClass( "point_viewcontrol" ) ) do
					ent:Fire( "Disable" )
				end
			end )

			if ( callback ) then callback() end

		end )
	end )

	game.CleanUpMap( false, nil, function() end )

end

function gmsave.SaveMap( ply )

	local Ents = ents.GetAll()

	for k, v in ipairs( Ents ) do

		if ( !gmsave.ShouldSaveEntity( v, v:GetSaveTable() ) || v:IsConstraint() ) then
			Ents[ k ] = nil
		end

	end

	-- This is to copy the constraints that are applied to the world only (ropes, etc)
	-- It will not actually save and then try to restore the world entity, as that would cause issues
	table.insert( Ents, game.GetWorld() )

	local tab = duplicator.CopyEnts( Ents )
	if ( !tab ) then return end

	tab.Player = gmsave.PlayerSave( ply )

	--
	-- Try to figure out if any of the models/materials/etc came from some addon
	--
	duplicator.FigureOutRequiredAddons( tab )

	return util.TableToJSON( tab )

end
