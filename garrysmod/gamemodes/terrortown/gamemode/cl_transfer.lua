
--- Credit transfer tab for equipment menu
local GetTranslation = LANG.GetTranslation
function CreateTransferMenu(parent)
   local dform = vgui.Create("DForm", parent)
   dform:SetName(GetTranslation("xfer_menutitle"))
   dform:StretchToParent(0,0,0,0)
   dform:SetAutoSize(false)

   if LocalPlayer():GetCredits() <= 0 then
      dform:Help(GetTranslation("xfer_no_credits"))
      return dform
   end

   local bw, bh = 100, 20
   local dsubmit = vgui.Create("DButton", dform)
   dsubmit:SetSize(bw, bh)
   dsubmit:SetDisabled(true)
   dsubmit:SetText(GetTranslation("xfer_send"))

   local selected_sid = nil

   local dpick = vgui.Create("DComboBox", dform)
   dpick.OnSelect = function(s, idx, val, data)
                       if data then
                          selected_sid = data
                          dsubmit:SetDisabled(false)
                       end
                    end

   dpick:SetWide(250)

   -- fill combobox
   local r = LocalPlayer():GetRole()
   for _, p in pairs(player.GetAll()) do
      if IsValid(p) and p:IsActiveRole(r) and p != LocalPlayer() then
         dpick:AddChoice(p:Nick(), p:SteamID())
      end
   end

   -- select first player by default
   if dpick:GetOptionText(1) then dpick:ChooseOptionID(1) end

   dsubmit.DoClick = function(s)
                        if selected_sid then
                           RunConsoleCommand("ttt_transfer_credits", selected_sid, "1")
                        end
                     end

   dsubmit.Think = function(s)
                      if LocalPlayer():GetCredits() < 1 then
                         s:SetDisabled(true)
                      end
                   end

   dform:AddItem(dpick)
   dform:AddItem(dsubmit)

   dform:Help(LANG.GetParamTranslation("xfer_help", {role = LocalPlayer():GetRoleString()}))

   return dform
end
