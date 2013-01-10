AddCSLuaFile()
DEFINE_BASECLASS( "base_edit" )

ENT.Spawnable			= true
ENT.AdminOnly			= true

ENT.PrintName			= "Sun Editor"
ENT.Author				= ""
ENT.Information			= ""
ENT.Category			= "Editors"

--
--
--
function ENT:Initialize()

	BaseClass.Initialize( self )
	self:EnableForwardArrow()

	self:SetMaterial( "gmod/edit_sun" )
	
	if ( SERVER ) then

		--
		-- Notify us when the entity angle changes, so we can update the sun entity
		--
		self:AddCallback( "OnAngleChange", self.OnAngleChange )


		--
		-- Find an env_sun entity
		--
		local list = ents.FindByClass( "env_sun" )
		if ( #list > 0 ) then
			self.EnvSun = list[1]
		end

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Float",	0, "SunSize", { KeyName = "sunsize", Edit = { type = "Float", min = 0, max = 100, order = 1 } }  );
	self:NetworkVar( "Float",	1, "OverlaySize", { KeyName = "overlaysize", Edit = { type = "Float", min = 0, max = 200, order = 2 } }  );
	self:NetworkVar( "Vector",	0, "SunColor", { KeyName = "suncolor", Edit = { type = "VectorColor", order = 3 } }  );
	self:NetworkVar( "Vector",	1, "OverlayColor", { KeyName = "overlaycolor", Edit = { type = "VectorColor", order = 4 } }  );

	

	if ( SERVER ) then

		-- defaults
		self:SetSunSize( 20 )
		self:SetOverlaySize( 20 )
		self:SetOverlayColor( Vector( 1, 1, 1 ) )
		self:SetSunColor( Vector( 1, 1, 1 ) )

		-- call this function when something changes these variables
		self:NetworkVarNotify( "SunSize",		self.OnVariableChanged );
		self:NetworkVarNotify( "OverlaySize",	self.OnVariableChanged );
		self:NetworkVarNotify( "SunColor",		self.OnVariableChanged );
		self:NetworkVarNotify( "OverlayColor",	self.OnVariableChanged );

	end

end

--
-- Callback - serverside - added in :Initialize
--
function ENT:OnAngleChange( newang )

	if ( IsValid( self.EnvSun ) ) then
		self.EnvSun:SetKeyValue( "sun_dir", tostring( newang:Forward() ) );
	end

end


--
-- Update all the variables on the sun, from our variables in this entity
--
function ENT:OnVariableChanged()

	if ( !IsValid( self.EnvSun ) ) then return end

	self.EnvSun:SetKeyValue( "size", self:GetSunSize() );
	self.EnvSun:SetKeyValue( "overlaysize", self:GetOverlaySize() );

	local vec = self:GetOverlayColor()
	self.EnvSun:SetKeyValue( "overlaycolor", Format( "%i %i %i", vec.x * 255, vec.y * 255, vec.z * 255 ) );

	local vec = self:GetSunColor()
	self.EnvSun:SetKeyValue( "suncolor", Format( "%i %i %i", vec.x * 255, vec.y * 255, vec.z * 255 ) );
	

end

--
-- This edits something global - so always network - even when not in PVS
--
function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS
end

