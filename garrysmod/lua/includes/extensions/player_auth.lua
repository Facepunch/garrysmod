


local meta = FindMetaTable( "Player" )
if (!meta) then return end


--[[---------------------------------------------------------
    Is an Admin
-----------------------------------------------------------]]
function meta:IsAdmin()

	-- Admin SteamID need to be fully authenticated by Steam!
	if ( self.IsFullyAuthenticated && !self:IsFullyAuthenticated() ) then return false end
	
	if ( self:IsSuperAdmin() ) then return true end
	if ( self:IsUserGroup("admin") ) then return true end

	return false
	
end

--[[---------------------------------------------------------
    Is a Super Admin
-----------------------------------------------------------]]
function meta:IsSuperAdmin()

	-- Admin SteamID need to be fully authenticated by Steam!
	if ( self.IsFullyAuthenticated && !self:IsFullyAuthenticated() ) then return false end
	
	return ( self:IsUserGroup("superadmin") )
	
end
	
--[[---------------------------------------------------------
    Is Usergroup X
	If you're really customizing your server you can add custom
	usergroups and modify your scripts to accomodate them easily
-----------------------------------------------------------]]
function meta:IsUserGroup( name )

	if ( !self:IsValid() ) then return false end
	return ( self:GetNetworkedString( "UserGroup" ) == name )
	
end


--[[---------------------------------------------------------
    SetUserGroup
	Sets the user's group (Server only)
-----------------------------------------------------------]]
function meta:SetUserGroup( name )

	self:SetNetworkedString( "UserGroup", name )

end


--[[---------------------------------------------------------
    This is the meat and spunk of the player auth system
-----------------------------------------------------------]]

if ( SERVER ) then

-- SteamIds table..
-- STEAM_0:1:7099:
--	 	 name	=	garry
--	 	 group	=	superadmin
local SteamIDs = {}

-- Load the users file
local UsersKV = util.KeyValuesToTable( file.Read( "settings/users.txt", true ) )

-- Extract the data into the SteamIDs table
for key, tab in pairs( UsersKV ) do

	for name, steamid in pairs( tab ) do
	
		SteamIDs[ steamid ] = {}
		SteamIDs[ steamid ].name = name
		SteamIDs[ steamid ].group = key
	
	end

end

local function PlayerSpawn( pl )

	local steamid = pl:SteamID()
	
	if ( game.SinglePlayer() || pl:IsListenServerHost() ) then
		pl:SetUserGroup( "superadmin" )
		return	
	end
	
	if ( SteamIDs[ steamid ] == nil ) then
		pl:SetUserGroup( "user" )
		return
	end

	pl:SetUserGroup( SteamIDs[ steamid ].group )
	pl:PrintMessage( HUD_PRINTTALK, "Hey '"..SteamIDs[ steamid ].name.."' - You're in the '"..SteamIDs[ steamid ].group.."' group on this server." )
	
end

hook.Add( "PlayerInitialSpawn", "PlayerAuthSpawn", PlayerSpawn )

end

