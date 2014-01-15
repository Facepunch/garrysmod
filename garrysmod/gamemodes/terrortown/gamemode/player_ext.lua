
-- serverside extensions to player table

local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

function plymeta:SetRagdollSpec(s)
   if s then
      self.spec_ragdoll_start = CurTime()
   end
   self.spec_ragdoll = s
end
function plymeta:GetRagdollSpec() return self.spec_ragdoll end

AccessorFunc(plymeta, "force_spec", "ForceSpec", FORCE_BOOL)

--- Karma

-- The base/start karma is determined once per round and determines the player's
-- damage penalty. It is networked and shown on clients.
function plymeta:SetBaseKarma(k)
   self:SetNWFloat("karma", k)
end

-- The live karma starts equal to the base karma, but is updated "live" as the
-- player damages/kills others. When another player damages/kills this one, the
-- live karma is used to determine his karma penalty.
AccessorFunc(plymeta, "live_karma", "LiveKarma", FORCE_NUMBER)

-- The damage factor scales how much damage the player deals, so if it is .9
-- then the player only deals 90% of his original damage.
AccessorFunc(plymeta, "dmg_factor", "DamageFactor", FORCE_NUMBER)

-- If a player does not damage team members in a round, he has a "clean" round
-- and gets a bonus for it.
AccessorFunc(plymeta, "clean_round", "CleanRound", FORCE_BOOL)

function plymeta:InitKarma()
   KARMA.InitPlayer(self)
end

--- Equipment credits
function plymeta:SetCredits(amt)
   self.equipment_credits = amt
   self:SendCredits()
end

function plymeta:AddCredits(amt)
   self:SetCredits(self:GetCredits() + amt)
end
function plymeta:SubtractCredits(amt) self:AddCredits(-amt) end

function plymeta:SetDefaultCredits()
   if self:GetTraitor() then
      local c = GetConVarNumber("ttt_credits_starting")
      if CountTraitors() == 1 then
         c = c + GetConVarNumber("ttt_credits_alonebonus")
      end
      self:SetCredits(math.ceil(c))
   elseif self:GetDetective() then
      self:SetCredits(math.ceil(GetConVarNumber("ttt_det_credits_starting")))
   else
      self:SetCredits(0)
   end
end

function plymeta:SendCredits()
   umsg.Start("credits", self)
   umsg.Char(self:GetCredits())
   umsg.End()
end

--- Equipment items
function plymeta:AddEquipmentItem(id)
   id = tonumber(id)
   if id then
      self.equipment_items = bit.bor(self.equipment_items, id)
      self:SendEquipment()
   end
end

-- We do this instead of an NW var in order to limit the info to just this ply
function plymeta:SendEquipment()
   umsg.Start("equipment", self)
   umsg.Short(self.equipment_items)
   umsg.End()
end

function plymeta:ResetEquipment()
   self.equipment_items = EQUIP_NONE
   self:SendEquipment()
end

