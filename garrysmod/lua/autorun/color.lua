local tab = {
 [ "$pp_colour_brightness" ] = 0,
 [ "$pp_colour_contrast" ] = 1.4,
 [ "$pp_colour_colour" ] = 1.5,
}

hook.Add( "RenderScreenspaceEffects", "color_modify_example", function()

 DrawColorModify( tab )

end )