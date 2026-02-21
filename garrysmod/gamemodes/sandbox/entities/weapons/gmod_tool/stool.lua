
ToolObj = {}

include( "ghostentity.lua" )
include( "object.lua" )

if ( CLIENT ) then
	include( "stool_cl.lua" )
end

function ToolObj:Create()

	local o = {}

	setmetatable( o, self )
	self.__index = self

	o.Mode				= nil
	o.SWEP				= nil
	o.Owner				= nil
	o.ClientConVar		= {}
	o.ServerConVar		= {}
	o.Objects			= {}
	o.Stage				= 0
	o.Message			= "start"
	o.LastMessage		= 0
	o.AllowedCVar		= 0

	return o

end

function ToolObj:CreateConVars()

	local mode = self:GetMode()

	self.AllowedCVar = CreateConVar( "toolmode_allow_" .. mode, "1", { FCVAR_NOTIFY, FCVAR_REPLICATED }, "Set to 0 to disallow players being able to use the \"" .. mode .. "\" tool." )
	self.ClientConVars = {}
	self.ServerConVars = {}

	if ( CLIENT ) then

		for cvar, default in pairs( self.ClientConVar ) do
			self.ClientConVars[ cvar ] = CreateClientConVar( mode .. "_" .. cvar, default, true, true, "Tool specific client setting (" .. mode .. ")" )
		end

	else

		for cvar, default in pairs( self.ServerConVar ) do
			self.ServerConVars[ cvar ] = CreateConVar( mode .. "_" .. cvar, default, FCVAR_ARCHIVE, "Tool specific server setting (" .. mode .. ")" )
		end

	end

end

function ToolObj:GetServerInfo( property )

	if ( self.ServerConVars[ property ] and SERVER ) then
		return self.ServerConVars[ property ]:GetString()
	end

	return GetConVarString( self:GetMode() .. "_" .. property )

end

function ToolObj:GetClientInfo( property )

	if ( self.ClientConVars[ property ] and CLIENT ) then
		return self.ClientConVars[ property ]:GetString()
	end

	return self:GetOwner():GetInfo( self:GetMode() .. "_" .. property )

end

function ToolObj:GetClientNumber( property, default )

	if ( self.ClientConVars[ property ] and CLIENT ) then
		return self.ClientConVars[ property ]:GetFloat()
	end

	return self:GetOwner():GetInfoNum( self:GetMode() .. "_" .. property, tonumber( default ) or 0 )

end

function ToolObj:GetClientBool( property, default )

	if ( self.ClientConVars[ property ] and CLIENT ) then
		return self.ClientConVars[ property ]:GetBool()
	end

	return math.floor( self:GetOwner():GetInfoNum( self:GetMode() .. "_" .. property, tonumber( default ) or 0 ) ) != 0

end

function ToolObj:BuildConVarList()

	local mode = self:GetMode()
	local convars = {}

	for k, v in pairs( self.ClientConVar ) do convars[ mode .. "_" .. k ] = v end

	return convars

end

function ToolObj:Allowed()

	return self.AllowedCVar:GetBool()

end

-- Now for all the ToolObj redirects

function ToolObj:Init() end

function ToolObj:GetMode()		return self.Mode end
function ToolObj:GetWeapon()	return self.SWEP end
function ToolObj:GetOwner()		return self:GetWeapon():GetOwner() or self.Owner end
function ToolObj:GetSWEP()		return self:GetWeapon() end

function ToolObj:LeftClick()	return false end
function ToolObj:RightClick()	return false end
function ToolObj:Reload()		self:ClearObjects() end
function ToolObj:Deploy()		self:ReleaseGhostEntity() return end
function ToolObj:Holster()		self:ReleaseGhostEntity() return end
function ToolObj:Think()		self:ReleaseGhostEntity() end

--[[---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
-----------------------------------------------------------]]
function ToolObj:CheckObjects()

	for k, v in pairs( self.Objects ) do

		if ( !v.Ent:IsWorld() and !v.Ent:IsValid() ) then
			self:ClearObjects()
		end

	end

end

for _, val in ipairs( file.Find( SWEP.Folder .. "/stools/*.lua", "LUA" ) ) do

	local _, _, toolmode = string.find( val, "([%w_]*).lua" )

	-- In multiplayer, the clientside filename is always lowercase (due to the Lua datapack)
	-- So ensure that the toolmode matches between client and server,
	-- when the serverside name is not all lowercase
	toolmode = toolmode:lower()

	TOOL = ToolObj:Create()
	TOOL.Mode = toolmode

	AddCSLuaFile( "stools/" .. val )
	include( "stools/" .. val )

	TOOL:CreateConVars()

	if ( hook.Run( "PreRegisterTOOL", TOOL, toolmode ) != false ) then
		SWEP.Tool[ toolmode ] = TOOL
	end

	TOOL = nil

end

ToolObj = nil

if ( SERVER ) then return end

-- Keep the tool list handy
local TOOLS_LIST = SWEP.Tool

-- Add the STOOLS to the tool menu
hook.Add( "PopulateToolMenu", "AddSToolsToMenu", function()

	for ToolName, tool in pairs( TOOLS_LIST ) do

		if ( tool.AddToMenu != false ) then

			spawnmenu.AddToolMenuOption(
				tool.Tab or "Main",
				tool.Category or "New Category",
				ToolName,
				tool.Name or ( "#" .. ToolName ),
				tool.Command or ( "gmod_tool " .. ToolName ),
				tool.ConfigName or ToolName,
				tool.BuildCPanel
			)

		end

	end

end )

--
-- Search
--
search.AddProvider( function( str )

	local list = {}

	for k, v in pairs( TOOLS_LIST ) do

		local niceName = v.Name or ( "#" .. k )
		if ( niceName:StartsWith( "#" ) ) then niceName = language.GetPhrase( niceName:sub( 2 ) ) end

		if ( !k:lower():find( str, nil, true ) and !niceName:lower():find( str, nil, true ) ) then continue end

		local entry = {
			text = niceName,
			icon = spawnmenu.CreateContentIcon( "tool", nil, {
				spawnname = k,
				nicename = v.Name or ( "#" .. k )
			} ),
			words = { k }
		}

		table.insert( list, entry )

		if ( #list >= GetConVarNumber( "sbox_search_maxresults" ) / 32 ) then break end

	end

	return list

end )

--
-- Tool spawnmenu icon
--
spawnmenu.AddContentType( "tool", function( container, obj )

	if ( !obj.spawnname ) then return end

	local icon = vgui.Create( "ContentIcon", container )
	icon:SetContentType( "tool" )
	icon:SetSpawnName( obj.spawnname )
	icon:SetName( obj.nicename or ( "#tool." .. obj.spawnname .. ".name" ) )
	icon:SetMaterial( "gui/tool.png" )

	icon.DoClick = function()

		spawnmenu.ActivateTool( obj.spawnname )

		surface.PlaySound( "ui/buttonclickrelease.wav" )

	end

	icon.OpenMenu = icon.OpenGenericSpawnmenuRightClickMenu

	if ( IsValid( container ) ) then
		container:Add( icon )
	end

	return icon

end )

