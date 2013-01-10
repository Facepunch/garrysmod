---- Adding informative info to sv_tags

include('crcs.lua')

local base_dir = "gamemodes/" .. GM.FolderName .. "/"

local crc32 = util.CRC
local fread = file.Read
function GM:CheckFileConsistency()
   MsgN("Checking TTT file consistency.")
   self.LocalCRCs = {}
   self.ModdedScripts = {}

   -- Loop over crc table and check values against local files
   for fname, crc in pairs(self.CRCs) do
      -- Why does util.CRC return a string?
      local crc_local = crc32(fread(base_dir .. fname, "GAME") or '')
      self.LocalCRCs[fname] = crc_local

      if crc_local != crc then
         table.insert(self.ModdedScripts, fname)

         Dev(1, Format("Script %s is modded: %s != %s", fname, crc, crc_local))
      end
   end
end

local function IsModded(fname)
   return GAMEMODE.CRCs[fname] != GAMEMODE.LocalCRCs[fname]
end

local knife_scripts = {
   "entities/weapons/weapon_ttt_knife/shared.lua",
   "entities/entities/ttt_knife_proj/shared.lua"
};

local function IsModdedKnife()
   for k, v in pairs(knife_scripts) do
      if IsModded(v) then return true end
   end
   return false
end

-- we only want to show the modded_knife tag if we modded more than the knife
local function IsModdedGame()
   for k, v in pairs(GAMEMODE.ModdedScripts) do
      -- any modded script that is not part of the knife == modded game
      if not table.HasValue(knife_scripts, v) then return true end
   end
   return false
end

-- Tagname -> predicate map, if predicate returns anything but false or nil, tag
-- is added. If the return value is a string, it replaces the tagname.
GM.TagPredicates = {
   ["ttt:version"] =
      function(gm) return "ttt:v" .. gm.Version end,

   ["ttt:custom_weapons"] =
      function(gm) return gm.Customized end,

   ["ttt:language"] =
      function(gm)
         local lng = GetConVarString("ttt_lang_serverdefault") or "english"
         if lng != "english" and lng != "" then
            return "ttt:language_" .. string.gsub(lng, "([^%w]*)", "")
         end
      end,

   ["ttt:modded_game"] = IsModdedGame,

   ["ttt:modded_knife"] = IsModdedKnife,

   ["ttt:vanilla"] =
      function(gm)
         return ((not gm.Customized) and (#gm.ModdedScripts == 0) and
                 GetConVarNumber("ttt_haste") == 1 and
                 KARMA.IsEnabled() and
                 DetectiveMode())
      end
};

function GM:UpdateServerTags(remove_only)
   if not self.LocalCRCs then self:CheckFileConsistency() end

   local tags_old = GetConVarString("sv_tags")

   -- Strip out any tags we might have added before
   tags_old = string.gsub(tags_old, "(,ttt:[^,]*)", "")
   Dev(1, "Old tags: " .. tags_old)

   -- Generate new tag list
   local tags_new = ""
   if not remove_only then
      for tag, pred in pairs(self.TagPredicates) do
         local t = pred(self)
         if t then
            tags_new = tags_new .. "," .. (type(t) == "string" and t or tag)
         end
      end
      Dev(1, "Adding to sv_tags: " .. tags_new)
   end

   RunConsoleCommand("sv_tags", tags_old .. tags_new)
end
