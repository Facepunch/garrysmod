-- Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= ""

SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"
SWEP.AnimPrefix			= "python"

SWEP.UseHands			= true
SWEP.Spawnable			= true

-- Be nice, precache the models
util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

-- Todo, make/find a better sound.
SWEP.ShootSound			= Sound( "Airboat.FireGunRevDown" )

SWEP.Tool				= {}

SWEP.Primary = 
{
	ClipSize 	= -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.Secondary = 
{
	ClipSize 	= -1,
	DefaultClip = -1,
	Automatic = false,
	Ammo = "none"
}

SWEP.CanHolster			= true
SWEP.CanDeploy			= true

function SWEP:InitializeTools()

	local temp = {}
	
	for k,v in pairs( self.Tool ) do
	
		temp[k] = table.Copy(v)
		temp[k].SWEP = self
		temp[k].Owner = self.Owner
		temp[k].Weapon = self.Weapon
		temp[k]:Init()
		
	end
	
	self.Tool = temp
	
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Entity", 0, "TargetEntity1" );
	self:NetworkVar( "Entity", 1, "TargetEntity2" );
	self:NetworkVar( "Entity", 2, "TargetEntity3" );
	self:NetworkVar( "Entity", 3, "TargetEntity4" );

end

--[[---------------------------------------------------------
	Initialize
-----------------------------------------------------------]]
function SWEP:Initialize()

	self:SetHoldType( "pistol" )

	self:InitializeTools()
	
	-- We create these here. The problem is that these are meant to be constant values.
	-- in the toolmode they're not because some tools can be automatic while some tools aren't.
	-- Since this is a global table it's shared between all instances of the gun.
	-- By creating new tables here we're making it so each tool has its own instance of the table
	-- So changing it won't affect the other tools.
	
	self.Primary = 
	{
		-- Note: Switched this back to -1.. lets not try to hack our way around shit that needs fixing. -gn
		ClipSize 	= -1,
		DefaultClip = -1,
		Automatic = false,
		Ammo = "none"
	}
	
	self.Secondary = 
	{
		ClipSize 	= -1,
		DefaultClip = -1,
		Automatic = false,
		Ammo = "none"
	}
	
end


--[[---------------------------------------------------------
	OnRestore
-----------------------------------------------------------]]
function SWEP:OnRestore()

	self:InitializeTools()
	
end

--[[---------------------------------------------------------
   Precache Stuff
-----------------------------------------------------------]]
function SWEP:Precache()

	util.PrecacheSound( self.ShootSound )
	
end

--[[---------------------------------------------------------
	Reload clears the objects
-----------------------------------------------------------]]
function SWEP:Reload()

	-- This makes the reload a semi-automatic thing rather than a continuous thing
	if ( !self.Owner:KeyPressed( IN_RELOAD ) ) then return end

	local mode = self:GetMode()
	local tr = util.GetPlayerTrace( self.Owner )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	local tool = self:GetToolObject()
	if ( !tool ) then return end
	
	tool:CheckObjects()
	
	-- Does the server setting say it's ok?
	if ( !tool:Allowed() ) then return end
	
	-- Ask the gamemode if it's ok to do this
	if ( !gamemode.Call( "CanTool", self.Owner, trace, mode ) ) then return end
	
	if ( !tool:Reload( trace ) ) then return end
	
	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )
	
end

--[[---------------------------------------------------------
	Returns the mode we're in
-----------------------------------------------------------]]
function SWEP:GetMode()
	
	return self.Mode
	
end

--[[---------------------------------------------------------
	Think does stuff every frame
-----------------------------------------------------------]]
function SWEP:Think()

	self.Mode = self.Owner:GetInfo( "gmod_toolmode" )
	local mode = self:GetMode()
	local tool = self:GetToolObject()
	
	if ( !tool ) then return end
	
	tool:CheckObjects()
	
	self.last_mode 		= self.current_mode
	self.current_mode 	= mode
	
	-- Release ghost entities if we're not allowed to use this new mode?
	if ( !tool:Allowed() ) then 
		self:GetToolObject( self.last_mode ):ReleaseGhostEntity() 
		return 
	end
	
	if ( self.last_mode != self.current_mode ) then
	
		if ( !self:GetToolObject( self.last_mode ) ) then return end
		
		-- We want to release the ghost entity just in case
		self:GetToolObject( self.last_mode ):Holster()
		
	end
	
	self.Primary.Automatic 		= tool.LeftClickAutomatic 	or false
	self.Secondary.Automatic 	= tool.RightClickAutomatic 	or false
	self.RequiresTraceHit 		= tool.RequiresTraceHit 	or true
	
	tool:Think()
	
