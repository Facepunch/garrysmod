---- Voicechat popup, radio commands, text chat stuff

DEFINE_BASECLASS("gamemode_base")

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local string = string

local function LastWordsRecv()
   local sender = net.ReadEntity()
   local words  = net.ReadString()

   local was_detective = IsValid(sender) and sender:IsDetective()
   local nick = IsValid(sender) and sender:Nick() or "<Unknown>"

   chat.AddText(Color( 150, 150, 150 ),
                Format("(%s) ", string.upper(GetTranslation("last_words"))),
                was_detective and Color(50, 200, 255) or Color(0, 200, 0),
                nick,
                COLOR_WHITE,
                ": " .. words)
end
net.Receive("TTT_LastWordsMsg", LastWordsRecv)

local function RoleChatRecv()
   -- virtually always our role, but future equipment might allow listening in
   local role = net.ReadUInt(2)
   local sender = net.ReadEntity()
   if not IsValid(sender) then return end

   local text = net.ReadString()

   if role == ROLE_TRAITOR then
      chat.AddText(Color( 255, 30, 40 ),
                   Format("(%s) ", string.upper(GetTranslation("traitor"))),
                   Color( 255, 200, 20),
                   sender:Nick(),
                   Color( 255, 255, 200),
                   ": " .. text)

   elseif role == ROLE_DETECTIVE then
      chat.AddText(Color( 20, 100, 255 ),
                   Format("(%s) ", string.upper(GetTranslation("detective"))),
                   Color( 25, 200, 255),
                   sender:Nick(),
                   Color( 200, 255, 255),
                   ": " .. text)
   end
end
net.Receive("TTT_RoleChat", RoleChatRecv)

-- special processing for certain special chat types
function GM:ChatText(idx, name, text, type)

   if type == "joinleave" then
      if string.find(text, "Changed name during a round") then
         -- prevent nick from showing up
         chat.AddText(LANG.GetTranslation("name_kick"))
         return true
      end
   end

   return BaseClass.ChatText(self, idx, name, text, type)
end


-- Detectives have a blue name, in both chat and radio messages
local function AddDetectiveText(ply, text)
   chat.AddText(Color(50, 200, 255),
                ply:Nick(),
                Color(255,255,255),
                ": " .. text)
end

function GM:OnPlayerChat(ply, text, teamchat, dead)
   if not IsValid(ply) then return BaseClass.OnPlayerChat(self, ply, text, teamchat, dead) end 
   
   if ply:IsActiveDetective() then
      AddDetectiveText(ply, text)
      return true
   end
   
   local team = ply:Team() == TEAM_SPEC
   
   if team and not dead then
      dead = true
   end
   
   if teamchat and ((not team and not ply:IsSpecial()) or team) then
      teamchat = false
   end

   return BaseClass.OnPlayerChat(self, ply, text, teamchat, dead)
end

local last_chat = ""
function GM:ChatTextChanged(text)
   last_chat = text
end

function ChatInterrupt()
   local client = LocalPlayer()
   local id = net.ReadUInt(32)

   local last_seen = IsValid(client.last_id) and client.last_id:EntIndex() or 0

   local last_words = "."
   if last_chat == "" then
      if RADIO.LastRadio.t > CurTime() - 2 then
         last_words = RADIO.LastRadio.msg
      end
   else
      last_words = last_chat
   end

   RunConsoleCommand("_deathrec", tostring(id), tostring(last_seen), last_words)
end
net.Receive("TTT_InterruptChat", ChatInterrupt)

--- Radio

RADIO = {}
RADIO.Show = false

RADIO.StoredTarget = {nick="", t=0}
RADIO.LastRadio = {msg="", t=0}

-- [key] -> command
RADIO.Commands = {
   {cmd="yes",      text="quick_yes", format=false},
   {cmd="no",       text="quick_no", format=false},
   {cmd="help",     text="quick_help", format=false},
   {cmd="imwith",   text="quick_imwith", format=true},
   {cmd="see",      text="quick_see", format=true},
   {cmd="suspect",  text="quick_suspect", format=true},
   {cmd="traitor",  text="quick_traitor", format=true},
   {cmd="innocent", text="quick_inno", format=true},
   {cmd="check",    text="quick_check", format=false}
};

