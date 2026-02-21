
local table			= table
local vgui			= vgui
local Msg			= Msg
local setmetatable	= setmetatable
local _G			= _G
local gamemode		= gamemode
local pairs			= pairs
local isfunction	= isfunction

module( "derma" )

Controls = {}
SkinList = {}

local DefaultSkin = {}
local SkinMetaTable = {}
local iSkinChangeIndex = 1

SkinMetaTable.__index = function ( self, key )

	return DefaultSkin[ key ]

end

local function FindPanelsByClass( SeekingClass )

	local outtbl = {}

	--
	-- Going through the registry is a hacky way to do this.
	-- We're only doing it this way because it doesn't matter if it's a
	-- bit slow - because this function is only used when reloading.
	--
	local tbl = vgui.GetAll()
	for k, v in pairs( tbl ) do

		if ( v.ClassName && v.ClassName == SeekingClass ) then

			table.insert( outtbl, v )

		end

	end

	return outtbl

end

--
-- Find all the panels that use this class and
-- if allowed replace the functions with the new ones.
--
local function ReloadClass( classname )

	local ctrl = vgui.GetControlTable( classname )
	if ( !ctrl ) then return end

	local tbl = FindPanelsByClass( classname )

	for k, v in pairs ( tbl ) do

		if ( !v.AllowAutoRefresh ) then continue end

		if ( v.PreAutoRefresh ) then
			v:PreAutoRefresh()
		end

		for name, func in pairs( ctrl ) do

			if ( !isfunction( func ) ) then continue end

			v[ name ] = func

		end

		if ( v.PostAutoRefresh ) then
			v:PostAutoRefresh()
		end

	end

end

--[[---------------------------------------------------------
	GetControlList
-----------------------------------------------------------]]
function GetControlList()

	return Controls

end

--[[---------------------------------------------------------
	DefineControl
-----------------------------------------------------------]]
function DefineControl( strName, strDescription, strTable, strBase )

	local bReloading = Controls[ strName ] != nil

	-- Add Derma table to PANEL table.
	strTable.Derma = {
		ClassName	= strName,
		Description	= strDescription,
		BaseClass	= strBase
	}

	-- Register control with VGUI
	vgui.Register( strName, strTable, strBase )

	-- Store control
	Controls[ strName ] = strTable.Derma

	-- Store as a global so controls can 'baseclass' easier
	-- TODO: STOP THIS
	_G[ strName ] = strTable

	if ( bReloading ) then
		Msg( "Reloaded Control: ", strName, "\n" )
		ReloadClass( strName )
	end

	return strTable

end

--[[---------------------------------------------------------
	DefineSkin
-----------------------------------------------------------]]
function DefineSkin( strName, strDescription, strTable )

	strTable.Name = strName
	strTable.Description = strDescription
	strTable.Base = strTable.Base or "Default"

	if ( strName != "Default" ) then
		setmetatable( strTable, SkinMetaTable )
	else
		DefaultSkin = strTable
	end

	SkinList[ strName ] = strTable

	-- Make all panels update their skin
	RefreshSkins()

end

--[[---------------------------------------------------------
	GetSkin - Returns current skin for panel
-----------------------------------------------------------]]
function GetSkinTable()

	return table.Copy( SkinList )

end

--[[---------------------------------------------------------
	Returns 'Default' Skin
-----------------------------------------------------------]]
function GetDefaultSkin()

	local skin = nil

	-- Check gamemode skin preference
	if ( gamemode ) then
		local skinname = gamemode.Call( "ForceDermaSkin" )
		if ( skinname ) then skin = GetNamedSkin( skinname ) end
	end

	-- default
	if ( !skin ) then skin = DefaultSkin end

	return skin

end

--[[---------------------------------------------------------
	Returns 'Named' Skin
-----------------------------------------------------------]]
function GetNamedSkin( name )

	return SkinList[ name ]

end

--[[---------------------------------------------------------
	SkinHook( strType, strName, panel )
-----------------------------------------------------------]]
function SkinHook( strType, strName, panel, w, h )

	local Skin = panel:GetSkin()
	if ( !Skin ) then return end

	local func = Skin[ strType .. strName ]
	if ( !func ) then return end

	return func( Skin, panel, w, h )

end

--[[---------------------------------------------------------
	SkinTexture( strName, panel, default )
-----------------------------------------------------------]]
function SkinTexture( strName, panel, default )

	local Skin = panel:GetSkin()
	if ( !Skin ) then return default end

	local Textures = Skin.tex
	if ( !Textures ) then return default end

	return Textures[ strName ] or default

end

--[[---------------------------------------------------------
	Color( strName, panel, default )
-----------------------------------------------------------]]
function Color( strName, panel, default )

	local Skin = panel:GetSkin()
	if ( !Skin ) then return default end

	return Skin[ strName ] or default

end

--[[---------------------------------------------------------
	SkinChangeIndex
-----------------------------------------------------------]]
function SkinChangeIndex()

	return iSkinChangeIndex

end

--[[---------------------------------------------------------
	RefreshSkins - clears all cache'd panels (so they will reassess which skin they should be using)
-----------------------------------------------------------]]
function RefreshSkins()

	iSkinChangeIndex = iSkinChangeIndex + 1

end
