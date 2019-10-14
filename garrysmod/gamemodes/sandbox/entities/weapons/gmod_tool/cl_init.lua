
local gmod_drawhelp = CreateClientConVar( "gmod_drawhelp", "1", true, false, "Should the tool HUD be displayed when the tool gun is active?" )
local gmod_toolmode = CreateClientConVar( "gmod_toolmode", "rope", true, true )
CreateClientConVar( "gmod_drawtooleffects", "1", true, false, "Should tools draw certain UI elements or effects? ( Will not work for all tools )" )

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
	weight = 1000
} )

surface.CreateFont( "GModToolSubtitle", {
	font = "Roboto Bk",
	size = 24,
	weight = 1000
} )

surface.CreateFont( "GModToolHelp", {
	font = "Roboto Bk",
	size = 17,
	weight = 1000
} )

--[[---------------------------------------------------------
	Draws the help on the HUD (disabled if gmod_drawhelp is 0)
-----------------------------------------------------------]]
function SWEP:DrawHUD()

	local mode = gmod_toolmode:GetString()

	-- Don't draw help for a nonexistant tool!
	if ( !self:GetToolObject() ) then return end

	self:GetToolObject():DrawHUD()

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
	local alpha = math.Clamp( 255 + ( self:GetToolObject().LastMessage - CurTime() ) * 800, 10, 255 )
	QuadTable.color = Color( alpha, alpha, alpha, 230 )
	draw.TexturedQuad( QuadTable )

	y = y + 4

	TextTable.font = "GModToolHelp"

	if ( !self:GetToolObject().Information ) then
		TextTable.pos = { x + self.InfoBoxHeight, y }
		TextTable.text = self:GetToolObject():GetHelpText()
		w, h = draw.TextShadow( TextTable, 1 )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( self.InfoIcon )
		surface.DrawTexturedRect( x + 1, y + 1, h - 3, h - 3 )

		self.InfoBoxHeight = h + 8

		return
	end

	local h2 = 0

	for k, v in pairs( self:GetToolObject().Information ) do
		if ( isstring( v ) ) then v = { name = v } end

		if ( !v.name ) then continue end
		if ( v.stage && v.stage != self:GetStage() ) then continue end
		if ( v.op && v.op != self:GetToolObject():GetOperation() ) then continue end

		local txt = "#tool." .. GetConVarString( "gmod_toolmode" ) .. "." .. v.name
		if ( v.name == "info" ) then
			txt = self:GetToolObject():GetHelpText()
		end

		TextTable.text = txt
		TextTable.pos = { x + 21, y + h2 }

		w, h = draw.TextShadow( TextTable, 1 )

		if ( !v.icon ) then
			if ( v.name:StartWith( "info" ) ) then v.icon = "gui/info" end
			if ( v.name:StartWith( "left" ) ) then v.icon = "gui/lmb.png" end
			if ( v.name:StartWith( "right" ) ) then v.icon = "gui/rmb.png" end
			if ( v.name:StartWith( "reload" ) ) then v.icon = "gui/r.png" end
			if ( v.name:StartWith( "use" ) ) then v.icon = "gui/e.png" end
		end
		if ( !v.icon2 && !v.name:StartWith( "use" ) && v.name:EndsWith( "use" ) ) then v.icon2 = "gui/e.png" end

		self.Icons = self.Icons or {}
		if ( v.icon && !self.Icons[ v.icon ] ) then self.Icons[ v.icon ] = Material( v.icon ) end
		if ( v.icon2 && !self.Icons[ v.icon2 ] ) then self.Icons[ v.icon2 ] = Material( v.icon2 ) end

		if ( v.icon && self.Icons[ v.icon ] && !self.Icons[ v.icon ]:IsError() ) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( self.Icons[ v.icon ] )
			surface.DrawTexturedRect( x, y + h2, 16, 16 )
		end

		if ( v.icon2 && self.Icons[ v.icon2 ] && !self.Icons[ v.icon2 ]:IsError() ) then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( self.Icons[ v.icon2 ] )
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

	local mode = self:GetMode()

	if ( !self:GetToolObject() ) then return false end

	return self:GetToolObject():FreezeMovement()

end

function SWEP:OnReloaded()

	-- TODO: Reload the tool control panels
	-- controlpanel.Clear()

end
