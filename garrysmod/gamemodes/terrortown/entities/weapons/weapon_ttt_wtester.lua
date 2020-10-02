-- DNA Scanner

AddCSLuaFile()

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType              = "normal"

if CLIENT then
   SWEP.PrintName          = "dna_name"
   SWEP.Slot               = 8

   SWEP.ViewModelFOV       = 10
   SWEP.DrawCrosshair      = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "dna_desc"
   };

   SWEP.Icon               = "vgui/ttt/icon_wtester"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.ViewModel             = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel            = "models/props_lab/huladoll.mdl"

SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.Delay         = 1
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"
SWEP.Secondary.Delay       = 2

SWEP.Kind                  = WEAPON_ROLE
SWEP.CanBuy                = nil -- no longer a buyable thing
SWEP.WeaponID              = AMMO_WTESTER

SWEP.InLoadoutFor          = {ROLE_DETECTIVE}

--SWEP.AllowDrop = false
SWEP.AutoSpawnable         = false
SWEP.NoSights              = true

SWEP.Range                 = 175

SWEP.ItemSamples           = {}

SWEP.NowRepeating          = nil

local MAX_ITEM = 30
SWEP.MaxItemSamples        = MAX_ITEM

local CHARGE_DELAY = 0.1
local CHARGE_RATE = 3
local MAX_CHARGE = 1250

local SAMPLE_PLAYER = 1
local SAMPLE_ITEM   = 2

AccessorFuncDT(SWEP, "charge", "Charge")
AccessorFuncDT(SWEP, "last_scanned", "LastScanned")

if CLIENT then
   CreateClientConVar("ttt_dna_scan_repeat", 1, true, true)
else
   function SWEP:GetRepeating()
      local ply = self:GetOwner()
      return IsValid(ply) and ply:GetInfoNum("ttt_dna_scan_repeat", 1) == 1
   end
end

SWEP.NextCharge = 0

function SWEP:SetupDataTables()
   self:DTVar("Int", 0, "charge")
   self:DTVar("Int", 1, "last_scanned")

   return self.BaseClass.SetupDataTables(self)
end

function SWEP:Initialize()
   self:SetCharge(MAX_CHARGE)
   self:SetLastScanned(-1)

   if CLIENT then
      self:AddHUDHelp("dna_help_primary", "dna_help_secondary", true)
   end

   return self.BaseClass.Initialize(self)
end

local beep_miss = Sound("player/suit_denydevice.wav")
function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   -- will be tracing against players
   self:GetOwner():LagCompensation(true)

   local spos = self:GetOwner():GetShootPos()
   local sdest = spos + (self:GetOwner():GetAimVector() * self.Range)

   local tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT})
   local ent = tr.Entity
   if IsValid(ent) and (not ent:IsPlayer()) then
      if SERVER then
         if ent:GetClass() == "prop_ragdoll" and ent.killer_sample then
            if CORPSE.GetFound(ent, false) then
               self:GatherRagdollSample(ent)
            else
               self:Report("dna_identify")
            end
         elseif ent.fingerprints and #ent.fingerprints > 0 then
            self:GatherObjectSample(ent)
         else
            self:Report("dna_notfound")
         end
      end
   else
      if CLIENT then
         self:GetOwner():EmitSound(beep_miss)
      end
   end

   self:GetOwner():LagCompensation(false)
end

