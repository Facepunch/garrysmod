
--
-- The number of frames to blend
--
local pp_fb = CreateClientConVar( "pp_fb", "0", false, false )

--
-- The number of frames to blend
--
local pp_fb_frames = CreateClientConVar( "pp_fb_frames", "16", true, false )

--
-- The amount of time the shutter is open. If this is 0.5 then we will blend only
-- 50% of the frames. This is normally 0.5. Lowering it will make it more blurry.
--
local pp_fb_shutter = CreateClientConVar( "pp_fb_shutter", "0.5", true, false )

local FrameCurves = {}

local function FixupCurve( num )

	local overflow = num
	for k, v in pairs( FrameCurves[ num ] ) do
		overflow = overflow - v
	end

	overflow = overflow * math.Rand( 0, 0.5 )

	for i=0, num-1 do

		FrameCurves[ num ][ i ] = FrameCurves[ num ][ i ] + ( overflow / num )

	end

end

local function FrameCurve( f, num )

	if ( FrameCurves[ num ] ) then
		return FrameCurves[ num ][ f ]
	end

	local curve = {}

	for i=0, num-1 do

		local delta = ( i + 1 ) / num
		curve[ i ] = math.sin( delta * math.pi )

	end

	FrameCurves[ num ] = curve

	for i=0, 10 do
		FixupCurve( num )
	end

	return 1.0

end

local texFB = GetRenderTargetEx( "_GMOD_FrameBlend", -1, -1, RT_SIZE_FULL_FRAME_BUFFER, MATERIAL_RT_DEPTH_NONE, 0, 0, IMAGE_FORMAT_DEFAULT )
local matFB = Material( "pp/frame_blend" )
local matFSB = Material( "pp/motionblur" )
local texMB0 = render.GetMoBlurTex0()
local texMB1 = render.GetMoBlurTex1()
local NumFramesTaken = 0

frame_blend = {}

frame_blend.IsActive = function()

	return pp_fb:GetBool()

end

frame_blend.IsLastFrame = function()

	if ( !frame_blend.IsActive() ) then return true end

	local padding = math.floor( pp_fb_frames:GetInt() * pp_fb_shutter:GetFloat() * 0.5 )

	return NumFramesTaken == ( pp_fb_frames:GetInt() - padding - 1 )

end

frame_blend.RenderableFrames = function()

	local padding = math.floor( pp_fb_frames:GetInt() * pp_fb_shutter:GetFloat() * 0.5 ) * 2
	return pp_fb_frames:GetInt() - padding

end

frame_blend.DrawPreview = function()

	render.Clear( 0, 0, 0, 255, true, true )
	matFSB:SetFloat( "$alpha", 1.0 )
	matFSB:SetTexture( "$basetexture", texMB1 )
	render.SetMaterial( matFSB )
	render.DrawScreenQuad()

end

frame_blend.ShouldSkipFrame = function()

	if ( pp_fb_shutter:GetFloat() <= 0 ) then return false end
	if ( pp_fb_shutter:GetFloat() >= 1 ) then return false end

	local padding = math.floor( pp_fb_frames:GetInt() * pp_fb_shutter:GetFloat() * 0.5 )

	if ( NumFramesTaken < padding || NumFramesTaken >= pp_fb_frames:GetInt() - padding ) then
		return true
	end

	return false

end

frame_blend.CompleteFrame = function()

	matFSB:SetFloat( "$alpha", 1.0 )
	matFSB:SetTexture( "$basetexture", texMB0 )

	render.PushRenderTarget( texMB1 )
		render.SetMaterial( matFSB )
		render.DrawScreenQuad()
	render.PopRenderTarget()

	render.PushRenderTarget( texMB0 )
		render.Clear( 0, 0, 0, 255, true, true )
	render.PopRenderTarget()

end

frame_blend.AddFrame = function()

	NumFramesTaken = NumFramesTaken + 1

	if ( NumFramesTaken >= pp_fb_frames:GetInt() ) then
		frame_blend.CompleteFrame()
		NumFramesTaken = 0
	end

end

frame_blend.BlendFrame = function()

	local padding = math.floor( pp_fb_frames:GetInt() * pp_fb_shutter:GetFloat() * 0.5 )
	local frames = pp_fb_frames:GetInt()

	render.PushRenderTarget( texFB )
		render.UpdateScreenEffectTexture()
	render.PopRenderTarget()

	local curve = FrameCurve( NumFramesTaken - padding, frames-padding * 2 )
	if ( !curve ) then return end

	curve = ( 1 / ( NumFramesTaken - padding ) ) * curve

	matFB:SetFloat( "$alpha", curve )

	render.PushRenderTarget( texMB0 )
		render.SetMaterial( matFB )
		render.DrawScreenQuad()
	render.PopRenderTarget()

end

--
-- Don't use these hooks when rendering a demo
--
if ( engine.IsPlayingDemo() ) then return end

hook.Add( "PostRender", "RenderFrameBlend", function()

	if ( !frame_blend.IsActive() ) then return end

	if ( !frame_blend.ShouldSkipFrame() ) then
		render.CopyRenderTargetToTexture( texFB )
		frame_blend.BlendFrame()
	end
	
	frame_blend.AddFrame()
	frame_blend.DrawPreview()

end )

list.Set( "PostProcess", "#frame_blend_pp", {

	icon = "gui/postprocess/frame_blend.png",
	convar = "pp_fb",
	category = "#effects_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#frame_blend_pp.desc" )
		CPanel:Help( "#frame_blend_pp.desc2" )

		CPanel:CheckBox( "#frame_blend_pp.enable", "pp_fb" )

		CPanel:ToolPresets( "frame_blend", { pp_fb_frames = "16", pp_fb_shutter = "0.5" } )

		CPanel:NumSlider( "#frame_blend_pp.frames", "pp_fb_frames", 3, 64, 0 )
		CPanel:NumSlider( "#frame_blend_pp.shutter", "pp_fb_shutter", 0, 0.99 )

	end

} )