local radioframe = nil

function RADIO:ShowRadioCommands(state)
   if not state then
      if radioframe and radioframe:IsValid() then
         radioframe:Remove()
         radioframe = nil

         -- don't capture keys
         self.Show = false
      end
   else
      local client = LocalPlayer()
      if not IsValid(client) then return end

      if not radioframe then

         local w, h = 200, 300

         radioframe = vgui.Create("DForm")
         radioframe:SetName(GetTranslation("quick_title"))
         radioframe:SetSize(w, h)
         radioframe:SetMouseInputEnabled(false)
         radioframe:SetKeyboardInputEnabled(false)

         radioframe:CenterVertical()

         -- ASS
         radioframe.ForceResize = function(s)
                                     local w, label = 0, nil
                                     for k,v in pairs(s.Items) do
                                        label = v:GetChild(0)
                                        if label:GetWide() > w then
                                           w = label:GetWide()
                                        end
                                     end
                                     s:SetWide(w + 20)
                                  end

         for key, command in pairs(self.Commands) do
            local dlabel = vgui.Create("DLabel", radioframe)
            local id = key .. ": "
            local txt = id
            if command.format then
               txt = txt .. GetPTranslation(command.text, {player = GetTranslation("quick_nobody")})
            else
               txt = txt .. GetTranslation(command.text)
            end

            dlabel:SetText(txt)
            dlabel:SetFont("TabLarge")
            dlabel:SetTextColor(COLOR_WHITE)
            dlabel:SizeToContents()

            if command.format then
               dlabel.target = nil
               dlabel.id = id
               dlabel.txt = GetTranslation(command.text)
               dlabel.Think = function(s)
                                 local tgt, v = RADIO:GetTarget()
                                 if s.target != tgt then
                                    s.target = tgt

                                    tgt = string.Interp(s.txt, {player = RADIO.ToPrintable(tgt)})
                                    if v then
                                       tgt = util.Capitalize(tgt)
                                    end

                                    s:SetText(s.id .. tgt)
                                    s:SizeToContents()
                                    radioframe:ForceResize()
                                 end
                              end
            end

            radioframe:AddItem(dlabel)
         end

         radioframe:ForceResize()
      end

      radioframe:MakePopup()

      -- grabs input on init(), which happens in makepopup
      radioframe:SetMouseInputEnabled(false)
      radioframe:SetKeyboardInputEnabled(false)

      -- capture slot keys while we're open
      self.Show = true

      timer.Create("radiocmdshow", 3, 1,
                   function() RADIO:ShowRadioCommands(false) end)
   end
end

function RADIO:SendCommand(slotidx)
   local c = self.Commands[slotidx]
   if c then
      RunConsoleCommand("ttt_radio", c.cmd)

      self:ShowRadioCommands(false)
   end
end

function RADIO:GetTargetType()
   if not IsValid(LocalPlayer()) then return end
   local trace = LocalPlayer():GetEyeTrace(MASK_SHOT)

   if not trace or (not trace.Hit) or (not IsValid(trace.Entity)) then return end

   local ent = trace.Entity

   if ent:IsPlayer() and  ent:IsTerror() then
      if ent:GetNWBool("disguised", false) then
         return "quick_disg", true
      else
         return ent, false
      end
   elseif ent:GetClass() == "prop_ragdoll" and CORPSE.GetPlayerNick(ent, "") != "" then

      if DetectiveMode() and not CORPSE.GetFound(ent, false) then
         return "quick_corpse", true
      else
         return ent, false
      end
   end
end


function RADIO.ToPrintable(target)
   if type(target) == "string" then
      return GetTranslation(target)
   elseif IsValid(target) then
      if target:IsPlayer() then
         return target:Nick()
      elseif target:GetClass() == "prop_ragdoll" then
         return GetPTranslation("quick_corpse_id", {player = CORPSE.GetPlayerNick(target, "A Terrorist")})
      end
   end
end

