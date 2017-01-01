
-- we need our own weapon switcher because the hl2 one skips empty weapons

local math = math
local draw = draw
local surface = surface
local table = table

WSWITCH = {}

WSWITCH.Show = false
WSWITCH.Selected = -1
WSWITCH.NextSwitch = -1
WSWITCH.WeaponCache = {}

WSWITCH.cv = {}
WSWITCH.cv.stay = CreateConVar("ttt_weaponswitcher_stay", "0", FCVAR_ARCHIVE)
WSWITCH.cv.fast = CreateConVar("ttt_weaponswitcher_fast", "0", FCVAR_ARCHIVE)
WSWITCH.cv.display = CreateConVar("ttt_weaponswitcher_displayfast", "0", FCVAR_ARCHIVE)

local delay = 0.03
local showtime = 3

local margin = 10
local width = 300
local height = 20

local barcorner = surface.GetTextureID( "gui/corner8" )

local col_active = {
   tip = {
      [ROLE_INNOCENT]  = Color(55, 170, 50, 255),
      [ROLE_TRAITOR]   = Color(180, 50, 40, 255),
      [ROLE_DETECTIVE] = Color(50, 60, 180, 255)
   },

   bg = Color(20, 20, 20, 250),

   text_empty = Color(200, 20, 20, 255),
   text = Color(255, 255, 255, 255),

   shadow = 255
};

local col_dark = {
   tip = {
      [ROLE_INNOCENT]  = Color(60, 160, 50, 155),
      [ROLE_TRAITOR]   = Color(160, 50, 60, 155),
      [ROLE_DETECTIVE] = Color(50, 60, 160, 155),
   },

   bg = Color(20, 20, 20, 200),

   text_empty = Color(200, 20, 20, 100),
   text = Color(255, 255, 255, 100),

   shadow = 100
};

-- Draw a bar in the style of the the weapon pickup ones
local round = math.Round
function WSWITCH:DrawBarBg(x, y, w, h, col)
   local rx = round(x - 4)
   local ry = round(y - (h / 2)-4)
   local rw = round(w + 9)
   local rh = round(h + 8)

   local b = 8 --bordersize
   local bh = b / 2

   local role = LocalPlayer():GetRole() or ROLE_INNOCENT

   local c = col.tip[role]

   -- Draw the colour tip
   surface.SetTexture(barcorner)

   surface.SetDrawColor(c.r, c.g, c.b, c.a)
   surface.DrawTexturedRectRotated( rx + bh , ry + bh, b, b, 0 ) 
   surface.DrawTexturedRectRotated( rx + bh , ry + rh -bh, b, b, 90 ) 
   surface.DrawRect( rx, ry+b, b, rh-b*2 )
   surface.DrawRect( rx+b, ry, h - 4, rh )
   
   -- Draw the remainder
   -- Could just draw a full roundedrect bg and overdraw it with the tip, but
   -- I don't have to do the hard work here anymore anyway
   c = col.bg
   surface.SetDrawColor(c.r, c.g, c.b, c.a)

   surface.DrawRect( rx+b+h-4, ry,  rw - (h - 4) - b*2,  rh )
   surface.DrawTexturedRectRotated( rx + rw - bh , ry + rh - bh, b, b, 180 ) 
   surface.DrawTexturedRectRotated( rx + rw - bh , ry + bh, b, b, 270 ) 
   surface.DrawRect( rx+rw-b,  ry+b,  b,  rh-b*2 )

end

local TryTranslation = LANG.TryTranslation
function WSWITCH:DrawWeapon(x, y, c, wep)
   if not IsValid(wep) then return false end

   local name = TryTranslation(wep:GetPrintName() or wep.PrintName or "...")
   local cl1, am1 = wep:Clip1(), wep:Ammo1()
   local ammo = false

   -- Clip1 will be -1 if a melee weapon
   -- Ammo1 will be false if weapon has no owner (was just dropped)
   if cl1 != -1 and am1 != false then
      ammo = Format("%i + %02i", cl1, am1)
   end

   -- Slot
   local spec = {text=wep.Slot+1, font="Trebuchet22", pos={x+4, y}, yalign=TEXT_ALIGN_CENTER, color=c.text}
   draw.TextShadow(spec, 1, c.shadow)

   -- Name
   spec.text  = name
   spec.font  = "TimeLeft"
   spec.pos[1] = x + 10 + height
   draw.Text(spec)

   if ammo then
      local col = c.text

      if wep:Clip1() == 0 and wep:Ammo1() == 0 then
         col = c.text_empty
      end

      -- Ammo
      spec.text   = ammo
      spec.pos[1] = ScrW() - margin*3
      spec.xalign = TEXT_ALIGN_RIGHT
      spec.color  = col
      draw.Text(spec)
   end

   return true
end

