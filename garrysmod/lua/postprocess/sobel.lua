
local SobelMaterial = Material( "pp/sobel" )
SobelMaterial:SetTexture( "$fbtexture", render.GetScreenEffectTexture() );

-- convars
local pp_sobel_threshold = CreateClientConVar( "pp_sobel_threshold", "0.11", false, false );
local pp_sobel = CreateClientConVar( "pp_sobel", "0", false, false );

--[[------------------------------------
	DrawSobel()
--------------------------------------]]
function DrawSobel( threshold )

	render.UpdateScreenEffectTexture();

	-- update threshold value
	SobelMaterial:SetFloat( "$threshold", threshold );

	render.SetMaterial( SobelMaterial );
	render.DrawScreenQuad();
	
end


--[[------------------------------------
	DrawInternal()
--------------------------------------]]
local function DrawInternal()

	if ( !pp_sobel:GetBool() ) then return; end
	if ( !GAMEMODE:PostProcessPermitted( "sobel" ) ) then return; end

	DrawSobel( pp_sobel_threshold:GetFloat() );

end
hook.Add( "RenderScreenspaceEffects", "RenderSobel", DrawInternal );


list.Set( "PostProcess", "Sobel",
{
	icon		= "gui/postprocess/sobel.png",
	
	convar		= "pp_sobel",
	
	category	= "Shaders",
	
	cpanel		= function( CPanel )

		CPanel:AddControl( "Header", { Text = "#Sobel", Description = "" }  )
		CPanel:AddControl( "CheckBox", { Label = "#Enable", Command = "pp_sobel" }  )
		
		CPanel:AddControl( "Slider", {
			Label = "#Threshold",
			Command = "pp_sobel_threshold",
			Type = "Float",
			Min = "0",
			Max = "1"
		} );
		
	end,
	
})
