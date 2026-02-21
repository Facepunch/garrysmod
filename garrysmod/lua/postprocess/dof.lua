
CreateClientConVar( "pp_dof", "0", false, false )

local pp_dof_initlength = CreateClientConVar( "pp_dof_initlength", "256", true, false )
local pp_dof_spacing = CreateClientConVar( "pp_dof_spacing", "512", true, false )

-- Global table to hold the DoF effect
DOF_Ents = {}
DOF_SPACING = 0
DOF_OFFSET = 0

local NUM_DOF_NODES = 16

function DOF_Kill()

	for i = #DOF_Ents, 1, -1 do

		local v = DOF_Ents[i]

		if ( IsValid( v ) ) then
			v:Remove()
		end

		DOF_Ents[i] = nil

	end

	DOFModeHack( false )

end

function DOF_Start()

	DOF_Kill()

	for i = 0, NUM_DOF_NODES do

		local effectdata = EffectData()
		effectdata:SetScale( i )
		util.Effect( "dof_node", effectdata )

	end

	DOFModeHack( true )

end

hook.Add( "Think", "DOFThink", function()

	DOF_SPACING = pp_dof_spacing:GetFloat()
	DOF_OFFSET = pp_dof_initlength:GetFloat()

end )

cvars.AddChangeCallback( "pp_dof", function( name, oldvalue, newvalue )

	if ( !GAMEMODE:PostProcessPermitted( "dof" ) ) then return end

	if ( newvalue != "0" ) then
		DOF_Start()
	else
		DOF_Kill()
	end

end )


list.Set( "PostProcess", "#dof_pp", {

	icon = "gui/postprocess/dof.png",
	convar = "pp_dof",
	category = "#effects_pp",

	cpanel = function( CPanel )

		CPanel:Help( "#dof_pp.desc" )
		CPanel:CheckBox( "#dof_pp.enable", "pp_dof" )

		CPanel:ToolPresets( "dof", { pp_dof_initlength = "256", pp_dof_spacing = "512" } )

		CPanel:NumSlider( "#dof_pp.spacing", "pp_dof_spacing", 8, 1024 )
		CPanel:NumSlider( "#dof_pp.start_distance", "pp_dof_initlength", 9, 1024 )

	end

} )
