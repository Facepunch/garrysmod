-- Random stuff

if not util then return end

local math = math
local string = string
local table = table
local pairs = pairs

-- attempts to get the weapon used from a DamageInfo instance needed because the
-- GetAmmoType value is useless and inflictor isn't properly set (yet)
function util.WeaponFromDamage(dmg)
   local inf = dmg:GetInflictor()
   local wep = nil
   if IsValid(inf) then
      if inf:IsWeapon() or inf.Projectile then
         wep = inf
      elseif dmg:IsDamageType(DMG_DIRECT) or dmg:IsDamageType(DMG_CRUSH) then
         -- DMG_DIRECT is the player burning, no weapon involved
         -- DMG_CRUSH is physics or falling on someone
         wep = nil
      elseif inf:IsPlayer() then
         wep = inf:GetActiveWeapon()
         if not IsValid(wep) then
            -- this may have been a dying shot, in which case we need a
            -- workaround to find the weapon because it was dropped on death
            wep = IsValid(inf.dying_wep) and inf.dying_wep or nil
         end
      end
   end

   return wep
end

-- Gets the table for a SWEP or a weapon-SENT (throwing knife), so not
-- equivalent to weapons.Get. Do not modify the table returned by this, consider
-- as read-only.
function util.WeaponForClass(cls)
   local wep = weapons.GetStored(cls)

   if not wep then
      wep = scripted_ents.GetStored(cls)
      if wep then
         -- don't like to rely on this, but the alternative is
         -- scripted_ents.Get which does a full table copy, so only do
         -- that as last resort
         wep = wep.t or scripted_ents.Get(cls)
      end
   end

   return wep
end

function util.GetAlivePlayers()
   local alive = {}
   for k, p in pairs(player.GetAll()) do
      if IsValid(p) and p:Alive() and p:IsTerror() then
         table.insert(alive, p)
      end
   end

   return alive
end

function util.GetNextAlivePlayer(ply)
   local alive = util.GetAlivePlayers()

   if #alive < 1 then return nil end

   local prev = nil
   local choice = nil

   if IsValid(ply) then
      for k,p in pairs(alive) do
         if prev == ply then
            choice = p
         end

         prev = p
      end
   end

   if not IsValid(choice) then
      choice = alive[1]
   end

   return choice
end

-- Uppercases the first character only
function string.Capitalize(str)
   return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end
util.Capitalize = string.Capitalize

-- Color unpacking
function clr(color) return color.r, color.g, color.b, color.a; end

if CLIENT then
   -- Is screenpos on screen?
   function IsOffScreen(scrpos)
      return not scrpos.visible or scrpos.x < 0 or scrpos.y < 0 or scrpos.x > ScrW() or scrpos.y > ScrH()
   end
end

function AccessorFuncDT(tbl, varname, name)
   tbl["Get" .. name] = function(s) return s.dt and s.dt[varname] end
   tbl["Set" .. name] = function(s, v) if s.dt then s.dt[varname] = v end end
end

function util.PaintDown(start, effname, ignore)
   local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-256)), filter=ignore, mask=MASK_SOLID})

   util.Decal(effname, btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal)
end

local function DoBleed(ent)
   if not IsValid(ent) or (ent:IsPlayer() and (not ent:Alive() or not ent:IsTerror())) then
      return
   end

   local jitter = VectorRand() * 30
   jitter.z = 20

   util.PaintDown(ent:GetPos() + jitter, "Blood", ent)
end

-- Something hurt us, start bleeding for a bit depending on the amount
function util.StartBleeding(ent, dmg, t)
   if dmg < 5 or not IsValid(ent) then
      return
   end

   if ent:IsPlayer() and (not ent:Alive() or not ent:IsTerror()) then
      return
   end

   local times = math.Clamp(math.Round(dmg / 15), 1, 20)

   local delay = math.Clamp(t / times , 0.1, 2)

   if ent:IsPlayer() then
      times = times * 2
      delay = delay / 2
   end

   timer.Create("bleed" .. ent:EntIndex(), delay, times,
                function() DoBleed(ent) end)
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function util.EquipmentDestroyed(pos)
   local effect = EffectData()
   effect:SetOrigin(pos)
   util.Effect("cball_explode", effect)
   sound.Play(zapsound, pos)
end

-- Useful default behaviour for semi-modal DFrames
function util.BasicKeyHandler(pnl, kc)
   -- passthrough F5
   if kc == KEY_F5 then
      RunConsoleCommand("jpeg")
   else
      pnl:Close()
   end
end

function util.SafeRemoveHook(event, name)
   local h = hook.GetTable()
   if h and h[event] and h[event][name] then
      hook.Remove(event, name)
   end
end

function util.noop() end
function util.passthrough(x) return x end

