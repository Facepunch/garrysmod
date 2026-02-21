--- Display of and interaction with ttt_traitor_button
local surface = surface
local pairs = pairs
local math = math
local abs = math.abs

TBHUD = {}
TBHUD.buttons = {}
TBHUD.buttons_count = 0

TBHUD.focus_ent = nil
TBHUD.focus_stick = 0

function TBHUD:Clear()
   self.buttons = {}
   self.buttons_count = 0

   self.focus_ent = nil
   self.focus_stick = 0
end

function TBHUD:CacheEnts()
   self.buttons = {}

   if IsValid(LocalPlayer()) and LocalPlayer():IsActiveTraitor() then
      for _, ent in ipairs(ents.FindByClass("ttt_traitor_button")) do
         if IsValid(ent) then
            self.buttons[ent:EntIndex()] = ent
         end
      end
   end

   self.buttons_count = table.Count(self.buttons)
end

function TBHUD:PlayerIsFocused()
   return IsValid(LocalPlayer()) and LocalPlayer():IsActiveTraitor() and IsValid(self.focus_ent)
end

function TBHUD:UseFocused()
   if IsValid(self.focus_ent) and self.focus_stick >= CurTime() then
      RunConsoleCommand("ttt_use_tbutton", tostring(self.focus_ent:EntIndex()))

      self.focus_ent = nil
      return true
   else
      return false
   end
end

local confirm_sound = Sound("buttons/button24.wav")
function TBHUD.ReceiveUseConfirm()
   surface.PlaySound(confirm_sound)

   TBHUD:CacheEnts()
end
net.Receive("TTT_ConfirmUseTButton", TBHUD.ReceiveUseConfirm)

local function ComputeRangeFactor(plypos, tgtpos)
   local d = tgtpos - plypos
   d = d:Dot(d)
   return d / range
end

local tbut_normal = surface.GetTextureID("vgui/ttt/tbut_hand_line")
local tbut_focus = surface.GetTextureID("vgui/ttt/tbut_hand_filled")
local size = 32
local mid  = size / 2
local focus_range = 25
local focus_d = 0
local sz = 16

local use_key = Key("+use", "USE")

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
function TBHUD:Draw(client)
   if self.buttons_count == 0 then return end

   surface.SetTexture(tbut_normal)

   -- we're doing slowish distance computation here, so lots of probably
   -- ineffective micro-optimization
   local plypos = client:GetPos()
   local midscreen_x = ScrW() / 2
   local midscreen_y = ScrH() / 2
   local pos, scrpos, d
   local focus_ent = nil
   local focus_scrpos_x, focus_scrpos_y = midscreen_x, midscreen_y

   -- draw icon on HUD for every button within range
   for k, but in pairs(self.buttons) do
      if not IsValid(but) or not but.IsUsable or not but:IsUsable() then continue end

      pos = but:GetPos()
      scrpos = pos:ToScreen()

      if IsOffScreen(scrpos) then continue end

      d = pos - plypos
      d = d:Dot(d) / (but:GetUsableRange() ^ 2)

      -- draw if this button is within range, with alpha based on distance
      if d >= 1 then continue end

      if not IsValid(focus_ent) and d > focus_d and (self.focus_stick < CurTime() or but == self.focus_ent) then
         local x = abs(scrpos.x - midscreen_x)
         local y = abs(scrpos.y - midscreen_y)
         if (x < focus_range and y < focus_range and
             x < focus_scrpos_x and y < focus_scrpos_y) then

            -- draw extra graphics and information for button when it's in-focus
            focus_ent = but

            -- avoid constantly switching focus every frame causing
            -- 2+ buttons to appear in focus, instead "stick" to one
            -- ent for a very short time to ensure consistency
            self.focus_ent = focus_ent
            self.focus_stick = CurTime() + 0.1

            -- redraw in-focus version of icon
            surface.SetTexture(tbut_focus)
            surface.SetDrawColor(255, 255, 255, 200)
            surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)

            -- description
            surface.SetTextColor(255, 50, 50, 255)
            surface.SetFont("TabLarge")

            x = scrpos.x + sz + 10
            y = scrpos.y - sz - 3
            surface.SetTextPos(x, y)
            surface.DrawText(focus_ent:GetDescription())

            y = y + 12
            surface.SetTextPos(x, y)

            local delay = focus_ent:GetDelay()
            if delay < 0 then
               surface.DrawText(GetTranslation("tbut_single"))
            elseif delay == 0 then
               surface.DrawText(GetTranslation("tbut_reuse"))
            else
               local txt = GetPTranslation("tbut_retime", {num = delay})
               surface.DrawText(txt)
            end

            y = y + 12
            surface.SetTextPos(x, y)

            local txt = GetPTranslation("tbut_help", {key = use_key})
            surface.DrawText(txt)

            surface.SetTexture(tbut_normal)

            continue
         end
      end

      surface.SetDrawColor(255, 255, 255, 200 * (1 - d))
      surface.DrawTexturedRect(scrpos.x - mid, scrpos.y - mid, size, size)
   end
end
