AddCSLuaFile()
DEFINE_BASECLASS( "base_edit" )

ENT.Spawnable			= true
ENT.AdminOnly			= true

ENT.PrintName			= "Sky Editor"
ENT.Author				= ""
ENT.Information			= ""
ENT.Category			= "Editors"

--
--
--
function ENT:Initialize()

	BaseClass.Initialize( self )
	self:SetMaterial( "gmod/edit_sky" )

	--
	-- Over-ride the sky controller with this.
	--
	if ( CLIENT ) then

		if ( IsValid( g_SkyPaint ) ) then
			-- TODO: Copy settings from `current` sky to here.
		end

		g_SkyPaint = self

	end

end

function ENT:Think()

	--
	-- Find an env_sun - if we don't already have one.
	--
	if ( SERVER && self.EnvSun == nil ) then
		
		-- so this closure only gets called once - even if it fails
		self.EnvSun = false;

		local list = ents.FindByClass( "env_sun" )
		if ( #list > 0 ) then
			self.EnvSun = list[1]
		end

	end
	
	--
	-- If we have a sun - force our sun normal to its value
	--
	if ( SERVER && IsValid( self.EnvSun ) ) then

		local vec = self.EnvSun:GetInternalVariable( "m_vDirection" );
		
		if ( isvector( vec ) ) then
			self:SetSunNormal( vec )
		end

	end

end

--
-- This needs to be a 1:1 copy of env_skypaint
--
function ENT:SetupDataTables()

	local SetupDataTables = scripted_ents.GetMember( "env_skypaint", "SetupDataTables" )
	SetupDataTables( self )

end


--
-- This edits something global - so always network - even wjen not in PVS
--
function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS
end
