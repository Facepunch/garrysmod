
AddCSLuaFile()
DEFINE_BASECLASS( "base_edit" )

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.PrintName = "#edit_sun"
ENT.Category = "#spawnmenu.category.editors"
ENT.Information = "Right click on this entity via the context menu (hold C by default) and select 'Edit Properties' to edit the sun. Rotate the entity to move the sun."

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
			self.EnvSun = list[ 1 ]
		end

	end

end

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "SunSize", { KeyName = "sunsize", Edit = { type = "Float", min = 0, max = 100, order = 1 } } )
	self:NetworkVar( "Float", 1, "OverlaySize", { KeyName = "overlaysize", Edit = { type = "Float", min = 0, max = 200, order = 2 } } )
	self:NetworkVar( "Vector", 0, "SunColor", { KeyName = "suncolor", Edit = { type = "VectorColor", order = 3 } } )
	self:NetworkVar( "Vector", 1, "OverlayColor", { KeyName = "overlaycolor", Edit = { type = "VectorColor", order = 4 } } )

	if ( SERVER ) then

		-- defaults
		self:SetSunSize( 20 )
		self:SetOverlaySize( 20 )
		self:SetOverlayColor( Vector( 1, 1, 1 ) )
		self:SetSunColor( Vector( 1, 1, 1 ) )

		-- call this function when something changes these variables
		self:NetworkVarNotify( "SunSize", self.OnVariableChanged )
		self:NetworkVarNotify( "OverlaySize", self.OnVariableChanged )
		self:NetworkVarNotify( "SunColor", self.OnVariableChanged )
		self:NetworkVarNotify( "OverlayColor", self.OnVariableChanged )

	end

end

--
-- Callback - serverside - added in :Initialize
--
function ENT:OnAngleChange( newang )

	if ( IsValid( self.EnvSun ) ) then
		self.EnvSun:SetKeyValue( "sun_dir", tostring( newang:Forward() ) )
	end

end

--
-- Force update everything after being pasted in
--
function ENT:PostEntityPaste( ply, ent )

	self:OnAngleChange( ent:GetAngles() )
	self:OnVariableChanged()

end

--
-- Update all the variables on the sun, from our variables in this entity
--
function ENT:OnVariableChanged()

	if ( !IsValid( self.EnvSun ) ) then return end

	self.EnvSun:SetKeyValue( "size", self:GetSunSize() )
	self.EnvSun:SetKeyValue( "overlaysize", self:GetOverlaySize() )

	local overlay = self:GetOverlayColor()
	self.EnvSun:SetKeyValue( "overlaycolor", Format( "%i %i %i", overlay.x * 255, overlay.y * 255, overlay.z * 255 ) )

	local sun = self:GetSunColor()
	self.EnvSun:SetKeyValue( "suncolor", Format( "%i %i %i", sun.x * 255, sun.y * 255, sun.z * 255 ) )

end

--
-- This edits something global - so always network - even when not in PVS
--
function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS

end

-- Player just spawned this entity from the spawnmenu - not from a duplication.
-- Copy over the settings of the map
hook.Add( "PlayerSpawnedSENT", "CopyOverEditSunSettings", function( ply, ent )

	if ( ent:GetClass() != "edit_sun" ) then return end

	local envSun = ents.FindByClass( "env_sun" )[ 1 ];
	if ( !IsValid( envSun ) ) then return end

	ent:SetSunSize( envSun:GetInternalVariable( "size" ) )
	ent:SetOverlaySize( envSun:GetInternalVariable( "overlaysize" ) )
	ent:SetOverlayColor( Vector( envSun:GetInternalVariable( "overlaycolor" ) ) / 255 )
	ent:SetSunColor( Vector( envSun:GetInternalVariable( "rendercolor" ) ) / 255 )

end )
