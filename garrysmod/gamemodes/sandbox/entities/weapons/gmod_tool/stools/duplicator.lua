
include( "duplicator/transport.lua" )
include( "duplicator/arming.lua" )

if ( CLIENT ) then

	include( "duplicator/icon.lua" )

else

	AddCSLuaFile( "duplicator/arming.lua" )
	AddCSLuaFile( "duplicator/transport.lua" )
	AddCSLuaFile( "duplicator/icon.lua" )
	util.AddNetworkString( "CopiedDupe" )

end

TOOL.Category = "Construction"
TOOL.Name = "#tool.duplicator.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" }
}

cleanup.Register( "duplicates" )

local function fixupDupePos( pos, ang, ply, mins, maxs )
	local endposD = LocalToWorld( mins, Angle( 0, 0, 0 ), pos, ang )
	local tr_down = util.TraceLine( {
		start = pos,
		endpos = endposD,
		filter = ply
	} )

	local endposU = LocalToWorld( maxs, Angle( 0, 0, 0 ), pos, ang )
	local tr_up = util.TraceLine( {
		start = pos,
		endpos = endposU,
		filter = ply
	} )

	-- Debug visualizations. Also use r_visualizetraces
	--[[if ( CLIENT ) then
		render.DrawWireframeBox( endposU, ang, Vector( -1, -1, -1 ), Vector( 1, 1, 1 ), Color(255,0,255), true )
		render.DrawWireframeBox( endposD, ang, Vector( -1, -1, -1 ), Vector( 1, 1, 1 ), Color(0,0,255), true )
	end]]

	-- Both traces hit meaning we are probably inside a wall on both sides, do nothing
	if ( tr_up.Hit && tr_down.Hit ) then return pos end

	if ( tr_down.Hit ) then return pos + ( tr_down.HitPos - endposD ) end
	if ( tr_up.Hit ) then return pos + ( tr_up.HitPos - endposU ) end
	return pos
end

-- Edit of TryFixPropPosition
local function TryFixDupePosition( pos, ang, ply, mins, maxs )
	pos = fixupDupePos( pos, ang, ply, Vector( mins.x, 0, 0 ), Vector( maxs.x, 0, 0 ) )
	pos = fixupDupePos( pos, ang, ply, Vector( 0, mins.y, 0 ), Vector( 0, maxs.y, 0 ) )
	pos = fixupDupePos( pos, ang, ply, Vector( 0, 0, mins.z ), Vector( 0, 0, maxs.z ) )

	-- Extra checks
	pos = fixupDupePos( pos, ang, ply, Vector( mins.x, mins.y, 0 ), Vector( maxs.x, maxs.y, 0 ) )
	pos = fixupDupePos( pos, ang, ply, Vector( maxs.x, mins.y, 0 ), Vector( mins.x, maxs.y, 0 ) )
	return pos
end

function TOOL:GeneratePastePosition( ply, trace, mins, maxs, ang )
	local SpawnCenter = trace.HitPos

	if ( trace.HitNormal:Dot( -vector_up ) > 0.7 ) then
		-- If aiming at ceiling
		SpawnCenter.z = SpawnCenter.z - maxs.z
	else
		SpawnCenter.z = SpawnCenter.z - mins.z
	end

	SpawnCenter = TryFixDupePosition( SpawnCenter, ang, ply, mins, maxs )

	return SpawnCenter
end

--
-- PASTE
--
function TOOL:LeftClick( trace )

	if ( CLIENT ) then return true end

	--
	-- Get the copied dupe. We store it on the player so it will still exist if they die and respawn.
	--
	local dupe = self:GetOwner().CurrentDupe
	if ( !dupe ) then return false end

	--
	-- Spawn it rotated with the player - but not pitch.
	--
	local SpawnAngle = self:GetOwner():EyeAngles()
	SpawnAngle.pitch = 0
	SpawnAngle.roll = 0

	--
	-- We want to spawn it flush on the ground. So get the point that we hit
	-- and take away the mins.z of the bounding box of the dupe.
	--
	local SpawnCenter = self:GeneratePastePosition( self:GetOwner(), trace, dupe.Mins, dupe.Maxs, SpawnAngle )

	--
	-- Spawn them all at our chosen positions
	--
	duplicator.SetLocalPos( SpawnCenter )
	duplicator.SetLocalAng( SpawnAngle )

	DisablePropCreateEffect = true

		local Ents = duplicator.Paste( self:GetOwner(), dupe.Entities, dupe.Constraints )

	DisablePropCreateEffect = nil

	duplicator.SetLocalPos( vector_origin )
	duplicator.SetLocalAng( angle_zero )

	--
	-- Create one undo for the whole creation
	--
	undo.Create( "Duplicator" )

		for k, ent in pairs( Ents ) do
			undo.AddEntity( ent )
		end

		for k, ent in pairs( Ents )	do
			self:GetOwner():AddCleanup( "duplicates", ent )
		end

		undo.SetPlayer( self:GetOwner() )
		undo.SetCustomUndoText( "Undone #undo.duplication" )

	undo.Finish( "#undo.duplication (" .. tostring( table.Count( Ents ) ) ..  ")" )

	return true

