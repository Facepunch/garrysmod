
IncludeCS( "ai_translations.lua" )
IncludeCS( "sh_anim.lua" )

-- Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 8					-- Size of a clip
SWEP.Primary.DefaultClip	= 32				-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false				-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"

SWEP.Secondary.ClipSize		= 8					-- Size of a clip
SWEP.Secondary.DefaultClip	= 32				-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "Pistol"



--[[---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
-----------------------------------------------------------]]
function SWEP:Initialize()

	self:SetHoldType( "pistol" )

end


--[[---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
-----------------------------------------------------------]]
function SWEP:Precache()
end


--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	-- Play shoot sound
	self.Weapon:EmitSound("Weapon_AR2.Single")
	
	-- Shoot 9 bullets, 150 damage, 0.75 aimcone
	self:ShootBullet( 150, 1, 0.01 )
	
	-- Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	-- Punch the player's view
	self.Owner:ViewPunch( Angle( -1, 0, 0 ) )

end


--[[---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanSecondaryAttack() ) then return end

	-- Play shoot sound
	self.Weapon:EmitSound("Weapon_Shotgun.Single")
	
	-- Shoot 9 bullets, 150 damage, 0.75 aimcone
	self:ShootBullet( 150, 9, 0.2 )
	
	-- Remove 1 bullet from our clip
	self:TakeSecondaryAmmo( 1 )
	
	-- Punch the player's view
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) )

end


--[[---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
-----------------------------------------------------------]]
function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
end


--[[---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
-----------------------------------------------------------]]
function SWEP:Think()
end


--[[---------------------------------------------------------
   Name: SWEP:Holster( weapon_to_swap_to )
   Desc: Weapon wants to holster
   RetV: Return true to allow the weapon to holster
-----------------------------------------------------------]]
function SWEP:Holster( wep )
	return true
end

--[[---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
-----------------------------------------------------------]]
function SWEP:Deploy()
	return true
end


--[[---------------------------------------------------------
   Name: SWEP:ShootEffects( )
   Desc: A convenience function to create shoot effects
-----------------------------------------------------------]]
function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	self.Owner:MuzzleFlash()								-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				-- 3rd Person Animation

end


--[[---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
-----------------------------------------------------------]]
function SWEP:ShootBullet( damage, num_bullets, aimcone )
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()			-- Source
	bullet.Dir 		= self.Owner:GetAimVector()			-- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	bullet.Tracer	= 5									-- Show a tracer on every x bullets 
	bullet.Force	= 1									-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	self.Owner:FireBullets( bullet )
	
	self:ShootEffects()
	
end


--[[---------------------------------------------------------
   Name: SWEP:TakePrimaryAmmo(   )
   Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakePrimaryAmmo( num )
	
	-- Doesn't use clips
	if ( self.Weapon:Clip1() <= 0 ) then 
	
		if ( self:Ammo1() <= 0 ) then return end
		
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	
	return end
	
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )	
	
end


--[[---------------------------------------------------------
   Name: SWEP:TakeSecondaryAmmo(   )
   Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakeSecondaryAmmo( num )
	
	-- Doesn't use clips
	if ( self.Weapon:Clip2() <= 0 ) then 
	
		if ( self:Ammo2() <= 0 ) then return end
		
		self.Owner:RemoveAmmo( num, self.Weapon:GetSecondaryAmmoType() )
	
	return end
	
	self.Weapon:SetClip2( self.Weapon:Clip2() - num )	
	
end


--[[---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() <= 0 ) then
	
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false
		
	end

	return true

end


--[[---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanSecondaryAttack()

	if ( self.Weapon:Clip2() <= 0 ) then
	
		self.Weapon:EmitSound( "Weapon_Pistol.Empty" )
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
		return false
		
	end

	return true

end


--[[---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end


--[[---------------------------------------------------------
   Name: OwnerChanged
   Desc: When weapon is dropped or picked up by a new player
-----------------------------------------------------------]]
function SWEP:OwnerChanged()
end


--[[---------------------------------------------------------
   Name: Ammo1
   Desc: Returns how much of ammo1 the player has
-----------------------------------------------------------]]
function SWEP:Ammo1()
	return self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
end


--[[---------------------------------------------------------
   Name: Ammo2
   Desc: Returns how much of ammo2 the player has
-----------------------------------------------------------]]
function SWEP:Ammo2()
	return self.Owner:GetAmmoCount( self.Weapon:GetSecondaryAmmoType() )
end

--[[---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed. 
		 This value needs to match on client and server.
-----------------------------------------------------------]]
function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

--[[---------------------------------------------------------
   Name: DoImpactEffect
   Desc: Callback so the weapon can override the impact effects it makes
		 return true to not do the default thing - which is to call UTIL_ImpactTrace in c++
-----------------------------------------------------------]]
function SWEP:DoImpactEffect( tr, nDamageType )
		
	return false;
	
end