function RADIO:GetTarget()
   local client = LocalPlayer()
   if IsValid(client) then

      local current, vague = self:GetTargetType()
      if current then return current, vague end

      local stored = self.StoredTarget
      if stored.target and stored.t > (CurTime() - 3) then
         return stored.target, stored.vague
      end
   end
   return "quick_nobody", true
end

function RADIO:StoreTarget()
   local current, vague = self:GetTargetType()
   if current then
      self.StoredTarget.target = current
      self.StoredTarget.vague = vague
      self.StoredTarget.t = CurTime()
   end
end

-- Radio commands are a console cmd instead of directly sent from RADIO, because
-- this way players can bind keys to them
local function RadioCommand(ply, cmd, arg)
   if not IsValid(ply) or #arg != 1 then
      print("ttt_radio failed, too many arguments?")
      return
   end

   if RADIO.LastRadio.t > (CurTime() - 0.5) then return end

   local msg_type = arg[1]
   local target, vague = RADIO:GetTarget()
   local msg_name = nil

   -- this will not be what is shown, but what is stored in case this message
   -- has to be used as last words (which will always be english for now)
   local text = nil

   for _, msg in pairs(RADIO.Commands) do
      if msg.cmd == msg_type then
         local eng = LANG.GetTranslationFromLanguage(msg.text, "english")
         text = msg.format and string.Interp(eng, {player = RADIO.ToPrintable(target)}) or eng

         msg_name = msg.text
         break
      end
   end

   if not text then
      print("ttt_radio failed, argument not valid radiocommand")
      return
   end

   if vague then
      text = util.Capitalize(text)
   end

   RADIO.LastRadio.t = CurTime()
   RADIO.LastRadio.msg = text

   -- target is either a lang string or an entity
   target = type(target) == "string" and target or tostring(target:EntIndex())

   RunConsoleCommand("_ttt_radio_send", msg_name, tostring(target))
end

local function RadioComplete(cmd, arg)
   local c = {}
   for k, cmd in pairs(RADIO.Commands) do
      local rcmd = "ttt_radio " .. cmd.cmd
      table.insert(c, rcmd)
   end
   return c
end
concommand.Add("ttt_radio", RadioCommand, RadioComplete)


local function RadioMsgRecv()
   local sender = net.ReadEntity()
   local msg    = net.ReadString()
   local param  = net.ReadString()

   if not (IsValid(sender) and sender:IsPlayer()) then return end

   GAMEMODE:PlayerSentRadioCommand(sender, msg, param)

   -- if param is a language string, translate it
   -- else it's a nickname
   local lang_param = LANG.GetNameParam(param)
   if lang_param then
      if lang_param == "quick_corpse_id" then
         -- special case where nested translation is needed
         param = GetPTranslation(lang_param, {player = net.ReadString()})
      else
         param = GetTranslation(lang_param)
      end
   end

   local text = GetPTranslation(msg, {player = param})

   -- don't want to capitalize nicks, but everything else is fair game
   if lang_param then
      text = util.Capitalize(text)
   end

   if sender:IsDetective() then
      AddDetectiveText(sender, text)
   else
      chat.AddText(sender,
                   COLOR_WHITE,
                   ": " .. text)
   end
end
net.Receive("TTT_RadioMsg", RadioMsgRecv)


local radio_gestures = {
   quick_yes     = ACT_GMOD_GESTURE_AGREE,
   quick_no      = ACT_GMOD_GESTURE_DISAGREE,
   quick_see     = ACT_GMOD_GESTURE_WAVE,
   quick_check   = ACT_SIGNAL_GROUP,
   quick_suspect = ACT_SIGNAL_HALT
};

function GM:PlayerSentRadioCommand(ply, name, target)
   local act = radio_gestures[name]
   if act then
      ply:AnimPerformGesture(act)
   end
end


--- voicechat stuff
VOICE = {}

local MutedState = nil

-- voice popups, copied from base gamemode and modified

g_VoicePanelList = nil

