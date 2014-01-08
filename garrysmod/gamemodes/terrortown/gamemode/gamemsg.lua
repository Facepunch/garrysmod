---- Communicating game state to players

local umsg = umsg
local string = string
local table = table
local pairs = pairs

-- NOTE: most uses of the Msg functions here have been moved to the LANG
-- functions. These functions are essentially deprecated, though they won't be
-- removed and can safely be used by SWEPs and the like.

function GameMsg(msg)
   umsg.Start("game_msg")
   umsg.String(msg)
   umsg.Bool(false)
   umsg.End()
end

function CustomMsg(ply_or_rfilter, msg, clr)
   clr = clr or COLOR_WHITE

   umsg.Start("game_msg_color", ply_or_rfilter)
   umsg.String(msg)
   umsg.Short(clr.r)
   umsg.Short(clr.g)
   umsg.Short(clr.b)
   umsg.End()
end

-- Basic status message to single player or a recipientfilter
function PlayerMsg(ply_or_rfilter, msg, traitor_only)
   umsg.Start("game_msg", ply_or_rfilter)
   umsg.String(msg)
   umsg.Bool(traitor_only)
   umsg.End()
end

-- Traitor-specific message that will appear in a special color
function TraitorMsg(ply_or_rfilter, msg)
   PlayerMsg(ply_or_rfilter, msg, true)
end

-- Traitorchat
local function RoleChatMsg(sender, role, msg)
   umsg.Start("role_chat", GetRoleFilter(role))
   umsg.Char(role)
   umsg.Entity(sender)
   umsg.String(msg)
   umsg.End()
end


-- Round start info popup
function ShowRoundStartPopup()
   for k, v in pairs(player.GetAll()) do
      if IsValid(v) and v:Team() == TEAM_TERROR and v:Alive() then
         v:ConCommand("ttt_cl_startpopup")
      end
   end
end

local function GetPlayerFilter(pred)
   local filter = RecipientFilter()
   for k, v in pairs(player.GetAll()) do
      if IsValid(v) and pred(v) then
         filter:AddPlayer(v)
      end
   end
   return filter
end

function GetTraitorFilter(alive_only)
   return GetPlayerFilter(function(p) return p:GetTraitor() and (not alive_only or p:Alive()) end)
end

function GetDetectiveFilter(alive_only)
   return GetPlayerFilter(function(p) return p:IsDetective() and (not alive_only or p:Alive()) end)
end

function GetInnocentFilter(alive_only)
   return GetPlayerFilter(function(p) return (not p:IsTraitor()) and (not alive_only or p:Alive()) end)
end

function GetRoleFilter(role, alive_only)
   return GetPlayerFilter(function(p) return p:IsRole(role) and (not alive_only or p:Alive()) end)
end

---- Communication control
CreateConVar("ttt_limit_spectator_chat", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY)
CreateConVar("ttt_limit_spectator_voice", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY)

local mumbles = {"mumble", "mm", "hmm", "hum", "mum", "mbm", "mble", "ham", "mammaries", "political situation", "mrmm", "hrm", "uzbekistan", "mumu", "cheese export", "hmhm", "mmh", "mumble", "mphrrt", "mrh", "hmm", "mumble", "mbmm", "hmml", "mfrrm"}

