
CreateClientConVar( "pp_dof", "0", false, false )	
local pp_dof_initlength = CreateClientConVar( "pp_dof_initlength", "256", false, false )
local pp_dof_spacing	= CreateClientConVar( "pp_dof_spacing", "512", false, false )

-- Global table to hold the DoF effect
DOF_Ents 		= {}
DOF_SPACING 	= 0
DOF_OFFSET 		= 0

local NUM_DOF_NODES = 16

function DOF_Kill( )

	for k, v in pairs(DOF_Ents) do
	
		if (v:IsValid()) then
			v:Remove()
		end
	
	end

	DOFModeHack( false )
	
end


function DOF_Start()

	DOF_Kill()
	
	for i=0, NUM_DOF_NODES do
		
		local effectdata = EffectData()
			effectdata:SetScale( i )
		util.Effect( "dof_node", effectdata )
	
	end
	
	DOFModeHack( true )

end


local function DOF_Think( )

	DOF_SPACING		= pp_dof_spacing:GetFloat()
	DOF_OFFSET		= pp_dof_initlength:GetFloat()

end

hook.Add( "Think", "DOFThink", DOF_Think )


local function OnChange( name, oldvalue, newvalue )

	if ( !GAMEMODE:PostProcessPermitted( "dof" ) ) then	return end

	if ( newvalue != "0" ) then
		DOF_Start()
	else
		DOF_Kill()
	end

end

cvars.AddChangeCallback( "pp_dof", OnChange )


list.Set( "PostProcess", "Depth Of Field",
{
	icon		= "gui/postprocess/dof.png",
	
	convar		= "pp_dof",
	
	category	= "Effects",
	
	cpanel		= function( CPanel )

		CPanel:AddControl( "Header", { Text = "#Depth_Of_Field", Description = "#Depth_Of_Field_Information" }  )
		CPanel:AddControl( "CheckBox", { Label = "#Depth_Of_Field_Toggle", Command = "pp_dof" }  )
			
		CPanel:AddControl( "Slider", { Label = "#Depth_Of_Field_spacing", Command = "pp_dof_spacing", Type = "Float", Min = "8", Max = "1024" }  )	
		CPanel:AddControl( "Slider", { Label = "#Depth_Of_Field_start_distance", Command = "pp_dof_initlength", Type = "Float", Min = "9", Max = "1024" }  )	

	end,
	
})