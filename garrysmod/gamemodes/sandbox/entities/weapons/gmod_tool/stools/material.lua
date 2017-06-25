
TOOL.Category = "Render"
TOOL.Name = "#tool.material.name"

TOOL.ClientConVar[ "override" ] = "debug/env_cubemap_model"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

--
-- Duplicator function
--
local function SetMaterial(Player, Entity, Data)

	if (SERVER) then

		--
		-- Make sure this is in the 'allowed' list in multiplayer - to stop people using exploits
		--
		if (not game.SinglePlayer() and not list.Contains( "OverrideMaterials", Data.MaterialOverride) and Data.MaterialOverride ~= "") then return end

		Entity:SetMaterial(Data.MaterialOverride)
		duplicator.StoreEntityModifier(Entity, "material", Data)
	end

	return true

end
duplicator.RegisterEntityModifier("material", SetMaterial)

-- Left click applies the current material
function TOOL:LeftClick(trace)

	local ent = trace.Entity
	if (IsValid( ent.AttachedEntity)) then ent = ent.AttachedEntity end
	if (not IsValid( ent)) then return false end -- The entity is valid and isn't worldspawn
	if (CLIENT) then return true end

	local mat = self:GetClientInfo("override")
	SetMaterial(self:GetOwner(), ent, { MaterialOverride = mat })
	return true

end

-- Right click copies the material
function TOOL:RightClick(trace)

	local ent = trace.Entity
	if (IsValid( ent.AttachedEntity)) then ent = ent.AttachedEntity end
	if (not IsValid( ent)) then return false end -- The entity is valid and isn't worldspawn
	if (CLIENT) then return true end

	self:GetOwner():ConCommand( "material_override " .. ent:GetMaterial())

	return true

end

-- Reload reverts the material
function TOOL:Reload(trace)

	local ent = trace.Entity
	if (IsValid( ent.AttachedEntity)) then ent = ent.AttachedEntity end
	if (not IsValid( ent)) then return false end -- The entity is valid and isn't worldspawn
	if (CLIENT) then return true end

	SetMaterial(self:GetOwner(), ent, { MaterialOverride = "" })
	return true

end

if (IsMounted( "tf")) then
	list.Add("OverrideMaterials", "models/player/shared/gold_player")
	list.Add("OverrideMaterials", "models/player/shared/ice_player")
end

list.Add("OverrideMaterials", "models/wireframe")
list.Add("OverrideMaterials", "debug/env_cubemap_model")
list.Add("OverrideMaterials", "models/shadertest/shader3")
list.Add("OverrideMaterials", "models/shadertest/shader4")
list.Add("OverrideMaterials", "models/shadertest/shader5")
list.Add("OverrideMaterials", "models/shiny")
list.Add("OverrideMaterials", "models/debug/debugwhite")
list.Add("OverrideMaterials", "Models/effects/comball_sphere")
list.Add("OverrideMaterials", "Models/effects/comball_tape")
list.Add("OverrideMaterials", "Models/effects/splodearc_sheet")
list.Add("OverrideMaterials", "Models/effects/vol_light001")
list.Add("OverrideMaterials", "models/props_combine/stasisshield_sheet")
list.Add("OverrideMaterials", "models/props_combine/portalball001_sheet")
list.Add("OverrideMaterials", "models/props_combine/com_shield001a")
list.Add("OverrideMaterials", "models/props_c17/frostedglass_01a")
list.Add("OverrideMaterials", "models/props_lab/Tank_Glass001")
list.Add("OverrideMaterials", "models/props_combine/tprings_globe")
list.Add("OverrideMaterials", "models/rendertarget")
list.Add("OverrideMaterials", "models/screenspace")
list.Add("OverrideMaterials", "brick/brick_model")
list.Add("OverrideMaterials", "models/props_pipes/GutterMetal01a")
list.Add("OverrideMaterials", "models/props_pipes/Pipesystem01a_skin3")
list.Add("OverrideMaterials", "models/props_wasteland/wood_fence01a")
list.Add("OverrideMaterials", "models/props_foliage/tree_deciduous_01a_trunk")
list.Add("OverrideMaterials", "models/props_c17/FurnitureFabric003a")
list.Add("OverrideMaterials", "models/props_c17/FurnitureMetal001a")
list.Add("OverrideMaterials", "models/props_c17/paper01")
list.Add("OverrideMaterials", "models/flesh")

-- phx
list.Add("OverrideMaterials", "phoenix_storms/metalset_1-2")
list.Add("OverrideMaterials", "phoenix_storms/metalfloor_2-3")
list.Add("OverrideMaterials", "phoenix_storms/plastic")
list.Add("OverrideMaterials", "phoenix_storms/wood")
list.Add("OverrideMaterials", "phoenix_storms/bluemetal")
list.Add("OverrideMaterials", "phoenix_storms/cube")
list.Add("OverrideMaterials", "phoenix_storms/dome")
list.Add("OverrideMaterials", "phoenix_storms/gear")
list.Add("OverrideMaterials", "phoenix_storms/stripes")
list.Add("OverrideMaterials", "phoenix_storms/wire/pcb_green")
list.Add("OverrideMaterials", "phoenix_storms/wire/pcb_red")
list.Add("OverrideMaterials", "phoenix_storms/wire/pcb_blue")

list.Add("OverrideMaterials", "hunter/myplastic")
list.Add("OverrideMaterials", "models/XQM/LightLinesRed_tool")

function TOOL.BuildCPanel(CPanel)

	CPanel:AddControl("Header", { Description = "#tool.material.help" })

	CPanel:MatSelect("material_override", list.Get( "OverrideMaterials"), true, 0.25, 0.25)

end
