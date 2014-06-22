---- VGUI panel version of the scoreboard, based on TEAM GARRY's sandbox mode
---- scoreboard.

local surface = surface
local draw = draw
local math = math
local string = string
local vgui = vgui

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

include("sb_team.lua")

surface.CreateFont("cool_small", {font = "coolvetica",
                                  size = 20,
                                  weight = 400})
surface.CreateFont("cool_large", {font = "coolvetica",
                                  size = 24,
                                  weight = 400})
surface.CreateFont("treb_small", {font = "Trebuchet18",
                                  size = 14,
                                  weight = 700})

local logo = surface.GetTextureID("vgui/ttt/score_logo")

local PANEL = {}

local max = math.max
local floor = math.floor
local function UntilMapChange()
   local rounds_left = max(0, GetGlobalInt("ttt_rounds_left", 6))
   local time_left = floor(max(0, ((GetGlobalInt("ttt_time_limit_minutes") or 60) * 60) - CurTime()))

   local h = floor(time_left / 3600)
   time_left = time_left - floor(h * 3600)
   local m = floor(time_left / 60)
   time_left = time_left - floor(m * 60)
   local s = floor(time_left)

   return rounds_left, string.format("%02i:%02i:%02i", h, m, s)
end


GROUP_TERROR = 1
GROUP_NOTFOUND = 2
GROUP_FOUND = 3
GROUP_SPEC = 4

GROUP_COUNT = 4

function ScoreGroup(p)
   if not IsValid(p) then return -1 end -- will not match any group panel

   if DetectiveMode() then
      if p:IsSpec() and (not p:Alive()) then
         if p:GetNWBool("body_found", false) then
            return GROUP_FOUND
         else
            local client = LocalPlayer()
            -- To terrorists, missing players show as alive
            if client:IsSpec() or
               client:IsActiveTraitor() or
               ((GAMEMODE.round_state != ROUND_ACTIVE) and client:IsTerror()) then
               return GROUP_NOTFOUND
            else
               return GROUP_TERROR
            end
         end
      end
   end

   return p:IsTerror() and GROUP_TERROR or GROUP_SPEC
end

function PANEL:Init()

   self.hostdesc = vgui.Create("DLabel", self)
   self.hostdesc:SetText(GetTranslation("sb_playing"))
   self.hostdesc:SetContentAlignment(9)

   self.hostname = vgui.Create( "DLabel", self )
   self.hostname:SetText( GetHostName() )
   self.hostname:SetContentAlignment(6)

   self.mapchange = vgui.Create("DLabel", self)
   self.mapchange:SetText("Map changes in 00 rounds or in 00:00:00")
   self.mapchange:SetContentAlignment(9)

   self.mapchange.Think = function (sf)
                             local r, t = UntilMapChange()

                             sf:SetText(GetPTranslation("sb_mapchange",
                                                        {num = r, time = t}))
                             sf:SizeToContents()
                          end


   self.ply_frame = vgui.Create( "TTTPlayerFrame", self )

   self.ply_groups = {}

   local t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
   t:SetGroupInfo(GetTranslation("terrorists"), Color(0,200,0,100), GROUP_TERROR)
   self.ply_groups[GROUP_TERROR] = t

   t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
   t:SetGroupInfo(GetTranslation("spectators"), Color(200, 200, 0, 100), GROUP_SPEC)
   self.ply_groups[GROUP_SPEC] = t

   if DetectiveMode() then
      t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
      t:SetGroupInfo(GetTranslation("sb_mia"), Color(130, 190, 130, 100), GROUP_NOTFOUND)
      self.ply_groups[GROUP_NOTFOUND] = t

      t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
      t:SetGroupInfo(GetTranslation("sb_confirmed"), Color(130, 170, 10, 100), GROUP_FOUND)
      self.ply_groups[GROUP_FOUND] = t
   end

   -- the various score column headers
   self.cols = {}
   self:AddColumn( GetTranslation("sb_ping") )
   self:AddColumn( GetTranslation("sb_deaths") )
   self:AddColumn( GetTranslation("sb_score") )

   if KARMA.IsEnabled() then
      self:AddColumn( GetTranslation("sb_karma") )
   end

   -- Let hooks add their column headers (via AddColumn())
   hook.Call( "TTTScoreboardColumns", nil, self )

   self:UpdateScoreboard()
   self:StartUpdateTimer()
end

-- For headings only the label parameter is relevant, func is included for
-- parity with sb_row
function PANEL:AddColumn( label, func, width )
   local lbl = vgui.Create( "DLabel", self )
   lbl:SetText( label )
   lbl.IsHeading = true
   lbl.Width = width or 50 -- Retain compatibility with existing code

   table.insert( self.cols, lbl )
   return lbl
end

function PANEL:StartUpdateTimer()
   if not timer.Exists("TTTScoreboardUpdater") then
      timer.Create( "TTTScoreboardUpdater", 0.3, 0,
                    function()
                       local pnl = GAMEMODE:GetScoreboardPanel()
                       if IsValid(pnl) then
                          pnl:UpdateScoreboard()
                       end
                    end)
   end
end

local colors = {
   bg = Color(30,30,30, 235),
   bar = Color(220,180,0,255)
};

local y_logo_off = 72

function PANEL:Paint()
   -- Logo sticks out, so always offset bg
   draw.RoundedBox( 8, 0, y_logo_off, self:GetWide(), self:GetTall() - y_logo_off, colors.bg)

   -- Server name is outlined by orange/gold area
   draw.RoundedBox( 8, 0, y_logo_off + 25, self:GetWide(), 32, colors.bar)

   -- TTT Logo
   surface.SetTexture( logo )
   surface.SetDrawColor( 255, 255, 255, 255 )
   surface.DrawTexturedRect( 5, 0, 256, 256 )

