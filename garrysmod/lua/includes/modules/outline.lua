OUTLINE_MODE_BOTH,OUTLINE_MODE_NOTVISIBLE,OUTLINE_MODE_VISIBLE = 0,1,2

module("outline",package.seeall)

local List,ListSize = {},0
local RenderEnt = NULL

local CopyMat		= Material("pp/copy")
local OutlineMat	= CreateMaterial("OutlineMat","UnlitGeneric",{["$ignorez"] = 1,["$alphatest"] = 1})
local StoreTexture	= render.GetScreenEffectTexture(0)
local DrawTexture	= render.GetScreenEffectTexture(1)

local ENTS,COLOR,MODE = 1,2,3

function Add(ents,color,mode)
	if ListSize>=255 then return end		--Maximum 255 reference values
	if !istable(ents) then ents = {ents} end	--Support for passing Entity as first argument
	if ents[1]==nil then return end			--Do not pass empty tables
	
	table.insert(List,{
		[ENTS] = ents,
		[COLOR] = color,
		[MODE] = mode or OUTLINE_MODE_BOTH
	})
	
	ListSize = ListSize+1
end

function RenderedEntity()
	return RenderEnt
end

local function Render()
	local scene = render.GetRenderTarget()
	render.CopyRenderTargetToTexture(StoreTexture)
	
	local w,h = ScrW(),ScrH()
	
	render.Clear(0,0,0,0,true,true)

	render.SetStencilEnable(true)
		cam.IgnoreZ(true)
		render.SuppressEngineLighting(true)
	
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_REPLACE)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		
		cam.Start3D()
			for k=1,ListSize do
				local v = List[k]
				local mode = v[MODE]
				
				render.SetStencilReferenceValue(k)
				
				local ents = v[ENTS]
				local entssize = #ents		
		
				for k2=1,entssize do
					local v2 = ents[k2]
					
					if !IsValid(v2) then continue end
					if mode==OUTLINE_MODE_NOTVISIBLE and LocalPlayer():IsLineOfSightClear(v2) or mode==OUTLINE_MODE_VISIBLE and !LocalPlayer():IsLineOfSightClear(v2) then continue end
					
					RenderEnt = v2
					v2:DrawModel()
					RenderEnt = NULL
				end
			end
		cam.End3D()
		
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		
		cam.Start2D()
			for i=1,ListSize do
				render.SetStencilReferenceValue(i)
				
				surface.SetDrawColor(List[i][COLOR])
				surface.DrawRect(0,0,w,h)
			end
		cam.End2D()
		
		render.SuppressEngineLighting(false)
		cam.IgnoreZ(false)
	render.SetStencilEnable(false)
	
	render.CopyRenderTargetToTexture(DrawTexture)
	
	render.SetRenderTarget(scene)
	CopyMat:SetTexture("$basetexture",StoreTexture)
	render.SetMaterial(CopyMat)
	render.DrawScreenQuad()
	
	render.SetStencilEnable(true)
		render.SetStencilReferenceValue(0)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		
		OutlineMat:SetTexture("$basetexture",DrawTexture)
		render.SetMaterial(OutlineMat)
		
		render.DrawScreenQuadEx(-1,-1,w,h)
		render.DrawScreenQuadEx(-1,0,w,h)
		render.DrawScreenQuadEx(-1,1,w,h)
		render.DrawScreenQuadEx(0,-1,w,h)
		render.DrawScreenQuadEx(0,1,w,h)
		render.DrawScreenQuadEx(1,1,w,h)
		render.DrawScreenQuadEx(1,0,w,h)
		render.DrawScreenQuadEx(1,1,w,h)
	
	render.SetStencilEnable(false)
end

hook.Add("PostDrawEffects","RenderOutlines",function()
	hook.Run("PreDrawOutlines")
	
	if ListSize==0 then return end
	
	Render()
	
	List,ListSize = {},0
end)