-- 255 at 100
-- 5 at 5000
local function VoiceNotifyThink(pnl)
   if not (IsValid(pnl) and LocalPlayer() and IsValid(pnl.ply)) then return end
   if not (GetGlobalBool("ttt_locational_voice", false) and (not pnl.ply:IsSpec()) and (pnl.ply != LocalPlayer())) then return end
   if LocalPlayer():IsActiveTraitor() && pnl.ply:IsActiveTraitor() then return end
   
   local d = LocalPlayer():GetPos():Distance(pnl.ply:GetPos())

   pnl:SetAlpha(math.max(-0.1 * d + 255, 15))
end

local PlayerVoicePanels = {}

function GM:PlayerStartVoice( ply )
   local client = LocalPlayer()
   if not IsValid(g_VoicePanelList) or not IsValid(client) then return end

   -- There'd be an extra one if voice_loopback is on, so remove it.
   GAMEMODE:PlayerEndVoice(ply, true)

   if not IsValid(ply) then return end

   -- Tell server this is global
   if client == ply then
      if client:IsActiveTraitor() then
         if (not client:KeyDown(IN_SPEED)) and (not client:KeyDownLast(IN_SPEED)) then
            client.traitor_gvoice = true
            RunConsoleCommand("tvog", "1")
         else
            client.traitor_gvoice = false
            RunConsoleCommand("tvog", "0")
         end
      end

      VOICE.SetSpeaking(true)
   end

   local pnl = g_VoicePanelList:Add("VoiceNotify")
   pnl:Setup(ply)
   pnl:Dock(TOP)
   
   local oldThink = pnl.Think
   pnl.Think = function( self )
                  oldThink( self )
                  VoiceNotifyThink( self )
               end

   local shade = Color(0, 0, 0, 150)
   pnl.Paint = function(s, w, h)
                  if not IsValid(s.ply) then return end
                  draw.RoundedBox(4, 0, 0, w, h, s.Color)
                  draw.RoundedBox(4, 1, 1, w-2, h-2, shade)
               end

   if client:IsActiveTraitor() then
      if ply == client then
         if not client.traitor_gvoice then
            pnl.Color = Color(200, 20, 20, 255)
         end
      elseif ply:IsActiveTraitor() then
         if not ply.traitor_gvoice then
            pnl.Color = Color(200, 20, 20, 255)
         end
      end
   end

   if ply:IsActiveDetective() then
      pnl.Color = Color(20, 20, 200, 255)
   end

   PlayerVoicePanels[ply] = pnl

   -- run ear gesture
   if not (ply:IsActiveTraitor() and (not ply.traitor_gvoice)) then
      ply:AnimPerformGesture(ACT_GMOD_IN_CHAT)
   end
end

local function ReceiveVoiceState()
   local idx = net.ReadUInt(7) + 1 -- we -1 serverside
   local state = net.ReadBit() == 1

   -- prevent glitching due to chat starting/ending across round boundary
   if GAMEMODE.round_state != ROUND_ACTIVE then return end
   if (not IsValid(LocalPlayer())) or (not LocalPlayer():IsActiveTraitor()) then return end

   local ply = player.GetByID(idx)
   if IsValid(ply) then
      ply.traitor_gvoice = state

      if IsValid(PlayerVoicePanels[ply]) then
         PlayerVoicePanels[ply].Color = state and Color(0,200,0) or Color(200, 0, 0)
      end
   end
end
net.Receive("TTT_TraitorVoiceState", ReceiveVoiceState)

local function VoiceClean()
   for ply, pnl in pairs( PlayerVoicePanels ) do
      if (not IsValid(pnl)) or (not IsValid(ply)) then
         GAMEMODE:PlayerEndVoice(ply)
      end
   end
end
timer.Create( "VoiceClean", 10, 0, VoiceClean )


function GM:PlayerEndVoice(ply, no_reset)
   if IsValid( PlayerVoicePanels[ply] ) then
      PlayerVoicePanels[ply]:Remove()
      PlayerVoicePanels[ply] = nil
   end

   if IsValid(ply) and not no_reset then
      ply.traitor_gvoice = false
   end

   if ply == LocalPlayer() then
      VOICE.SetSpeaking(false)
   end
end

