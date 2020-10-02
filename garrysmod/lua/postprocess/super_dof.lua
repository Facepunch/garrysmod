
local PANEL = {}

local Distance = 256
local BlurSize = 0.5
local Passes = 12
local Steps = 24
local Shape = 0.5

local SuperDOFWindow = nil
local Status = "Preview"

local FocusGrabber = false

function PANEL:Init()

	self:SetTitle( "#superdof_pp.title" )
	self:SetRenderInScreenshots( false )

	local Panel = vgui.Create( "DPanel", self )

	local lbl = Label( "#superdof_pp.settings", Panel )
	lbl:SetContentAlignment( 8 )
	lbl:Dock( TOP )
	lbl:SetDark( true )

	self.BlurSize = vgui.Create( "DNumSlider", Panel )
	self.BlurSize:SetMin( 0 )
	self.BlurSize:SetMax( 10 )
	self.BlurSize:SetDecimals( 3 )
	self.BlurSize:SetText( "#superdof_pp.size" )
	self.BlurSize:SetValue( BlurSize )
	function self.BlurSize:OnValueChanged( val ) BlurSize = val end
	self.BlurSize:Dock( TOP )
	self.BlurSize:DockMargin( 0, 0, 0, 16 )
	self.BlurSize:SetDark( true )

	self.Distance = vgui.Create( "DNumSlider", Panel )
	self.Distance:SetMin( 0 )
	self.Distance:SetMax( 4096 )
	self.Distance:SetText( "#superdof_pp.distance" )
	self.Distance:SetValue( Distance )
	function self.Distance:OnValueChanged( val ) Distance = val end
	self.Distance:Dock( TOP )
	self.Distance:SetDark( true )
	self.Distance:SetTooltip( "#superdof_pp.distance.tooltip" )

	Panel:SetPos( 10, 30 )
	Panel:SetSize( 300, 90 )
	Panel:DockPadding( 8, 8, 8, 8 )
	Panel:DockMargin( 0, 0, 4, 0 )
	Panel:Dock( FILL )

	local Panel = vgui.Create( "DPanel", self )

	local lbl = Label( "#superdof_pp.adv", Panel )
	lbl:SetContentAlignment( 8 )
	lbl:Dock( TOP )
	lbl:SetDark( true )

	local PassesCtrl = vgui.Create( "DNumSlider", Panel )
	PassesCtrl:SetMin( 1 )
	PassesCtrl:SetMax( 64 )
	PassesCtrl:SetDecimals( 0 )
	PassesCtrl:SetText( "#superdof_pp.passes" )
	PassesCtrl:SetValue( Passes )
	function PassesCtrl:OnValueChanged( val ) Passes = val end
	PassesCtrl:Dock( TOP )
	PassesCtrl:DockMargin( 0, 0, 0, 4 )
	PassesCtrl:SetDark( true )

	local RadialsCtrl = vgui.Create( "DNumSlider", Panel )
	RadialsCtrl:SetMin( 1 )
	RadialsCtrl:SetMax( 64 )
	RadialsCtrl:SetDecimals( 0 )
	RadialsCtrl:SetText( "#superdof_pp.radials" )
	RadialsCtrl:SetValue( Steps )
	function RadialsCtrl:OnValueChanged( val ) Steps = val end
	RadialsCtrl:Dock( TOP )
	RadialsCtrl:DockMargin( 0, 0, 0, 4 )
	RadialsCtrl:SetDark( true )

	local ShapeCtrl = vgui.Create( "DNumSlider", Panel )
	ShapeCtrl:SetMin( 0 )
	ShapeCtrl:SetMax( 1 )
	ShapeCtrl:SetDecimals( 3 )
	ShapeCtrl:SetText( "#superdof_pp.shape" )
	ShapeCtrl:SetValue( Shape )
	function ShapeCtrl:OnValueChanged( val ) Shape = val end
	ShapeCtrl:Dock( TOP )
	ShapeCtrl:DockMargin( 0, 0, 0, 4 )
	ShapeCtrl:SetDark( true )

	Panel:SetPos( 10, 30 )
	Panel:SetSize( 150, 100 )
	Panel:DockPadding( 8, 8, 8, 8 )
	Panel:Dock( RIGHT )

	local Panel = vgui.Create( "DPanel", self )

	self.Render = vgui.Create( "DButton", Panel )
	self.Render:SetText( "#superdof_pp.render" )
	function self.Render:DoClick() Status = "Render" end
	self.Render:Dock( RIGHT ) self.Render:SetSize( 70, 20 )

	self.Screenshot = vgui.Create( "DButton", Panel )
	self.Screenshot:SetText( "#superdof_pp.screenshot" )
	function self.Screenshot:DoClick() RunConsoleCommand( "jpeg" ) end
	self.Screenshot:Dock( RIGHT )
	self.Screenshot:SetSize( 120, 20 )
	self.Screenshot:DockMargin( 0, 0, 8, 0 )

	local Break = vgui.Create( "DButton", Panel )
	Break:SetText( "5" )
	local THIS = self
	function Break:DoClick()
		THIS:SetVisible( false )
		timer.Simple( 5, function() THIS:SetVisible( true ) end )
	end
	Break:Dock( LEFT )
	Break:SetSize( 20, 20 )
	Break:SetTooltip( "#superdof_pp.5hint" )

	Panel:Dock( BOTTOM )
	Panel:DockPadding( 4, 4, 4, 4 )
	Panel:DockMargin( 0, 4, 0, 0 )
	Panel:SetTall( 28 )
	Panel:MoveToBack()

	self:SetSize( 600, 220 )

