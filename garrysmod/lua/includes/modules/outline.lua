OUTLINE_MODE_BOTH		= 0		-- Render always
OUTLINE_MODE_NOTVISIBLE	= 1
OUTLINE_MODE_VISIBLE	= 2

OUTLINE_RENDERTYPE_BEFORE_VM	= 0		-- Render before drawing the view model
OUTLINE_RENDERTYPE_BEFORE_EF	= 1		-- Render before drawing all effects (after drawing the viewmodel)
OUTLINE_RENDERTYPE_AFTER_EF		= 2		-- Render after drawing all effects

local istable			= istable
local render			= render
local Material			= Material
local CreateMaterial	= CreateMaterial
local hook				= hook
local cam				= cam
local ScrW				= ScrW
local ScrH				= ScrH
local IsValid			= IsValid
local surface			= surface

module( "outline", package.seeall )

local List, ListSize		= {}, 0
local RenderEnt				= NULL
local RenderType			= OUTLINE_RENDERTYPE_AFTER_EF
local OutlineThickness		= 1

local StoreTexture			= render.GetScreenEffectTexture( 0 )
local DrawTexture			= render.GetScreenEffectTexture( 1 )

local OutlineMatSettings	= {
	[ "$basetexture" ]	= DrawTexture:GetName(),
	[ "$ignorez" ]		= 1,
	[ "$alphatest" ]	= 1
}

local CopyMat				= Material( "pp/copy" )
local OutlineMat			= CreateMaterial( "outline", "UnlitGeneric", OutlineMatSettings )

local ENTS, COLOR, MODE		= 1, 2, 3

function Add( ents, color, mode )
	
	if ( ListSize >= 255 ) then return end				--Maximum 255 reference values
	if ( !istable( ents ) ) then ents = { ents } end	--Support for passing Entity as first argument
	if ( ents[ 1 ] == nil ) then return end				--Do not pass empty tables
	
	if (
		mode != OUTLINE_MODE_BOTH &&
		mode != OUTLINE_MODE_NOTVISIBLE &&
		mode != OUTLINE_MODE_VISIBLE
	) then
		mode = OUTLINE_MODE_BOTH
	end
	
	local data = {
		[ ENTS ] = ents,
		[ COLOR ] = color,
		[ MODE ] = mode
	}
	
	ListSize = ListSize + 1
	List[ ListSize ] = data
	
end

function RenderedEntity()
	
	return RenderEnt
	
end

function SetRenderType( render_type )
	
	if (
		render_type != OUTLINE_RENDERTYPE_BEFORE_VM &&
		render_type != OUTLINE_RENDERTYPE_BEFORE_EF &&
		render_type != OUTLINE_RENDERTYPE_AFTER_EF
	) then
		return
	end

	local old_type = RenderType
	RenderType = render_type
	
	return old_type
	
end

function GetRenderType()
	
	return RenderType
	
end

function SetDoubleThickness( thickness )

	local old_thickness = OutlineThickness == 2
	OutlineThickness = thickness && 2 || 1
	
	return old_thickness
	
end

function IsDoubleThickness()
	
	return OutlineThickness == 2
	
end

