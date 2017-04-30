
local util = util
local surface = surface
local draw = draw

local GetPTranslation = LANG.GetParamTranslation
local GetRaw = LANG.GetRawTranslation

local key_params = {usekey = Key("+use", "USE"), walkkey = Key("+walk", "WALK")}

local ClassHint = {
   prop_ragdoll = {
      name= "corpse",
      hint= "corpse_hint",

      fmt = function(ent, txt) return GetPTranslation(txt, key_params) end
   }
};

-- Basic access for servers to add/modify hints. They override hints stored on
-- the entities themselves.
function GM:AddClassHint(cls, hint)
   ClassHint[cls] = table.Copy(hint)
end


---- "T" indicator above traitors

local indicator_mat = Material("vgui/ttt/sprite_traitor")
local indicator_col = Color(255, 255, 255, 130)

local client, plys, ply, pos, dir, tgt
local GetPlayers = player.GetAll

local propspec_outline = Material("models/props_combine/portalball001_sheet")

-- using this hook instead of pre/postplayerdraw because playerdraw seems to
-- happen before certain entities are drawn, which then clip over the sprite
function GM:PostDrawTranslucentRenderables()
   client = LocalPlayer()
   plys = GetPlayers()

   if client:GetTraitor() then

      dir = client:GetForward() * -1

      render.SetMaterial(indicator_mat)

      for i=1, #plys do
         ply = plys[i]
         if ply:IsActiveTraitor() and ply != client then
            pos = ply:GetPos()
            pos.z = pos.z + 74

            render.DrawQuadEasy(pos, dir, 8, 8, indicator_col, 180)
         end
      end
   end

   if client:Team() == TEAM_SPEC then
      cam.Start3D(EyePos(), EyeAngles())

      for i=1, #plys do
         ply = plys[i]
         tgt = ply:GetObserverTarget()
         if IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == ply then
            render.MaterialOverride(propspec_outline)
            render.SuppressEngineLighting(true)
            render.SetColorModulation(1, 0.5, 0)

            tgt:SetModelScale(1.05, 0)
            tgt:DrawModel()

            render.SetColorModulation(1, 1, 1)
            render.SuppressEngineLighting(false)
            render.MaterialOverride(nil)
         end
      end

      cam.End3D()
   end
end

---- Spectator labels

local function DrawPropSpecLabels(client)
   if (not client:IsSpec()) and (GetRoundState() != ROUND_POST) then return end

   surface.SetFont("TabLarge")

   local tgt = nil
   local scrpos = nil
   local text = nil
   local w = 0
   for _, ply in pairs(player.GetAll()) do
      if ply:IsSpec() then
         surface.SetTextColor(220,200,0,120)

         tgt = ply:GetObserverTarget()

         if IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == ply then

            scrpos = tgt:GetPos():ToScreen()
         else
            scrpos = nil
         end
      else
         local _, healthcolor = util.HealthToString(ply:Health(), ply:GetMaxHealth())
         surface.SetTextColor(clr(healthcolor))

         scrpos = ply:EyePos()
         scrpos.z = scrpos.z + 20

         scrpos = scrpos:ToScreen()
      end

      if scrpos and (not IsOffScreen(scrpos)) then
         text = ply:Nick()
         w, _ = surface.GetTextSize(text)

         surface.SetTextPos(scrpos.x - w / 2, scrpos.y)
         surface.DrawText(text)
      end
   end
end


---- Crosshair affairs

surface.CreateFont("TargetIDSmall2", {font = "TargetID",
                                      size = 16,
                                      weight = 1000})

local minimalist = CreateConVar("ttt_minimal_targetid", "0", FCVAR_ARCHIVE)

local magnifier_mat = Material("icon16/magnifier.png")
local ring_tex = surface.GetTextureID("effects/select_ring")

local rag_color = Color(200,200,200,255)

local GetLang = LANG.GetUnsafeLanguageTable

