
if ( !render ) then return end

--[[---------------------------------------------------------
  Short aliases for stencil constants
-----------------------------------------------------------]]

STENCIL_NEVER = STENCILCOMPARISONFUNCTION_NEVER
STENCIL_LESS = STENCILCOMPARISONFUNCTION_LESS
STENCIL_EQUAL = STENCILCOMPARISONFUNCTION_EQUAL
STENCIL_LESSEQUAL = STENCILCOMPARISONFUNCTION_LESSEQUAL
STENCIL_GREATER = STENCILCOMPARISONFUNCTION_GREATER
STENCIL_NOTEQUAL = STENCILCOMPARISONFUNCTION_NOTEQUAL
STENCIL_GREATEREQUAL = STENCILCOMPARISONFUNCTION_GREATEREQUAL
STENCIL_ALWAYS = STENCILCOMPARISONFUNCTION_ALWAYS

STENCIL_KEEP = STENCILOPERATION_KEEP
STENCIL_ZERO = STENCILOPERATION_ZERO
STENCIL_REPLACE = STENCILOPERATION_REPLACE
STENCIL_INCRSAT = STENCILOPERATION_INCRSAT
STENCIL_DECRSAT = STENCILOPERATION_DECRSAT
STENCIL_INVERT = STENCILOPERATION_INVERT
STENCIL_INCR = STENCILOPERATION_INCR
STENCIL_DECR = STENCILOPERATION_DECR

--[[---------------------------------------------------------
   Name:	ClearRenderTarget
   Params: 	<texture> <color>
   Desc:	Clear a render target
-----------------------------------------------------------]]
function render.ClearRenderTarget( rt, color )

	local OldRT = render.GetRenderTarget();
		render.SetRenderTarget( rt )
		render.Clear( color.r, color.g, color.b, color.a )
	render.SetRenderTarget( OldRT )

end


--[[---------------------------------------------------------
   Name:	SupportsHDR
   Params:
   Desc:	Return true if the client supports HDR
-----------------------------------------------------------]]
function render.SupportsHDR( )

	if ( render.GetDXLevel() < 80 ) then return false end

	return true

end


--[[---------------------------------------------------------
   Name:	CopyTexture
   Params: 	<texture from> <texture to>
   Desc:	Copy the contents of one texture to another
-----------------------------------------------------------]]
function render.CopyTexture( from, to )

	local OldRT = render.GetRenderTarget();

		render.SetRenderTarget( from )
		render.CopyRenderTargetToTexture( to )

	render.SetRenderTarget( OldRT )

end

local matColor = Material( "color" )

function render.SetColorMaterial()
	render.SetMaterial( matColor )
end

local matColorIgnoreZ = Material( "color_ignorez" )

function render.SetColorMaterialIgnoreZ()
	render.SetMaterial( matColorIgnoreZ )
end

local mat_BlurX			= Material( "pp/blurx" )
local mat_BlurY			= Material( "pp/blury" )
local tex_Bloom1		= render.GetBloomTex1()

function render.BlurRenderTarget( rt, sizex, sizey, passes )

	mat_BlurX:SetTexture( "$basetexture", rt )
	mat_BlurY:SetTexture( "$basetexture", tex_Bloom1 )
	mat_BlurX:SetFloat( "$size", sizex )
	mat_BlurY:SetFloat( "$size", sizey )

	for i=1, passes+1 do

		render.SetRenderTarget( tex_Bloom1 )
		render.SetMaterial( mat_BlurX )
		render.DrawScreenQuad()

		render.SetRenderTarget( rt )
		render.SetMaterial( mat_BlurY )
		render.DrawScreenQuad()

	end

end

function cam.Start2D()

	return cam.Start( { type = '2D' } )

end

function cam.Start3D( pos, ang, fov, x, y, w, h, znear, zfar )

	local tab = {}

	tab.type = '3D';
	tab.origin = pos
	tab.angles = ang

	if ( fov != nil ) then tab.fov = fov end

	if ( x != nil && y != nil && w != nil && h != nil ) then

		tab.x			= x
		tab.y			= y
		tab.w			= w
		tab.h			= h
		tab.aspect		= ( w / h )

	end

	if ( znear != nil && zfar != nil ) then

		tab.znear	= znear
		tab.zfar	= zfar

	end

	return cam.Start( tab )

end

local matFSB = Material( "pp/motionblur" )

function render.DrawTextureToScreen( tex )

	matFSB:SetFloat( "$alpha", 1.0 )
	matFSB:SetTexture( "$basetexture", tex )

	render.SetMaterial( matFSB )
	render.DrawScreenQuad()

end

function render.DrawTextureToScreenRect( tex, x, y, w, h )

	matFSB:SetFloat( "$alpha", 1.0 )
	matFSB:SetTexture( "$basetexture", tex )

	render.SetMaterial( matFSB )
	render.DrawScreenQuadEx( x, y, w, h )

end


--
-- This isn't very fast. If you're doing something every frame you should find a way to
-- cache a ClientsideModel and keep it around! This is fine for rendering to a render
-- target once - or something.
--

function render.Model( tbl, ent )

	local inent = ent

	if ( ent == nil ) then
		ent = ClientsideModel( tbl.model or "error.mdl", RENDERGROUP_OTHER )
	end

	if ( !IsValid( ent ) ) then return end

	ent:SetModel( tbl.model or "error.mdl" )
	ent:SetNoDraw( true )

	ent:SetPos( tbl.pos or vector_origin )
	ent:SetAngles( tbl.angle or angle_zero )
	ent:DrawModel()

	--
	-- If we created the model, then remove it!
	--
	if ( inent != ent ) then
		ent:Remove()
	end

end