end

function PANEL:ChangeDistanceTo( dist )

	self.Distance:SetValue( dist )

end

function PANEL:PositionMyself()

	self:AlignBottom( 50 )
	self:CenterHorizontal()

end

function PANEL:OnScreenSizeChanged( what, ever )

	self:PositionMyself()

end

local paneltypeSuperDOF = vgui.RegisterTable( PANEL, "DFrame" )
local texFSB = render.GetSuperFPTex()
local matFSB = Material( "pp/motionblur" )
local matFB = Material( "pp/fb" )

function RenderDoF( vOrigin, vAngle, vFocus, fAngleSize, radial_steps, passes, bSpin, inView, ViewFOV )

	local OldRT = render.GetRenderTarget()
	local view = { x = 0, y = 0, w = ScrW(), h = ScrH() }
	local fDistance = vOrigin:Distance( vFocus )

	fAngleSize = fAngleSize * math.Clamp( 256 / fDistance, 0.1, 1 ) * 0.5

	local view = inView

	if ( !view ) then

		view = {
			x = 0,
			y = 0,
			w = ScrW(),
			h = ScrH(),
			dopostprocess = true,
			origin = vOrigin,
			angles = vAngle,
			fov = ViewFOV
		}

	end

	-- Straight render (to act as a canvas)
	render.RenderView( view )

	render.UpdateScreenEffectTexture()

	render.SetRenderTarget( texFSB )
	render.Clear( 0, 0, 0, 255, true, true )
	matFB:SetFloat( "$alpha", 1 )
	render.SetMaterial( matFB )
	render.DrawScreenQuad()

	local Radials = ( math.pi * 2 ) / radial_steps

	for mul = 1 / passes, 1, 1 / passes do

		for i = 0, math.pi * 2, Radials do

			local VA = vAngle * 1 -- hack - this makes it copy the angles instead of the reference
			local VRot = vAngle * 1
			-- Rotate around the focus point
			VA:RotateAroundAxis( VRot:Right(), math.sin( i + mul ) * fAngleSize * mul * Shape * 2 )
			VA:RotateAroundAxis( VRot:Up(), math.cos( i + mul ) * fAngleSize * mul * ( 1 - Shape ) * 2 )

			view.origin = vFocus - VA:Forward() * fDistance
			view.angles = VA

			-- Render to the front buffer
			render.SetRenderTarget( OldRT )
			render.Clear( 0, 0, 0, 255, true, true )
			render.RenderView( view )
			render.UpdateScreenEffectTexture()

			-- Copy it to our floating point buffer at a reduced alpha
			render.SetRenderTarget( texFSB )
			local alpha = ( Radials / ( math.pi * 2 ) ) -- Divide alpha by number of radials
			alpha = alpha * ( 1 - mul ) -- Reduce alpha the further away from center we are
			matFB:SetFloat( "$alpha", alpha )

			render.SetMaterial( matFB )
			render.DrawScreenQuad()

			-- We have to SPIN here to stop the Source engine running out of render queue space.
			if ( bSpin ) then

				-- Restore RT
				render.SetRenderTarget( OldRT )

				-- Render our result buffer to the screen
				matFSB:SetFloat( "$alpha", 1 )
				matFSB:SetTexture( "$basetexture", texFSB )

				render.SetMaterial( matFSB )
				render.DrawScreenQuad()

				cam.Start2D()
					local add = ( i / ( math.pi * 2 ) ) * ( 1 / passes )
					local percent = string.format( "%.1f", ( mul - ( 1 / passes ) + add ) * 100 )
					draw.DrawText( percent .. "%", "GModWorldtip", view.w - 100, view.h - 100, color_black, TEXT_ALIGN_CENTER )
					draw.DrawText( percent .. "%", "GModWorldtip", view.w - 101, view.h - 101, color_white, TEXT_ALIGN_CENTER )
				cam.End2D()

				render.Spin()

			end

		end

	end

	-- Restore RT
	render.SetRenderTarget( OldRT )
	render.Clear( 0, 255, 0, 255, true, true )

	-- Render our result buffer to the screen
	matFSB:SetFloat( "$alpha", 1 )
	matFSB:SetTexture( "$basetexture", texFSB )

	render.SetMaterial( matFSB )
	render.DrawScreenQuad()

