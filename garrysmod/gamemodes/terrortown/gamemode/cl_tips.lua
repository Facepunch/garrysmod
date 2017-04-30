---- Tips panel shown to specs

CreateConVar("ttt_tips_enable", "1", FCVAR_ARCHIVE)

local draw = draw

TIPS = {}

--- Tip cycling button
PANEL = {}

PANEL.Colors = {
   default = COLOR_LGRAY,
   hover = COLOR_WHITE,
   press = COLOR_RED
};

function PANEL:Paint()
   -- parent panel will deal with the normal bg, we only need to worry about
   -- mouse effects

   local clr = self.Colors.default
   if self.Depressed then
      clr = self.Colors.press
   elseif self.Hovered then
      clr = self.Colors.hover
   end

   surface.SetDrawColor(clr.r, clr.g, clr.b, clr.a)
   self:DrawOutlinedRect()
end

derma.DefineControl("TipsButton", "Tip cycling button", PANEL, "DButton")


--- Main tip panel

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

local tips_bg = Color(0, 0, 0, 200)

local tip_ids = {}
for i=1, 40 do
   table.insert(tip_ids, i)
end

table.Shuffle(tip_ids)

local tip_params = {
   [1]  = {walkkey = Key("+walk", "WALK"), usekey = Key("+use", "USE")},
   [24] = {helpkey = Key("+gm_showhelp", "F1")},
   [28] = {mutekey = Key("+gm_showteam", "F2")},
   [30] = {zoomkey = Key("+zoom", "the 'Suit Zoom' key")},
   [31] = {duckkey = Key("+duck", "DUCK")},
   [36] = {helpkey = Key("+gm_showhelp", "F1")},
};

PANEL = {}