function GM:HUDDrawTargetID()
   local client = LocalPlayer()

   local L = GetLang()

   DrawPropSpecLabels(client)

   local trace = client:GetEyeTrace(MASK_SHOT)
   local ent = trace.Entity
   if (not IsValid(ent)) or ent.NoTarget then return end

   -- some bools for caching what kind of ent we are looking at
   local target_traitor = false
   local target_detective = false
   local target_corpse = false

   local text = nil
   local color = COLOR_WHITE

   -- if a vehicle, we identify the driver instead
   if IsValid(ent:GetNWEntity("ttt_driver", nil)) then
      ent = ent:GetNWEntity("ttt_driver", nil)

      if ent == client then return end
   end

   local cls = ent:GetClass()
   local minimal = minimalist:GetBool()
   local hint = (not minimal) and (ent.TargetIDHint or ClassHint[cls])

   if ent:IsPlayer() then
      if ent:GetNWBool("disguised", false) then
         client.last_id = nil

         if client:IsTraitor() or client:IsSpec() then
            text = ent:Nick() .. L.target_disg
         else
            -- Do not show anything
            return
         end

         color = COLOR_RED
      else
         text = ent:Nick()
         client.last_id = ent
      end

      local _ -- Stop global clutter
      -- in minimalist targetID, colour nick with health level
      if minimal then
         _, color = util.HealthToString(ent:Health(), ent:GetMaxHealth())
      end

      if client:IsTraitor() and GetRoundState() == ROUND_ACTIVE then
         target_traitor = ent:IsTraitor()
      end

      target_detective = GetRoundState() > ROUND_PREP and ent:IsDetective() or false

   elseif cls == "prop_ragdoll" then
      -- only show this if the ragdoll has a nick, else it could be a mattress
      if CORPSE.GetPlayerNick(ent, false) == false then return end

      target_corpse = true

      if CORPSE.GetFound(ent, false) or not DetectiveMode() then
         text = CORPSE.GetPlayerNick(ent, "A Terrorist")
      else
         text  = L.target_unid
         color = COLOR_YELLOW
      end
   elseif not hint then
      -- Not something to ID and not something to hint about
      return
   end

   local x_orig = ScrW() / 2.0
   local x = x_orig
   local y = ScrH() / 2.0

   local w, h = 0,0 -- text width/height, reused several times

   if target_traitor or target_detective then
      surface.SetTexture(ring_tex)

      if target_traitor then
         surface.SetDrawColor(255, 0, 0, 200)
      else
         surface.SetDrawColor(0, 0, 255, 220)
      end
      surface.DrawTexturedRect(x-32, y-32, 64, 64)
   end

   y = y + 30
   local font = "TargetID"
   surface.SetFont( font )

   -- Draw main title, ie. nickname
   if text then
      w, h = surface.GetTextSize( text )

      x = x - w / 2

      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
      draw.SimpleText( text, font, x, y, color )

      -- for ragdolls searched by detectives, add icon
      if ent.search_result and client:IsDetective() then
         -- if I am detective and I know a search result for this corpse, then I
         -- have searched it or another detective has
         surface.SetMaterial(magnifier_mat)
         surface.SetDrawColor(200, 200, 255, 255)
         surface.DrawTexturedRect(x + w + 5, y, 16, 16)
      end

      y = y + h + 4
   end

   -- Minimalist target ID only draws a health-coloured nickname, no hints, no
   -- karma, no tag
   if minimal then return end

   -- Draw subtitle: health or type
   local clr = rag_color
   if ent:IsPlayer() then
      text, clr = util.HealthToString(ent:Health(), ent:GetMaxHealth())

      -- HealthToString returns a string id, need to look it up
      text = L[text]
   elseif hint then
      text = GetRaw(hint.name) or hint.name
   else
      return
   end
   font = "TargetIDSmall2"

   surface.SetFont( font )
   w, h = surface.GetTextSize( text )
   x = x_orig - w / 2

   draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
   draw.SimpleText( text, font, x, y, clr )

   font = "TargetIDSmall"
   surface.SetFont( font )

   -- Draw second subtitle: karma
   if ent:IsPlayer() and KARMA.IsEnabled() then
      text, clr = util.KarmaToString(ent:GetBaseKarma())

      text = L[text]

      w, h = surface.GetTextSize( text )
      y = y + h + 5
      x = x_orig - w / 2

      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
      draw.SimpleText( text, font, x, y, clr )
   end

   -- Draw key hint
   if hint and hint.hint then
      if not hint.fmt then
         text = GetRaw(hint.hint) or hint.hint
      else
         text = hint.fmt(ent, hint.hint)
      end

      w, h = surface.GetTextSize(text)
      x = x_orig - w / 2
      y = y + h + 5
      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
      draw.SimpleText( text, font, x, y, COLOR_LGRAY )
   end

   text = nil

   if target_traitor then
      text = L.target_traitor
      clr = COLOR_RED
   elseif target_detective then
      text = L.target_detective
      clr = COLOR_BLUE
   elseif ent.sb_tag and ent.sb_tag.txt != nil then
      text = L[ ent.sb_tag.txt ]
      clr = ent.sb_tag.color
   elseif target_corpse and client:IsActiveTraitor() and CORPSE.GetCredits(ent, 0) > 0 then
      text = L.target_credits
      clr = COLOR_YELLOW
   end

   if text then
      w, h = surface.GetTextSize( text )
      x = x_orig - w / 2
      y = y + h + 5

      draw.SimpleText( text, font, x+1, y+1, COLOR_BLACK )
      draw.SimpleText( text, font, x, y, clr )
   end
end
