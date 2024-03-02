
local crosshair_sliders = {
	{ title = "Style", cvar = "cl_crosshairstyle", values = { ["0"] = "Half-Life 2", ["1"] = "Dot Image", ["2"] = "Classic" } },
	{ title = "Gap", cvar = "cl_crosshairgap", min = 0, max = 200 },
	{ title = "Size", cvar = "cl_crosshairsize", min = 0, max = 200 },
	{ title = "Thickness", cvar = "cl_crosshairthickness", min = 0, max = 200 },
	{ title = "Dot", cvar = "cl_crosshairdot" },
	{ title = "T-Style", cvar = "cl_crosshair_t" },
	{ title = "Use Alpha", cvar = "cl_crosshairusealpha" },
	{ title = "Quick Info", cvar = "hud_quickinfo" },
	{ title = "Outline", cvar = "cl_crosshair_drawoutline" },
	{ title = "Outline Thickness", cvar = "cl_crosshair_outlinethickness", min = 0.1, max = 3 },
}

local function GetCrosshairColor()
	return Color( GetConVarNumber( "cl_crosshaircolor_r" ),
		GetConVarNumber( "cl_crosshaircolor_g" ),
		GetConVarNumber( "cl_crosshaircolor_b" ),
		GetConVarNumber( "cl_crosshairalpha" )
	)
end

local function DrawCrosshairRect( color, x0, y0, x1, y1, bAdditive )
	if ( GetConVarNumber( "cl_crosshair_drawoutline" ) != 0 ) then
		local flThick = GetConVarNumber( "cl_crosshair_outlinethickness" )
		surface.SetDrawColor( 0, 0, 0, color.a )
		surface.DrawRect( x0 - flThick, y0 - flThick, (x1 + flThick) - x0 + flThick, (y1 + flThick) - y0 + flThick )
	end

	surface.SetDrawColor( color.r, color.g, color.b, color.a )

	if ( bAdditive ) then
		surface.DrawTexturedRect( x0, y0, x1 - x0, y1 - y0 )
	else
		surface.DrawRect( x0, y0, x1 - x0, y1 - y0 )
	end
end

local additiveTex = Material( "vgui/white_additive" )
local function DrawSimpleCrosshairPreview( x, y )
	local color = GetCrosshairColor()

	local bAdditive = GetConVarNumber( "cl_crosshairusealpha" ) == 0
	if ( bAdditive ) then
		surface.SetMaterial( additiveTex )
		color.a = 200
	end

	local iBarSize = math.Round( ScreenScaleH( GetConVarNumber( "cl_crosshairsize" ) ))
	local iBarThickness = math.max( 1, math.Round( ScreenScaleH( GetConVarNumber( "cl_crosshairthickness" ) ) ) )
	local iInnerCrossDist = GetConVarNumber( "cl_crosshairgap" )

	-- draw horizontal crosshair lines
	local iInnerLeft = x - iInnerCrossDist - iBarThickness / 2
	local iInnerRight = iInnerLeft + 2 * iInnerCrossDist + iBarThickness
	local iOuterLeft = iInnerLeft - iBarSize
	local iOuterRight = iInnerRight + iBarSize
	local y0 = y - iBarThickness / 2
	local y1 = y0 + iBarThickness
	DrawCrosshairRect( color, iOuterLeft, y0, iInnerLeft, y1, bAdditive )
	DrawCrosshairRect( color, iInnerRight, y0, iOuterRight, y1, bAdditive )

	-- draw vertical crosshair lines
	local iInnerTop = y - iInnerCrossDist - iBarThickness / 2
	local iInnerBottom = iInnerTop + 2 * iInnerCrossDist + iBarThickness
	local iOuterTop = iInnerTop - iBarSize
	local iOuterBottom = iInnerBottom + iBarSize
	local x0 = x - iBarThickness / 2
	local x1 = x0 + iBarThickness
	if ( GetConVarNumber( "cl_crosshair_t" ) == 0 ) then
		DrawCrosshairRect( color, x0, iOuterTop, x1, iInnerTop, bAdditive )
	end
	DrawCrosshairRect( color, x0, iInnerBottom, x1, iOuterBottom, bAdditive )

	-- draw dot
	if ( GetConVarNumber( "cl_crosshairdot" ) != 0 ) then
		x0 = x - iBarThickness / 2
		x1 = x0 + iBarThickness
		y0 = y - iBarThickness / 2
		y1 = y0 + iBarThickness
		DrawCrosshairRect( color, x0, y0, x1, y1, bAdditive )
	end
end



