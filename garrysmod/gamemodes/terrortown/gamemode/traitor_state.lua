
function GetTraitors()
   local trs = {}
   for k,v in ipairs(player.GetAll()) do
      if v:GetTraitor() then table.insert(trs, v) end
   end

   return trs
end

function CountTraitors() return #GetTraitors() end

---- Role state communication

-- Send every player their role
local function SendPlayerRoles()
   for k, v in pairs(player.GetAll()) do
      umsg.Start("ttt_role", v)
      umsg.Char(v:GetRole())
      umsg.End()
   end
end

local function SendRoleListMessage(role, role_ids, ply_or_rf)
   umsg.Start("role_list", ply_or_rf)
   -- send what kind of list this is
   umsg.Char(role)

   -- list contents
   local num_ids = #role_ids
   umsg.Char(num_ids)
   for i=1, num_ids do
      umsg.Short(role_ids[i])
   end
   umsg.End()
end

local function SendRoleList(role, ply_or_rf, pred)
   local role_ids = {}
   for k, v in pairs(player.GetAll()) do
      if v:IsRole(role) then
         if not pred or (pred and pred(v)) then
            table.insert(role_ids, v:EntIndex())
         end
      end
   end

   SendRoleListMessage(role, role_ids, ply_or_rf)
end

-- Tell traitors about other traitors

function SendTraitorList(ply_or_rf, pred) SendRoleList(ROLE_TRAITOR, ply_or_rf, pred) end
function SendDetectiveList(ply_or_rf) SendRoleList(ROLE_DETECTIVE, ply_or_rf) end

-- this is purely to make sure last round's traitors/dets ALWAYS get reset
-- not happy with this, but it'll do for now
function SendInnocentList(ply_or_rf)
   -- Send innocent and detectives a list of actual innocents + traitors, while
   -- sending traitors only a list of actual innocents.
   local inno_ids = {}
   local traitor_ids = {}
   for k, v in pairs(player.GetAll()) do
      if v:IsRole(ROLE_INNOCENT) then
         table.insert(inno_ids, v:EntIndex())
      elseif v:IsRole(ROLE_TRAITOR) then
         table.insert(traitor_ids, v:EntIndex())
      end
   end

   -- traitors get actual innocent, so they do not reset their traitor mates to
   -- innocence
   SendRoleListMessage(ROLE_INNOCENT, inno_ids, GetTraitorFilter())

   -- detectives and innocents get an expanded version of the truth so that they
   -- reset everyone who is not detective
   table.Add(inno_ids, traitor_ids)
   table.Shuffle(inno_ids)
   SendRoleListMessage(ROLE_INNOCENT, inno_ids, GetInnocentFilter())
end

function SendConfirmedTraitors(ply_or_rf)
   SendTraitorList(ply_or_rf, function(p) return p:GetNWBool("body_found") end)
end

function SendFullStateUpdate()
   SendPlayerRoles()
   SendInnocentList()
   SendTraitorList(GetTraitorFilter())
   SendDetectiveList()
   -- not useful to sync confirmed traitors here
end

function SendRoleReset(ply_or_rf)
   local plys = player.GetAll()
   umsg.Start("role_list", ply_or_rf)
   umsg.Char(ROLE_INNOCENT)
   umsg.Char(#plys)
   for k, v in pairs(plys) do
      umsg.Short(v:EntIndex())
   end
   umsg.End()
end

---- Console commands

local function force_terror(ply)
   if cvars.Bool("sv_cheats", 0) then
      ply:SetRole(ROLE_INNOCENT)
      ply:UnSpectate()
      ply:SetTeam(TEAM_TERROR)

      ply:StripAll()

      ply:Spawn()
      ply:PrintMessage(HUD_PRINTTALK, "You are now on the terrorist team.")

      SendFullStateUpdate()
   end
end
concommand.Add("ttt_force_terror", force_terror)

local function force_traitor(ply)
   if cvars.Bool("sv_cheats", 0) then
      ply:SetRole(ROLE_TRAITOR)

      SendFullStateUpdate()
   end
end
concommand.Add("ttt_force_traitor", force_traitor)

local function force_detective(ply)
   if cvars.Bool("sv_cheats", 0) then
      ply:SetRole(ROLE_DETECTIVE)

      SendFullStateUpdate()
   end
end
concommand.Add("ttt_force_detective", force_detective)


local function force_spectate(ply, cmd, arg)
   if IsValid(ply) then
      if #arg == 1 and tonumber(arg[1]) == 0 then
         ply:SetForceSpec(false)
      else
         if not ply:IsSpec() then
            ply:Kill()
         end

         GAMEMODE:PlayerSpawnAsSpectator(ply)
         ply:SetTeam(TEAM_SPEC)
         ply:SetRole(ROLE_INNOCENT)
         ply:SetForceSpec(true)
         ply:Spawn()

         ply:SetRagdollSpec(false) -- dying will enable this, we don't want it here
      end
   end
end
concommand.Add("ttt_spectate", force_spectate)


