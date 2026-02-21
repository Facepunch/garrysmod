
AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

if ( CLIENT ) then

	CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )

end

local PLAYER = {}

PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.1		-- How fast to go from ducking, to not ducking

--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.SlowWalkSpeed		= 100
PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 400

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end


function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()

	if ( cvars.Bool( "sbox_weapons", true ) ) then

		self.Player:GiveAmmo( 256,	"Pistol", 		true )
		self.Player:GiveAmmo( 256,	"SMG1", 		true )
		self.Player:GiveAmmo( 5,	"grenade", 		true )
		self.Player:GiveAmmo( 64,	"Buckshot", 	true )
		self.Player:GiveAmmo( 32,	"357", 			true )
		self.Player:GiveAmmo( 32,	"XBowBolt", 	true )
		self.Player:GiveAmmo( 6,	"AR2AltFire", 	true )
		self.Player:GiveAmmo( 100,	"AR2", 			true )

		self.Player:Give( "weapon_crowbar" )
		self.Player:Give( "weapon_pistol" )
		self.Player:Give( "weapon_smg1" )
		self.Player:Give( "weapon_frag" )
		self.Player:Give( "weapon_physcannon" )
		self.Player:Give( "weapon_crossbow" )
		self.Player:Give( "weapon_shotgun" )
		self.Player:Give( "weapon_357" )
		self.Player:Give( "weapon_rpg" )
		self.Player:Give( "weapon_ar2" )

		-- The only reason I'm leaving this out is because
		-- I don't want to add too many weapons to the first
		-- row because that's where the gravgun is.
		--pl:Give( "weapon_stunstick" )

	end

	self.Player:Give( "gmod_tool" )
	self.Player:Give( "gmod_camera" )
	self.Player:Give( "weapon_physgun" )

	self.Player:SwitchToDefaultWeapon()

end

function PLAYER:SetModel()

	BaseClass.SetModel( self )

	local skin = self.Player:GetInfoNum( "cl_playerskin", 0 )
	self.Player:SetSkin( skin )

	local bodygroups = self.Player:GetInfo( "cl_playerbodygroups" )
	if ( bodygroups == nil ) then bodygroups = "" end

	local groups = string.Explode( " ", bodygroups )
	for k = 0, self.Player:GetNumBodyGroups() - 1 do
		self.Player:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
	end

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )

	local plyclr = self.Player:GetInfo( "cl_playercolor" )
	self.Player:SetPlayerColor( Vector( plyclr ) )

	local wepclr = Vector( self.Player:GetInfo( "cl_weaponcolor" ) )
	if ( wepclr:Length() < 0.001 ) then
		wepclr = Vector( 0.001, 0.001, 0.001 )
	end
	self.Player:SetWeaponColor( wepclr )

end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal()

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

--
-- Reproduces the jump boost from HL2 singleplayer
--
local JUMPING

function PLAYER:StartMove( move )

	-- Only apply the jump boost in FinishMove if the player has jumped during this frame
	-- Using a global variable is safe here because nothing else happens between SetupMove and FinishMove
	if bit.band( move:GetButtons(), IN_JUMP ) ~= 0 and bit.band( move:GetOldButtons(), IN_JUMP ) == 0 and self.Player:OnGround() then
		JUMPING = true
	end

end

function PLAYER:FinishMove( move )

	-- If the player has jumped this frame
	if ( JUMPING ) then
		-- Get their orientation
		local forward = move:GetAngles()
		forward.p = 0
		forward = forward:Forward()

		-- Compute the speed boost

		-- HL2 normally provides a much weaker jump boost when sprinting
		-- For some reason this never applied to GMod, so we won't perform
		-- this check here to preserve the "authentic" feeling
		local speedBoostPerc = ( ( not self.Player:Crouching() ) and 0.5 ) or 0.1

		local speedAddition = math.abs( move:GetForwardSpeed() * speedBoostPerc )
		local maxSpeed = move:GetMaxSpeed() * ( 1 + speedBoostPerc )
		local newSpeed = speedAddition + move:GetVelocity():Length2D()

		-- Clamp it to make sure they can't bunnyhop to ludicrous speed
		if newSpeed > maxSpeed then
			speedAddition = speedAddition - ( newSpeed - maxSpeed )
		end

		-- Reverse it if the player is running backwards
		if move:GetVelocity():Dot( forward ) < 0 then
			speedAddition = -speedAddition
		end

		-- Apply the speed boost
		move:SetVelocity( forward * speedAddition + move:GetVelocity() )
	end

	JUMPING = nil

end

player_manager.RegisterClass( "player_sandbox", PLAYER, "player_default" )
