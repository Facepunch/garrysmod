--traitor equipment - Roundbomb
--repackaged and modified by gravetracer
--based on http://steamcommunity.com/sharedfiles/filedetails/?id=892101684

AddCSLuaFile()

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false



SWEP.SlotPos			= 1
SWEP.Icon = "vgui/ttt/icon_c4"
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.EquipMenuData = {
   type = "Weapon",
   desc = "I will remember you...\nYour silhouette will charge the view."
};


if CLIENT then
   SWEP.PrintName           = "Roundabomb"
   SWEP.Slot                = 6
   
   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54
   SWEP.DrawCrosshair      = false

   SWEP.EquipMenuData = {
      type  = "item_weapon",
      name  = "Roundabomb",
      desc  = "Left click to make you out 'n' out.\nRight click to spend the day your way."
   };

   SWEP.Icon                = "vgui/ttt/icon_roundabout"
   SWEP.IconLetter          = "I"
end


SWEP.Base 					= "weapon_tttbase"
SWEP.Kind                   = WEAPON_EQUIP
SWEP.CanBuy 				= { ROLE_TRAITOR }
SWEP.WeaponID               = AMMO_C4 --not sure if this will work, think it's for statistics.

SWEP.UseHands               = true
SWEP.ViewModel              = Model("models/weapons/cstrike/c_c4.mdl")
SWEP.WorldModel             = Model("models/weapons/w_c4.mdl")

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 5.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.NoSights = true

SWEP.AutoSpawnable = false
SWEP.InLoadoutFor = nil
SWEP.AllowDrop = true
SWEP.IsSilent = false


--Bewm
function SWEP:WorldBoom()
	
	surface.EmitSound( "roundabout/explosion.wav" )

end

function SWEP:Reload()
end   



function SWEP:Initialize()
    util.PrecacheSound("roundabout/explosion.wav")
    util.PrecacheSound("roundabout/roundabout.wav")
end


/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()	
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + 3)

	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetNormal( self.Owner:GetPos() )
		effectdata:SetMagnitude( 8 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )
	util.Effect( "Sparks", effectdata )
	
	self.BaseClass.ShootEffects( self )
	
	
	// The rest is only done on the server
	if (SERVER) then
		timer.Simple(2.25, function() self:Asplode() end )
		self.Owner:EmitSound( "roundabout/roundabout.wav" ) --default self.Owner:EmitSound( "jihad/roundabout.wav" )
	end

end

--The asplode function
function SWEP:Asplode()
local k, v
	
	// Make an explosion at your position
	local ent = ents.Create( "env_explosion" )
		ent:SetPos( self.Owner:GetPos() )
		ent:SetOwner( self.Owner )
		ent:Spawn()
		ent:SetKeyValue( "iMagnitude", "300" )
		ent:Fire( "Explode", 0, 0 )
		ent:EmitSound( "roundabout/explosion.wav", 500, 500 ) --default ent:EmitSound( "jihad/explosion.wav", 500, 500 )
		
		self.Owner:Kill( )
		self.Owner:AddFrags( -1 )
 
		for k, v in pairs( player.GetAll( ) ) do
		  v:ConCommand( "play roundabout/explosion.wav\n" ) --default v:ConCommand( "play jihad/explosion.wav\n" )
		end

end


/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()	
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	
	local TauntSound = Sound( "roundabout/taunt.wav" ) --default local TauntSound = Sound( "jihad/taunt.wav" )

	self.Weapon:EmitSound( TauntSound )
	
	// The rest is only done on the server
	if (!SERVER) then return end
	
	self.Weapon:EmitSound( TauntSound )


end
