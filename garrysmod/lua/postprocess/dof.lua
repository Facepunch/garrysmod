
CreateClientConVar( "pp_dof", "0", false, false )

local pp_dof_initlength = CreateClientConVar( "pp_dof_initlength", "256", true, false )
local pp_dof_spacing = CreateClientConVar( "pp_dof_spacing", "512", true, false )

-- Global table to hold the DoF effect
DOF_Ents = {}
DOF_SPACING = 0
DOF_OFFSET = 0

local NUM_DOF_NODES = 16

function DOF_Kill()

	for k, v in pairs( DOF_Ents ) do

		if ( IsValid( v ) ) then
			v:Remove()
		end

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

		CPanel:AddControl( "Header", { Description = "#dof_pp.desc" } )
		CPanel:AddControl( "CheckBox", { Label = "#dof_pp.enable", Command = "pp_dof" } )

		local params = { Options = {}, CVars = {}, MenuButton = "1", Folder = "dof" }
		params.Options[ "#preset.default" ] = { pp_dof_initlength = "256", pp_dof_spacing = "512" }
		params.CVars = table.GetKeys( params.Options[ "#preset.default" ] )
		CPanel:AddControl( "ComboBox", params )

		CPanel:AddControl( "Slider", { Label = "#dof_pp.spacing", Command = "pp_dof_spacing", Type = "Float", Min = "8", Max = "1024" } )
		CPanel:AddControl( "Slider", { Label = "#dof_pp.start_distance", Command = "pp_dof_initlength", Type = "Float", Min = "9", Max = "1024" } )

	end

} )
