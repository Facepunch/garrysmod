
local ConVar_RestrictFingers = CreateClientConVar("finger_restrict", "1", false, false)

local PANEL = {}

local MAX_ANGLE_X = 100
local MAX_ANGLE_Y = 100

function PANEL:Init()

	self.Value = { 0, 0 }
	self.UpdateTimer = 0

	-- Don't update convars straight away.
	self.NextUpdate = CurTime() + 0.5

	-- The parent will feed mouse presses to us
	self:SetMouseInputEnabled(false)

end

function PANEL:PerformLayout()

	self:SetSize(48, 48)

end

function PANEL:SetVarName(_name_)

	self.VarName = _name_

end

function PANEL:SetRestrictX(bRestrict)

	self.RestrictX = bRestrict

end

function PANEL:IsRestricted()

	return self.RestrictX and ConVar_RestrictFingers:GetBool()

end

function PANEL:GetValue()

	return { self.Value[1] / MAX_ANGLE_X, self.Value[2] / MAX_ANGLE_Y }

end

function PANEL:UpdateConVar()

	if (not self.VarName) then return end
	if (self.NextUpdate > CurTime()) then return end

	local Val = Format("%.2f %.2f", self.Value[1], self.Value[2])
	RunConsoleCommand(self.VarName, Val)

end

function PANEL:SetValue(x, y)

	x = math.Clamp(x, -0.5, 0.5) * MAX_ANGLE_X
	y = math.Clamp(y, -0.5, 0.5) * MAX_ANGLE_Y

	if (self:IsRestricted()) then x = 0 end

	self.Value = { x, y }

end

function PANEL:OnMousePressed(mousecode)

	if (mousecode == MOUSE_RIGHT) then
		self:SetValue(0, 0)
		self:UpdateConVar()

		return
	end

	self:SetMouseInputEnabled(true)
	self:MouseCapture(true)
	self.Dragging = 1
	self:GetParent().Dragging = true

end

function PANEL:OnMouseReleased()

	self:MouseCapture(false)
	self.Dragging = nil
	self:SetMouseInputEnabled(false)
	self:GetParent().Dragging = false

end

function PANEL:OnCursorMoved(x, y)

	if (not self.Dragging) then return end

	local w = self:GetWide()
	local h = self:GetTall()

	self:SetValue(( x / w) - 0.5, ( y / h) - 0.5)
	self:UpdateConVar()

end

function PANEL:Think()

	if (self.UpdateTimer > CurTime()) then return end
	self.UpdateTimer = CurTime() + 0.1

	local Value = string.Explode(" ", GetConVarString( self.VarName))

	self.Value[1] = tonumber(Value[1])
	self.Value[2] = tonumber(Value[2])

end

function PANEL:Paint(w, h)

	-- This part is dirty, the whole fingerposer needs redoing, it's messy
	local wep = LocalPlayer():GetWeapon( "gmod_tool")
	if (not IsValid( wep)) then return end

	local ent = wep:GetNWEntity("HandEntity")
	if (not IsValid( ent) or not ent.FingerIndex) then return end

	local boneid = ent.FingerIndex[ tonumber(self.VarName:sub( 8)) + 1 + 15 * wep:GetNWInt( "HandNum", 0) ]
	if (not boneid or ent:GetBoneName( boneid) == "__INVALIDBONE__") then return end

	local v = self:GetValue()

	local x = (v[1] * w) + w / 2
	local y = (v[2] * h) + h / 2

	x = math.Clamp(x, 3, w - 3)
	y = math.Clamp(y, 3, h - 3)

	surface.SetDrawColor(0, 0, 0, 250)
	if (self.HoveredFingerVar) then surface.SetDrawColor( 255, 255, 255, 255) end
	surface.DrawLine(x, y, w / 2, h / 2)
	surface.DrawRect(w / 2 - 1, h / 2 - 1, 2, 2)
	surface.DrawRect(x - 3, y - 3, 6, 6)

	surface.SetDrawColor(255, 255, 0, 255)
	if (self:IsRestricted()) then surface.SetDrawColor( 30, 180, 255, 255) end
	surface.DrawRect(x - 2, y - 2, 4, 4)

end

vgui.Register("FingerVar", PANEL, "Panel")
