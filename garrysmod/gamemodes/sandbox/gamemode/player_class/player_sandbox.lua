
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

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )

	local col = self.Player:GetInfo( "cl_playercolor" )
	self.Player:SetPlayerColor( Vector( col ) )

	local col = self.Player:GetInfo( "cl_weaponcolor" )
	self.Player:SetWeaponColor( Vector( col ) )

	-- It is here because it must be in sandbox and GM:PlayerSetModel must really be inside a player class instead of the gamemode itself.
	timer.Simple( 0, function()
		local skin = self.Player:GetInfo( "cl_playerskin" )
		self.Player:SetSkin( tonumber( skin ) )

		local groups = string.Explode( " ", self.Player:GetInfo( "cl_playerbodygroups" ) )
		for k = 0, self.Player:GetNumBodyGroups() - 1 do
			self.Player:SetBodygroup( k, groups[ k + 1 ] or 0 )
		end
	end)

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

player_manager.RegisterClass( "player_sandbox", PLAYER, "player_default" )
