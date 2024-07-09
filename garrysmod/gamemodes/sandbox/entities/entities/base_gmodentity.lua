
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

if ( CLIENT ) then
	ENT.MaxWorldTipDistance = 256

	local FrameNumber = FrameNumber
	local FrameLast = FrameNumber()

	local GetViewEntity = GetViewEntity

	local TraceLine = util.TraceLine
	local TraceEndpos = Vector()
	local TraceConfig = { endpos = TraceEndpos, output = {} }
	
	local CurrentLookedAt

	function ENT:BeingLookedAtByLocalPlayer()
		local Frame = FrameNumber()
		if Frame ~= FrameLast then
			FrameLast = Frame

			local view = GetViewEntity()
			local TraceResult

			if view:IsPlayer() then
				TraceResult = view:GetEyeTrace()
			else
				local startpos = view:GetPos()
				TraceConfig.start = startpos
				TraceConfig.filter = view

				TraceEndpos:Set( view:GetForward() )
				TraceEndpos:Mul( 32768 )
				TraceEndpos:Add( startpos )

				TraceResult = TraceLine( TraceConfig )
			end

			CurrentLookedAt = TraceResult.Entity
			
			local MaxWorldTipDistance = CurrentLookedAt.MaxWorldTipDistance
			if not MaxWorldTipDistance or ( TraceResult.Fraction or 0 ) * 32768 > MaxWorldTipDistance then
				CurrentLookedAt = nil
			end
		end

		return self == CurrentLookedAt
	end

	function ENT:Think()
		if ( not self:BeingLookedAtByLocalPlayer() or self:GetNoDraw() ) then
			return
		end

		local text = self:GetOverlayText()
		if ( not text or text == "" ) then
			return
		end

		AddWorldTip( self:EntIndex(), text, 0.5, self:GetPos(), self )

		halo.Add( { self }, color_white, 1, 1, 1, true, true )
	end
end

function ENT:SetOverlayText( text )
	self:SetNWString( "GModOverlayText", text )
end

function ENT:GetOverlayText()

	local txt = self:GetNWString( "GModOverlayText" )

	if ( txt == "" ) then
		return ""
	end

	if ( game.SinglePlayer() ) then
		return txt
	end

	local PlayerName = self:GetPlayerName()

	if ( !PlayerName or PlayerName == "" ) then
		return txt
	end

	return txt .. "\n(" .. PlayerName .. ")"

end

function ENT:SetPlayer( ply )

	self.Founder = ply

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
