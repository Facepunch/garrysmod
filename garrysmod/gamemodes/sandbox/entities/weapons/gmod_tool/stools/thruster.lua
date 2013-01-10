
TOOL.Category		= "Construction"
TOOL.Name			= "#tool.thruster.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "force" ]			= "1500"
TOOL.ClientConVar[ "model" ]			= "models/props_c17/lampShade001a.mdl"
TOOL.ClientConVar[ "keygroup" ]			= "7"
TOOL.ClientConVar[ "keygroup_back" ]	= "4"
TOOL.ClientConVar[ "toggle" ]			= "0"
TOOL.ClientConVar[ "collision" ]		= "0"
TOOL.ClientConVar[ "effect" ]			= "fire"
TOOL.ClientConVar[ "damageable" ]		= "0"
TOOL.ClientConVar[ "soundname" ]		= "PhysicsCannister.ThrusterLoop"

cleanup.Register( "thrusters" )

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	
	local force			= self:GetClientNumber( "force" )
	local model			= self:GetClientInfo( "model" )
	local key 			= self:GetClientNumber( "keygroup" ) 
	local key_bk 		= self:GetClientNumber( "keygroup_back" ) 
	local toggle		= self:GetClientNumber( "toggle" ) 
	local collision		= self:GetClientNumber( "collision" ) 
	local effect		= self:GetClientInfo( "effect" ) 
	local damageable	= self:GetClientNumber( "damageable" ) 
	local soundname		= self:GetClientInfo( "soundname" )
		
	-- If we shot a thruster change its force
	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_thruster" && trace.Entity.pl == ply ) then

		trace.Entity:SetForce( force )
		trace.Entity:SetEffect( effect )
		trace.Entity:SetToggle( toggle == 1 )
		trace.Entity.ActivateOnDamage = ( damageable == 1 )
		trace.Entity:SetSound( soundname )

		trace.Entity.force	= force
		trace.Entity.toggle	= toggle
		trace.Entity.effect	= effect
		trace.Entity.damageable = damageable

		return true
	end
	
	if ( !self:GetSWEP():CheckLimit( "thrusters" ) ) then return false end

	if (!util.IsValidModel(model)) then return false end
	if (!util.IsValidProp(model)) then return false end		-- Allow ragdolls to be used?

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local thruster = MakeThruster( ply, model, Ang, trace.HitPos, key, key_bk, force, toggle, effect, damageable, soundname )
	
	local min = thruster:OBBMins()
	thruster:SetPos( trace.HitPos - trace.HitNormal * min.z )
	
	local const, nocollide
	
	-- Don't weld to world
	if ( trace.Entity:IsValid() ) then
	
		const = constraint.Weld( thruster, trace.Entity, 0, trace.PhysicsBone, 0, collision == 0, true )
		
		-- Don't disable collision if it's not attached to anything
		if ( collision == 0 ) then 
		
			thruster:GetPhysicsObject():EnableCollisions( false )
			thruster.nocollide = true
			
		end
		
	end
	
	undo.Create("Thruster")
		undo.AddEntity( thruster )
		undo.AddEntity( const )
		undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "thrusters", thruster )
	ply:AddCleanup( "thrusters", const )
	ply:AddCleanup( "thrusters", nocollide )
	
	return true

end

if (SERVER) then

	function MakeThruster( pl, Model, Ang, Pos, key, key_bck, force, toggle, effect, damageable, soundname, nocollide, Vel, aVel, frozen )
	
		if ( IsValid( pl ) ) then
			if ( !pl:CheckLimit( "thrusters" ) ) then return false end
		end
	
		local thruster = ents.Create( "gmod_thruster" )
		if (!thruster:IsValid()) then return false end
		thruster:SetModel( Model )

		thruster:SetAngles( Ang )
		thruster:SetPos( Pos )
		thruster:Spawn()

		thruster:SetEffect( effect )
		thruster:SetForce( force )
		thruster:SetToggle( toggle == 1 )
		thruster.ActivateOnDamage = ( damageable == 1 )
		thruster:SetPlayer( pl )
		thruster:SetSound( soundname )

		numpad.OnDown( 	 pl, 	key, 	"Thruster_On", 		thruster, 1 )
		numpad.OnUp( 	 pl, 	key, 	"Thruster_Off", 	thruster, 1 )
		
		numpad.OnDown( 	 pl, 	key_bck, 	"Thruster_On", 		thruster, -1 )
		numpad.OnUp( 	 pl, 	key_bck, 	"Thruster_Off", 	thruster, -1 )

		if ( nocollide == true && IsValid( thruster:GetPhysicsObject() ) ) then thruster:GetPhysicsObject():EnableCollisions( false ) end

		local ttable = {
			key	= key,
			key_bck = key_bck,
			force	= force,
			toggle	= toggle,
			pl	= pl,
			effect	= effect,
			nocollide = nocollide,
			damageable = damageable,
			soundname = soundname
			}

		table.Merge(thruster:GetTable(), ttable )
		
		if ( IsValid( pl ) ) then
			pl:AddCount( "thrusters", thruster )
		end
		
		DoPropSpawnedEffect( thruster )

		return thruster
		
	end
	
	duplicator.RegisterEntityClass( "gmod_thruster", MakeThruster, "Model", "Ang", "Pos", "key", "key_bck", "force", "toggle", "effect", "damageable", "soundname", "nocollide", "Vel", "aVel", "frozen" )

end