end


--[[---------------------------------------------------------
	The shoot effect
-----------------------------------------------------------]]
function SWEP:DoShootEffect( hitpos, hitnormal, entity, physbone, bFirstTimePredicted )

	self.Weapon:EmitSound( self.ShootSound	)
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 	-- View model animation
	
	-- There's a bug with the model that's causing a muzzle to 
	-- appear on everyone's screen when we fire this animation. 
	self.Owner:SetAnimation( PLAYER_ATTACK1 )			-- 3rd Person Animation
	
	if ( !bFirstTimePredicted ) then return end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( hitpos )
		effectdata:SetNormal( hitnormal )
		effectdata:SetEntity( entity )
		effectdata:SetAttachment( physbone )
	util.Effect( "selection_indicator", effectdata )	
	
	local effectdata = EffectData()
		effectdata:SetOrigin( hitpos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )
	
end

--[[---------------------------------------------------------
	Trace a line then send the result to a mode function
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()

	local mode = self:GetMode()
	local tr = util.GetPlayerTrace( self.Owner )
	tr.mask = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	local tool = self:GetToolObject()
	if ( !tool ) then return end
	
	tool:CheckObjects()
	
	-- Does the server setting say it's ok?
	if ( !tool:Allowed() ) then return end
	
	-- Ask the gamemode if it's ok to do this
	if ( !gamemode.Call( "CanTool", self.Owner, trace, mode ) ) then return end
	
	if ( !tool:LeftClick( trace ) ) then return end
	
	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )
	
end


--[[---------------------------------------------------------
	SecondaryAttack - Reset everything to how it was
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()

	local mode = self:GetMode()
	local tr = util.GetPlayerTrace( self.Owner )
	tr.mask = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	local tool = self:GetToolObject()
	if ( !tool ) then return end
	
	tool:CheckObjects()
	
	-- Ask the gamemode if it's ok to do this
	if ( !tool:Allowed() ) then return end
	if ( !gamemode.Call( "CanTool", self.Owner, trace, mode ) ) then return end
	
	if ( !tool:RightClick( trace ) ) then return end

	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )
	
end

--[[---------------------------------------------------------
	Holster
-----------------------------------------------------------]]
function SWEP:Holster()

	-- Just do what the SWEP wants to do if there's no tool
	if ( !self:GetToolObject() ) then return self.CanHolster end
	
	local CanHolster = self:GetToolObject():Holster()
	if ( CanHolster ~= nil ) then return CanHolster end
	
	return self.CanHolster
	
end

--[[---------------------------------------------------------
	OnRemove
	- Delete ghosts here in case the weapon gets deleted all of a sudden somehow
-----------------------------------------------------------]]
function SWEP:OnRemove()

	if ( !self:GetToolObject() ) then return end
	
	self:GetToolObject():ReleaseGhostEntity()
	
end


--[[---------------------------------------------------------
	OwnerChanged
	- This will remove any ghosts when a player dies and drops the weapon
-----------------------------------------------------------]]
function SWEP:OwnerChanged()

	if ( !self:GetToolObject() ) then return end
	
	self:GetToolObject():ReleaseGhostEntity()
	
end

--[[---------------------------------------------------------
	Deploy
-----------------------------------------------------------]]
function SWEP:Deploy()

	-- Just do what the SWEP wants to do if there is no tool
	if ( !self:GetToolObject() ) then return self.CanDeploy end
	
	self:GetToolObject():UpdateData()
	
	local CanDeploy = self:GetToolObject():Deploy()
	if ( CanDeploy ~= nil ) then return CanDeploy end
	
	return self.CanDeploy
	
end

function SWEP:GetToolObject( tool )
	
	local mode = tool or self:GetMode()
	
	if ( !self.Tool[ mode ] ) then return false end
	
	return self.Tool[ mode ]
	
end

function SWEP:FireAnimationEvent( pos, ang, event, options )
	
	-- Disables animation based muzzle event
	if ( event == 21 ) then return true end	
	-- Disable thirdperson muzzle flash
	if ( event == 5003 ) then return true end

end

include( 'stool.lua' )