concommand.Add( "crosshair_setup", function()

	surface.CreateFont( "QuickInfoLarge", {
		font = "HL2cross",
		size = 64,
		additive = false,
	} )

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 600, 480 )
	frame:Center()
	frame:SetTitle( "Default Crosshair Setup" )
	frame:MakePopup()

	local crosshairMat = Material( "gui/crosshair.png" )

	local preview = vgui.Create( "DImage", frame )
	preview:Dock( LEFT )
	preview:DockPadding( 5, 5, 5, 5 )
	preview:SetWide( 320 )
	preview:SetMouseInputEnabled( true )
	preview:SetImage( "gui/crosshair_bg.png" )
	preview.PaintOver = function( p, w, h )
		if ( GetConVarNumber( "cl_crosshairstyle" ) == 0 ) then
			surface.SetFont( "Crosshairs" )
			surface.SetTextColor( 255, 208, 64, 255 )
			local width, height = surface.GetTextSize( "Q" )
			surface.SetTextPos( w / 2 - width / 2, h / 2 - height / 2 )
			surface.DrawText( "Q" )
		elseif ( GetConVarNumber( "cl_crosshairstyle" ) == 1 ) then
			surface.SetDrawColor( GetCrosshairColor() )
			surface.SetMaterial( crosshairMat )
			surface.DrawTexturedRect( w / 2 - 32, h / 2 - 32, 64, 64 )
		elseif ( GetConVarNumber( "cl_crosshairstyle" ) >= 2 ) then
			DrawSimpleCrosshairPreview( w / 2, h / 2 )
		end

		if ( GetConVarNumber( "hud_quickinfo" ) != 0 ) then
			surface.SetFont( "QuickInfoLarge" )
			surface.SetTextColor( 255, 208, 64, 200 )
			local width, height = surface.GetTextSize( "{ ]" )
			surface.SetTextPos( w / 2 - width / 2, h / 2 - height / 2 )
			surface.DrawText( "{ ]" )
		end
	end

	local previewBtns = vgui.Create( "Panel", preview )
	previewBtns:Dock( TOP )

	local img1btn = vgui.Create( "DButton", previewBtns )
	img1btn:Dock( LEFT )
	img1btn:SetWide( 320 / 2 )
	img1btn:SetText( "Preview 1" )
	img1btn.DoClick = function() preview:SetImage( "gui/crosshair_bg.png" ) end
	local img2btn = vgui.Create( "DButton", previewBtns )
	img2btn:SetText( "Preview 2" )
	img2btn.DoClick = function() preview:SetImage( "gui/crosshair_bg2.png" ) end
	img2btn:Dock( FILL )

	local settings = vgui.Create( "Panel", frame )
	settings:Dock( FILL )
	settings:DockPadding( 5, 0, 0, 0 )

	local function HideUselessStuff( style )
		style = style or GetConVarNumber( "cl_crosshairstyle" )

		for i, pnl in pairs( settings:GetChildren() ) do
			if ( pnl.ClassName == "DColorMixer" and style == 0 ) then
				pnl:SetVisible( false )
			elseif ( pnl.ClassName == "DNumSlider" and style != 2 ) then
				pnl:SetVisible( false )
			elseif ( pnl.ClassName == "DCheckBoxLabel" ) then
				pnl:SetVisible( pnl.Button.m_strConVar == "hud_quickinfo" or style == 2 )
			else
				pnl:SetVisible( true )
			end
		end
		settings:InvalidateLayout()
	end

	for i, str in pairs( crosshair_sliders ) do
		local setting = nil
		if ( str.min ) then
			setting = vgui.Create( "DNumSlider", settings )
			setting:SetMinMax( str.min, str.max )
			setting:SetDefaultValue( GetConVar( str.cvar ):GetDefault() )
			setting:SetDecimals( 0 )
		elseif ( str.values ) then
			setting = vgui.Create( "DComboBox", settings )
			setting.OnSelect = function( pnl, indx, val, data ) pnl:ConVarChanged( data ) HideUselessStuff( tonumber( data ) ) end
			for id, title in pairs( str.values ) do setting:AddChoice( title, id ) end
		else
			setting = vgui.Create( "DCheckBoxLabel", settings )
		end
		setting:Dock( TOP )
		setting:SetText( str.title )
		setting:SetConVar( str.cvar )
	end

	local mixer =  vgui.Create( "DColorMixer", settings )
	mixer:Dock( TOP )
	mixer:SetTall( 220 )
	mixer:SetColor( GetCrosshairColor() )
	mixer:SetConVarR( "cl_crosshaircolor_r" )
	mixer:SetConVarG( "cl_crosshaircolor_g" )
	mixer:SetConVarB( "cl_crosshaircolor_b" )
	mixer:SetConVarA( "cl_crosshairalpha" )

	HideUselessStuff()

	local resetCrosshair = vgui.Create( "DButton", preview )
	resetCrosshair.DoClick = function()
		for i, str in pairs( crosshair_sliders ) do
			local def = GetConVar( str.cvar ):GetDefault()
			RunConsoleCommand( str.cvar, def )
		end
		mixer:SetColor( color_white ) -- hack
		HideUselessStuff()
	end
	resetCrosshair:SetText( "Reset Crosshair" )
	resetCrosshair:Dock( BOTTOM )

end )
