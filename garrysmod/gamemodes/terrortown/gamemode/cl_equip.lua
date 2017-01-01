---- Traitor equipment menu

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

-- Buyable weapons are loaded automatically. Buyable items are defined in
-- equip_items_shd.lua

local Equipment = nil
function GetEquipmentForRole(role)
   -- need to build equipment cache?
   if not Equipment then
      -- start with all the non-weapon goodies
      local tbl = table.Copy(EquipmentItems)

      -- find buyable weapons to load info from
      for k, v in pairs(weapons.GetList()) do
         if v and v.CanBuy then
            local data = v.EquipMenuData or {}
            local base = {
               id       = WEPS.GetClass(v),
               name     = v.PrintName or "Unnamed",
               limited  = v.LimitedStock,
               kind     = v.Kind or WEAPON_NONE,
               slot     = (v.Slot or 0) + 1,
               material = v.Icon or "vgui/ttt/icon_id",
               -- the below should be specified in EquipMenuData, in which case
               -- these values are overwritten
               type     = "Type not specified",
               model    = "models/weapons/w_bugbait.mdl",
               desc     = "No description specified."
            };

            -- Force material to nil so that model key is used when we are
            -- explicitly told to do so (ie. material is false rather than nil).
            if data.modelicon then
               base.material = nil
            end

            table.Merge(base, data)

            -- add this buyable weapon to all relevant equipment tables
            for _, r in pairs(v.CanBuy) do
               table.insert(tbl[r], base)
            end
         end
      end

      -- mark custom items
      for r, is in pairs(tbl) do
         for _, i in pairs(is) do
            if i and i.id then
               i.custom = not table.HasValue(DefaultEquipment[r], i.id)
            end
         end
      end

      Equipment = tbl
   end

   return Equipment and Equipment[role] or {}
end


local function ItemIsWeapon(item) return not tonumber(item.id) end
local function CanCarryWeapon(item) return LocalPlayer():CanCarryType(item.kind) end

local color_bad = Color(220, 60, 60, 255)
local color_good = Color(0, 200, 0, 255)

-- Creates tabel of labels showing the status of ordering prerequisites
local function PreqLabels(parent, x, y)
   local tbl = {}

   tbl.credits = vgui.Create("DLabel", parent)
   tbl.credits:SetTooltip(GetTranslation("equip_help_cost"))
   tbl.credits:SetPos(x, y)
   tbl.credits.Check = function(s, sel)
                          local credits = LocalPlayer():GetCredits()
                          return credits > 0, GetPTranslation("equip_cost", {num = credits})
                       end

   tbl.owned = vgui.Create("DLabel", parent)
   tbl.owned:SetTooltip(GetTranslation("equip_help_carry"))
   tbl.owned:CopyPos(tbl.credits)
   tbl.owned:MoveBelow(tbl.credits, y)
   tbl.owned.Check = function(s, sel)
                        if ItemIsWeapon(sel) and (not CanCarryWeapon(sel)) then
                           return false, GetPTranslation("equip_carry_slot", {slot = sel.slot})
                        elseif (not ItemIsWeapon(sel)) and LocalPlayer():HasEquipmentItem(sel.id) then
                           return false, GetTranslation("equip_carry_own")
                        else
                           return true, GetTranslation("equip_carry")
                        end
                     end

   tbl.bought = vgui.Create("DLabel", parent)
   tbl.bought:SetTooltip(GetTranslation("equip_help_stock"))
   tbl.bought:CopyPos(tbl.owned)
   tbl.bought:MoveBelow(tbl.owned, y)
   tbl.bought.Check = function(s, sel)
                         if sel.limited and LocalPlayer():HasBought(tostring(sel.id)) then
                            return false, GetTranslation("equip_stock_deny")
                         else
                            return true, GetTranslation("equip_stock_ok")
                         end
                      end

   for k, pnl in pairs(tbl) do
      pnl:SetFont("TabLarge")
   end

   return function(selected)
             local allow = true
             for k, pnl in pairs(tbl) do
                local result, text = pnl:Check(selected)
                pnl:SetTextColor(result and color_good or color_bad)
                pnl:SetText(text)
                pnl:SizeToContents()

                allow = allow and result
             end
             return allow
          end
end

