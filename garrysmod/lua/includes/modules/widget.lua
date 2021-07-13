

--
-- Widgets are like gui controls in the 3D world(!!!)
--

widgets = {}
widgets.entities = {}

--
-- Holds the currently hovered widget
-- 
widgets.Hovered = nil
widgets.HoveredPos = vector_origin

--
-- Holds the current pressed widget
-- 
widgets.Pressed = nil

local tr = { }
local trace = { output = tr,
	filter = function( ent )
		return ent:IsWidget()
	end
}

local dotraces = false

local function UpdateHovered( pl, mv )
	if ( !IsValid( pl ) ) then return end

	pl:SetHoveredWidget( NULL ) 
	if ( !dotraces or !pl:Alive( ) ) then 
		return
	end

	local eye_pos = pl:EyePos()
	trace.start = eye_pos
	trace.endpos = eye_pos + pl:GetAimVector() * 128
	
--	debugoverlay.Line( trace.start, trace.endpos, 0.5 )

	widgets.Tracing = true
	util.TraceLine( trace )
	widgets.Tracing = false

	if ( !IsValid( tr.Entity ) ) then return end
	-- these two lines are unnecessary
	--if ( tr.Entity:IsWorld() ) then return end
	--if ( !tr.Entity:IsWidget() ) then return end

--	debugoverlay.Cross( tr.HitPos, 1, 60 )
	
	pl:SetHoveredWidget( tr.Entity )
	pl.WidgetHitPos = tr.HitPos

end

local function UpdateButton( pl, mv, btn, mousebutton )

	local now = mv:KeyDown( btn )
	local was = mv:KeyWasDown( btn )
	local hvr = pl:GetHoveredWidget()
	local prs = pl:GetPressedWidget()
	
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

	UpdateHovered( pl, mv )
	if ( not dotraces ) then return end
	
	UpdateButton( pl, mv, IN_ATTACK, 1 )
	UpdateButton( pl, mv, IN_ATTACK2, 2 )
	
	
	local prs = pl:GetPressedWidget()
	
	if ( IsValid( prs ) ) then
		prs:PressedThinkInternal( pl, mv )
	end
	
end


---
---  Render the widgets!
---

local RenderList = {}

function widgets.RenderMe( ent )

	--
	-- The pressed widget gets to decide what should draw
	--
	if ( IsValid(LocalPlayer():GetPressedWidget()) ) then
	
		if ( !LocalPlayer():GetPressedWidget():PressedShouldDraw( ent ) ) then 
			return 
		end
	
	end
	

	table.insert( RenderList, ent )

end

hook.Add( "PostDrawEffects", "RenderWidgets", function() 

	--
	-- Don't do anything if we don't have widgets to render!
	--
	if ( #RenderList == 0 ) then return end

	cam.Start3D( EyePos(), EyeAngles() )

		for k, v in next, RenderList, nil do
	
			v:OverlayRender()
	
		end
	
	cam.End3D()
	
	RenderList = {}

end )

hook.Add( "OnEntityCreated", "CreateWidgets", function( ent )
	timer.Simple( 1, function( ) -- why is this needed? no one may ever know!
		if ( ent:IsWidget( ) ) then
			table.insert( widgets.entities, ent )
			dotraces = true
		end
	end )
end )
hook.Add( "EntityRemoved", "RemoveWidgets", function( ent )
	if ( ent:IsWidget( ) ) then
		for k,v in next, widgets.entities, nil do
			table.remove( widgets.entities, k )
			break
		end
		if ( #widgets.entities == 0 ) then dotraces = false end
	end
	
end )

hook.Add( "PlayerTick", "TickWidgets", function( pl, mv ) widgets.PlayerTick( pl, mv ) end )




local ENTITY = FindMetaTable( "Entity" )

function ENTITY:IsWidget()
	return self.Widget
end
