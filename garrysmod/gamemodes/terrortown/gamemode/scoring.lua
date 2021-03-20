---- Customized scoring

local math = math
local string = string
local table = table
local pairs = pairs

SCORE = SCORE or {}
SCORE.Events = SCORE.Events or {}

include("scoring_shd.lua")

-- One might wonder why all the key names in the event tables are so annoyingly
-- short. Well, the serialisation module in gmod (glon) does not do any
-- compression. At all. This means the difference between all events having a
-- "time_added" key versus a "t" key is very significant for the amount of data
-- we need to send. It's a pain, but I'm not going to code my own compression,
-- so doing it manually is the only way.

-- One decent way to reduce data sent turned out to be rounding the time floats.
-- We don't actually need to know about 10000ths of seconds after all.

function SCORE:AddEvent(entry, t_override)
   entry.t = t_override or CurTime()
   table.insert(self.Events, entry)
end

local function CopyDmg(dmg)
   local wep = util.WeaponFromDamage(dmg)
   local g, n

   if wep then
      local id = WepToEnum(wep)
      if id then
         g = id
      else
         -- we can convert each standard TTT weapon name to a preset ID, but
         -- that's not workable with custom SWEPs from people, so we'll just
         -- have to pay the byte tax there
         g = wep:GetClass()
      end
   else
      local infl = dmg:GetInflictor()
      if IsValid(infl) and infl.ScoreName then
         n = infl.ScoreName
      end
   end

   -- t = type, a = amount, g = gun, h = headshot, n = name
   return {
      t = dmg:GetDamageType(),
      a = dmg:GetDamage(),
      h = false,
      g = g,
      n = n
   }
end

function SCORE:HandleKill(victim, attacker, dmginfo)
   if not (IsValid(victim) and victim:IsPlayer()) then return end

   local e = {
      id=EVENT_KILL,
      att={ni="", sid=-1, tr=false},
      vic={ni=victim:Nick(), sid=victim:SteamID(), tr=false},
      dmg=CopyDmg(dmginfo)};

   e.dmg.h = victim.was_headshot

   e.vic.tr = victim:GetTraitor()

   if IsValid(attacker) and attacker:IsPlayer() then
      e.att.ni = attacker:Nick()
      e.att.sid = attacker:SteamID()
      e.att.tr = attacker:GetTraitor()

      -- If a traitor gets himself killed by another traitor's C4, it's his own
      -- damn fault for ignoring the indicator.
      if dmginfo:IsExplosionDamage() and attacker:GetTraitor() and victim:GetTraitor() then
         local infl = dmginfo:GetInflictor()
         if IsValid(infl) and infl:GetClass() == "ttt_c4" then
            e.att = table.Copy(e.vic)
         end
      end
   end

   self:AddEvent(e)
end

function SCORE:HandleSpawn(ply)
   if ply:Team() == TEAM_TERROR then
      self:AddEvent({id=EVENT_SPAWN, ni=ply:Nick(), sid=ply:SteamID()})
   end
end

function SCORE:HandleSelection()
   local traitors = {}
   local detectives = {}
   for k, ply in ipairs(player.GetAll()) do
      if ply:GetTraitor() then
         table.insert(traitors, ply:SteamID())
      elseif ply:GetDetective() then
         table.insert(detectives, ply:SteamID())
      end
   end

   self:AddEvent({id=EVENT_SELECTED, traitor_ids=traitors, detective_ids=detectives})
end

function SCORE:HandleBodyFound(finder, found)
   self:AddEvent({id=EVENT_BODYFOUND, ni=finder:Nick(), sid=finder:SteamID(), b=found:Nick()})
end

function SCORE:HandleC4Explosion(planter, arm_time, exp_time)
   local nick = "Someone"
   if IsValid(planter) and planter:IsPlayer() then
      nick = planter:Nick()
   end

   self:AddEvent({id=EVENT_C4PLANT, ni=nick}, arm_time)
   self:AddEvent({id=EVENT_C4EXPLODE, ni=nick}, exp_time)
end

function SCORE:HandleC4Disarm(disarmer, owner, success)
   if disarmer == owner then return end
   if not IsValid(disarmer) then return end

   local ev = {
      id = EVENT_C4DISARM,
      ni = disarmer:Nick(),
      s  = success
   };

   if IsValid(owner) then
      ev.own = owner:Nick()
   end

   self:AddEvent(ev)
end

function SCORE:HandleCreditFound(finder, found_nick, credits)
   self:AddEvent({id=EVENT_CREDITFOUND, ni=finder:Nick(), sid=finder:SteamID(), b=found_nick, cr=credits})
end

function SCORE:ApplyEventLogScores(wintype)
   local scores = {}
   local traitors = {}
   local detectives = {}
   for k, ply in ipairs(player.GetAll()) do
      scores[ply:SteamID()] = {}

      if ply:GetTraitor() then
         table.insert(traitors, ply:SteamID())
      elseif ply:GetDetective() then
         table.insert(detectives, ply:SteamID())
      end
   end

   -- individual scores, and count those left alive
   local alive = {traitors = 0, innos = 0}
   local dead = {traitors = 0, innos = 0}
   local scored_log = ScoreEventLog(self.Events, scores, traitors, detectives)
   local ply = nil
   for sid, s in pairs(scored_log) do
      ply = player.GetBySteamID(sid)
      if ply and ply:ShouldScore() then
         ply:AddFrags(KillsToPoints(s, ply:GetTraitor()))
      end
   end

   -- team scores
   local bonus = ScoreTeamBonus(scored_log, wintype)

   for sid, s in pairs(scored_log) do
      ply = player.GetBySteamID(sid)
      if ply and ply:ShouldScore() then
         ply:AddFrags(ply:GetTraitor() and bonus.traitors or bonus.innos)
      end
   end

   -- count deaths
   local events = self.Events
   for i = 1, #events do
      local e = events[i]
      if e.id == EVENT_KILL then
         local victim = player.GetBySteamID(e.vic.sid)
         if IsValid(victim) and victim:ShouldScore() then
            victim:AddDeaths(1)
         end
      end
   end
end

function SCORE:RoundStateChange(newstate)
   self:AddEvent({id=EVENT_GAME, state=newstate})
end

function SCORE:RoundComplete(wintype)
   self:AddEvent({id=EVENT_FINISH, win=wintype})
end

function SCORE:Reset()
   self.Events = {}
end

function SCORE:StreamToClients()
   local events = util.TableToJSON(self.Events)
   if events == nil then
      ErrorNoHalt("Round report event encoding failed!\n")
      return
   end

   events = util.Compress(events)
   if events == "" then
      ErrorNoHalt("Round report event compression failed!\n")
      return
   end

   -- divide into happy lil bits.
   -- this was necessary with user messages, now it's
   -- a just-in-case thing if a round somehow manages to be > 64K
   local len = #events
   local MaxStreamLength = SCORE.MaxStreamLength

   if len <= MaxStreamLength then
      net.Start("TTT_ReportStream")
         net.WriteUInt(len, 16)
         net.WriteData(events, len)
      net.Broadcast()
   else
      local curpos = 0

      repeat
         net.Start("TTT_ReportStream_Part")
            net.WriteData(string.sub(events, curpos + 1, curpos + MaxStreamLength + 1), MaxStreamLength)
         net.Broadcast()

         curpos = curpos + MaxStreamLength + 1
      until(len - curpos <= MaxStreamLength)

      net.Start("TTT_ReportStream")
         net.WriteUInt(len, 16)
         net.WriteData(string.sub(events, curpos + 1, len), len - curpos)
      net.Broadcast()
   end
end
