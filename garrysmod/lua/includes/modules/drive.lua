
local IsValid		= IsValid
local setmetatable	= setmetatable
local SERVER		= SERVER
local util			= util
local ErrorNoHalt	= ErrorNoHalt
local baseclass		= baseclass
local LocalPlayer	= LocalPlayer

module( "drive" )

local Type = {}

function Register( name, table, base )

	Type[ name ] = table

	--
	-- If we have a base method then hook
	-- it up in the meta table
	--
	if ( base ) then
		Type[ base ] = Type[ base ] or baseclass.Get( base )
		setmetatable( Type[ name ], { __index = Type[ base ] } )
	end

	if ( SERVER ) then
		util.AddNetworkString( name )
	end

	--
	-- drive methods cooperate with the baseclass system
	-- /lua/includes/modules/baseclass.lua
	--
	baseclass.Set( name, Type[ name ] )

end

function PlayerStartDriving( ply, ent, mode )

	local method = Type[mode]
	if ( !method ) then ErrorNoHalt( "Unknown drive type " .. ( mode ) .. "!\n" ) return end

	local id = util.NetworkStringToID( mode )

	ply:SetDrivingEntity( ent, id )

end

function PlayerStopDriving( ply )

	ply:SetDrivingEntity( nil )

end

function GetMethod( ply )

	--
	-- Not driving, return immediately
	--
	if ( !ply:IsDrivingEntity() ) then return end

	local ent = ply:GetDrivingEntity()
	local modeid = ply:GetDrivingMode()

	--
	-- Entity is invalid or mode isn't set - return out
	--
	if ( !IsValid( ent ) || modeid == 0 ) then return end

	--
	-- Have we already got a drive method? If so then reuse.
	--
	local method = ply.m_CurrentDriverMethod
	if ( method && method.Entity == ent && method.ModeID == modeid ) then return method end

	--
	-- No method - lets create one. Get the string from the modeid.
	--
	local modename = util.NetworkIDToString( modeid )
	if ( !modename ) then return end

	--
	-- Get that type. Fail if we don't have the type.
	--
	local type = Type[ modename ]
	if ( !type ) then return end

	local method = {}
	method.Entity = ent
	method.Player = ply
	method.ModeID = modeid

	setmetatable( method, { __index = type } )

	ply.m_CurrentDriverMethod = method

	method:Init()
	return method

end

function DestroyMethod( pl )

	if ( !IsValid( pl ) ) then return end

	pl.m_CurrentDriverMethod = nil

end
--
-- Called when the player first
-- starts driving this entity
--
function Start( ply, ent )

	if ( SERVER ) then

		-- Set this to the ent's view entity
		ply:SetViewEntity( ent )

		-- Save the player's eye angles
		ply.m_PreDriveEyeAngles = ply:EyeAngles()
		ply.m_PreDriveObserveMode = ply:GetObserverMode()

		-- Lock the player's eye angles to our angles
		local ang = ent:GetAngles()
		ply:SetEyeAngles( ang )

		-- Hide the controlling player's world model
		ply:DrawWorldModel( false )

	end

end

--
-- Clientside, the client creates the cmd (usercommand)
-- from their input device (mouse, keyboard) and then
-- it's sent to the server. Restrict view angles here :)
--
function CreateMove( cmd )

	local method = GetMethod( LocalPlayer() )
	if ( !method ) then return end

	method:SetupControls( cmd )
	return true

end

--
-- Optionally alter the view
--
function CalcView( ply, view )

	local method = GetMethod( ply )
	if ( !method ) then return end

	method:CalcView( view )
	return true

end

--
-- The user command is received by the server and then
-- converted into a move. This is also run clientside
-- when in multiplayer, for prediction to work.
--
function StartMove( ply, mv, cmd )

	local method = GetMethod( ply )
	if ( !method ) then return end

	method:StartMove( mv, cmd )
	return true

end


--
-- The move is executed here.
--
function Move( ply, mv )

	local method = GetMethod( ply )
	if ( !method ) then return end

	method:Move( mv )
	return true

end

--
-- The move is finished. Copy mv back into the target.
--
function FinishMove( ply, mv )

	local method = GetMethod( ply )
	if ( !method ) then return end

	method:FinishMove( mv )

	if ( method.StopDriving ) then
		PlayerStopDriving( ply )
	end

	return true

end

--
-- Player has stopped driving the entity
--
function End( ply, ent )

	--
	-- If the player is valid then set the view entity to nil
	--
	if ( SERVER && IsValid( ply ) ) then

		if ( ply.m_PreDriveEyeAngles != nil ) then
			ply:SetEyeAngles( ply.m_PreDriveEyeAngles )
			ply.m_PreDriveEyeAngles = nil
		end

		if ( ply.m_PreDriveObserveMode != nil ) then
			ply:SetObserverMode( ply.m_PreDriveObserveMode )
			ply.m_PreDriveObserveMode = nil
		end

		ply:SetViewEntity( nil )

		-- Show the controlling player's world model
		ply:DrawWorldModel( true )

	end

	DestroyMethod( ply )

end