-- While a round is active, spectators can only talk among themselves. When they
-- try to speak to all players they could divulge information about who killed
-- them. So we mumblify them. In detective mode, we shut them up entirely.
function GM:PlayerSay(ply, text, team_only)
   if not IsValid(ply) then return end

   if team_only and ply:Team() != TEAM_SPEC and GetRoundState() == ROUND_ACTIVE then
      if ply:IsSpecial() then
         -- traitor chat handling
         RoleChatMsg(ply, ply:GetRole(), text)
      else
         LANG.Msg(ply, "inno_globalchat_hint")
      end

      return ""
   end

   if (not team_only) and GetRoundState() == ROUND_ACTIVE and ply:Team() == TEAM_SPEC then
      if DetectiveMode() then
         LANG.Msg(ply, "spec_teamchat_hint")
         return ""
      end

      if not GetConVar("ttt_limit_spectator_chat"):GetBool() then
         return text
      end

      local filtered = {}
      for k, v in pairs(string.Explode(" ", text)) do
         -- grab word characters and whitelisted interpunction
         -- necessary or leetspeek will be used (by trolls especially)
         local word, interp = string.match(v, "(%a*)([%.,;!%?]*)")
         if word != "" then
            table.insert(filtered, mumbles[math.random(1, #mumbles)] .. interp)
         end
      end

      -- make sure we have something to say
      if table.Count(filtered) < 1 then
         table.insert(filtered, mumbles[math.random(1, #mumbles)])
      end

      table.insert( filtered, 1, "[MUMBLED]")
      return table.concat(filtered, " ")
   end

   return text
end


-- Mute players when we are about to run map cleanup, because it might cause
-- net buffer overflows on clients.
local mute_all = false
function MuteForRestart(state)
   mute_all = state
end


local loc_voice = GetConVar("ttt_locational_voice")

-- Of course voice has to be limited as well
function GM:PlayerCanHearPlayersVoice( listener, speaker )
   -- Enforced silence
   if mute_all then
      return false, false
   end

   if (not IsValid(speaker)) or (not IsValid(listener)) or (listener == speaker) then
      return false, false
   end

   -- limited if specific convar is on, or we're in detective mode
   local limit = DetectiveMode() or GetConVar("ttt_limit_spectator_voice"):GetBool()

   -- Spectators should not be heard by living players during round
   if speaker:IsSpec() and (not listener:IsSpec()) and limit and GetRoundState() == ROUND_ACTIVE then
      return false, false
   end

   -- Specific mute
   if listener:IsSpec() and listener.mute_team == speaker:Team() then
      return false, false
   end

   -- Specs should not hear each other locationally
   if speaker:IsSpec() and listener:IsSpec() then
      return true, false
   end

   -- Traitors "team"chat by default, non-locationally
   if speaker:IsActiveTraitor() then
      if speaker.traitor_gvoice then
         return true, loc_voice:GetBool()
      elseif listener:IsActiveTraitor() then
         return true, false
      else
         -- unless traitor_gvoice is true, normal innos can't hear speaker
         return false, false
      end
   end

   return true, (loc_voice:GetBool() and GetRoundState() != ROUND_POST)
end

local function SendTraitorVoiceState(speaker, state)
   -- send umsg to living traitors that this is traitor-only talk
   local rf = GetTraitorFilter(true)

   -- tiny umsg in the hope of it arriving asap
   umsg.Start("tvo", rf)
   umsg.Short(speaker:EntIndex())
   umsg.Bool(state)
   umsg.End()
end


local function TraitorGlobalVoice(ply, cmd, args)
   if not IsValid(ply) or not ply:IsActiveTraitor() then return end
   if not #args == 1 then return end
   local state = tonumber(args[1])

   ply.traitor_gvoice = (state == 1)

   SendTraitorVoiceState(ply, ply.traitor_gvoice)
end
concommand.Add("tvog", TraitorGlobalVoice)

local function MuteTeam(ply, cmd, args)
   if not IsValid(ply) then return end
   if not #args == 1 and tonumber(args[1]) then return end
   if not ply:IsSpec() then
      ply.mute_team = -1
      return
   end

   local t = tonumber(args[1])
   ply.mute_team = t

   local name = (t != 0) and team.GetName(t) or "None"
   ply:ChatPrint(name .. " muted.")
end
concommand.Add("ttt_mute_team", MuteTeam)

local ttt_lastwords = CreateConVar("ttt_lastwords_chatprint", "0")

local LastWordContext = {
   [KILL_NORMAL] = "",
   [KILL_SUICIDE] = " *kills self*",
   [KILL_FALL] = " *SPLUT*",
   [KILL_BURN] = " *crackle*"
};

local function LastWordsMsg(ply, words)
   -- only append "--" if there's no ending interpunction
   local final = string.match(words, "[\\.\\!\\?]$") != nil

   -- add optional context relating to death type
   local context = LastWordContext[ply.death_type] or ""

   umsg.Start("lastwords_msg")
   umsg.Entity(ply)
   umsg.String(words .. (final and "" or "--") .. context)
   umsg.End()
end

local function LastWords(ply, cmd, args)
   if IsValid(ply) and (not ply:Alive()) and #args > 1 then
      local id = tonumber(args[1])
      if id and ply.last_words_id and id == ply.last_words_id then
         -- never allow multiple last word stuff
         ply.last_words_id = nil

         -- we will be storing this on the ragdoll
         local rag = ply.server_ragdoll
         if not (IsValid(rag) and rag.player_ragdoll) then
            rag = nil
         end

         --- last id'd person
         local last_seen = tonumber(args[2])
         if last_seen then
            local ent = Entity(last_seen)
            if IsValid(ent) and ent:IsPlayer() and rag and (not rag.lastid) then
               rag.lastid = {ent=ent, t=CurTime()}
            end
         end

         --- last words
         local words = string.Trim(args[3])

         -- nothing of interest
         if string.len(words) < 2 then return end

         if ttt_lastwords:GetBool() or ply.death_type == KILL_FALL then
            LastWordsMsg(ply, words)
         end

         if rag and (not rag.last_words) then
            rag.last_words = words
         end
      else
         ply.last_words_id = nil
      end
   end
end
concommand.Add("_deathrec", LastWords)

-- Override or hook in plugin for spam prevention and whatnot. Return true
-- to block a command.
function GM:TTTPlayerRadioCommand(ply, msg_name, msg_target)
end

local function RadioCommand(ply, cmd, args)
   if IsValid(ply) and ply:IsTerror() and #args == 2 then
      local msg_name = args[1]
      local msg_target = args[2]

      local name = ""
      local rag_name = nil

      if tonumber(msg_target) then
         -- player or corpse ent idx
         local ent = Entity(tonumber(msg_target))
         if IsValid(ent) then
            if ent:IsPlayer() then
               name = ent:Nick()
            elseif ent:GetClass() == "prop_ragdoll" then
               name = LANG.NameParam("quick_corpse_id")
               rag_name = CORPSE.GetPlayerNick(ent, "A Terrorist")
            end
         end

         msg_target = ent
      else
         -- lang string
         name = LANG.NameParam(msg_target)
      end

      if hook.Call("TTTPlayerRadioCommand", GAMEMODE, ply, msg_name, msg_target) then
         return
      end

      umsg.Start("ttt_radio_msg")
      umsg.Entity(ply)
      umsg.String(msg_name)
      umsg.String(name)

      -- special case for id'd ragdolls, kind of ugly
      if rag_name then
         umsg.String(rag_name)
      end
      umsg.End()
   end
end
concommand.Add("_ttt_radio_send", RadioCommand)
