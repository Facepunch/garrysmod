---- Unlike sandbox, we have teams to deal with, so here's an extra panel in the
---- hierarchy that handles a set of player rows belonging to its team.

include("sb_row.lua")

local PANEL = {}

function PANEL:Init()
   self.name = "Unnamed"

   self.color = COLOR_WHITE

   self.rows = {}
   self.rowcount = 0

   self.rows_sorted = {}

   self.group = "spec"
end

function PANEL:SetGroupInfo(name, color, group)
   self.name = name
   self.color = color
   self.group = group
end

local bgcolor = Color(20,20,20, 150)
function PANEL:Paint()
   -- Darkened background
   draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), bgcolor)

   surface.SetFont("treb_small")

   -- Header bg
   local txt = self.name .. " (" .. self.rowcount .. ")"
   local w, h = surface.GetTextSize(txt)
   draw.RoundedBox(8, 0, 0, w + 24, 20, self.color)

   -- Shadow
   surface.SetTextPos(11, 11 - h/2)
   surface.SetTextColor(0,0,0, 200)
   surface.DrawText(txt)

   -- Text
   surface.SetTextPos(10, 10 - h/2)
   surface.SetTextColor(255,255,255,255)
   surface.DrawText(txt)

   -- Alternating row background
   local y = 24
   for i, row in ipairs(self.rows_sorted) do
      if (i % 2) != 0 then
         surface.SetDrawColor(75,75,75, 100)
         surface.DrawRect(0, y, self:GetWide(), row:GetTall())
      end

      y = y + row:GetTall() + 1
   end

   -- Column darkening
   local scr = sboard_panel.ply_frame.scroll.Enabled and 16 or 0
   surface.SetDrawColor(0,0,0, 80)
   if sboard_panel.cols then
      local cx = self:GetWide() - scr
      for k,v in ipairs(sboard_panel.cols) do
         cx = cx - v.Width
         if k % 2 == 1 then -- Draw for odd numbered columns
            surface.DrawRect(cx-v.Width/2, 0, v.Width, self:GetTall())
         end
      end
   else
      -- If columns are not setup yet, fall back to darkening the areas for the
      -- default columns
      surface.DrawRect(self:GetWide() - 175 - 25 - scr, 0, 50, self:GetTall())
      surface.DrawRect(self:GetWide() - 75 - 25 - scr, 0, 50, self:GetTall())
   end
end

function PANEL:AddPlayerRow(ply)
   if ScoreGroup(ply) == self.group and not self.rows[ply] then
      local row = vgui.Create("TTTScorePlayerRow", self)
      row:SetPlayer(ply)
      self.rows[ply] = row
      self.rowcount = table.Count(self.rows)

      -- must force layout immediately or it takes its sweet time to do so
      self:PerformLayout()
   end
end

function PANEL:HasPlayerRow(ply)
   return self.rows[ply] != nil
end

function PANEL:HasRows()
   return self.rowcount > 0
end

local strlower = string.lower
function PANEL:UpdateSortCache()
   self.rows_sorted = {}

   for _, row in pairs(self.rows) do
      table.insert(self.rows_sorted, row)
   end

   table.sort(self.rows_sorted, function(rowa, rowb)
      local plya = rowa:GetPlayer()
      local plyb = rowb:GetPlayer()

      if not IsValid(plya) then return false end
      if not IsValid(plyb) then return true end

      local sort_mode = GetConVar("ttt_scoreboard_sorting"):GetString()
      local sort_func = sboard_sort[sort_mode]

      local comp = 0
      if sort_func != nil then
         comp = sort_func(plya, plyb)
      end

      local ret = true

      if comp != 0 then
         ret = comp > 0
      else
         ret = strlower(plya:GetName()) > strlower(plyb:GetName())
      end

      if GetConVar("ttt_scoreboard_ascending"):GetBool() then
         ret = not ret
      end

      return ret
   end)
end

function PANEL:UpdatePlayerData()
   local to_remove = {}
   for k,v in pairs(self.rows) do
      -- Player still belongs in this group?
      if IsValid(v) and IsValid(v:GetPlayer()) and ScoreGroup(v:GetPlayer()) == self.group then
         v:UpdatePlayerData()
      else
         -- can't remove now, will break pairs
         table.insert(to_remove, k)
      end
   end

   if #to_remove == 0 then return end

   for k,ply in pairs(to_remove) do
      local pnl = self.rows[ply]
      if IsValid(pnl) then
         pnl:Remove()
      end

      self.rows[ply] = nil
   end
   self.rowcount = table.Count(self.rows)

   self:UpdateSortCache()

   self:InvalidateLayout()
end


function PANEL:PerformLayout()
   if self.rowcount < 1 then
      self:SetVisible(false)
      return
   end

   self:SetSize(self:GetWide(), 30 + self.rowcount + self.rowcount * SB_ROW_HEIGHT)

   -- Sort and layout player rows
   self:UpdateSortCache()

   local y = 24
   for k, v in ipairs(self.rows_sorted) do
      v:SetPos(0, y)
      v:SetSize(self:GetWide(), v:GetTall())

      y = y + v:GetTall() + 1
   end

   self:SetSize(self:GetWide(), 30 + (y - 24))
end

vgui.Register("TTTScoreGroup", PANEL, "Panel")
