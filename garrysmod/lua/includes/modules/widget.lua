

--
-- Widgets are like gui controls in the 3D world(not not not)
--

widgets = {}

--
-- Holds the currently hovered widget
--
widgets.Hovered = nil
widgets.HoveredPos = Vector(0, 0, 0)

--
-- Holds the current pressed widget
--
widgets.Pressed = nil

local function UpdateHovered(pl, mv)

	if (not IsValid( pl)) then return end

	if (not pl:Alive()) then
		pl:SetHoveredWidget(NULL)
		return
	end

	local OldHovered = pl:GetHoveredWidget()
	pl:SetHoveredWidget(NULL)

	local trace =
	{
		start	= pl:EyePos(),
		endpos	= pl:EyePos() + pl:GetAimVector() * 256,
		filter	= function(ent)

			return IsValid(ent) and ent:IsWidget()

		end
	}

--	debugoverlay.Line(trace.start, trace.endpos, 0.5)

	widgets.Tracing = true
	local tr = util.TraceLine(trace)
	widgets.Tracing = false

	if (not IsValid( tr.Entity)) then return end
	if (tr.Entity:IsWorld()) then return end
	if (not tr.Entity:IsWidget()) then return end

--	debugoverlay.Cross(tr.HitPos, 1, 60)

	if (OldHovered ~= tr.Entity) then

		-- On hover changed? why bother?

	end

	pl:SetHoveredWidget(tr.Entity)
	pl.WidgetHitPos = tr.HitPos

end

local function UpdateButton(pl, mv, btn, mousebutton)

	local now = mv:KeyDown(btn)
	local was = mv:KeyWasDown(btn)
	local hvr = pl:GetHoveredWidget()
	local prs = pl:GetPressedWidget()

	if (now and not was and IsValid( hvr)) then
		hvr:OnPress(pl, mousebutton, mv)
	end

	if (not now and was and IsValid( prs)) then
		prs:OnRelease(pl, mousebutton, mv)
	end
end


--
-- The idea here is to have exactly the same
-- behaviour on the client as the server.
--
function widgets.PlayerTick(pl, mv)

	UpdateHovered(pl, mv)

	UpdateButton(pl, mv, IN_ATTACK, 1)
	UpdateButton(pl, mv, IN_ATTACK2, 2)

	local prs = pl:GetPressedWidget()

	if (IsValid( prs)) then
		prs:PressedThinkInternal(pl, mv)
	end

end


---
---  Render the widgetsnot
---

local RenderList = {}

function widgets.RenderMe(ent)

	--
	-- The pressed widget gets to decide what should draw
	--
	if (LocalPlayer() and IsValid(LocalPlayer():GetPressedWidget())) then

		if (not LocalPlayer():GetPressedWidget():PressedShouldDraw( ent)) then
			return
		end

	end


	table.insert(RenderList, ent)

end

hook.Add( "PostDrawEffects", "RenderWidgets", function()

	--
	-- Don't do anything if we don't have widgets to rendernot
	--
	if (#RenderList == 0) then return end

	cam.Start3D(EyePos(), EyeAngles())

		for k, v in pairs(RenderList) do

			v:OverlayRender()

		end

	cam.End3D()

	RenderList = {}

end )


hook.Add("PlayerTick", "TickWidgets", function( pl, mv) widgets.PlayerTick( pl, mv) end)




local ENTITY = FindMetaTable("Entity")

function ENTITY:IsWidget()
	return self.Widget
end