end

function RenderSuperDoF( ViewOrigin, ViewAngles, ViewFOV )

	if ( FocusGrabber ) then

		local x, y = gui.MousePos()
		local dir = util.AimVector( ViewAngles, ViewFOV, x, y, ScrW(), ScrH() )

		local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer(), dir ) )
		Distance = tr.HitPos:Distance( ViewOrigin )
		Status = "Preview"

		-- debugoverlay.Cross( tr.HitPos, 10 )

		SuperDOFWindow:ChangeDistanceTo( Distance )

		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetNormal( tr.HitNormal )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 16 )

		util.Effect( "Sparks", effectdata )

	end

	local FocusPoint = ViewOrigin + ViewAngles:Forward() * Distance

	if ( Status == "Preview" ) then

		-- A low quality, pretty quickly drawn rough outline
		RenderDoF( ViewOrigin, ViewAngles, FocusPoint, BlurSize, 2, 2, false, nil, ViewFOV )

	elseif ( Status == "Render" ) then

		-- A great quality render..
		RenderDoF( ViewOrigin, ViewAngles, FocusPoint, BlurSize, Steps, Passes, true, nil, ViewFOV )
		Status = "ViewShot"

	elseif ( Status == "ViewShot" ) then

		matFSB:SetFloat( "$alpha", 1 )
		matFSB:SetTexture( "$basetexture", texFSB )
		render.SetMaterial( matFSB )
		render.DrawScreenQuad()

	end

end

hook.Add( "RenderScene", "RenderSuperDoF", function( ViewOrigin, ViewAngles, ViewFOV )

	if ( !IsValid( SuperDOFWindow ) ) then return end

	-- Don't render it when the console is up
	if ( FrameTime() == 0 ) then return end

	RenderSuperDoF( ViewOrigin, ViewAngles, ViewFOV )
	return true

end )

concommand.Add( "pp_superdof", function()

	Status = "Preview"

	if ( IsValid( SuperDOFWindow ) ) then
		SuperDOFWindow:Remove()
	end

	SuperDOFWindow = vgui.CreateFromTable( paneltypeSuperDOF )

	SuperDOFWindow:InvalidateLayout( true )
	SuperDOFWindow:MakePopup()
	SuperDOFWindow:PositionMyself()

end )

hook.Add( "GUIMousePressed", "SuperDOFMouseDown", function( mouse )

	if ( !IsValid( SuperDOFWindow ) ) then return end

	vgui.GetWorldPanel():MouseCapture( true )
	FocusGrabber = true

end )

hook.Add( "GUIMouseReleased", "SuperDOFMouseUp", function( mouse )

	if ( !IsValid( SuperDOFWindow ) ) then return end

	vgui.GetWorldPanel():MouseCapture( false )
	FocusGrabber = false

end )

list.Set( "PostProcess", "#superdof_pp", {
	icon = "gui/postprocess/superdof.png",
	category = "#effects_pp",
	onclick = function() RunConsoleCommand( "pp_superdof" ) end
} )

--
-- We don't want people using weapons when they click on the screen
--
hook.Add( "PreventScreenClicks", "SuperDOFPreventClicks", function()

	if ( IsValid( SuperDOFWindow ) ) then return true end

end )
