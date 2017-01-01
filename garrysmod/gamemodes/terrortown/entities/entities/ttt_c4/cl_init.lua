-- bomb menus

include("shared.lua")

local starttime = C4_MINIMUM_TIME

local beep = Sound("weapons/c4/c4_click.wav")

local T = LANG.GetTranslation
local PT = LANG.GetParamTranslation

---- ARMING

-- Initial bomb arming
function ShowC4Config(bomb)
   local dframe = vgui.Create("DFrame")
   local w, h = 350, 270
   dframe:SetSize(w, h)
   dframe:Center()
   dframe:SetTitle(T("c4_arm"))
   dframe:SetVisible(true)
   dframe:ShowCloseButton(true)
   dframe:SetMouseInputEnabled(true)

   local m = 5

   local bg = vgui.Create("DPanel", dframe)
   bg:SetPaintBackground(false)
   bg:SetPos(0,0)
   bg:StretchToParent(m,m*5,m,m)

   -- Time
   local dformtime = vgui.Create("DForm", bg)
   dformtime:SetPos(m, m)
   dformtime:SetSize(w - m*4, h / 2)
   dformtime:SetName(T("c4_arm_timer"))

   local dclock = vgui.Create("DLabel", dformtime)
   dclock:SetFont("TimeLeft")
   dclock:SetText(util.SimpleTime(starttime, "%02i:%02i"))
   dclock:SizeToContents()
   dclock:SetPos(m*2, m*2)

   dformtime:AddItem(dclock)

   local ch, cw = dclock:GetSize()

   local dtime = vgui.Create("DNumSlider", dformtime)
   dtime:SetWide(w - m*4)
   dtime:SetText(T("c4_arm_seconds"))
   dtime:SetDark(false)
   dtime:SetMin(C4_MINIMUM_TIME)
   dtime:SetMax(C4_MAXIMUM_TIME)
   dtime:SetDecimals(0)
   dtime:SetValue(starttime)
   dtime.Label:SetWrap(true)

   local dwires

   dtime.OnValueChanged = function(self, val)
                             if not (IsValid(dclock) and IsValid(dwires)) then return end
                             dclock:SetText(util.SimpleTime(val, "%02i:%02i"))

                             dwires:Update(val)
                          end

   dformtime:AddItem(dtime)

   dwires = vgui.Create("DLabel", dformtime)
   dwires:SetText("")
   dwires:SetWrap(true)
   dwires:SetTall(30)

   local SafeWires = bomb.SafeWiresForTime
   dwires.Update = function(s, t)
                      s:SetText(PT("c4_arm_attempts", {num = C4_WIRE_COUNT - SafeWires(t)}))

                      s:InvalidateLayout()
                   end

   dwires:Update(starttime)

   dformtime:AddItem(dwires)

   local dformmisc = vgui.Create("DForm", bg)
   dformmisc:SetAutoSize(false)
   dformmisc:SetPos(m, m + 140)
   dformmisc:SetSize(w - m*4, h / 2)
   dformmisc:SetPadding(20)
   dformmisc:SetName(T("c4_remove_title"))

   -- Buttons
   local by = 200

   local bw, bh = 110, 25

   local dgrab = vgui.Create("DButton", dformmisc)
   dgrab:SetPos(m*6, m*5)
   dgrab:SetSize(bw, bh)
   dgrab:SetText(T("c4_remove_pickup"))
   dgrab:SetDisabled(false)
   dgrab.DoClick = function()
                      if not LocalPlayer() or not LocalPlayer():Alive() then return end

                      RunConsoleCommand("ttt_c4_pickup", bomb:EntIndex())
                      dframe:Close()
                   end

   --dformmisc:AddItem(dgrab)

   local ddestroy = vgui.Create("DButton", dformmisc)
   ddestroy:SetPos(w - m*4 - bw - m*6, m*5)
   ddestroy:SetSize(bw, bh)
   ddestroy:SetText(T("c4_remove_destroy1"))
   ddestroy:SetDisabled(false)
   ddestroy.Confirmed = false
   ddestroy.DoClick = function(s)
                         if not LocalPlayer() or not LocalPlayer():Alive() then return end

                         if not s.Confirmed then
                            s:SetText(T("c4_remove_destroy2"))
                            s.Confirmed = true
                         else
                            RunConsoleCommand("ttt_c4_destroy", bomb:EntIndex())
                            dframe:Close()
                         end
                   end


   local dconf = vgui.Create("DButton", bg)
   dconf:SetPos(m*2, m + by)
   dconf:SetSize(bw, bh)
   dconf:SetText(T("c4_arm"))
   dconf.DoClick = function()
                      if not LocalPlayer() or not LocalPlayer():Alive() then return end
                      local t = dtime:GetValue()
                      if t and tonumber(t) then

                         RunConsoleCommand("ttt_c4_config", bomb:EntIndex(), t)
                         dframe:Close()
                      end
                   end

   local dcancel = vgui.Create("DButton", bg)
   dcancel:SetPos( w - m*4 - bw, m + by)
   dcancel:SetSize(bw, bh)
   dcancel:SetText(T("cancel"))
   dcancel.DoClick = function() dframe:Close() end


   dframe:MakePopup()
