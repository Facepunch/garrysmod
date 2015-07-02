---- Clientside language stuff

-- Need to build custom tables of strings. Can't use language.Add as there is no
-- way to access the translated string in Lua. Identifiers only get translated
-- when Source/gmod print them. By using our own table and our own lookup, we
-- have far more control. Maybe it's slower, but maybe not, we aren't scanning
-- strings for "#identifiers" after all.

LANG.Strings = {}

CreateConVar("ttt_language", "auto", FCVAR_ARCHIVE)

LANG.DefaultLanguage = "english"
LANG.ActiveLanguage  = LANG.DefaultLanguage

LANG.ServerLanguage  = "english"

local cached_default, cached_active

function LANG.CreateLanguage(lang_name)
   if not lang_name then return end
   lang_name = string.lower(lang_name)

   if not LANG.IsLanguage(lang_name) then
      -- Empty string is very convenient to have, so init with that.
      LANG.Strings[lang_name] = { [""] = "" }
   end

   if lang_name == LANG.DefaultLanguage then
      cached_default = LANG.Strings[lang_name]

      -- when a string is not found in the active or the default language, an
      -- error message is shown
      setmetatable(LANG.Strings[lang_name],
                   {
                      __index = function(tbl, name)
                                   return Format("[ERROR: Translation of %s not found]", name), false
                                end
                   })
   end

   return LANG.Strings[lang_name]
end

-- Add a string to a language. Should not be used in a language file, only for
-- adding strings elsewhere, such as a SWEP script.
function LANG.AddToLanguage(lang_name, string_name, string_text)
   lang_name = lang_name and string.lower(lang_name)

   if not LANG.IsLanguage(lang_name) then
      ErrorNoHalt(Format("Failed to add '%s' to language '%s': language does not exist.\n", tostring(string_name), tostring(lang_name)))
   end

   LANG.Strings[lang_name][string_name] = string_text

   return string_name
end

-- Simple and fastest name->string lookup
function LANG.GetTranslation(name)
   return cached_active[name]
end

-- Lookup with no error upon failback, just nil. Slightly slower, but best way
-- to handle lookup of strings that may legitimately fail to exist
-- (eg. SWEP-defined).
function LANG.GetRawTranslation(name)
   return rawget(cached_active, name) or rawget(cached_default, name)
end

-- A common idiom
local GetRaw = LANG.GetRawTranslation
function LANG.TryTranslation(name)
   return GetRaw(name) or name
end

local interp = string.Interp

-- Parameterised version, performs string interpolation. Slower than
-- GetTranslation.
function LANG.GetParamTranslation(name, params)
   return interp(cached_active[name], params)
end
LANG.GetPTranslation = LANG.GetParamTranslation

function LANG.GetTranslationFromLanguage(name, lang_name)
   return rawget(LANG.Strings[lang_name], name)
end

-- Ability to perform lookups in the current language table directly is of
-- interest to consumers in draw/think hooks. Grabbing a translation directly
-- from the table is very fast, and much simpler than a local caching solution.
-- Modifying it would typically be a bad idea.
function LANG.GetUnsafeLanguageTable() return cached_active end

function LANG.GetUnsafeNamed(name) return LANG.Strings[name] end

-- Safe and slow access, not sure if it's ever useful.
function LANG.GetLanguageTable(lang_name)
   lang_name = lang_name or LANG.ActiveLanguage

   local cpy = table.Copy(LANG.Strings[lang_name])
   SetFallback(cpy)

   return cpy
end


local function SetFallback(tbl)
   -- languages may deal with this themselves, or may already have the fallback
   local m = getmetatable(tbl)
   if m and m.__index then return end

   -- Set the __index of the metatable to use the default lang, which makes any
   -- keys not found in the table to be looked up in the default. This is faster
   -- than using branching ("return lang[x] or default[x] or errormsg") and
   -- allows fallback to occur even when consumer code directly accesses the
   -- lang table for speed (eg. in a rendering hook).
   setmetatable(tbl,
                {
                   __index = cached_default
                })

end

function LANG.SetActiveLanguage(lang_name)
   lang_name = lang_name and string.lower(lang_name)

   if LANG.IsLanguage(lang_name) then
      local old_name = LANG.ActiveLanguage
      LANG.ActiveLanguage = lang_name

      -- cache ref to table to avoid hopping through LANG and Strings every time
      cached_active = LANG.Strings[lang_name]

      -- set the default lang as fallback, if it hasn't yet
      SetFallback(cached_active)

      -- some interface elements will want to know so they can update themselves
      if old_name != lang_name then
         hook.Call("TTTLanguageChanged", GAMEMODE, old_name, lang_name)
      end
   else
      MsgN(Format("The language '%s' does not exist on this server. Falling back to English...", lang_name))

      -- fall back to default if possible
      if lang_name != LANG.DefaultLanguage then
         LANG.SetActiveLanguage(LANG.DefaultLanguage)
      end
   end
