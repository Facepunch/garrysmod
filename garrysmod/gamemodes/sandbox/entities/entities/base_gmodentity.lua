
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

if ( CLIENT ) then
	ENT.MaxWorldTipDistance = 256

	local FrameNumber = FrameNumber
	local FrameLast = FrameNumber()

	local GetViewEntity = GetViewEntity

	local TraceLine = util.TraceLine
	local TraceLineEndpos = Vector()
	local TraceLineConfig = { endpos = TraceLineEndpos, output = {} }

	local vec_meta = FindMetaTable( "Vector" )
	local DistToSqr = vec_meta.DistToSqr
	local Set, Mul, Add = vec_meta.Set, vec_meta.Mul, vec_meta.Add
	
	local CurrentLookedAt

	function ENT:BeingLookedAtByLocalPlayer()
		local Frame = FrameNumber()
		if Frame ~= FrameLast then
			FrameLast = Frame

			local view = GetViewEntity()

			local isPlayer = view:IsPlayer()
			local start = isPlayer and view:EyePos() or view:GetPos()
			local direction = isPlayer and view:GetAimVector() or view:GetForward()

			TraceLineConfig.start = start

			Set( TraceLineEndpos, direction )
			Mul( TraceLineEndpos, 65536 )
			Add( TraceLineEndpos, start )

			TraceLineConfig.filter = view

			CurrentLookedAt = TraceLine( TraceLineConfig ).Entity

			if not CurrentLookedAt.BeingLookedAtByLocalPlayer or DistToSqr( CurrentLookedAt:GetPos(), start ) > CurrentLookedAt.MaxWorldTipDistance ^ 2 then
				CurrentLookedAt = nil
			end
		end

		return self == CurrentLookedAt
	end

	function ENT:Think()
		local text = self:GetOverlayText()

		if ( text != "" && self:BeingLookedAtByLocalPlayer() && !self:GetNoDraw() ) then
			AddWorldTip( self:EntIndex(), text, 0.5, self:GetPos(), self )

			halo.Add( { self }, color_white, 1, 1, 1, true, true )
		end
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