-- quick, very basic override of DPanelSelect
local PANEL = {}
local function DrawSelectedEquipment(pnl)
   surface.SetDrawColor(255, 200, 0, 255)
   surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall())
end

function PANEL:SelectPanel(pnl)
   self.BaseClass.SelectPanel(self, pnl)
   if pnl then
      pnl.PaintOver = DrawSelectedEquipment
   end
end
vgui.Register("EquipSelect", PANEL, "DPanelSelect")


local SafeTranslate = LANG.TryTranslation

local color_darkened = Color(255,255,255, 80)
-- TODO: make set of global role colour defs, these are same as wepswitch
local color_slot = {
   [ROLE_TRAITOR]   = Color(180, 50, 40, 255),
   [ROLE_DETECTIVE] = Color(50, 60, 180, 255)
};

local eqframe = nil
local function TraitorMenuPopup()
   local ply = LocalPlayer()
   if not IsValid(ply) or not ply:IsActiveSpecial() then
      return
   end

   -- Close any existing traitor menu
   if eqframe and IsValid(eqframe) then eqframe:Close() end

   local credits = ply:GetCredits()
   local can_order = credits > 0

   local dframe = vgui.Create("DFrame")
   local w, h = 570, 412
   dframe:SetSize(w, h)
   dframe:Center()
   dframe:SetTitle(GetTranslation("equip_title"))
   dframe:SetVisible(true)
   dframe:ShowCloseButton(true)
   dframe:SetMouseInputEnabled(true)
   dframe:SetDeleteOnClose(true)

   local m = 5

   local dsheet = vgui.Create("DPropertySheet", dframe)

   -- Add a callback when switching tabs
   local oldfunc = dsheet.SetActiveTab
   dsheet.SetActiveTab = function(self, new)
      if self.m_pActiveTab != new and self.OnTabChanged then
         self:OnTabChanged(self.m_pActiveTab, new)
      end
      oldfunc(self, new)
   end

   dsheet:SetPos(0,0)
   dsheet:StretchToParent(m,m + 25,m,m)
   local padding = dsheet:GetPadding()

   local dequip = vgui.Create("DPanel", dsheet)
   dequip:SetPaintBackground(false)
   dequip:StretchToParent(padding,padding,padding,padding)

   -- Determine if we already have equipment
   local owned_ids = {}
   for _, wep in pairs(ply:GetWeapons()) do
      if IsValid(wep) and wep:IsEquipment() then
         table.insert(owned_ids, wep:GetClass())
      end
   end

   -- Stick to one value for no equipment
   if #owned_ids == 0 then
      owned_ids = nil
   end

   --- Construct icon listing
   local dlist = vgui.Create("EquipSelect", dequip)
   dlist:SetPos(0,0)
   dlist:SetSize(216, h - 75)
   dlist:EnableVerticalScrollbar(true)
   dlist:EnableHorizontal(true)
   dlist:SetPadding(4)


   local items = GetEquipmentForRole(ply:GetRole())

   local to_select = nil
   for k, item in pairs(items) do
      local ic = nil

      -- Create icon panel
      if item.material then
         if item.custom then
            -- Custom marker icon
            ic = vgui.Create("LayeredIcon", dlist)

            local marker = vgui.Create("DImage")
            marker:SetImage("vgui/ttt/custom_marker")
            marker.PerformLayout = function(s)
                                      s:AlignBottom(2)
                                      s:AlignRight(2)
                                      s:SetSize(16, 16)
                                   end
            marker:SetTooltip(GetTranslation("equip_custom"))

            ic:AddLayer(marker)

            ic:EnableMousePassthrough(marker)
         elseif not ItemIsWeapon(item) then
            ic = vgui.Create("SimpleIcon", dlist)
         else
            ic = vgui.Create("LayeredIcon", dlist)
         end

         -- Slot marker icon
         if ItemIsWeapon(item) then
            local slot = vgui.Create("SimpleIconLabelled")
            slot:SetIcon("vgui/ttt/slotcap")
            slot:SetIconColor(color_slot[ply:GetRole()] or COLOR_GREY)
            slot:SetIconSize(16)

            slot:SetIconText(item.slot)

            slot:SetIconProperties(COLOR_WHITE,
                                   "DefaultBold",
                                   {opacity=220, offset=1},
                                   {10, 8})

            ic:AddLayer(slot)
            ic:EnableMousePassthrough(slot)
         end

         ic:SetIconSize(64)
         ic:SetIcon(item.material)
      elseif item.model then
         ic = vgui.Create("SpawnIcon", dlist)
         ic:SetModel(item.model)
      else
         ErrorNoHalt("Equipment item does not have model or material specified: " .. tostring(item) .. "\n")
      end

      ic.item = item

      local tip = SafeTranslate(item.name) .. " (" .. SafeTranslate(item.type) .. ")"
      ic:SetTooltip(tip)

      -- If we cannot order this item, darken it
      if ((not can_order) or
          -- already owned
          table.HasValue(owned_ids, item.id) or
          (tonumber(item.id) and ply:HasEquipmentItem(tonumber(item.id))) or
          -- already carrying a weapon for this slot
          (ItemIsWeapon(item) and (not CanCarryWeapon(item))) or
          -- already bought the item before
          (item.limited and ply:HasBought(tostring(item.id)))) then

         ic:SetIconColor(color_darkened)
      end

      dlist:AddPanel(ic)
   end

   local dlistw = 216

   local bw, bh = 100, 25

   local dih = h - bh - m*5
   local diw = w - dlistw - m*6 - 2
   local dinfobg = vgui.Create("DPanel", dequip)
   dinfobg:SetPaintBackground(false)
   dinfobg:SetSize(diw, dih)
   dinfobg:SetPos(dlistw + m, 0)

   local dinfo = vgui.Create("ColoredBox", dinfobg)
   dinfo:SetColor(Color(90, 90, 95))
   dinfo:SetPos(0,0)
   dinfo:StretchToParent(0, 0, 0, dih - 135)

   local dfields = {}
   for _, k in pairs({"name", "type", "desc"}) do
      dfields[k] = vgui.Create("DLabel", dinfo)
      dfields[k]:SetTooltip(GetTranslation("equip_spec_" .. k))
      dfields[k]:SetPos(m*3, m*2)
   end

   dfields.name:SetFont("TabLarge")

   dfields.type:SetFont("DermaDefault")
   dfields.type:MoveBelow(dfields.name)

   dfields.desc:SetFont("DermaDefaultBold")
   dfields.desc:SetContentAlignment(7)
   dfields.desc:MoveBelow(dfields.type, 1)

   local iw, ih = dinfo:GetSize()

   local dhelp = vgui.Create("ColoredBox", dinfobg)
   dhelp:SetColor(Color(90, 90, 95))
   dhelp:SetSize(diw, dih - 205)
   dhelp:MoveBelow(dinfo, m)

   local update_preqs = PreqLabels(dhelp, m*3, m*2)

   dhelp:SizeToContents()

   local dconfirm = vgui.Create("DButton", dinfobg)
   dconfirm:SetPos(0, dih - bh*2)
   dconfirm:SetSize(bw, bh)
   dconfirm:SetDisabled(true)
   dconfirm:SetText(GetTranslation("equip_confirm"))


   dsheet:AddSheet(GetTranslation("equip_tabtitle"), dequip, "icon16/bomb.png", false, false, "Traitor equipment menu")

   -- Item control
   if ply:HasEquipmentItem(EQUIP_RADAR) then
      local dradar = RADAR.CreateMenu(dsheet, dframe)
      dsheet:AddSheet(GetTranslation("radar_name"), dradar, "icon16/magnifier.png", false,false, "Radar control")
   end

   if ply:HasEquipmentItem(EQUIP_DISGUISE) then
      local ddisguise = DISGUISE.CreateMenu(dsheet)
      dsheet:AddSheet(GetTranslation("disg_name"), ddisguise, "icon16/user.png", false,false, "Disguise control")
   end

   -- Weapon/item control
   if IsValid(ply.radio) or ply:HasWeapon("weapon_ttt_radio") then
      local dradio = TRADIO.CreateMenu(dsheet)
      dsheet:AddSheet(GetTranslation("radio_name"), dradio, "icon16/transmit.png", false,false, "Radio control")
   end

   -- Credit transferring
   if credits > 0 then
      local dtransfer = CreateTransferMenu(dsheet)
      dsheet:AddSheet(GetTranslation("xfer_name"), dtransfer, "icon16/group_gear.png", false,false, "Transfer credits")
   end

   hook.Run("TTTEquipmentTabs", dsheet)


   -- couple panelselect with info
   dlist.OnActivePanelChanged = function(self, _, new)
                                   for k,v in pairs(new.item) do
                                      if dfields[k] then
                                         dfields[k]:SetText(SafeTranslate(v))
                                         dfields[k]:SizeToContents()
                                      end
                                   end

                                   -- Trying to force everything to update to
                                   -- the right size is a giant pain, so just
                                   -- force a good size.
                                   dfields.desc:SetTall(70)

                                   can_order = update_preqs(new.item)

                                   dconfirm:SetDisabled(not can_order)
                                end

   -- select first
   dlist:SelectPanel(to_select or dlist:GetItems()[1])

   -- prep confirm action
   dconfirm.DoClick = function()
                         local pnl = dlist.SelectedPanel
                         if not pnl or not pnl.item then return end
                         local choice = pnl.item
                         RunConsoleCommand("ttt_order_equipment", choice.id)
                         dframe:Close()
                      end

   -- update some basic info, may have changed in another tab
   -- specifically the number of credits in the preq list
   dsheet.OnTabChanged = function(s, old, new)
                            if not IsValid(new) then return end

                            if new:GetPanel() == dequip then
                               can_order = update_preqs(dlist.SelectedPanel.item)
                               dconfirm:SetDisabled(not can_order)
                            end
                         end

   local dcancel = vgui.Create("DButton", dframe)
   dcancel:SetPos(w - 13 - bw, h - bh - 16)
   dcancel:SetSize(bw, bh)
   dcancel:SetDisabled(false)
   dcancel:SetText(GetTranslation("close"))
   dcancel.DoClick = function() dframe:Close() end

   dframe:MakePopup()
   dframe:SetKeyboardInputEnabled(false)

   eqframe = dframe