local function CreateVoiceVGUI()
    g_VoicePanelList = vgui.Create( "DPanel" )

    g_VoicePanelList:ParentToHUD()
    g_VoicePanelList:SetPos(25, 25)
    g_VoicePanelList:SetSize(200, ScrH() - 200)
    g_VoicePanelList:SetPaintBackground(false)

    MutedState = vgui.Create("DLabel")
    MutedState:SetPos(ScrW() - 200, ScrH() - 50)
    MutedState:SetSize(200, 50)
    MutedState:SetFont("Trebuchet18")
    MutedState:SetText("")
    MutedState:SetTextColor(Color(240, 240, 240, 250))
    MutedState:SetVisible(false)
end
hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )

local MuteStates = {MUTE_NONE, MUTE_TERROR, MUTE_ALL, MUTE_SPEC}

local MuteText = {
   [MUTE_NONE]   = "",
   [MUTE_TERROR] = "mute_living",
   [MUTE_ALL]    = "mute_all",
   [MUTE_SPEC]   = "mute_specs"
};

local function SetMuteState(state)
   if MutedState then
      MutedState:SetText(string.upper(GetTranslation(MuteText[state])))
      MutedState:SetVisible(state != MUTE_NONE)
   end
end

local mute_state = MUTE_NONE
function VOICE.CycleMuteState(force_state)
   mute_state = force_state or next(MuteText, mute_state)

   if not mute_state then mute_state = MUTE_NONE end

   SetMuteState(mute_state)

   return mute_state
end

local battery_max = 100
local battery_min = 10
function VOICE.InitBattery()
   LocalPlayer().voice_battery = battery_max
end

local function GetRechargeRate()
   local r = GetGlobalFloat("ttt_voice_drain_recharge", 0.05)
   if LocalPlayer().voice_battery < battery_min then
      r = r / 2
   end
   return r
end

local function GetDrainRate()
   if not GetGlobalBool("ttt_voice_drain", false) then return 0 end

   if GetRoundState() != ROUND_ACTIVE then return 0 end
   local ply = LocalPlayer()
   if (not IsValid(ply)) or ply:IsSpec() then return 0 end

   if ply:IsAdmin() or ply:IsDetective() then
      return GetGlobalFloat("ttt_voice_drain_admin", 0)
   else
      return GetGlobalFloat("ttt_voice_drain_normal", 0)
   end
end

local function IsTraitorChatting(client)
   return client:IsActiveTraitor() and (not client.traitor_gvoice)
end

function VOICE.Tick()
   if not GetGlobalBool("ttt_voice_drain", false) then return end

   local client = LocalPlayer()
   if VOICE.IsSpeaking() and (not IsTraitorChatting(client)) then
      client.voice_battery = client.voice_battery - GetDrainRate()

      if not VOICE.CanSpeak() then
         client.voice_battery = 0
         RunConsoleCommand("-voicerecord")
      end
   elseif client.voice_battery < battery_max then
      client.voice_battery = client.voice_battery + GetRechargeRate()
   end
end

-- Player:IsSpeaking() does not work for localplayer
function VOICE.IsSpeaking() return LocalPlayer().speaking end
function VOICE.SetSpeaking(state) LocalPlayer().speaking = state end

function VOICE.CanSpeak()
   if not GetGlobalBool("ttt_voice_drain", false) then return true end

   return LocalPlayer().voice_battery > battery_min or IsTraitorChatting(LocalPlayer())
end

local speaker = surface.GetTextureID("voice/icntlk_sv")
function VOICE.Draw(client)
   local b = client.voice_battery
   if b >= battery_max then return end

   local x = 25
   local y = 10
   local w = 200
   local h = 6

   if b < battery_min and CurTime() % 0.2 < 0.1 then
      surface.SetDrawColor(200, 0, 0, 155)
   else
      surface.SetDrawColor(0, 200, 0, 255)
   end
   surface.DrawOutlinedRect(x, y, w, h)

   surface.SetTexture(speaker)
   surface.DrawTexturedRect(5, 5, 16, 16)

   x = x + 1
   y = y + 1
   w = w - 2
   h = h - 2

   surface.SetDrawColor(0, 200, 0, 150)
   surface.DrawRect(x, y, w * math.Clamp((client.voice_battery - 10) / 90, 0, 1), h)
end
