
-- Proxy Example:
--
--	Proxies
--	{
--		PlayerColor
--		{
--			resultVar	$color2
--		}
--	}

matproxy.Add( 
{
	name	=	"PlayerColor", 

	init	=	function( self, mat, values )

		-- Store the name of the variable we want to set
		self.ResultTo = values.resultvar

	end,

	bind	=	function( self, mat, ent )

		if ( !IsValid( ent ) ) then return end

		--
		-- If entity is a ragdoll try to convert it into the player
		--
		if ( ent:IsRagdoll() ) then
			ent = ent:GetRagdollOwner()
			if ( !IsValid( ent ) ) then return end
		end

		--
		-- If the target ent has a function called GetPlayerColor then use that
		-- The function SHOULD return a Vector with the chosen player's colour.
		--
		-- In sandbox this function is created as a network function, 
		-- in player_sandbox.lua in SetupDataTables
		--
		if ( ent.GetPlayerColor ) then
			mat:SetVector( self.ResultTo, ent:GetPlayerColor() )
		else
			mat:SetVector( self.ResultTo, Vector( 62.0/255.0, 88.0/255.0, 106.0/255.0 ) )
		end

	end 
})