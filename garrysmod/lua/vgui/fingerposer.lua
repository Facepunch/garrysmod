
local PANEL = {}

local MatBackground = surface.GetTextureID( "vgui/hand" )

local ow = 310
local oh = 270

local FingerPositions = { 
	{ 56 / ow, 230 / oh },
	{ 51 / ow, 180 / oh },
	{ 59 / ow, 130 / oh },
	
	{ 121 / ow, 114 / oh },
	{ 132 / ow, 75 / oh },
	{ 160 / ow, 34 / oh },
	
	{ 165 / ow, 126 / oh },
	{ 178 / ow, 92 / oh },
	{ 197 / ow, 60 / oh },
	
	{ 194 / ow, 156 / oh },
	{ 208 / ow, 124 / oh },
	{ 228 / ow, 92 / oh },
	
	{ 229 / ow, 175 / oh},
	{ 244 / ow, 146 / oh},
	{ 259 / ow, 115 / oh},
}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Hand = 0
	self.FingerVars = {}
	
	self.Label:SetBright( true )
	
	for i=0, 14 do
	
		if ( self.NumVars == 18 && i > 10 ) then break end
	
		self.FingerVars[ i ] = vgui.Create( "FingerVar", self )
		
		self.FingerVars[ i ]:SetVarName( "finger_" .. i )
		
		if ( i > 2 && i % 3 != 0 ) then
		
			self.FingerVars[ i ]:SetRestrictX( true )
		
		end
	
	end

end

--[[---------------------------------------------------------
   Name: ControlValues
   Desc: The keyvalues passed from the control defs
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local y = self.BaseClass.PerformLayout( self )
	
	y = y + 200
	y = y + 5
	
	local w, h = self:GetSize()
	
	for finger = 0, 4 do
	
		for var = 0, 2 do
		
			local ID = ( ( finger * 3 ) + var )
		
			local Pos = FingerPositions[ ID + 1 ]
			if ( Pos && self.FingerVars[ ID ] ) then
				self.FingerVars[ ID ]:SetPos( Pos[1] * w - 24, Pos[2] * h - 24 )
			end
		
		end
	
	end

	self:SetTall( y )

end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	surface.SetTexture( MatBackground )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, w, h )

	return true

end

--[[---------------------------------------------------------
   Name: Think
-----------------------------------------------------------]]
function PANEL:Think()
	self:UpdateHovered()
end

--[[---------------------------------------------------------
   Name: UpdateHovered
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed( mousecode )

	self:UpdateHovered()
	
	if ( !IsValid( self.HoveredPanel ) ) then return end
	
	self.HoveredPanel:OnMousePressed( mousecode )
	
end

vgui.Register( "fingerposer", PANEL, "ContextBase" )
