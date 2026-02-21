---- Karma system stuff

KARMA = {}

-- ply steamid64 -> karma table for disconnected players who might reconnect
KARMA.RememberedPlayers = {}

-- Convars, more convenient access than GetConVar bla bla
KARMA.cv = {}
KARMA.cv.enabled     = CreateConVar("ttt_karma", "1", FCVAR_ARCHIVE)
KARMA.cv.strict      = CreateConVar("ttt_karma_strict", "1")
KARMA.cv.starting    = CreateConVar("ttt_karma_starting", "1000")
KARMA.cv.max         = CreateConVar("ttt_karma_max", "1000")
KARMA.cv.ratio       = CreateConVar("ttt_karma_ratio", "0.001")
KARMA.cv.killpenalty = CreateConVar("ttt_karma_kill_penalty", "15")
KARMA.cv.roundheal   = CreateConVar("ttt_karma_round_increment", "5")
KARMA.cv.clean  = CreateConVar("ttt_karma_clean_bonus", "30")
KARMA.cv.tbonus = CreateConVar("ttt_karma_traitorkill_bonus", "40")
KARMA.cv.tratio = CreateConVar("ttt_karma_traitordmg_ratio", "0.0003")
KARMA.cv.debug  = CreateConVar("ttt_karma_debugspam", "0")

KARMA.cv.persist = CreateConVar("ttt_karma_persist", "0")
KARMA.cv.falloff = CreateConVar("ttt_karma_clean_half", "0.25")

KARMA.cv.autokick  = CreateConVar("ttt_karma_low_autokick", "1")
KARMA.cv.kicklevel = CreateConVar("ttt_karma_low_amount", "450")
KARMA.cv.autoban   = CreateConVar("ttt_karma_low_ban", "1")
KARMA.cv.bantime   = CreateConVar("ttt_karma_low_ban_minutes", "60")

local config = KARMA.cv

local function IsDebug() return config.debug:GetBool() end

local math = math

cvars.AddChangeCallback("ttt_karma_max", function(cvar, old, new)
   SetGlobalInt("ttt_karma_max", new)
end)

function KARMA.InitState()
   SetGlobalBool("ttt_karma", config.enabled:GetBool())
   SetGlobalInt("ttt_karma_max", config.max:GetFloat())
end

function KARMA.IsEnabled()
   return GetGlobalBool("ttt_karma", false)
end

-- Compute penalty for hurting someone a certain amount
function KARMA.GetHurtPenalty(victim_karma, dmg)
   return victim_karma * math.Clamp(dmg * config.ratio:GetFloat(), 0, 1)
end

-- Compute penalty for killing someone
function KARMA.GetKillPenalty(victim_karma)
   -- the kill penalty handled like dealing a bit of damage
   return KARMA.GetHurtPenalty(victim_karma, config.killpenalty:GetFloat())
end

-- Compute reward for hurting a traitor (when innocent yourself)
function KARMA.GetHurtReward(dmg)
   return config.max:GetFloat() * math.Clamp(dmg * config.tratio:GetFloat(), 0, 1)
end

-- Compute reward for killing traitor
function KARMA.GetKillReward()
   return KARMA.GetHurtReward(config.tbonus:GetFloat())
end

function KARMA.GivePenalty(ply, penalty, victim)
        if not hook.Call( "TTTKarmaGivePenalty", nil, ply, penalty, victim ) then
                ply:SetLiveKarma(math.max(ply:GetLiveKarma() - penalty, 0))
        end
end

function KARMA.GiveReward(ply, reward)
   reward = KARMA.DecayedMultiplier(ply) * reward
   ply:SetLiveKarma(math.min(ply:GetLiveKarma() + reward, config.max:GetFloat()))
   return reward
end

function KARMA.ApplyKarma(ply)
   local df = 1

   -- any karma at 1000 or over guarantees a df of 1, only when it's lower do we
   -- need the penalty curve
   if ply:GetBaseKarma() < 1000 and KARMA.IsEnabled() then
      local k = ply:GetBaseKarma() - 1000
      if config.strict:GetBool() then
         -- this penalty curve sinks more quickly, less parabolic
         df = 1 + (0.0007 * k) + (-0.000002 * (k^2))
      else
         df = 1 + -0.0000025 * (k^2)
      end
   end

   ply:SetDamageFactor(math.Clamp(df, 0.1, 1.0))

   if IsDebug() then
      print(Format("%s has karma %f and gets df %f", ply:Nick(), ply:GetBaseKarma(), df))
   end
