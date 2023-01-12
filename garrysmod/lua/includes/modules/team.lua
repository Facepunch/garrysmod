module( "team", package.seeall )

local TeamList = {}
local TeamLookup = {}
local DefaultColor = Color(255, 255, 100, 255)

--[[------------------------------------------------------------

	Call team.SetUp to quickly set up your team. You can also
	call team.Register to create a team object to handle custom
	logic per team. It should be called in a shared file. This
	system assumes that your teams are static. If you want to
	have dynamic teams you need to code this yourself.

	id should be a number. It's best to do something like

	TEAM_TERRORISTS = 2

	at the top of your code somewhere so you can reference
	teams via a variable rather than a number.

--------------------------------------------------------------]]

local TEAM = {}
TEAM.__index = TEAM

--[[------------------------------------------------------------

	Register our metatable to make it accessible using FindMetaTable

--------------------------------------------------------------]]

debug.getregistry().Team = TEAM

function Register( tbl, name )

	if ( !tbl.Name && name ) then tbl.Name = name end
	
	setmetatable( tbl, TEAM )
	TeamList[tbl.TeamID] = tbl
	TeamLookup[tbl.Name] = tbl
	
end

function SetUp( id, name, color, joinable )

	if ( joinable == nil ) then joinable = true end

	Register( { TeamID = id, Name = name, Color = color, Score = 0, Joinable = joinable }, name )
	
end

SetUp( TEAM_CONNECTING,	"Joining/Connecting",	DefaultColor,	false )
SetUp( TEAM_UNASSIGNED,	"Unassigned",			DefaultColor,	false )
SetUp( TEAM_SPECTATOR,	"Spectator",			DefaultColor,	true )

function GetByID( id )

	return TeamList[id]

end

function GetByName( name )

	return TeamLookup[name]

end

function GetAllTeams()

	return TeamList -- copyof?

end

function Valid( id )

	if ( !TeamList[id] ) then return false end
	return true

end

function Joinable( id )

	if ( !TeamList[id] ) then return false end
	return TeamList[id]:IsJoinable()

end

function GetSpawnPoint( id )

	if ( !TeamList[id] ) then return end
	return TeamList[id]:GetSpawnPointTable()

end

function GetSpawnPoints( id )

	if ( !TeamList[id] ) then return end
	return TeamList[id]:GetSpawnPoints()

end

function SetSpawnPoint( id, ent_name )

	if ( !TeamList[id] ) then return end
	if ( !istable( ent_name ) ) then ent_name = { ent_name } end

	TeamList[id]:SetSpawnPointTable( ent_name )

end

function SetClass( id, classtable )

	if ( !TeamList[id] ) then return end
	if ( !istable( classtable ) ) then classtable = { classtable } end

	TeamList[id]:SetSelectableClasses( classtable )

end

function GetClass( id )

	if ( !TeamList[id] ) then return end
	return TeamList[id]:GetSelectableClasses()

end

function TotalDeaths( id )

	if ( !TeamList[id] ) then return 0 end
	return TeamList[id]:GetTotalDeaths()

end

function TotalFrags( id )

	if ( !TeamList[id] ) then return 0 end
	return TeamList[id]:GetTotalFrags()

end

function NumPlayers( id )

	if ( !TeamList[id] ) then return 0 end
	return TeamList[id]:GetPlayerCount()

end

function GetPlayers( id )

	if ( !TeamList[id] ) then return {} end
	return TeamList[id]:GetPlayers()

end

function GetScore( id )

	if ( !TeamList[id] ) then return 0 end
	return TeamList[id]:GetScore()

end

function GetName( id )

	if ( !TeamList[id] ) then return "" end
	return TeamList[id]:GetName()

end

function SetColor( id, color )

	if ( !TeamList[id] ) then return false end
	TeamList[id]:SetColor( color )
	return color

end

function GetColor( id )

	if ( !TeamList[id] ) then return DefaultColor end
	return table.Copy( TeamList[id]:GetColor() )

end

function SetScore( id, score )

	if ( !TeamList[id] ) then return end
	TeamList[id]:SetScore( score )

end

function AddScore( id, score )

	SetScore( id, GetScore( id ) + score )

end

function BestAutoJoinTeam()

	local SmallestTeam = TEAM_UNASSIGNED
	local SmallestPlayers = 1000

	for id, tm in pairs( team.GetAllTeams() ) do

		if ( id != TEAM_SPECTATOR && id != TEAM_UNASSIGNED && id != TEAM_CONNECTING && tm.Joinable ) then

			local PlayerCount = tm:GetPlayerCount()
			if ( PlayerCount < SmallestPlayers || (PlayerCount == SmallestPlayers && id < SmallestTeam ) ) then
				SmallestPlayers = PlayerCount
				SmallestTeam = id
			end

		end

	end

	return SmallestTeam

end

--[[------------------------------------------------------------

	Class stuff.

--------------------------------------------------------------]]

AccessorFunc( TEAM, "Color", "Color" )
AccessorFunc( TEAM, "SpawnPointTable", "SpawnPointTable" )
AccessorFunc( TEAM, "SelectableClasses", "SelectableClasses" )

function TEAM:GetID()

	return self.TeamID

end

function TEAM:GetName()

	return self.Name

end

function TEAM:IsJoinable()

	return self.Joinable

end

function TEAM:SetJoinable( joinable )

	self.Joinable = joinable

end

function TEAM:GetSpawnPoints()
	
	if ( IsTableOfEntitiesValid( self.SpawnPoints ) ) then return self.SpawnPoints end

	local spawnPointTable = Self:GetSpawnPointTable()
	if ( !spawnPointTable ) then return end

	spawnPoints = {}

	for k, entname in pairs( spawnPointTable ) do

		spawnPoints = table.Add( spawnPoints, ents.FindByClass( entname ) )

	end

	self.SpawnPoints = spawnPoints
	
	return spawnPoints
	
end

function TEAM:GetTotalDeaths()
	
	local deaths, id = 0, self:GetID()
	local players, pl = player.GetAll()
	for i = 1, #players do
		pl = players[i]
		if ( pl:IsValid() && pl:Team() == id ) then
			deaths = deaths + pl:Deaths()
		end
	end
	return deaths
	
end

function TEAM:GetTotalFrags()

	local frags, id = 0, self:GetID()
	local players, pl = player.GetAll()
	for i = 1, #players do
		pl = players[i]
		if ( pl:IsValid() && pl:Team() == id ) then
			frags = frags + pl:Frags()
		end
	end
	return frags
	
end

function TEAM:GetPlayers()

	local tbl, size, id = {}, 0, self:GetID()
	local players, pl = player.GetAll()
	for i = 1, #players do
		pl = players[i]
		if ( pl:IsValid() && pl:Team() == id ) then
			size = size + 1
			tbl[size] = pl
		end
	end
	return tbl

end

function TEAM:GetPlayerCount()
	
	return #self:GetPlayers()

end

function TEAM:GetScore()
	
	return GetGlobalInt( "Team." .. self:GetID() .. ".Score", 0 )

end

function TEAM:SetScore( score )

	SetGlobalInt( "Team." .. self:GetID() .. ".Score", score )

end