end

function LANG.Init()
   local lang_name = GetConVarString("ttt_language")

   -- if we want to use the server language, we'll be switching to it as soon as
   -- we hear from the server which one it is, for now use default
   if LANG.IsServerDefault(lang_name) then
      lang_name = LANG.ServerLanguage
   end

   LANG.SetActiveLanguage(lang_name)
end

function LANG.IsServerDefault(lang_name)
   lang_name = string.lower(lang_name)
   return lang_name == "server default" or lang_name == "auto"
end

function LANG.IsLanguage(lang_name)
   lang_name = lang_name and string.lower(lang_name)
   return LANG.Strings[lang_name]
end

local function LanguageChanged(cv, old, new)
   if new and new != LANG.ActiveLanguage then

      if LANG.IsServerDefault(new) then
         new = LANG.ServerLanguage
      end

      LANG.SetActiveLanguage(new)
   end
end
cvars.AddChangeCallback("ttt_language", LanguageChanged)

local function ForceReload()
   LANG.SetActiveLanguage("english")
end
concommand.Add("ttt_reloadlang", ForceReload)

-- Get a copy of all available languages (keys in the Strings tbl)
function LANG.GetLanguages()
   local langs = {}
   for lang, strings in pairs(LANG.Strings) do
      table.insert(langs, lang)
   end
   return langs
end

---- Styling

local bgcolor = {
   [ROLE_TRAITOR]   = Color(150, 0, 0, 200),
   [ROLE_DETECTIVE] = Color(0, 0, 150, 200),
   [ROLE_INNOCENT]  = Color(0, 50,  0, 200)
};

-- Table of styles that can take a string and display it in some position,
-- colour, etc.
LANG.Styles = {
   default = function(text)
                MSTACK:AddMessage(text)
                print("TTT:   " .. text)
             end,

   rolecolour = function(text)
                   MSTACK:AddColoredBgMessage(text,
                                              bgcolor[ LocalPlayer():GetRole() ])
                   print("TTT:   " .. text)
                end,

   chat_warn  = function(text)
                   chat.AddText(COLOR_RED, text)
                end,


   chat_plain = chat.AddText
};

-- Table mapping message name => message style name. If no message style is
-- defined, the default style is used. This is the case for the vast majority of
-- messages at the time of writing.
LANG.MsgStyle = {}

-- Access of message styles
function LANG.GetStyle(name)
   return LANG.MsgStyle[name] or LANG.Styles.default
end

-- Set a style by name or directly as style-function
function LANG.SetStyle(name, style)
   if type(style) == "string" then
      style = LANG.Styles[style]
   end

   LANG.MsgStyle[name] = style
end

function LANG.ShowStyledMsg(text, style)
   style(text)
end

function LANG.ProcessMsg(name, params)
   local raw  = LANG.GetTranslation(name)

   local text = raw

   if params then
      -- some of our params may be string names themselves
      for k, v in pairs(params) do
         if type(v) == "string" then
            local name = LANG.GetNameParam(v)
            if not name then continue end

            params[k] = LANG.GetTranslation(name)
         end
      end
      
      text = interp(raw, params)
   end
   
   LANG.ShowStyledMsg(text, LANG.GetStyle(name))
end



--- Message style declarations

-- Rather than having a big list of LANG.SetStyle calls, we specify it the other
-- way around here and churn through it in code. This is convenient because
-- we're doing it en-masse for some random interface things spread out over the
-- place.
--
-- Styles of custom SWEP messages and such should use LANG.SetStyle in their
-- script. The SWEP stuff here might be moved out to the SWEPS too.

local styledmessages = {
   rolecolour = {
      "round_traitors_one",
      "round_traitors_more",

      "buy_no_stock",
      "buy_pending",
      "buy_received",
      
      "xfer_no_recip",
      "xfer_no_credits",
      "xfer_success",
      "xfer_received",

      "c4_no_disarm",

      "tele_failed",
      "tele_no_mark",
      "tele_marked",

      "dna_identify",
      "dna_notfound",
      "dna_limit",
      "dna_decayed",
      "dna_killer",
      "dna_no_killer",
      "dna_armed",
      "dna_object",
      "dna_gone",

      "credit_det_all",
      "credit_tr_all",
      "credit_kill"
   },

   chat_plain = {
      "body_call",
      "disg_turned_on",
      "disg_turned_off"
   },

   chat_warn = {
      "spec_mode_warning",
      "radar_not_owned",
      "radar_charging",
      "drop_no_room",
      "body_burning",

      "tele_no_ground",
      "tele_no_crouch",
      "tele_no_mark_ground",
      "tele_no_mark_crouch",

      "drop_no_ammo"
   }
};

local set_style = LANG.SetStyle
for style, msgs in pairs(styledmessages) do
   for _, name in pairs(msgs) do
      set_style(name, style)
   end
end
