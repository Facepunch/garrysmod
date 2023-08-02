--- Admin commands

local function GetPrintFn(ply)
   if IsValid(ply) then
      return function(...)
                local t = ""
                for _, a in ipairs({...}) do
                   t = t .. "\t" .. a
                end
                ply:PrintMessage(HUD_PRINTCONSOLE, t)
             end
   else
      return print
   end
end

local function TraitorSort(a,b)
   if not IsValid(a) then return true end
   if not IsValid(b) then return false end

   if a:GetTraitor() and (not b:GetTraitor()) then return true end
   if b:GetTraitor() and (not a:GetTraitor()) then return false end

   return false
end

function PrintTraitors(ply)
   if not IsValid(ply) or ply:IsSuperAdmin() then
      ServerLog(Format("%s used ttt_print_traitors\n", IsValid(ply) and ply:Nick() or "console"))

      local pr = GetPrintFn(ply)

      local ps = player.GetAll()
      table.sort(ps, TraitorSort)

      for _, p in ipairs(ps) do
         if IsValid(p) then
            pr(p:GetTraitor() and "TRAITOR" or "Innocent", ":", p:Nick())
         end
      end
   end
end
concommand.Add("ttt_print_traitors", PrintTraitors)

function PrintGroups(ply)
   local pr = GetPrintFn(ply)

   pr("User", "-", "Group")
   for _, p in ipairs(player.GetAll()) do
      pr(p:Nick(), "-", p:GetNWString("UserGroup"))
   end
end
concommand.Add("ttt_print_usergroups", PrintGroups)

function PrintReport(ply)
   local pr = GetPrintFn(ply)

   if not IsValid(ply) or ply:IsSuperAdmin() then
      ServerLog(Format("%s used ttt_print_adminreport\n", IsValid(ply) and ply:Nick() or "console"))

      for k, e in pairs(SCORE.Events) do
         if e.id == EVENT_KILL then
            if e.att.sid == -1 then
               pr("<something> killed " .. e.vic.ni .. (e.vic.tr and " [TRAITOR]" or " [inno.]"))
            else
               pr(e.att.ni .. (e.att.tr and " [TRAITOR]" or " [inno.]") .. " killed " .. e.vic.ni .. (e.vic.tr and " [TRAITOR]" or " [inno.]"))
            end
         end
      end
   else
      if IsValid(ply) then
         pr("You do not appear to be RCON or a superadmin!")
      end
   end
end
concommand.Add("ttt_print_adminreport", PrintReport)

local function PrintKarma(ply)
   local pr = GetPrintFn(ply)

   if (not IsValid(ply)) or ply:IsSuperAdmin() then
      ServerLog(Format("%s used ttt_print_karma\n", IsValid(ply) and ply:Nick() or "console"))

      KARMA.PrintAll(pr)

   else
      if IsValid(ply) then
         pr("You do not appear to be RCON or a superadmin!")
      end
   end
end
concommand.Add("ttt_print_karma", PrintKarma)


CreateConVar("ttt_highlight_admins", "1")
local function ApplyHighlightAdmins(cv, old, new)
   SetGlobalBool("ttt_highlight_admins", tobool(tonumber(new)))
end
cvars.AddChangeCallback("ttt_highlight_admins", ApplyHighlightAdmins)


local dmglog_console = CreateConVar("ttt_log_damage_for_console", "1")
local dmglog_save    = CreateConVar("ttt_damagelog_save", "0")

local function PrintDamageLog(ply)
   local pr = GetPrintFn(ply)

   if (not IsValid(ply)) or ply:IsSuperAdmin() or GetRoundState() != ROUND_ACTIVE then
      ServerLog(Format("%s used ttt_print_damagelog\n", IsValid(ply) and ply:Nick() or "console"))
      pr("*** Damage log:\n")

      if not dmglog_console:GetBool() then
         pr("Damage logging for console disabled. Enable with ttt_log_damage_for_console 1.")
      end

      for k, txt in ipairs(GAMEMODE.DamageLog) do
         pr(txt)
      end

      pr("*** Damage log end.")
   else
      if IsValid(ply) then
         pr("You do not appear to be RCON or a superadmin, nor are we in the post-round phase!")
      end
   end
end
concommand.Add("ttt_print_damagelog", PrintDamageLog)


local function SaveDamageLog()
   if not dmglog_save:GetBool() then return end

   local text = ""
   if #GAMEMODE.DamageLog == 0 then
      text = "Damage log is empty."
   else
      for k, txt in ipairs(GAMEMODE.DamageLog) do
         text = text .. txt .. "\n"
      end
   end

   local fname = Format("ttt/logs/dmglog_%s_%d.txt",
                        os.date("%d%b%Y_%H%M"),
                        os.time())
   file.Write(fname, text)
end
hook.Add("TTTEndRound", "ttt_damagelog_save_hook", SaveDamageLog)

function DamageLog(txt)
   local t = math.max(0, CurTime() - GAMEMODE.RoundStartTime)

   txt = util.SimpleTime(t, "%02i:%02i.%02i - ") .. txt
   ServerLog(txt .. "\n")

   if dmglog_console:GetBool() or dmglog_save:GetBool() then
      table.insert(GAMEMODE.DamageLog, txt)
   end
end


local ttt_bantype = CreateConVar("ttt_ban_type", "autodetect")

local function DetectServerPlugin()
   if ULib and ULib.kickban then
      return "ulx"
   elseif evolve and evolve.Ban then
      return "evolve"
   elseif exsto and exsto.GetPlugin('administration') then
      return "exsto"
   else
      return "gmod"
   end
end

local function StandardBan(ply, length, reason)
   RunConsoleCommand("banid", length, ply:UserID())
   ply:Kick(reason)
end

local ban_functions = {
   ulx    = ULib and ULib.kickban, -- has (ply, length, reason) signature

   evolve = function(p, l, r)
               evolve:Ban(p:UniqueID(), l * 60, r) -- time in seconds
            end,

   sm     = function(p, l, r)
               game.ConsoleCommand(Format("sm_ban \"#%s\" %d \"%s\"\n", p:SteamID(), l, r))
            end,

   exsto  = function(p, l, r)
               local adm = exsto.GetPlugin('administration')
               if adm and adm.Ban then
                  adm:Ban(nil, p, l, r)
               end
            end,

   gmod   = StandardBan
};

local function BanningFunction()
   local bantype = string.lower(ttt_bantype:GetString())
   if bantype == "autodetect" then
      bantype = DetectServerPlugin()
   end

   print("Banning using " .. bantype .. " method.")

   return ban_functions[bantype] or ban_functions["gmod"]
end

function PerformKickBan(ply, length, reason)
   local banfn = BanningFunction()

   banfn(ply, length, reason)
end