function TOOL:UpdateGhostThruster( ent, player )

	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= util.GetPlayerTrace( player )
	local trace 	= util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	if (trace.Entity && trace.Entity:GetClass() == "gmod_thruster" || trace.Entity:IsPlayer()) then
	
		ent:SetNoDraw( true )
		return
		
	end
	
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local min = ent:OBBMins()
	 ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( Ang )
	
	ent:SetNoDraw( false )
	
end


function TOOL:Think()

	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" )) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostThruster( self.GhostEntity, self:GetOwner() )
	
end


function TOOL.BuildCPanel( CPanel )

	-- HEADER
	CPanel:AddControl( "Header", { Text = "#tool.thruster.name", Description	= "#tool.thruster.desc" }  )
	
	local Options = { Default = { thruster_force = "20",
									thruster_model = "models/props_junk/plasticbucket001a.mdl",
									thruster_effect = "fire" } }
									
	local CVars = { "thruster_force", "thruster_model", "thruster_effect" }
	
	CPanel:AddControl( "ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "thruster",
									 Options = Options,
									 CVars = CVars } )

	CPanel:AddControl( "Numpad", { 	Label = "#tool.thruster.forward",
									 Label2 = "#tool.thruster.back",
									 Command = "thruster_keygroup",
									 Command2 = "thruster_keygroup_back",
									 ButtonSize = "22" } )

	CPanel:AddControl( "PropSelect", { Label = "#tool.thruster.model",
									 ConVar = "thruster_model",
									 Category = "Thrusters",
									 Models = list.Get( "ThrusterModels" ) } )
									 
									 
	CPanel:AddControl( "ComboBox", { Label = "#tool.thruster.effect",
									 Description = "Thruster_Effects_Desc",
									 MenuButton = "0",
									 Options = list.Get( "ThrusterEffects" ) } )

									 
	CPanel:AddControl( "ComboBox", { Label = "#tool.thruster.sound",
									 Description = "Thruster_Sounds_Desc",
									 MenuButton = "0",
									 Options = list.Get( "ThrusterSounds" ) } )

									 
	CPanel:AddControl( "Slider", { Label = "#tool.thruster.force",
									 Description = "",
									 Type = "Float",
									 Min = 1,
									 Max = 10000,
									 Command = "thruster_force" } )
									 
									 

									 
	CPanel:AddControl( "CheckBox", { Label = "#tool.thruster.toggle",
									 Command = "thruster_toggle" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#tool.thruster.collision",
									 Command = "thruster_collision" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#tool.thruster.damagable",
									 Command = "thruster_damageable" } )
									
end

list.Set( "ThrusterModels", "models/dav0r/thruster.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/plasticbucket001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/PropaneCanister001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/propane_tank001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/PopCan01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/MetalBucket01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_lab/jar01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/lampShade001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/canister_propane01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/canister01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/canister02a.mdl", {} )
list.Set( "ThrusterModels", "models/props_trainstation/trainstation_ornament002.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/TrafficCone001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/clock01.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/pottery02a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/pottery03a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/terracotta01.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/TrapPropeller_Engine.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/FurnitureSink001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_trainstation/trainstation_ornament001.mdl", {} )
list.Set( "ThrusterModels", "models/props_trainstation/trashcan_indoor001b.mdl", {} )

list.Set( "ThrusterModels", "models/props_phx2/garbage_metalcan001a.mdl", {} )

--Tile Model Pack Thrusters

list.Set( "ThrusterModels", "models/hunter/plates/plate.mdl", {} )
list.Set( "ThrusterModels", "models/hunter/blocks/cube025x025x025.mdl", {} )

--XQM Model Pack Thrusters

list.Set( "ThrusterModels", "models/XQM/AfterBurner1.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Medium.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Big.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Huge.mdl", {} )
list.Set( "ThrusterModels", "models/XQM/AfterBurner1Large.mdl", {} )

list.Set( "ThrusterModels", "models/MaxOfS2D/thruster_propeller.mdl", {} )

list.Set( "ThrusterEffects", "#No_Effects", { thruster_effect = "none" } )
list.Set( "ThrusterEffects", "#Flames", 	{ thruster_effect = "fire" } )
list.Set( "ThrusterEffects", "#Plasma", 	{ thruster_effect = "plasma" } )
list.Set( "ThrusterEffects", "#Magic",	 	{ thruster_effect = "magic" } )
list.Set( "ThrusterEffects", "#Rings", 		{ thruster_effect = "rings" } )
list.Set( "ThrusterEffects", "#Smoke", 		{ thruster_effect = "smoke" } )

list.Set( "ThrusterSounds", "#None", { thruster_soundname = "" } )
list.Set( "ThrusterSounds", "#Steam Low", { thruster_soundname = "PhysicsCannister.ThrusterLoop" } )
list.Set( "ThrusterSounds", "#Electric Zappy", { thruster_soundname = "WeaponDissolve.Charge" } )
list.Set( "ThrusterSounds", "#Electric Beam", { thruster_soundname = "WeaponDissolve.Beam" } )
list.Set( "ThrusterSounds", "#Elevator", { thruster_soundname = "eli_lab.elevator_move" } )
list.Set( "ThrusterSounds", "#Energy", { thruster_soundname = "combine.sheild_loop" } )
list.Set( "ThrusterSounds", "#Ring Flutter", { thruster_soundname = "k_lab.ringsrotating" } )
list.Set( "ThrusterSounds", "#Resonance", { thruster_soundname = "k_lab.teleport_rings_high" } )
list.Set( "ThrusterSounds", "#Drop Ship", { thruster_soundname = "k_lab2.DropshipRotorLoop" } )
list.Set( "ThrusterSounds", "#Little Machine", { thruster_soundname = "Town.d1_town_01_spin_loop" } )