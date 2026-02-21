
---- Shared language stuff

-- tbl is first created here on both server and client
-- could make it a module but meh
if LANG then return end
LANG = {}

util.IncludeClientFile("cl_lang.lua")

-- Add all lua files in our /lang/ dir
local dir = GM.FolderName or "terrortown"
local files = file.Find(dir .. "/gamemode/lang/*.lua", "LUA" )
for _, fname in ipairs(files) do
   local path = "lang/" .. fname
   -- filter out directories and temp files (like .lua~)
   if string.Right(fname, 3) == "lua" then
      util.IncludeClientFile(path)
      MsgN("Included TTT language file: " .. fname)
   end
end


if SERVER then
   local count = table.Count

   -- Can be called as:
   --   1) LANG.Msg(ply, name, params)  -- sent to ply
   --   2) LANG.Msg(name, params)       -- sent to all
   --   3) LANG.Msg(role, name, params) -- sent to plys with role
   function LANG.Msg(arg1, arg2, arg3)
      if isstring(arg1) then
         LANG.ProcessMsg(nil, arg1, arg2)
      elseif isnumber(arg1) then
         LANG.ProcessMsg(GetRoleFilter(arg1), arg2, arg3)
      else
         LANG.ProcessMsg(arg1, arg2, arg3)
      end
   end

   function LANG.ProcessMsg(send_to, name, params)
      -- don't want to send to null ents, but can't just IsValid send_to because
      -- it may be a recipientfilter, so type check first
      if type(send_to) == "Player" and (not IsValid(send_to)) then return end

      -- number of keyval param pairs to send
      local c = params and count(params) or 0

      net.Start("TTT_LangMsg")
         net.WriteString(name)

         net.WriteUInt(c, 8)
         if c > 0 then

            for k, v in pairs(params) do
               -- assume keys are strings, but vals may be numbers
               net.WriteString(k)
               net.WriteString(tostring(v))
            end
         end

      if send_to then
         net.Send(send_to)
      else
         net.Broadcast()
      end
   end

   function LANG.MsgAll(name, params)
      LANG.Msg(nil, name, params)
   end

   local lang_serverdefault = CreateConVar("ttt_lang_serverdefault", "english", FCVAR_ARCHIVE)

   local function ServerLangRequest(ply, cmd, args)
      if not IsValid(ply) then return end

      net.Start("TTT_ServerLang")
         net.WriteString(lang_serverdefault:GetString())
      net.Send(ply)
   end
   concommand.Add("_ttt_request_serverlang", ServerLangRequest)

else -- CLIENT

   local function RecvMsg()
      local name = net.ReadString()

      local c = net.ReadUInt(8)
      local params = nil
      if c > 0 then
         params = {}
         for i=1, c do
            params[net.ReadString()] = net.ReadString()
         end
      end

      LANG.Msg(name, params)
   end
   net.Receive("TTT_LangMsg", RecvMsg)

   LANG.Msg = LANG.ProcessMsg

   local function RecvServerLang()
      local lang_name = net.ReadString()
      lang_name = lang_name and string.lower(lang_name)
      if LANG.Strings[lang_name] then
         if LANG.IsServerDefault(GetConVar("ttt_language"):GetString()) then
            LANG.SetActiveLanguage(lang_name)
         end

         LANG.ServerLanguage = lang_name

         print("Server default language is:", lang_name)
      end
   end
   net.Receive("TTT_ServerLang", RecvServerLang)
end

-- It can be useful to send string names as params, that the client can then
-- localize before interpolating. However, we want to prevent user input like
-- nicknames from being localized, so mark string names with something users
-- can't input.
function LANG.NameParam(name)
   return "LID\t" .. name
end
LANG.Param = LANG.NameParam

function LANG.GetNameParam(str)
   return string.match(str, "^LID\t([%w_]+)$")
end