function WSWITCH:Draw(client)
   if not self.Show then return end

   local weps = self.WeaponCache

   local x = ScrW() - width - margin*2
   local y = ScrH() - (#weps * (height + margin))

   local col = col_dark
   for k, wep in pairs(weps) do
      if self.Selected == k then
         col = col_active
      else
         col = col_dark
      end

      self:DrawBarBg(x, y, width, height, col)
      if not self:DrawWeapon(x, y, col, wep) then
         
         self:UpdateWeaponCache()
         return
      end

      y = y + height + margin
   end
end

local function SlotSort(a, b)
   return a and b and a.Slot and b.Slot and a.Slot < b.Slot
end

local function CopyVals(src, dest)
   table.Empty(dest)
   for k, v in pairs(src) do
      if IsValid(v) then
         table.insert(dest, v)
      end
   end   
end

function WSWITCH:UpdateWeaponCache()
   -- GetWeapons does not always return a proper numeric table it seems
   --   self.WeaponCache = LocalPlayer():GetWeapons()
   -- So copy over the weapon refs
   self.WeaponCache = {}
   CopyVals(LocalPlayer():GetWeapons(), self.WeaponCache)

   table.sort(self.WeaponCache, SlotSort)
end

function WSWITCH:SetSelected(idx)
   self.Selected = idx

   self:UpdateWeaponCache()
end

function WSWITCH:SelectNext()
   if self.NextSwitch > CurTime() then return end
   self:Enable()

   local s = self.Selected + 1
   if s > #self.WeaponCache then
      s = 1
   end

   self:DoSelect(s)

   self.NextSwitch = CurTime() + delay
end

function WSWITCH:SelectPrev()
   if self.NextSwitch > CurTime() then return end
   self:Enable()

   local s = self.Selected - 1
   if s < 1 then
      s = #self.WeaponCache
   end

   self:DoSelect(s)

   self.NextSwitch = CurTime() + delay
end

-- Select by index
function WSWITCH:DoSelect(idx)
   self:SetSelected(idx)

   if self.cv.fast:GetBool() then
      -- immediately confirm if fastswitch is on
      self:ConfirmSelection(self.cv.display:GetBool())
   end   
end

-- Numeric key access to direct slots
function WSWITCH:SelectSlot(slot)
   if not slot then return end

   self:Enable()

   self:UpdateWeaponCache()

   slot = slot - 1

   -- find which idx in the weapon table has the slot we want
   local toselect = self.Selected
   for k, w in pairs(self.WeaponCache) do
      if w.Slot == slot then
         toselect = k
         break
      end
   end

   self:DoSelect(toselect)

   self.NextSwitch = CurTime() + delay
end

-- Show the weapon switcher
function WSWITCH:Enable()
   if self.Show == false then
      self.Show = true

      local wep_active = LocalPlayer():GetActiveWeapon()

      self:UpdateWeaponCache()

      -- make our active weapon the initial selection
      local toselect = 1
      for k, w in pairs(self.WeaponCache) do
         if w == wep_active then
            toselect = k
            break
         end
      end
      self:SetSelected(toselect)
   end

   -- cache for speed, checked every Think
   self.Stay = self.cv.stay:GetBool()
end

-- Hide switcher
function WSWITCH:Disable()
   self.Show = false
end

-- Switch to the currently selected weapon
function WSWITCH:ConfirmSelection(noHide)
   if not noHide then self:Disable() end

   for k, w in pairs(self.WeaponCache) do
      if k == self.Selected and IsValid(w) then
         RunConsoleCommand("wepswitch", w:GetClass())
         return
      end
   end
end

-- Allow for suppression of the attack command
function WSWITCH:PreventAttack()
   return self.Show and !self.cv.fast:GetBool()
end

function WSWITCH:Think()
   if (not self.Show) or self.Stay then return end

   -- hide after period of inaction
   if self.NextSwitch < (CurTime() - showtime) then
      self:Disable()
   end
end

-- Instantly select a slot and switch to it, without spending time in menu
function WSWITCH:SelectAndConfirm(slot)
   if not slot then return end
   WSWITCH:SelectSlot(slot)
   WSWITCH:ConfirmSelection()
end

local function QuickSlot(ply, cmd, args)
   if (not IsValid(ply)) or (not args) or #args != 1 then return end

   local slot = tonumber(args[1])
   if not slot then return end

   local wep = ply:GetActiveWeapon()
   if IsValid(wep) then
      if wep.Slot == (slot - 1) then
         RunConsoleCommand("lastinv")
      else
         WSWITCH:SelectAndConfirm(slot)
      end
   end   
end
concommand.Add("ttt_quickslot", QuickSlot)


local function SwitchToEquipment(ply, cmd, args)
   RunConsoleCommand("ttt_quickslot", tostring(7))
end
concommand.Add("ttt_equipswitch", SwitchToEquipment)
