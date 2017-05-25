AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

//###########################################
//# source engines trigger_waterydeath:		#
//# Classname: ent_watery_leech			    #
//# Damage: 2 (+ 2 every bite)			    #
//# NEXT_BITE: CurTime() + 0.3				#
//# Playback rate: random float(0.5, 1.5)	#
//# Cycle start: random float(0, 0.9)		#
//###########################################

function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end 

	local BoneIndx = ply:LookupBone("ValveBiped.Bip01_Head1")
	local HeadPos, HeadAng = ply:GetBonePosition( BoneIndx )

	// Source engines 'ent_watery_leech' spawned by source engines 'trigger_waterydeath'.
	local ent = ents.Create( "ent_wateryleech" )
	ent:SetNWEntity("target", ply) -- Set owner as target only.
	ent:SetPos( HeadPos ) 
 	ent:Spawn()
 	ent:Activate() 
	return ent 
end

function ENT:Initialize()
	
	// This is just here so that I don't have to remember the path.
	util.PrecacheModel( "models/leech.mdl" )

	self.anims = {}
	self.anims[1] = "attackloop1"
	self.anims[2] = "attackloop2"
	self.anims[3] = "attackloop3"
	self.anims[4] = "attackloop4"
	self.anims[5] = "loop1"
	self.anims[6] = "loop2"
	self.anims[7] = "loop3"
	self.anims[8] = "loop4"

	self.dmginfo = DamageInfo()
		self.dmginfo:SetAttacker( self.Entity ) -- Or make the player hurt himself.
		self.dmginfo:SetDamageType( DMG_GENERIC )
		self.dmginfo:SetDamageForce( Vector( 0, 0, 10 ) )
	self.damage = 2

	self:SetModel( "models/leech.mdl" )
	self:AddEffects(EF_NOSHADOW)
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	// The mother leech (THIS entity) gets the first animation and real playback rate.
	local sequence = self:LookupSequence(self.anims[1])
	self:ResetSequence(sequence)
	self:SetPlaybackRate(math.Rand( 0.5, 1.5 ))
	self:SetCycle(math.Rand(0, 0.9))

	// Let's spawn one leech for every animation starting at 2.
	self.leech = {}
	self.leech[1] = self.Entity
	for i = 2, 8 do
		self.leech[i] = ents.Create("prop_dynamic")
		self.leech[i]:SetModel( "models/leech.mdl" )
		self.leech[i]:SetPos( self:GetPos() )
		self.leech[i]:AddEffects(EF_NOSHADOW)
		self.leech[i]:PhysicsInit(SOLID_NONE)
		self.leech[i]:SetMoveType(MOVETYPE_NONE)
		self.leech[i]:SetSolid(SOLID_NONE)
		self.leech[i].AutomaticFrameAdvance = true
		self.leech[i]:SetParent(self.Entity)
		self.leech[i]:Spawn()
		self.leech[i]:Activate()

		local sequence = self.leech[i]:LookupSequence(self.anims[i])
		self.leech[i]:ResetSequence(sequence)
		// Randomize playback rate and starting frame of each leech a little.
		self.leech[i]:SetPlaybackRate(math.Rand( 2.0, 3.0 )) -- 0.5, 1.5
		self.leech[i]:SetCycle(math.Rand(0, 0.9))

		self:DeleteOnRemove( self.leech[i] )
	end
end

function ENT:Think()
	if (!self:GetNWEntity("target")) then return end
	if (!IsValid(self:GetNWEntity("target"))) then self:Remove() return end

	local target = self:GetNWEntity("target")
	local BoneIndx = target:LookupBone("ValveBiped.Bip01_Head1")
	local HeadPos, HeadAng = target:GetBonePosition( BoneIndx )
	if (target:Health() <= 0) then

		for i = 1, 8 do
			self.leech[i]:SetNoDraw(true)
		end

		self.damage = 2

		--self:Remove()
		return
	// Only re-position if the target is alive, so that the leeches stay at the location after death ie. corpse.
	else
		self:SetPos(HeadPos)
		self:SetAngles(Angle(0, 0, 0)) -- HeadAng
	end

	if (!self.NEXT_BITE or self.NEXT_BITE <= CurTime()) then
		if (target:IsPlayer()) then
			// Full body in water: Set leeches visible.
			if (target:WaterLevel() == 3) then

				for i = 1, 8 do
					self.leech[i]:SetNoDraw(false)
				end

				self.dmginfo:SetDamage( math.Clamp( self.damage, 2, 15 ) )
				target:TakeDamageInfo( self.dmginfo )
				self.damage = self.damage + 2

			// Majority of body in water: Set leeches invisible, but still active.
			elseif (target:WaterLevel() == 2) then

				for i = 1, 8 do
					self.leech[i]:SetNoDraw(true)
				end

				self.dmginfo:SetDamage( math.Clamp( self.damage, 2, 15 ) )
				target:TakeDamageInfo( self.dmginfo )
				self.damage = self.damage + 2

			// Not or just feet in water: Set leeches invisible and inactive, also reset damage.
			elseif (target:WaterLevel() <= 1) then

				for i = 1, 8 do
					self.leech[i]:SetNoDraw(true)
				end

				self.damage = 2

			end
		end
		self.NEXT_BITE = CurTime() + 0.3
	end

	self:NextThink( CurTime() )
	return true
end