function SWEP:GatherRagdollSample(ent)
   local sample = ent.killer_sample or {t=0, killer=nil}
   local ply = sample.killer
   if (not IsValid(ply)) and sample.killer_sid then
      ply = player.GetBySteamID(sample.killer_sid)
   end


   if IsValid(ply) then
      if sample.t < CurTime() then
         self:Report("dna_decayed")
         return
      end

      local added = self:AddPlayerSample(ent, ply)

      if not added then
         self:Report("dna_limit")
      else
         self:Report("dna_killer")

         if self:GetRepeating() and self:GetCharge() == MAX_CHARGE then
            self:PerformScan(#self.ItemSamples)
         end
      end
   elseif ply != nil then
      -- not valid but not nil -> disconnected?
      self:Report("dna_no_killer")
   else
      self:Report("dna_notfound")
   end
end

function SWEP:GatherObjectSample(ent)
   if ent:GetClass() == "ttt_c4" and ent:GetArmed() then
      self:Report("dna_armed")
   else
      local collected, old, own = self:AddItemSample(ent)

      if collected == -1 then
         self:Report("dna_limit")
      else
         self:Report("dna_object", {num = collected})
      end
   end
end

function SWEP:Report(msg, params)
   LANG.Msg(self:GetOwner(), msg, params)
end

function SWEP:AddPlayerSample(corpse, killer)
   if #self.ItemSamples < self.MaxItemSamples then
      local prnt = {source=corpse, ply=killer, type=SAMPLE_PLAYER, cls=killer:GetClass()}
      if not table.HasTable(self.ItemSamples, prnt) then
         table.insert(self.ItemSamples, prnt)

         DamageLog("SAMPLE:\t " .. self:GetOwner():Nick() .. " retrieved DNA of " .. (IsValid(killer) and killer:Nick() or "<disconnected>") .. " from corpse of " .. (IsValid(corpse) and CORPSE.GetPlayerNick(corpse) or "<invalid>"))

         hook.Call("TTTFoundDNA", GAMEMODE, self:GetOwner(), killer, corpse)
      end
      return true
   end
   return false
end

function SWEP:AddItemSample(ent)
   if #self.ItemSamples < self.MaxItemSamples then
      table.Shuffle(ent.fingerprints)

      local new = 0
      local old = 0
      local own = 0
      for _, p in pairs(ent.fingerprints) do
         local prnt = {source=ent, ply=p, type=SAMPLE_ITEM, cls=ent:GetClass()}

         if p == self:GetOwner() then
            own = own + 1
         elseif table.HasTable(self.ItemSamples, prnt) then
            old = old + 1
         else
            table.insert(self.ItemSamples, prnt)

            DamageLog("SAMPLE:\t " .. self:GetOwner():Nick() .. " retrieved DNA of " .. (IsValid(p) and p:Nick() or "<disconnected>") .. " from " .. ent:GetClass())

            new = new + 1
            hook.Call("TTTFoundDNA", GAMEMODE, self:GetOwner(), p, ent)
         end
      end
      return new, old, own
   end
   return -1
end

function SWEP:RemoveItemSample(idx)
   if self.ItemSamples[idx] then
      if self:GetLastScanned() == idx then
         self:ClearScanState()
      end

      table.remove(self.ItemSamples, idx)
      
      self:SendPrints(false)
   end   
end

function SWEP:SecondaryAttack()
   self:SetNextSecondaryFire( CurTime() + 0.05 )

   if CLIENT then return end

   self:SendPrints(true)
end

if SERVER then
   -- Sending this all in one umsg limits the max number of samples. 17 player
   -- samples and 20 item samples (with 20 matches) has been verified as
   -- working in the old DNA sampler.
   function SWEP:SendPrints(should_open)
      net.Start("TTT_ShowPrints", self:GetOwner())
        net.WriteBit(should_open)
        net.WriteUInt(#self.ItemSamples, 8)

        for k, v in ipairs(self.ItemSamples) do
          net.WriteString(v.cls)
        end

      net.Send(self:GetOwner())
   end

   function SWEP:SendScan(pos)
      local clear = (pos == nil) or (not IsValid(self:GetOwner()))
      net.Start("TTT_ScanResult", self:GetOwner())
        net.WriteBit(clear)
        if not clear then
          net.WriteVector(pos)
        end
      net.Send(self:GetOwner())
   end

   function SWEP:ClearScanState()
      self:SetLastScanned(-1)
      self.NowRepeating = nil
      self:SendScan(nil)
   end

   local function GetScanTarget(sample)
      if not sample then return end

      local target = sample.ply
      if not IsValid(target) then return end

      -- decoys always take priority, even after death
      if IsValid(target.decoy) then
         target = target.decoy
      elseif not target:IsTerror() then
         -- fall back to ragdoll, as long as it's not destroyed
         target = target.server_ragdoll
         if not IsValid(target) then return end
      end

      return target
   end

   function SWEP:PerformScan(idx, repeated)
      if self:GetCharge() < MAX_CHARGE then return end

      local sample = self.ItemSamples[idx]
      if (not sample) or (not IsValid(self:GetOwner())) then
         if repeated then self:ClearScanState() end
         return
      end

      local target = GetScanTarget(sample)
      if not IsValid(target) then
         self:Report("dna_gone")
         self:SetCharge(self:GetCharge() - 50)

         if repeated then self:ClearScanState() end
         return
      end

      local pos = target:LocalToWorld(target:OBBCenter())

      self:SendScan(pos)
      
      self:SetLastScanned(idx)
      self.NowRepeating = self:GetRepeating()

      local dist = math.ceil(self:GetOwner():GetPos():Distance(pos))

      self:SetCharge(math.max(0, self:GetCharge() - math.max(50, dist / 2)))
   end

   function SWEP:Think()
      if self:GetCharge() < MAX_CHARGE then
         if self.NextCharge < CurTime() then
            self:SetCharge(math.min(MAX_CHARGE, self:GetCharge() + CHARGE_RATE))

            self.NextCharge = CurTime() + CHARGE_DELAY
         end
      elseif self.NowRepeating and IsValid(self:GetOwner()) then
         -- owner changed his mind since running last scan?
         if self:GetRepeating() then 
            self:PerformScan(self:GetLastScanned(), true)
         else
            self.NowRepeating = self:GetRepeating()
         end
      end

      return true
   end
end

-- Helper to get at a player's scanner, if he has one
local function GetTester(ply)
   if IsValid(ply) then
      local tester = ply:GetActiveWeapon()
      if IsValid(tester) and tester:GetClass() == "weapon_ttt_wtester" then
         return tester
      end
   end
   return nil
end


if CLIENT then

   local T = LANG.GetTranslation
   local PT = LANG.GetParamTranslation
   local TT = LANG.TryTranslation
   
   function SWEP:DrawHUD()
      self:DrawHelp()

      local spos = self:GetOwner():GetShootPos()
      local sdest = spos + (self:GetOwner():GetAimVector() * self.Range)

      local tr = util.TraceLine({start=spos, endpos=sdest, filter=self:GetOwner(), mask=MASK_SHOT})

      local length = 20
      local gap = 6

      local can_sample = false

      local ent = tr.Entity
      if IsValid(ent) then
         -- weapon or dropped equipment
         if ((ent:IsWeapon() or ent.CanHavePrints) or
             -- knife in corpse, or a ragdoll
             ent:GetNWBool("HasPrints", false) or
             (ent:GetClass() == "prop_ragdoll" and
              CORPSE.GetPlayerNick(ent, false) and
              CORPSE.GetFound(ent, false))) then

            surface.SetDrawColor(0, 255, 0, 255)
            gap = 0

            can_sample = true
         else
            surface.SetDrawColor(255, 0, 0, 200)
            gap = 0
         end
      else
         surface.SetDrawColor(255, 255, 255, 200)
      end

      local x = ScrW() / 2.0
      local y = ScrH() / 2.0

      surface.DrawLine( x - length, y, x - gap, y )
      surface.DrawLine( x + length, y, x + gap, y )
      surface.DrawLine( x, y - length, x, y - gap )
      surface.DrawLine( x, y + length, x, y + gap )

      if ent and can_sample then
         surface.SetFont("DefaultFixedDropShadow")
         surface.SetTextColor(0, 255, 0, 255)
         surface.SetTextPos( x + length*2, y - length*2 )
         surface.DrawText(T("dna_hud_type") .. ": " .. (ent:GetClass() == "prop_ragdoll" and T("dna_hud_body") or T("dna_hud_item")))
         surface.SetTextPos( x + length*2, y - length*2 + 15)
         surface.DrawText("ID:   #" .. ent:EntIndex())
      end
   end

   local basedir = "vgui/ttt/icon_"
   local function GetDisplayData(cls)
      local wep = util.WeaponForClass(cls)

      local img = basedir .. "nades"
      local name = "something"

      if cls == "player" then
         img  = basedir .. "corpse"
         name = "corpse"
      elseif wep then
         img  = wep.Icon      or img
         name = wep.PrintName or name
      end

      return img, name
   end

   local last_panel_selected = 1
   local function ShowPrintsPopup(item_prints, tester)
      local m = 10
      local bw, bh = 100, 25

      local dpanel = vgui.Create("DFrame")
      local w, h = 400, 250
      dpanel:SetSize(w, h)

      dpanel:AlignRight(5)
      dpanel:AlignBottom(5)

      dpanel:SetTitle(T("dna_menu_title"))
      dpanel:SetVisible(true)
      dpanel:ShowCloseButton(true)
      dpanel:SetMouseInputEnabled(true)

      local wrap = vgui.Create("DPanel", dpanel)
      wrap:StretchToParent(m/2, m + 15, m/2, m + bh)
      wrap:SetPaintBackground(false)

      -- item sample listing
      local ilist = vgui.Create("DPanelSelect", wrap)
      ilist:StretchToParent(0,0,0,0)
      ilist:EnableHorizontal(true)
      ilist:SetSpacing(1)
      ilist:SetPadding(1)

      ilist.OnActivePanelChanged = function(s, old, new)
                                      last_panel_selected = new and new.key or 1
                                   end

      ilist.OnScan = function(s, scanned_pnl)
                        for k, pnl in pairs(s:GetItems()) do
                           pnl:SetIconColor(COLOR_LGRAY)
                        end

                        scanned_pnl:SetIconColor(COLOR_WHITE)
                     end

      if ilist.VBar then 
         ilist.VBar:Remove()
         ilist.VBar = nil
      end

      local iscroll = vgui.Create("DHorizontalScroller", ilist)
      iscroll:SetPos(3,1)
      iscroll:SetSize(363, 66)
      iscroll:SetOverlap(1)

      iscroll.LoadFrom = function(s, tbl, layout)
                            ilist:Clear(true)
                            ilist.SelectedPanel = nil

                            -- Scroller has no Clear()
                            for k, pnl in pairs(s.Panels) do
                               if IsValid(pnl) then
                                  pnl:Remove()
                               end
                            end

                            s.Panels = {}

                            local last_scan = tester and tester:GetLastScanned() or -1

                            for k, v in ipairs(tbl) do
                               local ic = vgui.Create("SimpleIcon", ilist)

                               ic:SetIconSize(64)

                               local img, name = GetDisplayData(v)

                               ic:SetIcon(img)

                               local tip = PT("dna_menu_sample", {source = TT(name) or "???"})

                               ic:SetTooltip(tip)

                               ic.key = k
                               ic.val = v

                               if layout then
                                  ic:PerformLayout()
                               end

                               ilist:AddPanel(ic)
                               s:AddPanel(ic)

                               if k == last_panel_selected then
                                  ilist:SelectPanel(ic)
                               end

                               if last_scan > 0 then
                                  ic:SetIconColor(last_scan == k and COLOR_WHITE or COLOR_LGRAY)
                               end
                            end

                            iscroll:InvalidateLayout()
                         end

      iscroll:LoadFrom(item_prints)

      local delwrap = vgui.Create("DPanel", wrap)
      delwrap:SetPos(m, 70)
      delwrap:SetSize(370, bh)
      delwrap:SetPaintBackground(false)

      local delitem = vgui.Create("DButton", delwrap)
      delitem:SetPos(0,0)
      delitem:SetSize(bw, bh)
      delitem:SetText(T("dna_menu_remove"))
      delitem.DoClick = function()
                           if IsValid(ilist) and IsValid(ilist.SelectedPanel) then
                              local idx = ilist.SelectedPanel.key
                              RunConsoleCommand("ttt_wtester_remove", idx)
                           end
                        end

      delitem.Think = function(s)
                         if IsValid(ilist) and IsValid(ilist.SelectedPanel) then
                            s:SetEnabled(true)
                         else
                            s:SetEnabled(false)
                         end
                      end

      local delhlp = vgui.Create("DLabel", delwrap)
      delhlp:SetPos(bw + m, 0)
      delhlp:SetText(T("dna_menu_help1"))
      delhlp:SizeToContents()


      -- hammer out layouts
      wrap:PerformLayout()
      -- scroller needs to sort itself out so it displays all icons it should
      iscroll:PerformLayout()

      local mwrap = vgui.Create("DPanel", wrap)
      mwrap:SetPaintBackground(false)
      mwrap:SetPos(m,100)
      mwrap:SetSize(370, 90)

      
      local bar = vgui.Create("TTTProgressBar", mwrap)
      bar:SetSize(370, 35)
      bar:SetPos(0, 0)
      bar:CenterHorizontal()
      bar:SetMin(0)
      bar:SetMax(MAX_CHARGE)
      bar:SetValue(tester and math.min(MAX_CHARGE, tester:GetCharge()))
      bar:SetColor(COLOR_GREEN)
      bar:LabelAsPercentage()

      local state = vgui.Create("DLabel", bar)
      state:SetSize(0, 35)
      state:SetPos(10, 6)
      state:SetFont("Trebuchet22")
      state:SetText(T("dna_menu_ready"))
      state:SetTextColor(COLOR_WHITE)
      state:SizeToContents()

      local scan = vgui.Create("DButton", mwrap)
      scan:SetText(T("dna_menu_scan"))
      scan:SetSize(bw, bh)
      scan:SetPos(0, 40)
      scan:SetEnabled(false)

      scan.DoClick = function(s)
                         if IsValid(ilist) then
                            local i = ilist.SelectedPanel
                            if IsValid(i) then
                               RunConsoleCommand("ttt_wtester_scan", i.key)

                               ilist:OnScan(i)
                            end
                         end
                      end

      local dcheck = vgui.Create("DCheckBoxLabel", mwrap)
      dcheck:SetPos(0, 70)
      dcheck:SetText(T("dna_menu_repeat"))
      dcheck:SetIndent(7)
      dcheck:SizeToContents()
      dcheck:SetConVar("ttt_dna_scan_repeat")
      --dcheck:SetValue(tester and tester:GetRepeating())


      local scanhlp = vgui.Create("DLabel", mwrap)
      scanhlp:SetPos(bw + m, 40)
      scanhlp:SetText(T("dna_menu_help2"))
      scanhlp:SizeToContents()

      -- CLOSE
      local dbut = vgui.Create("DButton", dpanel)
      dbut:SetSize(bw, bh)
      dbut:SetPos(m, h - bh - m/1.5)
      dbut:CenterHorizontal()
      dbut:SetText(T("close"))
      dbut.DoClick = function() dpanel:Close() end

      dpanel:MakePopup()
      dpanel:SetKeyboardInputEnabled(false)

      -- Expose updating fns
      dpanel.UpdatePrints = function(s, its)
                               if IsValid(iscroll) then
                                  iscroll:LoadFrom(its)
                               end
                            end

      dpanel.Think = function(s)
                        if IsValid(bar) and IsValid(scan) and tester then
                           local charge = tester:GetCharge()
                           bar:SetValue(math.min(MAX_CHARGE, charge))
                           if charge < MAX_CHARGE then
                              bar:SetColor(COLOR_RED)

                              state:SetText(T("dna_menu_charge"))
                              state:SizeToContents()

                              scan:SetEnabled(false)
                           else
                              bar:SetColor(COLOR_GREEN)

                              if IsValid(ilist) and IsValid(ilist.SelectedPanel) then
                                 scan:SetEnabled(true)

                                 state:SetText(T("dna_menu_ready"))
                                 state:SizeToContents()
                              else
                                 state:SetText(T("dna_menu_select"))
                                 state:SizeToContents()
                                 scan:SetEnabled(false)
                              end
                           end
                        end
                     end

      return dpanel
   end

   local printspanel = nil
   local function RecvPrints()
      local should_open = net.ReadBit() == 1

      local num = net.ReadUInt(8)
      local item_prints = {}
      for i=1, num do
         local ent = net.ReadString()
         table.insert(item_prints, ent)
      end

      if should_open then
         if IsValid(printspanel) then
            printspanel:Remove()
         end

         local tester = GetTester(LocalPlayer())

         printspanel = ShowPrintsPopup(item_prints, tester)
      else
         if IsValid(printspanel) then
            printspanel:UpdatePrints(item_prints)
         end
      end
   end
   net.Receive("TTT_ShowPrints", RecvPrints)

   local beep_success = Sound("buttons/blip2.wav")
   local function RecvScan()
      local clear = net.ReadBit() == 1
      if clear then
         RADAR.samples = {}
         RADAR.samples_count = 0
         return
      end

      local target_pos = net.ReadVector()
      if not target_pos then return end

      RADAR.samples = {
         {pos = target_pos}
      };

      RADAR.samples_count = 1

      surface.PlaySound(beep_success)
   end
   net.Receive("TTT_ScanResult", RecvScan)

   function SWEP:ClosePrintsPanel()
      if IsValid(printspanel) then
         printspanel:Close()
      end
   end

else -- SERVER

   local function ScanPrint(ply, cmd, args)
      if #args != 1 then return end

      local tester = GetTester(ply)
      if IsValid(tester) then
         local i = tonumber(args[1])

         if i then
            tester:PerformScan(i)
         end
      end
   end
   concommand.Add("ttt_wtester_scan", ScanPrint)

   local function RemoveSample(ply, cmd, args)
      if #args != 1 then return end

      local idx = tonumber(args[1])
      if not idx then return end

      local tester = GetTester(ply)
      if IsValid(tester) then
         tester:RemoveItemSample(idx)
      end
   end
   concommand.Add("ttt_wtester_remove", RemoveSample)

end

function SWEP:OnRemove()
   if CLIENT then
      self:ClosePrintsPanel()
   end
end

function SWEP:OnDrop()
end

function SWEP:PreDrop()
   if IsValid(self:GetOwner()) then
      self:GetOwner().scanner_weapon = nil
   end
end

function SWEP:Reload()
   return false
end

function SWEP:Deploy()
   if SERVER and IsValid(self:GetOwner()) then
      self:GetOwner():DrawViewModel(false)
      self:GetOwner().scanner_weapon = self
   end
   return true
end

if CLIENT then
   function SWEP:DrawWorldModel()
      if not IsValid(self:GetOwner()) then
         self:DrawModel()
      end
   end
end
