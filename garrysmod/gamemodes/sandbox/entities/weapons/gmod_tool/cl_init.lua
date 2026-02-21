
local gmod_drawhelp = CreateClientConVar( "gmod_drawhelp", "1", true, false, "Should the tool HUD be displayed when the tool gun is active?" )
local gmod_toolmode = CreateClientConVar( "gmod_toolmode", "rope", true, true, "Currently selected tool mode for the Tool Gun." )
CreateClientConVar( "gmod_drawtooleffects", "1", true, false, "Should tools draw certain UI elements or effects? (Will not work for all tools)" )

cvars.AddChangeCallback( "gmod_toolmode", function( name, old, new )
	if ( old == new ) then return end
	spawnmenu.ActivateTool( new, true )
end, "gmod_toolmode_panel" )

include( "shared.lua" )
include( "cl_viewscreen.lua" )

SWEP.Slot			= 5
SWEP.SlotPos		= 6
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true

SWEP.WepSelectIcon = surface.GetTextureID( "vgui/gmod_tool" )
SWEP.Gradient = surface.GetTextureID( "gui/gradient" )
SWEP.InfoIcon = surface.GetTextureID( "gui/info" )

SWEP.ToolNameHeight = 0
SWEP.InfoBoxHeight = 0

surface.CreateFont( "GModToolName", {
	font = "Roboto Bk",
	size = 80,
	weight = 1000,
	extended = true
} )

surface.CreateFont( "GModToolSubtitle", {
	font = "Roboto Bk",
	size = 24,
	weight = 1000,
	extended = true
} )

surface.CreateFont( "GModToolHelp", {
	font = "Roboto Bk",
	size = 17,
	weight = 1000,
	extended = true
} )

--[[---------------------------------------------------------
	Draws the help on the HUD (disabled if gmod_drawhelp is 0)
-----------------------------------------------------------]]
function SWEP:DrawHUD()

	local mode = gmod_toolmode:GetString()
	local toolObject = self:GetToolObject()

	-- Don't draw help for a nonexistant tool!
	if ( !toolObject ) then return end

	-- Do not draw help when in a vehicle unless allowed
	if ( LocalPlayer() and IsValid( LocalPlayer():GetVehicle() ) and not LocalPlayer():GetAllowWeaponsInVehicle() ) then return end

	toolObject:DrawHUD()

	if ( !gmod_drawhelp:GetBool() ) then return end

	-- This could probably all suck less than it already does

	local x, y = 50, 40
	local w, h = 0, 0

	local TextTable = {}
	local QuadTable = {}

	QuadTable.texture = self.Gradient
	QuadTable.color = Color( 10, 10, 10, 180 )

	QuadTable.x = 0
	QuadTable.y = y - 8
	QuadTable.w = 600
	QuadTable.h = self.ToolNameHeight - ( y - 8 )
	draw.TexturedQuad( QuadTable )

	TextTable.font = "GModToolName"
	TextTable.color = Color( 240, 240, 240, 255 )
	TextTable.pos = { x, y }
	TextTable.text = "#tool." .. mode .. ".name"
	w, h = draw.TextShadow( TextTable, 2 )
	y = y + h

	TextTable.font = "GModToolSubtitle"
	TextTable.pos = { x, y }
	TextTable.text = "#tool." .. mode .. ".desc"
	w, h = draw.TextShadow( TextTable, 1 )
	y = y + h + 8

	self.ToolNameHeight = y

	QuadTable.y = y
	QuadTable.h = self.InfoBoxHeight
	local alpha = math.Clamp( 255 + ( toolObject.LastMessage - CurTime() ) * 800, 10, 255 )
	QuadTable.color = Color( alpha, alpha, alpha, 230 )
	draw.TexturedQuad( QuadTable )

	y = y + 4

	TextTable.font = "GModToolHelp"

	if ( !toolObject.Information ) then
		TextTable.pos = { x + self.InfoBoxHeight, y }
		TextTable.text = toolObject:GetHelpText()
		w, h = draw.TextShadow( TextTable, 1 )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( self.InfoIcon )
		surface.DrawTexturedRect( x + 1, y + 1, h - 3, h - 3 )

		self.InfoBoxHeight = h + 8

		return
	end

	local h2 = 0

	for _, v in pairs( toolObject.Information ) do
		if ( isstring( v ) ) then v = { name = v } end

		local name = v.name

		if ( !name ) then continue end
		if ( v.stage && v.stage != self:GetStage() ) then continue end
		if ( v.op && v.op != toolObject:GetOperation() ) then continue end

		local txt = "#tool." .. mode .. "." .. name
		if ( name == "info" ) then txt = toolObject:GetHelpText() end

		TextTable.text = txt
		TextTable.pos = { x + 21, y + h2 }

		w, h = draw.TextShadow( TextTable, 1 )

		local icon1 = v.icon
		local icon2 = v.icon2

		if ( !icon1 ) then
			if ( string.StartsWith( name, "info" ) ) then icon1 = "gui/info" end
			if ( string.StartsWith( name, "left" ) ) then icon1 = "gui/lmb.png" end
			if ( string.StartsWith( name, "right" ) ) then icon1 = "gui/rmb.png" end
			if ( string.StartsWith( name, "reload" ) ) then icon1 = "gui/r.png" end
			if ( string.StartsWith( name, "use" ) ) then icon1 = "gui/e.png" end
		end
		if ( !icon2 && !string.StartsWith( name, "use" ) && string.EndsWith( name, "use" ) ) then icon2 = "gui/e.png" end

		self.Icons = self.Icons or {}
		if ( icon1 && !self.Icons[ icon1 ] ) then self.Icons[ icon1 ] = Material( icon1 ) end
		if ( icon2 && !self.Icons[ icon2 ] ) then self.Icons[ icon2 ] = Material( icon2 ) end

		if ( icon1 && self.Icons[ icon1 ] && !self.Icons[ icon1 ]:IsError() ) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( self.Icons[ icon1 ] )
			surface.DrawTexturedRect( x, y + h2, 16, 16 )
		end

		if ( icon2 && self.Icons[ icon2 ] && !self.Icons[ icon2 ]:IsError() ) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( self.Icons[ icon2 ] )
			surface.DrawTexturedRect( x - 25, y + h2, 16, 16 )

			draw.SimpleText( "+", "default", x - 8, y + h2 + 2, color_white )
		end

		h2 = h2 + h

	end

	self.InfoBoxHeight = h2 + 8

end

function SWEP:SetStage( ... )

	if ( !self:GetToolObject() ) then return end
	return self:GetToolObject():SetStage( ... )

end

function SWEP:GetStage( ... )

	if ( !self:GetToolObject() ) then return end
	return self:GetToolObject():GetStage( ... )

end

function SWEP:ClearObjects( ... )

	if ( !self:GetToolObject() ) then return end
	self:GetToolObject():ClearObjects( ... )

end

function SWEP:StartGhostEntities( ... )

	if ( !self:GetToolObject() ) then return end
	self:GetToolObject():StartGhostEntities( ... )

end

function SWEP:PrintWeaponInfo( x, y, alpha )
end

function SWEP:FreezeMovement()

	if ( !self:GetToolObject() ) then return false end

	return self:GetToolObject():FreezeMovement()

end

function SWEP:OnReloaded()

	-- TODO: Reload the tool control panels
	-- controlpanel.Clear()

end