function PANEL:Init()
   self.IdealWidth = 450
   self.IdealHeight = 45
   self.BgColor = tips_bg

   self.NextSwitch = 0

   self.AutoDelay = 15
   self.ManualDelay = 25

   self.tiptext = vgui.Create("DLabel", self)
   self.tiptext:SetContentAlignment(5)
   self.tiptext:SetText(GetTranslation("tips_panel_title"))

   self.bwrap = vgui.Create("Panel", self)

   self.buttons = {}
   self.buttons.left = vgui.Create("TipsButton", self.bwrap)
   self.buttons.left:SetText("<")

   self.buttons.left.DoClick = function() self:PrevTip() end

   self.buttons.right = vgui.Create("TipsButton", self.bwrap)
   self.buttons.right:SetText(">")

   self.buttons.right.DoClick = function() self:NextTip() end

   self.buttons.help = vgui.Create("TipsButton", self.bwrap)
   self.buttons.help:SetText("?")
   self.buttons.help:SetConsoleCommand("ttt_helpscreen")

   self.buttons.close = vgui.Create("TipsButton", self.bwrap)
   self.buttons.close:SetText("X")
   self.buttons.close:SetConsoleCommand("ttt_tips_hide")

   self.TipIndex = math.random(1, #tip_ids) or 0
   self:SetTip(self.TipIndex)
end

function PANEL:SetTip(idx)
   if not idx then
      self:SetVisible(false)
      return
   end

   self.TipIndex = idx

   local tip_id = tip_ids[idx]

   local text = nil
   if tip_params[tip_id] then
      text = GetPTranslation("tip" .. tip_id, tip_params[tip_id])
   else
      text = GetTranslation("tip" .. tip_id)
   end

   self.tiptext:SetText(GetTranslation("tips_panel_tip") .. " " .. text)

   self:InvalidateLayout(true)
end

function PANEL:NextTip(auto)
   local idx = self.TipIndex + 1
   if idx > #tip_ids then
      idx = 1
   end

   self:SetTip(idx)

   self.NextSwitch = CurTime() + (auto and self.AutoDelay or self.ManualDelay)
end

function PANEL:PrevTip(auto)
   local idx = self.TipIndex - 1
   if idx < 1 then
      idx = #tip_ids
   end

   self:SetTip(idx)

   self.NextSwitch = CurTime() + (auto and self.AutoDelay or self.ManualDelay)
end

function PANEL:PerformLayout()
   local m = 8
   local off_bottom = 10
   -- need to account for voice stuff in the bottom right and the time in the
   -- bottom left
   local off_left = 260
   local off_right = 250
   local room = ScrW() - off_left - off_right
   local width = math.min(room, self.IdealWidth)

   if width < 200 then
      -- people who run 640x480 do not deserve tips
      self:SetVisible(false)
      return
   end

   local bsize = 14

   -- position buttons
   self.bwrap:SetSize(bsize * 2 + 2, bsize * 2 + 2)

   self.buttons.left:SetSize(bsize,bsize)
   self.buttons.left:SetPos(0,0)

   self.buttons.right:SetSize(bsize,bsize)
   self.buttons.right:SetPos(bsize + 2, 0)

   self.buttons.help:SetSize(bsize,bsize)
   self.buttons.help:SetPos(0, bsize + 2)

   self.buttons.close:SetSize(bsize,bsize)
   self.buttons.close:SetPos(bsize + 2, bsize + 2)

   -- position content
   self.tiptext:SetPos(m, m)
   self.tiptext:SetTall(self.IdealHeight)
   self.tiptext:SetWide(width - m*2 - self.bwrap:GetWide())
   self.tiptext:SizeToContentsY()

   local height = math.max(self.IdealHeight, self.tiptext:GetTall() + m*2)

   local x = off_left + ((room - width) / 2)
   local y = ScrH() - off_bottom - height

   self:SetPos(x, y)
   self:SetSize(width, height)

   self.bwrap:SetPos(width - self.bwrap:GetWide() - m, height - self.bwrap:GetTall() - m)
end

function PANEL:ApplySchemeSettings()
   for k, but in pairs(self.buttons) do
      but:SetTextColor(COLOR_WHITE)
      but:SetContentAlignment(5)
   end

   self.bwrap:SetPaintBackgroundEnabled(false)

   self.tiptext:SetFont("DefaultBold")
   self.tiptext:SetTextColor(COLOR_WHITE)
   self.tiptext:SetWrap(true)
end

function PANEL:Paint()
   draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), self.BgColor)
end

function PANEL:Think()
   if self.NextSwitch < CurTime() then
      self:NextTip(true)
   end
end

vgui.Register("TTTTips", PANEL, "Panel")


--- Creation

local tips_panel = nil
function TIPS.Create()
   if IsValid(tips_panel) then
      tips_panel:Remove()
      tips_panel = nil
   end

   tips_panel = vgui.Create("TTTTips")

   -- workaround for layout oddities, give it a poke next tick
   timer.Simple(0.1, TIPS.Next)
end

function TIPS.Show()
   if not GetConVar("ttt_tips_enable"):GetBool() then return end

   if not tips_panel then
      TIPS.Create()
   end

   tips_panel:SetVisible(true)
end

function TIPS.Hide()
   if tips_panel then
      tips_panel:SetVisible(false)
   end

   if GAMEMODE.ForcedMouse then
      -- currently the only use of unlocking the mouse is screwing around with
      -- the hints, and it makes sense to lock the mouse again when closing the
      -- tips
      gui.EnableScreenClicker(false)
      GAMEMODE.ForcedMouse = false
   end
end
concommand.Add("ttt_tips_hide", TIPS.Hide)

function TIPS.Next()
   if tips_panel then
      tips_panel:NextTip()
   end
end

function TIPS.Prev()
   if tips_panel then
      tips_panel:PrevTip()
   end
end

local function TipsCallback(cv, prev, new)
   if tobool(new) then
      if LocalPlayer():IsSpec() then
         TIPS.Show()
      end
   else
      TIPS.Hide()
   end
end
cvars.AddChangeCallback("ttt_tips_enable", TipsCallback)
