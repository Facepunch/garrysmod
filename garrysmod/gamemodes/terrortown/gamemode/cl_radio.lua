--- Traitor radio controls

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local TryTranslation = LANG.TryTranslation

TRADIO.SoundOrder = {
   "scream", "burning", "explosion", "footsteps",
   "pistol", "shotgun", "mac10", "deagle",
   "m16", "rifle", "huge", "glock",
   "beeps", "sipistol", "teleport", "hstation"
};

local function PlayRadioSound(snd)
   local r = LocalPlayer().radio
   if IsValid(r) then
      RunConsoleCommand("ttt_radio_play", tostring(r:EntIndex()), snd)
   end
end

local function ButtonClickPlay(s) PlayRadioSound(s.snd) end

local columns = 4
local rows = 5

local bh, bw = 50, 120
local m = 5

local function CreateSoundBoard(parent)
   local b = vgui.Create("DScrollPanel", parent)

   local sorder = TRADIO.SoundOrder
   local ver = math.min(math.ceil(#sorder / columns), rows)
   local sbar = ver == rows and b:GetVBar():GetWide() or 0

   b:SetSize(bw * columns + m * (columns - 1) + sbar, bh * ver + m * (ver - 1))
   b:SetPos(m, 25)
   b:CenterHorizontal()

   local grid = vgui.Create("DIconLayout", b)
   grid:Dock(FILL)
   grid:SetSpaceX(m)
   grid:SetSpaceY(m)

   for ri, snd in ipairs(sorder) do
      local but = grid:Add("DButton")
      but:SetSize(bw, bh)

      local name = TRADIO.Sounds[snd].name
      local name_params = TRADIO.Sounds[snd].name_params
      local translated = TryTranslation(name)
      if name_params and name != translated then
         translated = GetPTranslation(name, name_params)
      end
      but:SetText(translated)

      but.snd = snd
      but.DoClick = ButtonClickPlay
   end

   return b
end

function TRADIO.CreateMenu(parent)
   local w, h = parent:GetSize()

   local client = LocalPlayer()

   local wrap = vgui.Create("DPanel", parent)
   wrap:SetSize(w, h)
   wrap:SetPaintBackground(false)

   local dhelp = vgui.Create("DLabel", wrap)
   dhelp:SetFont("TabLarge")
   dhelp:SetText(GetTranslation("radio_help"))
   dhelp:SetTextColor(COLOR_WHITE)

   if IsValid(client.radio) then
      CreateSoundBoard(wrap)
   elseif client:HasWeapon("weapon_ttt_radio") then
      dhelp:SetText(GetTranslation("radio_notplaced"))
   end

   dhelp:SizeToContents()
   dhelp:SetPos(10, 5)
   dhelp:CenterHorizontal()

   return wrap
end