end
concommand.Add("ttt_cl_traitorpopup", TraitorMenuPopup)

local function ForceCloseTraitorMenu(ply, cmd, args)
   if IsValid(eqframe) then
      eqframe:Close()
   end
end
concommand.Add("ttt_cl_traitorpopup_close", ForceCloseTraitorMenu)

function GM:OnContextMenuOpen()
   local r = GetRoundState()
   if r == ROUND_ACTIVE and not (LocalPlayer():GetTraitor() or LocalPlayer():GetDetective()) then
      return
   elseif r == ROUND_POST or r == ROUND_PREP then
      CLSCORE:Reopen()
      return
   end

   RunConsoleCommand("ttt_cl_traitorpopup")
end

local function ReceiveEquipment()
   local ply = LocalPlayer()
   if not IsValid(ply) then return end

   ply.equipment_items = net.ReadUInt(16)
end
net.Receive("TTT_Equipment", ReceiveEquipment)

local function ReceiveCredits()
   local ply = LocalPlayer()
   if not IsValid(ply) then return end

   ply.equipment_credits = net.ReadUInt(8)
end
net.Receive("TTT_Credits", ReceiveCredits)

local r = 0
local function ReceiveBought()
   local ply = LocalPlayer()
   if not IsValid(ply) then return end

   ply.bought = {}
   local num = net.ReadUInt(8)
   for i=1,num do
      local s = net.ReadString()
      if s != "" then
         table.insert(ply.bought, s)
      end
   end

   -- This usermessage sometimes fails to contain the last weapon that was
   -- bought, even though resending then works perfectly. Possibly a bug in
   -- bf_read. Anyway, this hack is a workaround: we just request a new umsg.
   if num != #ply.bought and r < 10 then -- r is an infinite loop guard
      RunConsoleCommand("ttt_resend_bought")
      r = r + 1
   else
      r = 0
   end
end
net.Receive("TTT_Bought", ReceiveBought)

-- Player received the item he has just bought, so run clientside init
local function ReceiveBoughtItem()
   local is_item = net.ReadBit() == 1
   local id = is_item and net.ReadUInt(16) or net.ReadString()

   -- I can imagine custom equipment wanting this, so making a hook
   hook.Run("TTTBoughtItem", is_item, id)
end
net.Receive("TTT_BoughtItem", ReceiveBoughtItem)
