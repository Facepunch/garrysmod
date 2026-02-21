

--
-- Widgets are like gui controls in the 3D world(!!!)
--

widgets = {}
local widgetEntities = {}

--
-- Holds the currently hovered widget
--
widgets.Hovered = nil
widgets.HoveredPos = vector_origin

--
-- Holds the current pressed widget
--
widgets.Pressed = nil

local tr = {}
local trace = {
	output = tr,
	filter = widgetEntities,
	whitelist = true,
}

local function UpdateHovered( pl )

	if ( !IsValid( pl ) ) then return end

	if ( !pl:Alive() ) then
		pl:SetHoveredWidget( NULL )
		return
	end

	local eyePos = pl:EyePos()
	local aimVector = pl:GetAimVector()
	aimVector:Mul( 256 )
	aimVector:Add( eyePos )

	trace.start = eyePos
	trace.endpos = aimVector

--	debugoverlay.Line( trace.start, trace.endpos, 0.5 )

	widgets.Tracing = true
	util.TraceLine( trace )
	widgets.Tracing = false

	if ( !IsValid( tr.Entity ) || tr.Entity:IsWorld() ) then
		pl:SetHoveredWidget( NULL )
		return
	end

--	debugoverlay.Cross( tr.HitPos, 1, 60 )

	pl:SetHoveredWidget( tr.Entity )
	pl.WidgetHitPos = tr.HitPos

	return tr.Entity

end

local function UpdateButton( pl, mv, btn, mousebutton, hvr, prs )

	local now = mv:KeyDown( btn )
	local was = mv:KeyWasDown( btn )

	if ( now && !was && IsValid( hvr ) ) then
		hvr:OnPress( pl, mousebutton, mv )
	end

	if ( !now && was && IsValid( prs ) ) then
		prs:OnRelease( pl, mousebutton, mv )
	end

end

--
-- The idea here is to have exactly the same
-- behaviour on the client as the server.
--
function widgets.PlayerTick( pl, mv )

	local hvr = UpdateHovered( pl )
	local prs = pl:GetPressedWidget()

	UpdateButton( pl, mv, IN_ATTACK, 1, hvr, prs )
	UpdateButton( pl, mv, IN_ATTACK2, 2, hvr, prs )

	if ( IsValid( prs ) ) then
		prs:PressedThinkInternal( pl, mv )
	end

end

---
---  Render the widgets!
---

-- Function stub for backwards compatibility
function widgets.RenderMe( ent )
	-- We do this solely for backwards compatibility
	ent._WantsWidgetRender = true
end

local function RenderWidgets()

	local prs = LocalPlayer():GetPressedWidget()
	local prsValid = IsValid( prs )

	cam.Start3D( EyePos(), EyeAngles() )

		for _, v in ipairs( widgetEntities ) do

			--
			-- The pressed widget gets to decide what should draw
			--
			if ( prsValid && !prs:PressedShouldDraw( v ) ) then continue end
			if ( !v._WantsWidgetRender ) then continue end

			v:OverlayRender()
			v._WantsWidgetRender = nil

		end

	cam.End3D()

end

hook.Add( "OnEntityCreated", "CreateWidgets", function( ent )

	timer.Simple( 0.001, function()

		if ( !ent:IsWidget() ) then return end

		table.insert( widgetEntities, ent )
		hook.Add( "PlayerTick", "TickWidgets", widgets.PlayerTick )

		if ( CLIENT ) then
			hook.Add( "PostDrawEffects", "RenderWidgets", RenderWidgets )
		end

	end )

end )

hook.Add( "EntityRemoved", "RemoveWidgets", function( ent )

	if ( !ent:IsWidget() ) then return end

	for k, v in next, widgetEntities do
		if ( v == ent ) then
			table.remove( widgetEntities, k )
			break
		end
	end

	if ( #widgetEntities == 0 ) then
		hook.Remove( "PlayerTick", "TickWidgets" )

		if ( CLIENT ) then
			hook.Remove( "PostDrawEffects", "RenderWidgets" )
		end
	end

end )

local ENTITY = FindMetaTable( "Entity" )

function ENTITY:IsWidget()
	return self.Widget
end