-- Nice Fisher-Yates implementation, from Wikipedia
local rand = math.random
function table.Shuffle(t)
  local n = #t

  while n > 2 do
    -- n is now the last pertinent index
    local k = rand(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end

  return t
end

-- Override with nil check
function table.HasValue(tbl, val)
   if not tbl then return end

   for k, v in pairs(tbl) do
      if v == val then return true end
   end
   return false
end

-- Value equality for tables
function table.EqualValues(a, b)
   if a == b then return true end

   for k, v in pairs(a) do
      if v != b[k] then
         return false
      end
   end

   return true
end

-- Basic table.HasValue pointer checks are insufficient when checking a table of
-- tables, so this uses table.EqualValues instead.
function table.HasTable(tbl, needle)
   if not tbl then return end

   for k, v in pairs(tbl) do
      if v == needle then
         return true
      elseif table.EqualValues(v, needle) then
         return true
      end
   end
   return false
end

-- Returns copy of table with only specific keys copied
function table.CopyKeys(tbl, keys)
   if not (tbl and keys) then return end

   local out = {}
   local val = nil
   for _, k in pairs(keys) do
      val = tbl[k]
      if type(val) == "table" then
         out[k] = table.Copy(val)
      else
         out[k] = val
      end
   end
   return out
end

local gsub = string.gsub
-- Simple string interpolation:
-- string.Interp("{killer} killed {victim}", {killer = "Bob", victim = "Joe"})
-- returns "Bob killed Joe"
-- No spaces or special chars in parameter name, just alphanumerics.
function string.Interp(str, tbl)
   return gsub(str, '{(%w+)}', tbl)
end

-- Short helper for input.LookupBinding, returns capitalised key or a default
function Key(binding, default)
   local b = input.LookupBinding(binding)
   if not b then return default end

   return string.upper(b)
end

local exp = math.exp
-- Equivalent to ExponentialDecay from Source's mathlib.
-- Convenient for falloff curves.
function math.ExponentialDecay(halflife, dt)
   -- ln(0.5) = -0.69..
   return exp((-0.69314718 / halflife) * dt)
end

function Dev(level, ...)
   if cvars and cvars.Number("developer", 0) >= level then
      Msg("[TTT dev]")
      -- table.concat does not tostring, derp

      local params = {...}
      for i=1,#params do
         Msg(" " .. tostring(params[i]))
      end

      Msg("\n")
   end
end

function IsPlayer(ent)
   return ent and ent:IsValid() and ent:IsPlayer()
end

function IsRagdoll(ent)
   return ent and ent:IsValid() and ent:GetClass() == "prop_ragdoll"
end

local band = bit.band
function util.BitSet(val, bit)
   return band(val, bit) == bit
end

if CLIENT then
   local healthcolors = {
      healthy = Color(0, 255, 0, 255),
      hurt    = Color(170, 230, 10, 255),
      wounded = Color(230, 215, 10, 255),
      badwound= Color(255, 140, 0, 255),
      death   = Color(255, 0, 0, 255)
   };

   function util.HealthToString(health, maxhealth)
      maxhealth = maxhealth or 100

      if health > maxhealth * 0.9 then
         return "hp_healthy", healthcolors.healthy
      elseif health > maxhealth * 0.7 then
         return "hp_hurt", healthcolors.hurt
      elseif health > maxhealth * 0.45 then
         return "hp_wounded", healthcolors.wounded
      elseif health > maxhealth * 0.2 then
         return "hp_badwnd", healthcolors.badwound
      else
         return "hp_death", healthcolors.death
      end
   end

   local karmacolors = {
      max  = Color(255, 255, 255, 255),
      high = Color(255, 240, 135, 255),
      med  = Color(245, 220, 60, 255),
      low  = Color(255, 180, 0, 255),
      min  = Color(255, 130, 0, 255),
   };

   function util.KarmaToString(karma)
      local maxkarma = GetGlobalInt("ttt_karma_max", 1000)

      if karma > maxkarma * 0.89 then
         return "karma_max", karmacolors.max
      elseif karma > maxkarma * 0.8 then
         return "karma_high", karmacolors.high
      elseif karma > maxkarma * 0.65 then
         return "karma_med", karmacolors.med
      elseif karma > maxkarma * 0.5 then
         return "karma_low", karmacolors.low
      else
         return "karma_min", karmacolors.min
      end
   end

   function util.IncludeClientFile(file)
      include(file)
   end
else
   function util.IncludeClientFile(file)
      AddCSLuaFile(file)
   end
end

-- Like string.FormatTime but simpler (and working), always a string, no hour
-- support
function util.SimpleTime(seconds, fmt)
	if not seconds then seconds = 0 end

    local ms = (seconds - math.floor(seconds)) * 100
    seconds = math.floor(seconds)
    local s = seconds % 60
    seconds = (seconds - s) / 60
    local m = seconds % 60

    return string.format(fmt, m, s, ms)
end
