
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )

ENT.Spawnable = false

if ( CLIENT ) then
	ENT.MaxWorldTipDistance = 256

	function ENT:BeingLookedAtByLocalPlayer()
		local ply = LocalPlayer()
		if ( not IsValid( ply ) ) then return false end

		local view = ply:GetViewEntity()
		local dist = self.MaxWorldtipDistance
		dist = dist * dist
		local pos = view:IsPlayer() && view:GetShootPos() || view:GetPos()

		return pos:DistToSqr( self:GetPos() ) <= dist && ply:GetEyeTrace().Entity == self
	end

	function ENT:Think()
		local text = self:GetOverlayText()

		if ( text != "" && self:BeingLookedAtByLocalPlayer() ) then
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

	return txt .. "\n(" .. PlayerName .. ")"

end

function ENT:SetPlayer( ply )

	if ( IsValid( ply ) ) then

		self:SetVar( "Founder", ply )
		self:SetVar( "FounderIndex", ply:UniqueID() )

		self:SetNWString( "FounderName", ply:Nick() )

	end

end

function ENT:GetPlayer()

	return self:GetVar( "Founder", NULL )

end

function ENT:GetPlayerIndex()

	return self:GetVar( "FounderIndex", 0 )

end

function ENT:GetPlayerName()

	local ply = self:GetPlayer()
	if ( IsValid( ply ) ) then
		return ply:Nick()
	end

	return self:GetNWString( "FounderName" )

end
