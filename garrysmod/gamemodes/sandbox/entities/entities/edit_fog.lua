AddCSLuaFile()
DEFINE_BASECLASS( "base_edit" )

ENT.Spawnable			= true
ENT.AdminOnly			= true

ENT.PrintName			= "Fog Editor"
ENT.Author				= ""
ENT.Information			= ""
ENT.Category			= "Editors"

--
--
--
function ENT:Initialize()

	BaseClass.Initialize( self )

	self:SetMaterial( "gmod/edit_fog" )
	
	if ( CLIENT ) then

		hook.Add( "SetupWorldFog", self, self.SetupWorldFog )
		hook.Add( "SetupSkyboxFog", self, self.SetupSkyFog )

	end

end

function ENT:SetupWorldFog()

	render.FogMode( 1 ) 
	render.FogStart( self:GetFogStart() )
	render.FogEnd( self:GetFogEnd()  )
	render.FogMaxDensity( self:GetDensity() )

	local col = self:GetFogColor()
	render.FogColor( col.x * 255, col.y * 255, col.z * 255 )

	return true

end

function ENT:SetupSkyFog( skyboxscale )

	render.FogMode( 1 ) 
	render.FogStart( self:GetFogStart() * skyboxscale )
	render.FogEnd( self:GetFogEnd() * skyboxscale )
	render.FogMaxDensity( self:GetDensity() )

	local col = self:GetFogColor()
	render.FogColor( col.x * 255, col.y * 255, col.z * 255 )

	return true

end

function ENT:SetupDataTables()

	self:NetworkVar( "Float",	0, "FogStart", { KeyName = "fogstart", Edit = { type = "Float", min = 0, max = 1000000, order = 1 } }  );
	self:NetworkVar( "Float",	1, "FogEnd", { KeyName = "fogend", Edit = { type = "Float", min = 0, max = 1000000, order = 2 } }  );
	self:NetworkVar( "Float",	2, "Density", { KeyName = "density", Edit = { type = "Float", min = 0, max = 1, order = 3 } }  );

	self:NetworkVar( "Vector",	0, "FogColor", { KeyName = "fogcolor", Edit = { type = "VectorColor", order = 3 } }  );

	--
	-- TODO: Should skybox fog be edited seperately?
	--

	if ( SERVER ) then

		-- defaults
		self:SetFogStart( 0.0 )
		self:SetFogEnd( 10000 )
		self:SetDensity( 0.9 )
		self:SetFogColor( Vector( 0.6, 0.7, 0.8 ) )

	end

end

--
-- This edits something global - so always network - even when not in PVS
--
function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS
end