function plymeta:SendBought()
   -- Send all as string, even though equipment are numbers, for simplicity
   umsg.Start("bought", self)
   umsg.Short(#self.bought)
   for k,v in pairs(self.bought) do
      umsg.String(v)
   end
   umsg.End()
end

local function ResendBought(ply)
   if IsValid(ply) then ply:SendBought() end
end
concommand.Add("ttt_resend_bought", ResendBought)

function plymeta:ResetBought()
   self.bought = {}
   self:SendBought()
end

function plymeta:AddBought(id)
   if not self.bought then self.bought = {} end

   table.insert(self.bought, tostring(id))

   self:SendBought()
end


-- Strips player of all equipment
function plymeta:StripAll()
   -- standard stuff
   self:StripAmmo()
   self:StripWeapons()

   -- our stuff
   self:ResetEquipment()
   self:SetCredits(0)
end

-- Sets all flags (force_spec, etc) to their default
function plymeta:ResetStatus()
   self:SetRole(ROLE_INNOCENT)
   self:SetRagdollSpec(false)
   self:SetForceSpec(false)

   self:ResetRoundFlags()
end

-- Sets round-based misc flags to default position. Called at PlayerSpawn.
function plymeta:ResetRoundFlags()
   -- equipment
   self:ResetEquipment()
   self:SetCredits(0)

   self:ResetBought()

   -- equipment stuff
   self.bomb_wire = nil
   self.radar_charge = 0
   self.decoy = nil

   -- corpse
   self:SetNWBool("body_found", false)

   self.kills = {}

   self.dying_wep = nil
   self.was_headshot = false

   -- communication
   self.mute_team = -1
   self.traitor_gvoice = false

   self:SetNWBool("disguised", false)

   -- karma
   self:SetCleanRound(true)

   self:Freeze(false)
end

function plymeta:GiveEquipmentItem(id)
   if self:HasEquipmentItem(id) then
      return false
   elseif id and id > EQUIP_NONE then
      self:AddEquipmentItem(id)
      return true
   end
end

-- Forced specs and latejoin specs should not get points
function plymeta:ShouldScore()
   if self:GetForceSpec() then
      return false
   elseif self:IsSpec() and self:Alive() then
      return false
   else
      return true
   end
end

function plymeta:RecordKill(victim)
   if not IsValid(victim) then return end

   if not self.kills then
      self.kills = {}
   end

   table.insert(self.kills, victim:UniqueID())
end


function plymeta:SetSpeed(slowed)
   if slowed then
      self:SetWalkSpeed(120)
      self:SetRunSpeed(120)
      self:SetMaxSpeed(120)
   else
      self:SetWalkSpeed(220)
      self:SetRunSpeed(220)
      self:SetMaxSpeed(220)
   end
end

function plymeta:ResetLastWords()
   if not IsValid(self) then return end -- timers are dangerous things
   self.last_words_id = nil
end

function plymeta:SendLastWords(dmginfo)
   -- Use a pseudo unique id to prevent people from abusing the concmd
   self.last_words_id = math.floor(CurTime() + math.random(500))

   -- See if the damage was interesting
   local dtype = KILL_NORMAL
   if dmginfo:GetAttacker() == self or dmginfo:GetInflictor() == self then
      dtype = KILL_SUICIDE
   elseif dmginfo:IsDamageType(DMG_BURN) then
      dtype = KILL_BURN
   elseif dmginfo:IsFallDamage() then
      dtype = KILL_FALL
   end

   self.death_type = dtype

   umsg.Start("interrupt_chat", self)
   umsg.Long(self.last_words_id)
   umsg.End()

   -- any longer than this and you're out of luck
   local ply = self
   timer.Simple(2, function() ply:ResetLastWords() end)
end


function plymeta:ResetViewRoll()
   local ang = self:EyeAngles()
   if ang.r != 0 then
      ang.r = 0
      self:SetEyeAngles(ang)
   end
end


function plymeta:ShouldSpawn()
   -- do not spawn players who have not been through initspawn
   if (not self:IsSpec()) and (not self:IsTerror()) then return false end
   -- do not spawn forced specs
   if self:IsSpec() and self:GetForceSpec() then return false end

   return true
end

-- Preps a player for a new round, spawning them if they should. If dead_only is
-- true, only spawns if player is dead, else just makes sure he is healed.
function plymeta:SpawnForRound(dead_only)
   GAMEMODE:PlayerSetModel(self)

   -- wrong alive status and not a willing spec who unforced after prep started
   -- (and will therefore be "alive")
   if dead_only and self:Alive() and (not self:IsSpec()) then
      -- if the player does not need respawn, make sure he has full health
      self:SetHealth(self:GetMaxHealth())
      return false
   end

   if not self:ShouldSpawn() then return false end

   -- respawn anyone else
   if self:Team() == TEAM_SPEC then
      self:UnSpectate()
   end

   self:StripAll()
   self:SetTeam(TEAM_TERROR)
   self:Spawn()

   -- tell caller that we spawned
   return true
end

function plymeta:InitialSpawn()
   self.has_spawned = false

   -- The team the player spawns on depends on the round state
   self:SetTeam(GetRoundState() == ROUND_PREP and TEAM_TERROR or TEAM_SPEC)

   -- Change some gmod defaults
   self:SetCanZoom(false)
   self:SetJumpPower(160)
   self:SetSpeed(false)
   self:SetCrouchedWalkSpeed(0.3)

   -- Always spawn innocent initially, traitor will be selected later
   self:ResetStatus()

   -- Start off with clean, full karma (unless it can and should be loaded)
   self:InitKarma()

   -- We never have weapons here, but this inits our equipment state
   self:StripAll()
end

function plymeta:KickBan(length, reason)
   -- see admin.lua
   PerformKickBan(self, length, reason)
end

local oldSpectate = plymeta.Spectate
function plymeta:Spectate(type)
   oldSpectate(self, type)

   -- NPCs should never see spectators. A workaround for the fact that gmod NPCs
   -- do not ignore them by default.
   self:SetNoTarget(true)

   if type == OBS_MODE_ROAMING then
      self:SetMoveType(MOVETYPE_NOCLIP)
   end
end

local oldSpectateEntity = plymeta.SpectateEntity
function plymeta:SpectateEntity(ent)
   oldSpectateEntity(self, ent)

   if IsValid(ent) and ent:IsPlayer() then
      self:SetPlayerHands(ent)
   end
end

local oldUnSpectate = plymeta.UnSpectate
function plymeta:UnSpectate()
   oldUnSpectate(self)
   self:SetNoTarget(false)
end

function plymeta:GetAvoidDetective()
   return self:GetInfoNum("ttt_avoid_detective", 0) > 0
end

-- Sets hands to be the correct model for given player and attaches to their
-- viewmodel. Note that the player is not necessarily *self*, but can be a
-- spectated player.
function plymeta:SetPlayerHands(ply)
   local hands = self:GetHands()
   if not IsValid(hands) or not IsValid(ply) then return end

   -- Find hands model
   local simplemodel = util.GetSimpleModelName(ply:GetModel())
   local info = player_manager.TranslatePlayerHands(simplemodel)
   if info then
      hands:SetModel(info.model)
      hands:SetSkin(info.skin)
      hands:SetBodyGroups(info.body)
   end

   -- Attach to vm
   local vm = ply:GetViewModel(0)
   if vm then
      hands:AttachToViewmodel(vm)
      vm:DeleteOnRemove(hands)
   end
end
