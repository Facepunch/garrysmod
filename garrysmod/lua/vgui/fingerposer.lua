
local PANEL = {}

local ow = 310
local oh = 270

PANEL.FingerPositions = {
	{ 60 / ow, 215 / oh },
	{ 50 / ow, 175 / oh },
	{ 55 / ow, 130 / oh },

	{ 117 / ow, 135 / oh },
	{ 128 / ow, 85 / oh },
	{ 149 / ow, 45 / oh },

	{ 155 / ow, 145 / oh },
	{ 172 / ow, 100 / oh },
	{ 197 / ow, 60 / oh },

	{ 185 / ow, 160 / oh },
	{ 215 / ow, 115 / oh },
	{ 235 / ow, 85 / oh },

	{ 215 / ow, 175 / oh },
	{ 245 / ow, 145 / oh },
	{ 272 / ow, 120 / oh },
}

function PANEL:Init()

	self.Hand = 0
	self.FingerVars = {}

	self.Label:SetBright( true )

	for i = 0, 14 do

		if ( self.NumVars == 18 && i > 10 ) then break end

		self.FingerVars[ i ] = vgui.Create( "FingerVar", self )

		self.FingerVars[ i ]:SetVarName( "finger_" .. i )

		if ( i > 2 && i % 3 != 0 ) then

			self.FingerVars[ i ]:SetRestrictX( true )

		end

	end

end

function PANEL:ControlValues( kv )

	if ( kv.hand == 1 ) then
		self.Label:SetText( "#tool.finger.righthand" )
		self.Hand = 1
	else
		self.Label:SetText( "#tool.finger.lefthand" )
		self.Hand = 0
	end

	self.NumVars = kv.numvars

	self:InvalidateLayout( true )

end

function PANEL:PerformLayout( w, h )

	local size = math.min( w, h )
	local targetH = math.Clamp( w, 256, 512 )
	local bgXoffset = w / 2 - size / 2

	self.Label:SetPos( 10 + bgXoffset, 5 )
	self.Label:SetWide( w )

	for finger = 0, 4 do

		for var = 0, 2 do

			local ID = ( finger * 3 ) + var

			local Pos = self.FingerPositions[ ID + 1 ]
			if ( Pos && self.FingerVars[ ID ] ) then
				-- Scale the finger "sliders" a bit
				local fsize = math.floor( math.Remap( targetH, 256, 512, 48, 64 ) )
				self.FingerVars[ ID ]:SetSize( fsize, fsize )

				self.FingerVars[ ID ]:SetPos( bgXoffset + Pos[1] * size - fsize / 2, Pos[2] * size - fsize / 2 )
			end

		end

	end

	self:SetTall( targetH )

end

local bg_mat = Material( "gui/hand_human_left.png" )
function PANEL:Paint( w, h )

	surface.SetMaterial( bg_mat )
	surface.SetDrawColor( 255, 255, 255, 255 )

	local size = math.min( w, h )

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
		surface.DrawTexturedRect( w / 2 - size / 2, 0, size, size )
	render.PopFilterMag()
	render.PopFilterMin()

	return true

end

function PANEL:Think()
	self:UpdateHovered()
end

function PANEL:UpdateHovered()

	if ( self.Dragging ) then return end

	local x, y = self:CursorPos()

	local distance = 256
	local hovered = nil
	for k, v in pairs( self.FingerVars ) do

		local val = v:GetValue()
		local AddX = val[1] * v:GetWide()
		local AddY = val[2] * v:GetTall()

		local dist = math.Distance( x, y, v.x + v:GetWide() / 2 + AddX, v.y + v:GetTall() / 2 + AddY )
		if ( dist < distance ) then
			hovered = v
			distance = dist
		end

	end

	if ( !hovered || hovered != self.HoveredPanel ) then

		if ( IsValid( self.HoveredPanel ) ) then
			self.HoveredPanel.HoveredFingerVar = nil
		end

		self.HoveredPanel = hovered

		if ( IsValid( self.HoveredPanel ) ) then
			self.HoveredPanel.HoveredFingerVar = true
		end

	end

end

function PANEL:OnMousePressed( mousecode )

	self:UpdateHovered()

	if ( !IsValid( self.HoveredPanel ) ) then return end

	self.HoveredPanel:OnMousePressed( mousecode )

end

vgui.Register( "fingerposer", PANEL, "ContextBase" )