end

-- Return true if a traitor could have easily avoided the damage/death
local function WasAvoidable(attacker, victim, dmginfo)
   local infl = dmginfo:GetInflictor()
   if attacker:IsTraitor() and victim:IsTraitor() and IsValid(infl) and infl.Avoidable then
      return true
   end

   return false
end

-- Handle karma change due to one player damaging another. Damage must not have
-- been applied to the victim yet, but must have been scaled according to the
-- damage factor of the attacker.
function KARMA.Hurt(attacker, victim, dmginfo)
   if not IsValid(attacker) or not IsValid(victim) then return end
   if attacker == victim then return end
   if not attacker:IsPlayer() or not victim:IsPlayer() then return end

   -- Ignore excess damage
   local hurt_amount = math.min(victim:Health(), dmginfo:GetDamage())

   if attacker:GetTraitor() == victim:GetTraitor() then
      if WasAvoidable(attacker, victim, dmginfo) then return end

      local penalty = KARMA.GetHurtPenalty(victim:GetLiveKarma(), hurt_amount)

      KARMA.GivePenalty(attacker, penalty, victim)

      attacker:SetCleanRound(false)

      if IsDebug() then
         print(Format("%s (%f) attacked %s (%f) for %d and got penalised for %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), hurt_amount, penalty))
      end
   elseif (not attacker:GetTraitor()) and victim:GetTraitor() then
      local reward = KARMA.GetHurtReward(hurt_amount)
      reward = KARMA.GiveReward(attacker, reward)

      if IsDebug() then
         print(Format("%s (%f) attacked %s (%f) for %d and got REWARDED %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), hurt_amount, reward))
      end
   end
end


-- Handle karma change due to one player killing another.
function KARMA.Killed(attacker, victim, dmginfo)
   if not IsValid(attacker) or not IsValid(victim) then return end
   if attacker == victim then return end
   if not attacker:IsPlayer() or not victim:IsPlayer() then return end

   if attacker:GetTraitor() == victim:GetTraitor() then
      -- don't penalise attacker for stupid victims
      if WasAvoidable(attacker, victim, dmginfo) then return end

      local penalty = KARMA.GetKillPenalty(victim:GetLiveKarma())

      KARMA.GivePenalty(attacker, penalty, victim)

      attacker:SetCleanRound(false)

      if IsDebug() then
         print(Format("%s (%f) killed %s (%f) and gets penalised for %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), penalty))
      end
   elseif (not attacker:GetTraitor()) and victim:GetTraitor() then
      local reward = KARMA.GetKillReward()
      reward = KARMA.GiveReward(attacker, reward)

      if IsDebug() then
         print(Format("%s (%f) killed %s (%f) and gets REWARDED %f", attacker:Nick(), attacker:GetLiveKarma(), victim:Nick(), victim:GetLiveKarma(), reward))
      end
   end
end

local expdecay = math.ExponentialDecay
function KARMA.DecayedMultiplier(ply)
   local max   = config.max:GetFloat()
   local start = config.starting:GetFloat()
   local k     = ply:GetLiveKarma()

   if config.falloff:GetFloat() <= 0 or k < start then
      return 1
   elseif k < max then
      -- if falloff is enabled, then if our karma is above the starting value,
      -- our round bonus is going to start decreasing as our karma increases
      local basediff = max - start
      local plydiff  = k - start
      local half     = math.Clamp(config.falloff:GetFloat(), 0.01, 0.99)

      -- exponentially decay the bonus such that when the player's excess karma
      -- is at (basediff * half) the bonus is half of the original value
      return expdecay(basediff * half, plydiff)
   end

   return 1
end

-- Handle karma regeneration upon the start of a new round
function KARMA.RoundIncrement()
   local healbonus = config.roundheal:GetFloat()
   local cleanbonus = config.clean:GetFloat()

   for _, ply in player.Iterator() do
      if ply:IsDeadTerror() and ply.death_type ~= KILL_SUICIDE or not ply:IsSpec() then
         local bonus = healbonus + (ply:GetCleanRound() and cleanbonus or 0)
         KARMA.GiveReward(ply, bonus)

         if IsDebug() then
            print(ply, "gets roundincr", incr)
         end
      end
   end

   -- player's CleanRound state will be reset by the ply class
end

-- When a new round starts, Live karma becomes Base karma
function KARMA.Rebase()
   for _, ply in player.Iterator() do
      if IsDebug() then
         print(ply, "rebased from", ply:GetBaseKarma(), "to", ply:GetLiveKarma())
      end

      ply:SetBaseKarma(ply:GetLiveKarma())
   end
end

-- Apply karma to damage factor for all players
function KARMA.ApplyKarmaAll()
   for _, ply in player.Iterator() do
      KARMA.ApplyKarma(ply)
   end
end

function KARMA.NotifyPlayer(ply)
   local df = ply:GetDamageFactor() or 1
   local k = math.Round(ply:GetBaseKarma())
   if df > 0.99 then
      LANG.Msg(ply, "karma_dmg_full", {amount = k})
   else
      LANG.Msg(ply, "karma_dmg_other",
               {amount = k,
                num = math.ceil((1 - df) * 100)})
   end
end

-- These generic fns will be called at round end and start, so that stuff can
-- easily be moved to a different phase
function KARMA.RoundEnd()
   if KARMA.IsEnabled() then
      KARMA.RoundIncrement()

      -- if karma trend needs to be shown in round report, may want to delay
      -- rebase until start of next round
      KARMA.Rebase()

      KARMA.RememberAll()

      if config.autokick:GetBool() then
         KARMA.CheckAutoKickAll()
      end
   end
end

function KARMA.RoundBegin()
   KARMA.InitState()

   if KARMA.IsEnabled() then
      for _, ply in player.Iterator() do
         KARMA.ApplyKarma(ply)

         KARMA.NotifyPlayer(ply)
      end
   end
end

function KARMA.InitPlayer(ply)
   local k = KARMA.Recall(ply) or config.starting:GetFloat()

   k = math.Clamp(k, 0, config.max:GetFloat())

   ply:SetBaseKarma(k)
   ply:SetLiveKarma(k)
   ply:SetCleanRound(true)
   ply:SetDamageFactor(1.0)

   -- compute the damagefactor based on actual (possibly loaded) karma
   KARMA.ApplyKarma(ply)
end

function KARMA.Remember(ply)
   if ply.karma_kicked or (not ply:IsFullyAuthenticated()) then return end

   -- use sql if persistence is on
   if config.persist:GetBool() then
      ply:SetPData("karma_stored", ply:GetLiveKarma())
   end

   -- if persist is on, this is purely a backup method
   KARMA.RememberedPlayers[ply:SteamID64()] = ply:GetLiveKarma()
end

function KARMA.Recall(ply)
   if config.persist:GetBool()then
      ply.delay_karma_recall = not ply:IsFullyAuthenticated()

      if ply:IsFullyAuthenticated() then
         local k = tonumber(ply:GetPData("karma_stored", nil))
         if k then
            return k
         end
      end
   end

   return KARMA.RememberedPlayers[ply:SteamID64()]
end

function KARMA.LateRecallAndSet(ply)
   local k = tonumber(ply:GetPData("karma_stored", KARMA.RememberedPlayers[ply:SteamID64()]))
   if k and k < ply:GetLiveKarma() then
      ply:SetBaseKarma(k)
      ply:SetLiveKarma(k)
   end
end

function KARMA.RememberAll()
   for _, ply in player.Iterator() do
      KARMA.Remember(ply)
   end
end

local reason = "Karma too low"
function KARMA.CheckAutoKick(ply)
   if ply:GetBaseKarma() <= config.kicklevel:GetInt() then
      if hook.Call("TTTKarmaLow", GAMEMODE, ply) == false then
         return
      end
      ServerLog(ply:Nick() .. " autokicked/banned for low karma.\n")

      -- flag player as autokicked so we don't perform the normal player
      -- disconnect logic
      ply.karma_kicked = true

      if config.persist:GetBool() then
         local k = math.Clamp(config.starting:GetFloat() * 0.8, config.kicklevel:GetFloat() * 1.1, config.max:GetFloat())
         ply:SetPData("karma_stored", k)
         KARMA.RememberedPlayers[ply:SteamID64()] = k
      end

      if config.autoban:GetBool() then
         ply:KickBan(config.bantime:GetInt(), reason)
      else
         ply:Kick(reason)
      end
   end
end

function KARMA.CheckAutoKickAll()
   for _, ply in player.Iterator() do
      KARMA.CheckAutoKick(ply)
   end
end

function KARMA.PrintAll(printfn)
   for _, ply in player.Iterator() do
      printfn(Format("%s : Live = %f -- Base = %f -- Dmg = %f\n",
                     ply:Nick(),
                     ply:GetLiveKarma(), ply:GetBaseKarma(),
                     ply:GetDamageFactor() * 100))
   end
end