end

--
-- Copy
--
function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end
	if ( CLIENT ) then return true end

	--
	-- Set the position to our local position (so we can paste relative to our `hold`)
	--
	duplicator.SetLocalPos( trace.HitPos )
	duplicator.SetLocalAng( Angle( 0, self:GetOwner():EyeAngles().yaw, 0 ) )

	local Dupe = duplicator.Copy( trace.Entity )

	duplicator.SetLocalPos( vector_origin )
	duplicator.SetLocalAng( angle_zero )

	if ( !Dupe ) then return false end

	--
	-- Tell the clientside that they're holding something new
	--
	net.Start( "CopiedDupe" )
		net.WriteUInt( 1, 1 )
		net.WriteVector( Dupe.Mins )
		net.WriteVector( Dupe.Maxs )
		net.WriteString( "#duplicator.dupe_unsaved" )
		net.WriteUInt( table.Count( Dupe.Entities ), 24 )
		net.WriteUInt( 0, 16 )
		net.WriteUInt( table.Count( Dupe.Constraints ), 24 )
	net.Send( self:GetOwner() )

	--
	-- Store the dupe on the player
	--
	self:GetOwner().CurrentDupeArmed = false
	self:GetOwner().CurrentDupe = Dupe

	return true

end


if ( CLIENT ) then

	local HandleWorkshopDupeInfo = function( id, lblPnl )
		steamworks.FileInfo( id, function( result ) lblPnl:SetText( language.GetPhrase( "duplicator.dupe_name" ) .. " " .. result.title ) end)
	end

	--
	-- Builds the context menu
	--
	function TOOL.BuildCPanel( CPanel, tool )

		CPanel:Clear()

		CPanel:Help( "#tool.duplicator.desc" )

		CPanel:Button( "#tool.duplicator.showsaves", "dupe_show" )

		if ( !tool && IsValid( LocalPlayer() ) ) then tool = LocalPlayer():GetTool( "duplicator" ) end
		if ( !tool || !tool.CurrentDupeName ) then return end

		local nameLbl = CPanel:Help( language.GetPhrase( "duplicator.dupe_name" ) .. " " .. language.GetPhrase( tool.CurrentDupeName ) )
		
		-- Try to present more useful information
		if ( tool.CurrentDupeName:StartsWith( "dupes/" ) ) then
			nameLbl:SetText( language.GetPhrase( "duplicator.dupe_name" ) .. " " .. string.GetFileFromFilename( tool.CurrentDupeName ) )

			-- The dupe icon, so we know what we are spawning
			local img_text = vgui.Create( "DImage", CPanel )
			img_text:SetSize( 256, 256 )
			img_text:SetImage( string.StripExtension( tool.CurrentDupeName ) .. ".jpg" )

			-- Something DImage should just do by itself..
			function img_text:Paint( w, h )
				self:LoadMaterial()
				surface.SetMaterial( self.m_Material )
				surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )
				if ( w > h ) then
					surface.DrawTexturedRect( ( w - h ) / 2, 0, h, h )
				else
					surface.DrawTexturedRect( 0, ( h - w ) / 2, w, w )
				end
			end

			CPanel:AddItem( img_text )
		elseif ( tool.CurrentDupeName:StartsWith( "cache/workshop/" ) ) then
			local id = string.GetFileFromFilename( tool.CurrentDupeName ):StripExtension()
			nameLbl:SetText( language.GetPhrase( "duplicator.dupe_name" ) .. " " .. id )
			HandleWorkshopDupeInfo( id, nameLbl )
		elseif ( tool.CurrentDupeName:StartsWith( "content/4000/" ) ) then
			local id = string.GetPathFromFilename( tool.CurrentDupeName ):sub( 1, -2 ):GetFileFromFilename()
			nameLbl:SetText( language.GetPhrase( "duplicator.dupe_name" ) .. " " .. id )
			HandleWorkshopDupeInfo( id, nameLbl )
		end

		local info = ""
		info = info .. "\n" .. language.GetPhrase( "duplicator.dupe_entities" ) .. " " .. tool.CurrentDupeEntCount
		info = info .. "\n" .. language.GetPhrase( "duplicator.dupe_constraints" ) .. " " .. tool.CurrentDupeConstraintCount
		CPanel:Help( info )

		if ( tool.CurrentDupeWSIDs && #tool.CurrentDupeWSIDs > 0 ) then
			CPanel:Help( "#duplicator.dupe_required_content" )
			for _, wsid in pairs( tool.CurrentDupeWSIDs ) do
				local b = CPanel:Button( wsid )
				b.DoClick = function( s, ... ) steamworks.ViewFile( wsid ) end

				-- Update item name
				steamworks.FileInfo( wsid, function( result )
					if ( !IsValid( b ) ) then return end
					b:SetText( result.title )
				end )

				-- Display status
				if ( steamworks.IsSubscribed( wsid ) ) then
					if ( steamworks.ShouldMountAddon( wsid ) ) then
						b:SetImage( "icon16/tick.png" )
					else
						b:SetImage( "icon16/disconnect.png" )
					end
				else
					b:SetImage( "icon16/cross.png" )
				end
			end
		end

		if ( tool.CurrentDupeCanSave ) then
			local b = CPanel:Button( "#dupes.savedupe", "dupe_save" )
			hook.Add( "DupeSaveUnavailable", b, function() b:Remove() end )
		end

	end

	function TOOL:RefreshCPanel()
		local CPanel = controlpanel.Get( "duplicator" )
		if ( !CPanel ) then return end

		self.BuildCPanel( CPanel, self )
	end

	--
	-- Received by the client to alert us that we have something copied
	-- This allows us to enable the save button in the spawn menu
	--
	net.Receive( "CopiedDupe", function()

		local canSave = net.ReadUInt( 1 )
		if ( canSave == 1 ) then
			hook.Run( "DupeSaveAvailable" )
		else
			hook.Run( "DupeSaveUnavailable" )
		end

		local ply = LocalPlayer()
		if ( !IsValid( ply ) || !ply.GetTool ) then return end

		local tool = ply:GetTool( "duplicator" )
		if ( !tool ) then return end

		tool.CurrentDupeCanSave = canSave == 1
		tool.CurrentDupeMins = net.ReadVector()
		tool.CurrentDupeMaxs = net.ReadVector()

		tool.CurrentDupeName = net.ReadString()
		tool.CurrentDupeEntCount = net.ReadUInt( 24 )

		local workshopCount = net.ReadUInt( 16 )
		local addons = {}
		for i = 1, workshopCount do
			table.insert( addons, net.ReadString() )
		end
		tool.CurrentDupeWSIDs = addons

		tool.CurrentDupeConstraintCount = net.ReadUInt( 24 )

		tool:RefreshCPanel()

	end )

	hook.Add( "PostDrawTranslucentRenderables", "DrawDuplicatorPreview", function ()
		local ply = LocalPlayer()
		if ( !IsValid( ply ) || !ply.GetTool ) then return end

		local wep = ply:GetWeapon( "gmod_tool" )
		if ( !IsValid( wep ) || ply:GetActiveWeapon() != wep || wep:GetMode() != "duplicator" ) then return end

		local tool = ply:GetTool( "duplicator" )
		if ( !tool ) then return end

		tool:DrawPreview()
	end )

	local color_red = Color( 255, 0, 0 )
	local color_pulse = Color( 255, 255, 255 )
	-- This is not perfect, but let the player see roughly the outline of what they are about to paste
	function TOOL:DrawPreview()

		local ply = LocalPlayer()
		if ( !IsValid( ply ) || !self.CurrentDupeMins || !self.CurrentDupeMaxs ) then return end

		local tr = self:GetWeapon():DoToolTrace()
		if ( !tr ) then return end

		local SpawnAngle = ply:EyeAngles()
		SpawnAngle.pitch = 0
		SpawnAngle.roll = 0

		local pos = self:GeneratePastePosition( self:GetOwner(), tr, self.CurrentDupeMins, self.CurrentDupeMaxs, SpawnAngle )

		-- Just so it doesn't look like its colliding with the floor in the preview
		pos.z = pos.z + 1

		local ang = ply:GetAngles()
		if ( IsValid( ply:GetVehicle() ) ) then
			ang = ang + ply:LocalEyeAngles()
			ang.y = ang.y - 90 -- Hacky
		end
		ang.p = 0
		ang.r = 0

		render.DrawWireframeBox( pos, ang, self.CurrentDupeMins, self.CurrentDupeMaxs, color_red, false )
		render.DrawWireframeBox( pos, ang, self.CurrentDupeMins, self.CurrentDupeMaxs, color_pulse, true )
		--render.DrawWireframeBox( pos, ang, Vector( -1, -1, -1 ), Vector( 1, 1, 1 ), color_red, true )

	end

end
