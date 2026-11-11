
-- This table is used by the client to show items in the equipment menu, and by
-- the server to check if a certain role is allowed to buy a certain item.

EQUIP = {}

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
   },


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
   }
}
EQUIP.Items = EquipmentItems


local eq_lookup = {}
for i = 0, 2 do
   local id = tostring(2^i)
   eq_lookup[id] = {idx = {[ROLE_TRAITOR] = i + 1}, flag = 2^i, chunk = 1}

   if i != 2 then -- exclude EQUIP_DISGUISE
      eq_lookup[id].idx[ROLE_DETECTIVE] = i + 1
   end
end

-- Search if an item is in the equipment table of a given role, and return it if
-- it exists, else return nil.
function GetEquipmentItem(role, id)
   local tbl = EquipmentItems[role]
   if not tbl then return end

   -- Converting ids into strings reliably allows number comparisons >= 2^47
   id = tostring(id)

   -- See if we've looked up this equipment item before
   local eq = eq_lookup[id]
   if eq and eq.idx then
      local idx = eq.idx[role]
      if idx then
         return tbl[idx]
      end
   end

   for k, v in ipairs(tbl) do
      if v and tostring(v.id) == id then
         if eq and eq.idx then
            eq.idx[role] = k
         end

         return v
      end
   end
end
EQUIP.GetItem = GetEquipmentItem

-- GMod's bitwise library is limited to a 32-bit signed int
local equip_chunk_size = 32

-- Utility function to register a new Equipment ID
function GenerateNewEquipmentID()
   local new_max = EQUIP_MAX * 2

   if new_max == math.huge then
      error("Passive equipment item limit reached. Things may break in strange ways!")
   end

   EQUIP_MAX = new_max

   local equip_count = math.floor(math.log(EQUIP_MAX) / math.log(2))
   eq_lookup[tostring(EQUIP_MAX)] = {
      idx = {},
      flag = bit.tobit(2 ^ (equip_count % equip_chunk_size)),
      chunk = math.ceil(equip_count / (equip_chunk_size - 1))
   }

   return EQUIP_MAX
end
EQUIP.GenerateNewID = GenerateNewEquipmentID


-- Networking more than 32 equipment items at once requires
-- splitting an equipment bit field into 32-bit chunks.
function EQUIP.GetBitChunk(id)
   local eq = eq_lookup[tostring(id)]
   return eq and eq.chunk
end

-- Returns the bitflag used to access given
-- equipment ID within its 32-bit chunk.
function EQUIP.GetBitFlag(id)
   local eq = eq_lookup[tostring(id)]
   return eq and eq.flag
end

-- Given an equipment id, returns if it was found within given equipment table.
-- Given nil, returns whether given equipment table has any equipment items.
function EQUIP.HasItem(eq, id)
   if not id then
      for _, chunk in ipairs(eq) do
         if chunk != EQUIP_NONE then return true end
      end

      return false
   end

   local chunkID = EQUIP.GetBitChunk(id)
   if not chunkID then return false end

   local chunk = eq[chunkID] or EQUIP_NONE
   return util.BitSet(chunk, EQUIP.GetBitFlag(id))
end
