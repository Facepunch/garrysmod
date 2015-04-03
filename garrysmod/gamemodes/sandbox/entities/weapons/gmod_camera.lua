
AddCSLuaFile()

SWEP.ViewModel = Model( "models/weapons/c_arms_animations.mdl" )
SWEP.WorldModel = Model( "models/MaxOfS2D/camera.mdl" )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"


SWEP.PrintName	= "#GMOD_Camera"

SWEP.Slot		= 5
SWEP.SlotPos	= 1

SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.Spawnable		= true

SWEP.ShootSound = Sound( "NPC_CScanner.TakePhoto" )

if ( SERVER ) then

	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	--
	-- A concommand to quickly switch to the camera
	--
	concommand.Add( "gmod_camera", function( player, command, arguments )

		player:SelectWeapon( "gmod_camera" )

	end )

end

--
-- Network/Data Tables
--
function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "Zoom" )
	self:NetworkVar( "Float", 1, "Roll" )

	if ( SERVER ) then
		self:SetZoom( 70 )
		self:SetRoll( 0 )
	end

end

--
-- Initialize Stuff
--
function SWEP:Initialize()

	self:SetHoldType( "camera" )

end

--
-- Reload resets the FOV and Roll
--
function SWEP:Reload()

	if ( !self.Owner:KeyDown( IN_ATTACK2 ) ) then self:SetZoom( self.Owner:IsBot() && 75 || self.Owner:GetInfoNum( "fov_desired", 75 ) ) end
	self:SetRoll( 0 )

end

--
-- PrimaryAttack - make a screenshot
--
function SWEP:PrimaryAttack()

	self:DoShootEffect()

	-- If we're multiplayer this can be done totally clientside
	if ( !game.SinglePlayer() && SERVER ) then return end
	if ( CLIENT && !IsFirstTimePredicted() ) then return end

	self.Owner:ConCommand( "jpeg" )

end

--
-- SecondaryAttack - Nothing. See Tick for zooming.
--
function SWEP:SecondaryAttack()
end

--
-- Mouse 2 action
--
function SWEP:Tick()

	if ( CLIENT && self.Owner != LocalPlayer() ) then return end -- If someone is spectating a player holding this weapon, bail

	local cmd = self.Owner:GetCurrentCommand()

	if ( !cmd:KeyDown( IN_ATTACK2 ) ) then return end -- Not holding Mouse 2, bail

	self:SetZoom( math.Clamp( self:GetZoom() + cmd:GetMouseY() * 0.1, 0.1, 175 ) ) -- Handles zooming
	self:SetRoll( self:GetRoll() + cmd:GetMouseX() * 0.025 ) -- Handles rotation

end

--
-- Override players Field Of View
--
function SWEP:TranslateFOV( current_fov )

	return self:GetZoom()

end

--
-- Deploy - Allow lastinv
--
function SWEP:Deploy()

	return true

end

--
-- Set FOV to players desired FOV
--
function SWEP:Equip()

	if ( self:GetZoom() == 70 && self.Owner:IsPlayer() && !self.Owner:IsBot() ) then
		self:SetZoom( self.Owner:GetInfoNum( "fov_desired", 75 ) )
	end

end

function SWEP:ShouldDropOnDie() return false end

--
-- The effect when a weapon is fired successfully
--
function SWEP:DoShootEffect()

	self:EmitSound( self.ShootSound )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( SERVER && !game.SinglePlayer() ) then

		--
		-- Note that the flash effect is only
		-- shown to other players!
		--

		local vPos = self.Owner:GetShootPos()
		local vForward = self.Owner:GetAimVector()

		local trace = {}
		trace.start = vPos
		trace.endpos = vPos + vForward * 256
		trace.filter = self.Owner

		local tr = util.TraceLine( trace )

		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		util.Effect( "camera_flash", effectdata, true )

	end

end

if ( SERVER ) then return end -- Only clientside lua after this line

SWEP.WepSelectIcon = surface.GetTextureID( "vgui/gmod_camera" )

-- Don't draw the weapon info on the weapon selection thing
function SWEP:DrawHUD() end
function SWEP:PrintWeaponInfo( x, y, alpha ) end

function SWEP:HUDShouldDraw( name )

	-- So we can change weapons
	if ( name == "CHudWeaponSelection" ) then return true end
	if ( name == "CHudChat" ) then return true end

	return false

end

function SWEP:FreezeMovement()

	-- Don't aim if we're holding the right mouse button
	if ( self.Owner:KeyDown( IN_ATTACK2 ) || self.Owner:KeyReleased( IN_ATTACK2 ) ) then
		return true
	end

	return false

end

function SWEP:CalcView( ply, origin, angles, fov )

	if ( self:GetRoll() != 0 ) then
		angles.Roll = self:GetRoll()
	end

	return origin, angles, fov

end

function SWEP:AdjustMouseSensitivity()

	if ( self.Owner:KeyDown( IN_ATTACK2 ) ) then return 1 end

	return self:GetZoom() / 80

end
