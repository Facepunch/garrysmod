
--[[---------------------------------------------------------
	PlayerColor Material Proxy
		Sets the clothing colour of custom made models to
		ent.GetPlayerColor, a normalized vector colour.
-----------------------------------------------------------]]

local clrFallback = Vector( 62 / 255, 88 / 255, 106 / 255 )

matproxy.Add( {
	name = "PlayerColor",

	init = function( self, mat, values )
		-- Store the name of the variable we want to set
		self.ResultTo = values.resultvar
	end,

	bind = function( self, mat, ent )
		if ( !IsValid( ent ) ) then return end

		-- If entity is a ragdoll try to convert it into the player
		-- ( this applies to their corpses )
		if ( ent:IsRagdoll() ) then
			local owner = ent:GetRagdollOwner()
			if ( IsValid( owner ) ) then ent = owner end
		end

		-- If the target ent has a function called GetPlayerColor then use that
		-- The function SHOULD return a Vector with the chosen player's colour.
		if ( ent.GetPlayerColor ) then
			local col = ent:GetPlayerColor()
			if ( isvector( col ) ) then
				mat:SetVector( self.ResultTo, col )
			end
		else
			mat:SetVector( self.ResultTo, clrFallback )
		end
	end
} )