end

---- DISARM

local disarm_beep    = Sound("buttons/blip2.wav")
local wire_cut       = Sound("ttt/wirecut.wav")

local c4_bomb_mat    = Material("vgui/ttt/c4_bomb")
local c4_cut_mat     = Material("vgui/ttt/c4_cut")
local c4_wire_mat    = Material("vgui/ttt/c4_wire")
local c4_wirecut_mat = Material("vgui/ttt/c4_wire_cut")

--- Disarm panels
local on_wire_cut = nil

-- Wire
local PANEL = {}


local wire_colors = {
   Color(200,   0,   0, 255), -- red
   Color(255, 255,   0, 255), -- yellow
   Color( 90,  90, 250, 255), -- blue
   Color(255, 255, 255, 255), -- white/grey
   Color( 20, 200,  20, 255), -- green
   Color(255, 160,  50, 255)  -- brown
};

function PANEL:Init()
   self.BaseClass.Init(self)

   self:NoClipping(true)
   self:SetMouseInputEnabled(true)
   self:MoveToFront()

   self.IsCut = false
end

local c4_cut_tex = surface.GetTextureID(c4_cut_mat:GetName())
function PANEL:PaintOverHovered()

   surface.SetTexture(c4_cut_tex)
   surface.SetDrawColor(255, 255, 255, 255)
   surface.DrawTexturedRect(175, -20, 32, 32)

   draw.SimpleText(PT("c4_disarm_cut", {num = self.Index}), "DermaDefault", 85, -10, COLOR_WHITE, 0, 0)
end

PANEL.OnMousePressed = DButton.OnMousePressed

PANEL.OnMouseReleased = DButton.OnMouseReleased


function PANEL:OnCursorEntered()
   if not self.IsCut then
      self.PaintOver = self.PaintOverHovered
   end
end

function PANEL:OnCursorExited()
   self.PaintOver = self.BaseClass.PaintOver
end

function PANEL:DoClick()
   if self:GetParent():GetDisabled() then return end

   self.IsCut = true

   self.PaintOver = self.BaseClass.PaintOver

   self.m_Image:SetMaterial(c4_wirecut_mat)

   surface.PlaySound(wire_cut)

   if on_wire_cut then
      on_wire_cut(self.Index)
   end
end

