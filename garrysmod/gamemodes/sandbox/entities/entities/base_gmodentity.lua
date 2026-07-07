
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

if ( CLIENT ) then

	ENT.MaxWorldTipDistance = 256

	local lastLookedFrame = nil
	local lastLooked = nil
	function ENT:BeingLookedAtByLocalPlayer()

		local currentFrame = FrameNumber()
		if ( currentFrame != lastLookedFrame ) then
			lastLookedFrame = currentFrame

			local trace = nil
			local viewer = GetViewEntity()
			if ( viewer:IsPlayer() ) then
				-- If we're spectating a player, perform an eye trace
				trace = viewer:GetEyeTrace()
			else
				-- If we're not spectating a player, perform a manual trace from the entity's position
				local startPos = viewer:GetPos()
				local endPos = viewer:GetForward()
				endPos:Mul( 32768 )
				endPos:Add( startPos )

				trace = util.TraceLine( {
					start = startPos,
					endpos = endPos,
					filter = viewer
				} )
			end

			lastLooked = trace.Entity

			local distance = lastLooked.MaxWorldTipDistance
			if ( !distance || trace.Fraction * 32768 > distance ) then
				lastLooked = nil
			end
		end

		return self == lastLooked

	end

	function ENT:Think()

		if ( !self:BeingLookedAtByLocalPlayer() ) then return end

		local text = self:GetOverlayText()
		if ( text != "" && !self:GetNoDraw() ) then
			AddWorldTip( nil, text, nil, nil, self )
			halo.Add( { self }, color_white, 1, 1, 1, true, true )
		end

	end

end

function ENT:SetOverlayText( text )

	self:SetNWString( "GModOverlayText", text )

end

function ENT:GetOverlayText()

	local txt = self:GetNWString( "GModOverlayText" )
	if ( txt == "" ) then return "" end

	if ( game.SinglePlayer() ) then return txt end

	local PlayerName = self:GetPlayerName()
	if ( !PlayerName or PlayerName == "" ) then return txt end

	return txt .. "\n(" .. PlayerName .. ")"

end

function ENT:SetPlayer( ply )

	self.Founder = ply
	self:SetCreator( ply )

	if ( IsValid( ply ) ) then

		self:SetNWString( "FounderName", ply:Nick() )
		self.FounderSID = ply:SteamID64()
		self.FounderIndex = ply:UniqueID()

	else

		self:SetNWString( "FounderName", "" )
		self.FounderSID = nil
		self.FounderIndex = nil

	end

end

function ENT:GetPlayer()

	if ( self.Founder == nil ) then

		-- SetPlayer has not been called
		return NULL

	elseif ( IsValid( self.Founder ) ) then

		-- Normal operations
		return self.Founder

	end

	-- See if the player has left the server then rejoined
	local ply = player.GetBySteamID64( self.FounderSID )
	if ( !IsValid( ply ) ) then

		-- Oh well
		return NULL

	end

	-- Save us the check next time
	self:SetPlayer( ply )
	return ply

end

function ENT:GetPlayerIndex()

	return self.FounderIndex or 0

end

function ENT:GetPlayerSteamID()

	return self.FounderSID or ""

end

function ENT:GetPlayerName()

	local ply = self:GetPlayer()
	if ( IsValid( ply ) ) then
		return ply:Nick()
	end

	return self:GetNWString( "FounderName", "" )

end