end

function PANEL:PerformLayout()
   -- position groups and find their total size
   local gy = 0
   -- can't just use pairs (undefined ordering) or ipairs (group 2 and 3 might not exist)
   for i=1, GROUP_COUNT do
      local group = self.ply_groups[i]
      if ValidPanel(group) then
         if group:HasRows() then
            group:SetVisible(true)
            group:SetPos(0, gy)
            group:SetSize(self.ply_frame:GetWide(), group:GetTall())
            group:InvalidateLayout()
            gy = gy + group:GetTall() + 5
         else
            group:SetVisible(false)
         end
      end
   end

   self.ply_frame:GetCanvas():SetSize(self.ply_frame:GetCanvas():GetWide(), gy)

   local h = y_logo_off + 110 + self.ply_frame:GetCanvas():GetTall()

   -- if we will have to clamp our height, enable the mouse so player can scroll
   local scrolling = h > ScrH() * 0.95
--   gui.EnableScreenClicker(scrolling)
   self.ply_frame:SetScroll(scrolling)

   h = math.Clamp(h, 110 + y_logo_off, ScrH() * 0.95)

   local w = math.max(ScrW() * 0.6, 640)

   self:SetSize(w, h)
   self:SetPos( (ScrW() - w) / 2, math.min(72, (ScrH() - h) / 4))

   self.ply_frame:SetPos(8, y_logo_off + 109)
   self.ply_frame:SetSize(self:GetWide() - 16, self:GetTall() - 109 - y_logo_off - 5)

   -- server stuff
   self.hostdesc:SizeToContents()
   self.hostdesc:SetPos(w - self.hostdesc:GetWide() - 8, y_logo_off + 5)

   local hw = w - 180 - 8
   self.hostname:SetSize(hw, 32)
   self.hostname:SetPos(w - self.hostname:GetWide() - 8, y_logo_off + 27)

   surface.SetFont("cool_large")
   local hname = self.hostname:GetValue()
   local tw, _ = surface.GetTextSize(hname)
   while tw > hw do
      hname = string.sub(hname, 1, -6) .. "..."
      tw, th = surface.GetTextSize(hname)
   end

   self.hostname:SetText(hname)

   self.mapchange:SizeToContents()
   self.mapchange:SetPos(w - self.mapchange:GetWide() - 8, y_logo_off + 60)

   -- score columns
   local cy = y_logo_off + 90
   local cx = w - 8 -(scrolling and 16 or 0)
   for k,v in ipairs(self.cols) do
      v:SizeToContents()
      cx = cx - v.Width
      v:SetPos(cx - v:GetWide()/2, cy)
   end
end

function PANEL:ApplySchemeSettings()
   self.hostdesc:SetFont("cool_small")
   self.hostname:SetFont("cool_large")
   self.mapchange:SetFont("treb_small")

   self.hostdesc:SetTextColor(COLOR_WHITE)
   self.hostname:SetTextColor(COLOR_BLACK)
   self.mapchange:SetTextColor(COLOR_WHITE)

   for k,v in pairs(self.cols) do
      v:SetFont("treb_small")
      v:SetTextColor(COLOR_WHITE)
   end
end

function PANEL:UpdateScoreboard( force )
   if not force and not self:IsVisible() then return end

   local layout = false

   -- Put players where they belong. Groups will dump them as soon as they don't
   -- anymore.
   for k, p in pairs(player.GetAll()) do
      if IsValid(p) then
         local group = ScoreGroup(p)
         if self.ply_groups[group] and not self.ply_groups[group]:HasPlayerRow(p) then
            self.ply_groups[group]:AddPlayerRow(p)
            layout = true
         end
      end
   end

   for k, group in pairs(self.ply_groups) do
      if ValidPanel(group) then
         group:SetVisible( group:HasRows() )
         group:UpdatePlayerData()
      end
   end

   if layout then
      self:PerformLayout()
   else
      self:InvalidateLayout()
   end
end

vgui.Register( "TTTScoreboard", PANEL, "Panel" )

---- PlayerFrame is defined in sandbox and is basically a little scrolling
---- hack. Just putting it here (slightly modified) because it's tiny.

local PANEL = {}
function PANEL:Init()
   self.pnlCanvas  = vgui.Create( "Panel", self )
   self.YOffset = 0

   self.scroll = vgui.Create("DVScrollBar", self)
end

function PANEL:GetCanvas() return self.pnlCanvas end

function PANEL:OnMouseWheeled( dlta )
   self.scroll:AddScroll(dlta * -2)

   self:InvalidateLayout()
end

function PANEL:SetScroll(st)
   self.scroll:SetEnabled(st)
end

function PANEL:PerformLayout()
   self.pnlCanvas:SetVisible(self:IsVisible())

   -- scrollbar
   self.scroll:SetPos(self:GetWide() - 16, 0)
   self.scroll:SetSize(16, self:GetTall())

   local was_on = self.scroll.Enabled
   self.scroll:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
   self.scroll:SetEnabled(was_on) -- setup mangles enabled state

   self.YOffset = self.scroll:GetOffset()

   self.pnlCanvas:SetPos( 0, self.YOffset )
   self.pnlCanvas:SetSize( self:GetWide() - (self.scroll.Enabled and 16 or 0), self.pnlCanvas:GetTall() )
end
vgui.Register( "TTTPlayerFrame", PANEL, "Panel" )