function PANEL:GetWireColor(i)
   i = i or 1
   i = i % (#wire_colors + 1)

   return wire_colors[i] or COLOR_WHITE
end

function PANEL:SetWireIndex(i)
   self.m_Image:SetImageColor(self:GetWireColor(i))

   self.Index = i
end

vgui.Register("DisarmWire", PANEL, "DImageButton")


-- Bomb
local PANEL = {}

AccessorFunc(PANEL, "wirecount", "WireCount")


function PANEL:Init()
   self.Bomb = vgui.Create("DImage", self)
   self.Bomb:SetSize(256, 256)
   self.Bomb:SetPos(0,0)
   self.Bomb:SetMaterial(c4_bomb_mat)

   self:SetWireCount(C4_WIRE_COUNT)

   self.Wires = {}

   local wx, wy = -84, 70
   local wc = 1
   for i=1, self:GetWireCount() do
      local w = vgui.Create("DisarmWire", self)
      w:SetPos(wx, wy)
      w:SetImage(c4_wire_mat:GetName())
      w:SizeToContents()

      w:SetWireIndex(i)

      table.insert(self.Wires, w)

      wy = wy + 27
   end

   self:SetPaintBackground(false)
end

vgui.Register( "DisarmPanel", PANEL, "DPanel" )


surface.CreateFont("C4Timer", {
                      font = "TabLarge",
                      size = 30,
                      weight = 750
                   })

local disarm_success, disarm_fail

function ShowC4Disarm(bomb)
   local dframe = vgui.Create("DFrame")
   local w, h = 420, 340
   dframe:SetSize(w, h)
   dframe:Center()
   dframe:SetTitle(T("c4_disarm"))
   dframe:SetVisible(true)
   dframe:ShowCloseButton(true)
   dframe:SetMouseInputEnabled(true)

   local m = 5
   local title_h = 20

   local left_w, left_h = 270, 270
   local right_w, right_h = 135, left_h

   local bw, bh = 100, 25

   local dleft = vgui.Create("ColoredBox", dframe)
   dleft:SetColor(Color(50, 50, 50))
   dleft:SetSize(left_w, left_h)
   dleft:SetPos(m, m + title_h)

   local dright = vgui.Create("ColoredBox", dframe)
   dright:SetColor(Color(50, 50, 50))
   dright:SetSize(right_w, right_h)
   dright:SetPos(left_w + m * 2, m + title_h)

   local dtimer = vgui.Create("DLabel", dright)
   dtimer:SetText("99:99:99")
   dtimer:SetFont("C4Timer")
   dtimer:SetTextColor(Color(200, 0, 0, 255))
   dtimer:SetExpensiveShadow(1, COLOR_BLACK)
   dtimer:SizeToContents()
   dtimer:SetWide(120)
   dtimer:SetPos(10, m)

   dtimer.Bomb = bomb
   dtimer.Stop = false

   dtimer.Think = function(s)
                     if not IsValid(bomb) then return end
                     if s.Stop then return end

                     local t = bomb:GetExplodeTime()
                     if t then
                        local r = t - CurTime()
                        if r > 0 then
                           s:SetText(util.SimpleTime(r, "%02i:%02i:%02i"))
                        end
                     end
                  end

   local dstatus = vgui.Create("DLabel", dright)
   dstatus:SetText(T("c4_status_armed"))
   dstatus:SetFont("HealthAmmo")
   dstatus:SetTextColor(Color(200, 0, 0, 255))
   dstatus:SetExpensiveShadow(1, COLOR_BLACK)
   dstatus:SizeToContents()
   dstatus:SetPos(m, m*2 + 30)
   dstatus:CenterHorizontal()


   local dgrab = vgui.Create("DButton", dright)
   dgrab:SetPos(m, right_h - m*2 - bh*2)
   dgrab:SetSize(bw, bh)
   dgrab:CenterHorizontal()
   dgrab:SetText(T("c4_remove_pickup"))
   dgrab:SetDisabled(true)
   dgrab.DoClick = function()
                      if (not LocalPlayer():Alive()) then return end
                      RunConsoleCommand("ttt_c4_pickup", bomb:EntIndex())
                      dframe:Close()
                   end

   local ddestroy = vgui.Create("DButton", dright)
   ddestroy:SetPos(m, right_h - m - bh)
   ddestroy:SetSize(bw, bh)
   ddestroy:CenterHorizontal()
   ddestroy:SetText(T("c4_remove_destroy1"))
   ddestroy:SetDisabled(true)
   ddestroy.Confirmed = false
   ddestroy.DoClick = function(s)
                         if not LocalPlayer():Alive() then return end

                         if not s.Confirmed then
                            s:SetText(T("c4_remove_destroy2"))
                            s.Confirmed = true
                         else
                            RunConsoleCommand("ttt_c4_destroy", bomb:EntIndex())
                            dframe:Close()
                         end
                   end


   local desc_h = 45

   local ddesc = vgui.Create("DLabel", dleft)
   ddesc:SetBright(true)
   ddesc:SetFont("DermaDefaultBold")
   ddesc:SetSize(256, desc_h)
   ddesc:SetWrap(true)
   if LocalPlayer():IsTraitor() then
      ddesc:SetText(T("c4_disarm_t"))
   elseif LocalPlayer() == bomb:GetOwner() then
      ddesc:SetText(T("c4_disarm_owned"))
   else
      ddesc:SetText(T("c4_disarm_other"))
   end
   ddesc:SetPos(m, m)

   local bg = vgui.Create("ColoredBox", dleft)
   bg:StretchToParent(m,m + desc_h,m,m)
   bg:SetColor(Color(20,20,20, 255))

   local dbomb = vgui.Create("DisarmPanel", bg)
   dbomb:SetSize(256, 256)
   dbomb:Center()


   local dcancel = vgui.Create("DButton", dframe)
   dcancel:SetPos( w - bw - m, h - bh - m)
   dcancel:SetSize(bw, bh)
   dcancel:CenterHorizontal()
   dcancel:SetText(T("close"))
   dcancel.DoClick = function()
                        dframe:Close()
                     end

   dframe:MakePopup()

   disarm_success = function()
                       surface.PlaySound(disarm_beep)
                       dtimer.Stop = true

                       dtimer:SetTextColor(COLOR_GREEN)

                       dstatus:SetTextColor(COLOR_GREEN)
                       dstatus:SetText(T("c4_status_disarmed"))
                       dstatus:SizeToContents()
                       dstatus:CenterHorizontal()

                       ddestroy:SetDisabled(false)
                       dgrab:SetDisabled(false)
                    end

   disarm_fail = function()
                    dframe:Close()
                 end

   on_wire_cut = function(idx)
                    if IsValid(dbomb) then
                       dbomb:SetDisabled(true)
                       -- disabled lowers alpha, looks weird here so work around
                       -- that
                       dbomb:SetAlpha(255)
                    end

                    if IsValid(bomb) then
                       RunConsoleCommand("ttt_c4_disarm", tostring(bomb:EntIndex()), tostring(idx))
                    end
                 end
end


---- Communication

local function C4ConfigHook()
   local bomb = net.ReadEntity()

   if IsValid(bomb) then
      if not bomb:GetArmed() then
         ShowC4Config(bomb)
      else
         ShowC4Disarm(bomb)
      end
   end
end
net.Receive("TTT_C4Config", C4ConfigHook)

local function C4DisarmResultHook()
   local bomb = net.ReadEntity()
   local correct = net.ReadBit() == 1

   if IsValid(bomb) then
      if correct and disarm_success then
         disarm_success()
      elseif disarm_fail then
         disarm_fail()
      end
   end
end
net.Receive("TTT_C4DisarmResult", C4DisarmResultHook)
