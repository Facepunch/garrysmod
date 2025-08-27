
AddCSLuaFile()
DEFINE_BASECLASS( "base_edit" )

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.PrintName = "#edit_sky"
ENT.Category = "#spawnmenu.category.editors"
ENT.Information = "Right click on this entity via the context menu (hold C by default) and select 'Edit Properties' to edit the sky."

function ENT:Initialize()

	BaseClass.Initialize( self )
	self:SetMaterial( "gmod/edit_sky" )

	--
	-- Over-ride the sky controller with this.
	--
	if ( CLIENT ) then

		g_SkyPaint = self

	end

end

function ENT:Think()

	--
	-- Find an env_sun - if we don't already have one.
	--
	if ( SERVER and self.EnvSun == nil ) then

		-- so this closure only gets called once - even if it fails
		self.EnvSun = false

		local list = ents.FindByClass( "env_sun" )
		if ( #list > 0 ) then
			self.EnvSun = list[ 1 ]
		end

	end

	--
	-- If we have a sun - force our sun normal to its value
	--
	if ( SERVER and IsValid( self.EnvSun ) ) then

		local vec = self.EnvSun:GetInternalVariable( "m_vDirection" )

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
-- This edits something global - so always network - even when not in PVS
--
function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS

end

-- Player just spawned this entity from the spawnmenu - not from a duplication.
-- Copy over the settings of the maps' skypaint
hook.Add( "PlayerSpawnedSENT", "CopyOverEditSkySettings", function( ply, ent )

	if ( ent:GetClass() != "edit_sky" ) then return end

	local skyPaint = ents.FindByClass( "env_skypaint" )[ 1 ];
	if ( !IsValid( skyPaint ) ) then return end

	ent:SetTopColor( skyPaint:GetTopColor() )
	ent:SetBottomColor( skyPaint:GetBottomColor() )
	ent:SetFadeBias( skyPaint:GetFadeBias() )
	ent:SetHDRScale( skyPaint:GetHDRScale() )

	ent:SetStarLayers( skyPaint:GetStarLayers() )
	ent:SetDrawStars( skyPaint:GetDrawStars() )
	ent:SetStarTexture( skyPaint:GetStarTexture() )
	ent:SetStarSpeed( skyPaint:GetStarSpeed() )
	ent:SetStarFade( skyPaint:GetStarFade() )
	ent:SetStarScale( skyPaint:GetStarScale() )

	ent:SetDuskIntensity( skyPaint:GetDuskIntensity() )
	ent:SetDuskScale( skyPaint:GetDuskScale() )
	ent:SetDuskColor( skyPaint:GetDuskColor() )

	ent:SetSunSize( skyPaint:GetSunSize() )
	ent:SetSunColor( skyPaint:GetSunColor() )

end )