local function Render()
	
	local scene = render.GetRenderTarget()
	render.CopyRenderTargetToTexture( StoreTexture )
	
	local w, h = ScrW(), ScrH()
	
	render.ClearStencil()
	
	render.SetStencilEnable( true )
		render.SuppressEngineLighting( true )
		
		render.SetStencilWriteMask( 0xFF )
		render.SetStencilTestMask( 0xFF )
		
		render.SetStencilCompareFunction( STENCIL_GREATER )
		render.SetStencilFailOperation( STENCIL_KEEP )
		
		cam.Start3D()
			render.SetBlend(1)
			
			for i = 1, ListSize do
				
				local reference = 0xFF - ( i - 1 )
				
				local data = List[ i ]
				local mode = data[ MODE ]
				local ents = data[ ENTS ]
				
				render.SetStencilReferenceValue( reference )
				
				if ( mode == OUTLINE_MODE_BOTH || mode == OUTLINE_MODE_VISIBLE ) then
					
					render.SetStencilZFailOperation( mode == OUTLINE_MODE_BOTH && STENCIL_REPLACE || STENCIL_KEEP )
					render.SetStencilPassOperation( STENCIL_REPLACE )
					
					for j = 1, #ents do
						
						local ent = ents[ j ]
						
						if ( IsValid( ent ) ) then
							
							RenderEnt = ent
							ent:DrawModel()
							
						end
						
					end
					
				elseif ( mode == OUTLINE_MODE_NOTVISIBLE ) then
					
					render.SetStencilZFailOperation( STENCIL_REPLACE )
					render.SetStencilPassOperation( STENCIL_KEEP )
					
					for j = 1, #ents do
						
						local ent = ents[ j ]
						
						if ( IsValid( ent ) ) then
							
							RenderEnt = ent
							ent:DrawModel()
							
						end
						
					end
					
					render.SetStencilCompareFunction( STENCIL_EQUAL )
					render.SetStencilZFailOperation( STENCIL_KEEP )
					render.SetStencilPassOperation( STENCIL_ZERO )
					
					for j = 1, #ents do
						
						local ent = ents[ j ]
						
						if ( IsValid( ent ) ) then
							
							RenderEnt = ent
							ent:DrawModel()
							
						end
						
					end
					
					render.SetStencilCompareFunction( STENCIL_GREATER )
					
				end
				
			end
			
			RenderEnt = NULL
			
			render.SetBlend(1)
		cam.End3D()
		
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		render.SetStencilZFailOperation( STENCIL_KEEP )
		render.SetStencilPassOperation( STENCIL_KEEP )
		
		render.Clear( 0, 0, 0, 0, false, false )
		
		cam.Start2D()
			
			for i = 1, ListSize do
				
				local reference = 0xFF - ( i - 1 )
				
				render.SetStencilReferenceValue( reference )
				
				surface.SetDrawColor( List[ i ][ COLOR ] )
				surface.DrawRect( 0, 0, w, h )
				
			end
			
		cam.End2D()
		
		render.SuppressEngineLighting( false )
	render.SetStencilEnable( false )
	
	render.CopyRenderTargetToTexture( DrawTexture )
	
	render.SetRenderTarget( scene )
	CopyMat:SetTexture( "$basetexture", StoreTexture )
	render.SetMaterial( CopyMat )
	render.DrawScreenQuad()
	
	render.SetStencilEnable( true )
	
		render.SetStencilReferenceValue( 0 )
		
		render.SetStencilCompareFunction( STENCIL_EQUAL )
		
		OutlineMat:SetTexture( "$basetexture", DrawTexture )
		render.SetMaterial( OutlineMat )
		
		render.DrawScreenQuadEx( -OutlineThickness, -OutlineThickness, w ,h )
		render.DrawScreenQuadEx( -OutlineThickness, 0, w, h )
		render.DrawScreenQuadEx( -OutlineThickness, OutlineThickness, w, h )
		render.DrawScreenQuadEx( 0, -OutlineThickness, w, h )
		render.DrawScreenQuadEx( 0, OutlineThickness, w, h )
		render.DrawScreenQuadEx( OutlineThickness, -OutlineThickness, w, h )
		render.DrawScreenQuadEx( OutlineThickness, 0, w, h )
		render.DrawScreenQuadEx( OutlineThickness, OutlineThickness, w, h )
		
	render.SetStencilEnable( false )
	
	render.ClearDepth()		-- Allows to render view model and other stuff in front of outline
end

local function RenderOutlines()
	
	hook.Run( "SetupOutlines", Add )
	
	if ( ListSize == 0 ) then return end
	
	Render()
	
	List, ListSize = {}, 0
	
end

hook.Add( "PreDrawViewModels", "RenderOutlines", function()
	
	if ( RenderType == OUTLINE_RENDERTYPE_BEFORE_VM ) then
		
		RenderOutlines()
		
	end
	
end )

hook.Add( "PreDrawEffects", "RenderOutlines", function()
	
	if ( RenderType == OUTLINE_RENDERTYPE_BEFORE_EF ) then
		
		RenderOutlines()
		
	end
	
end )

hook.Add( "PostDrawEffects", "RenderOutlines", function()
	
	if ( RenderType == OUTLINE_RENDERTYPE_AFTER_EF ) then
		
		RenderOutlines()
		
	end
	
end )
