
local meta = FindMetaTable( "Player" )
if ( not meta ) then return end

--[[---------------------------------------------------------
	Name: IsAdmin
	Desc: Returns if a player is an admin.
-----------------------------------------------------------]]
function meta:IsAdmin()

	if ( self:IsSuperAdmin() ) then return true end
	if ( self:IsUserGroup( "admin" ) ) then return true end

	return false

end

--[[---------------------------------------------------------
	Name: IsSuperAdmin
	Desc: Returns if a player is a superadmin.
-----------------------------------------------------------]]
function meta:IsSuperAdmin()

	return self:IsUserGroup( "superadmin" )

end

--[[---------------------------------------------------------
	Name: IsUserGroup
	Desc: Returns if a player is in the specified usergroup.
-----------------------------------------------------------]]
function meta:IsUserGroup( name )

	if ( not self:IsValid() ) then return false end

	return self:GetUserGroup() == name

end

--[[---------------------------------------------------------
	Name: GetUserGroup
	Desc: Returns the player's usergroup.
-----------------------------------------------------------]]
function meta:GetUserGroup()

	return self:GetNWString( "UserGroup", "user" )

end


--[[---------------------------------------------------------
	This is the meat and spunk of the player auth system
-----------------------------------------------------------]]

if ( not SERVER ) then return end

--[[---------------------------------------------------------
	Name: SetUserGroup
	Desc: Sets the player's usergroup. ( Serverside Only )
-----------------------------------------------------------]]
function meta:SetUserGroup( name )

	self:SetNWString( "UserGroup", name )

end


-- SteamIds table..
-- STEAM_0:1:7099:
--		name	=	garry
--		group	=	superadmin

local SteamIDs = {}

local function LoadUsersFile()

	local txt = file.Read( "settings/users.txt", "MOD" )
	if ( not txt ) then MsgN( "Failed to load settings/users.txt!" ) return end

	-- Load the users file
	local UsersKV = util.KeyValuesToTable( txt )
	if ( not UsersKV ) then MsgN( "Failed to parse settings/users.txt!" ) return end

	SteamIDs = {}

	-- Extract the data into the SteamIDs table
	for key, tab in pairs( UsersKV ) do
		for name, steamid in pairs( tab ) do
			SteamIDs[ steamid ] = {}
			SteamIDs[ steamid ].name = name
			SteamIDs[ steamid ].group = key
		end
	end

end

LoadUsersFile()

function util.GetUserGroups()

	return SteamIDs

end

hook.Add( "PlayerInitialSpawn", "PlayerAuthSpawn", function( ply )

	local steamid = ply:SteamID()

	if ( game.SinglePlayer() or ply:IsListenServerHost() ) then
		ply:SetUserGroup( "superadmin" )
		return
	end

	if ( SteamIDs[ steamid ] == nil ) then
		ply:SetUserGroup( "user" )
		return
	end

	-- Admin SteamID need to be fully authenticated by Steam!
	if ( ply.IsFullyAuthenticated and not ply:IsFullyAuthenticated() ) then
		ply:ChatPrint( string.format( "Hey '%s' - Your SteamID wasn't fully authenticated, so your usergroup has not been set to '%s'.", SteamIDs[ steamid ].name, SteamIDs[ steamid ].group ) )
		ply:ChatPrint( "Try restarting Steam." )
		return
	end

	ply:SetUserGroup( SteamIDs[ steamid ].group )
	ply:ChatPrint( string.format( "Hey '%s' - You're in the '%s' group on this server.", SteamIDs[ steamid ].name, SteamIDs[ steamid ].group ) )

end )
