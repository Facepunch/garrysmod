
-- This table is used by the client to show items in the equipment menu, and by
-- the server to check if a certain role is allowed to buy a certain item.


-- If you have custom items you want to add, consider using a separate lua
-- script that uses table.insert to add an entry to this table. This method
-- means you won't have to add your code back in after every TTT update. Just
-- make sure the script is also run on the client.
--
-- For example:
--   table.insert(EquipmentItems[ROLE_DETECTIVE], { id = EQUIP_ARMOR, ... })
--
-- Note that for existing items you can just do:
--   table.insert(EquipmentItems[ROLE_DETECTIVE], GetEquipmentItem(ROLE_TRAITOR, EQUIP_ARMOR))


-- Special equipment bitflags. Every unique piece of equipment needs its own
-- id. 
--
-- Use the GenerateNewEquipmentID function (see below) to get a unique ID for
-- your equipment. This is guaranteed not to clash with other addons (as long
-- as they use the same safe method).
--
-- Details you shouldn't need:
-- The number should increase by a factor of two for every item (ie. ids
-- should be powers of two).
EQUIP_NONE     = 0
EQUIP_ARMOR    = 1
EQUIP_RADAR    = 2
EQUIP_DISGUISE = 4

EQUIP_MAX      = 4

-- Icon doesn't have to be in this dir, but all default ones are in here
local mat_dir = "vgui/ttt/"


-- Stick to around 35 characters per description line, and add a "\n" where you
-- want a new line to start.

EquipmentItems = {
   [ROLE_DETECTIVE] = {

      -- body armor
      {  id       = EQUIP_ARMOR,
         loadout  = true, -- default equipment for detectives
         type     = "item_passive",
         material = mat_dir .. "icon_armor",
         name     = "item_armor",
         desc     = "item_armor_desc"
      },

      -- radar
      {  id       = EQUIP_RADAR,
         type     = "item_active",
         material = mat_dir .. "icon_radar",
         name     = "item_radar",
         desc     = "item_radar_desc"
      }


      -- The default TTT equipment uses the language system to allow
      -- translation. Below is an example of how the type, name and desc fields
      -- would look with explicit non-localized text (which is probably what you
      -- want when modding).

--      {  id       = EQUIP_ARMOR,
--         loadout  = true, -- default equipment for detectives
--         type     = "Passive effect item",
--         material = mat_dir .. "icon_armor",
--         name     = "Body Armor",
--         desc     = "Reduces bullet damage by 30% when\nyou get hit."
--      },
   };


   [ROLE_TRAITOR] = {
      -- body armor
      {  id       = EQUIP_ARMOR,
         type     = "item_passive",
         material = mat_dir .. "icon_armor",
         name     = "item_armor",
         desc     = "item_armor_desc"
      },

      -- radar
      {  id       = EQUIP_RADAR,
         type     = "item_active",
         material = mat_dir .. "icon_radar",
         name     = "item_radar",
         desc     = "item_radar_desc"
      },

      -- disguiser
      {  id       = EQUIP_DISGUISE,
         type     = "item_active",
         material = mat_dir .. "icon_disguise",
         name     = "item_disg",
         desc     = "item_disg_desc"
      }
   };
};


-- Search if an item is in the equipment table of a given role, and return it if
-- it exists, else return nil.
function GetEquipmentItem(role, id)
   local tbl = EquipmentItems[role]
   if not tbl then return end

   for k, v in pairs(tbl) do
      if v and v.id == id then
         return v
      end
   end
end

 -- Utility function to register a new Equipment ID
function GenerateNewEquipmentID()
   EQUIP_MAX = EQUIP_MAX * 2
   return EQUIP_MAX
end
