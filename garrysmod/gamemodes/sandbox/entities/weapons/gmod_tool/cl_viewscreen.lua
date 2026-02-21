
local matScreen = Material( "models/weapons/v_toolgun/screen" )
local txBackground = surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )
local toolmode = GetConVar( "gmod_toolmode" )
local TEX_SIZE = 256

-- GetRenderTarget returns the texture if it exists, or creates it if it doesn't
local RTTexture = GetRenderTarget( "GModToolgunScreen", TEX_SIZE, TEX_SIZE )

surface.CreateFont( "GModToolScreen", {
	font	= "Helvetica",
	size	= 60,
	weight	= 900
} )

local function DrawScrollingText( text, y, texwide )

	local w, h = surface.GetTextSize( text )
	w = w + 64

	y = y - h / 2 -- Center text to y position

	local x = RealTime() * 250 % w * -1

	while ( x < texwide ) do

		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( x + 3, y + 3 )
		surface.DrawText( text )

		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( x, y )
		surface.DrawText( text )

		x = x + w

	end

end

--[[---------------------------------------------------------
	We use this opportunity to draw to the toolmode
		screen's rendertarget texture.
-----------------------------------------------------------]]
function SWEP:RenderScreen()

	-- Set the material of the screen to our render target
	matScreen:SetTexture( "$basetexture", RTTexture )

	-- Set up our view for drawing to the texture
	render.PushRenderTarget( RTTexture )
	cam.Start2D()

		-- Background
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( txBackground )
		surface.DrawTexturedRect( 0, 0, TEX_SIZE, TEX_SIZE )

		-- Give our toolmode the opportunity to override the drawing
		if ( self:GetToolObject() && self:GetToolObject().DrawToolScreen ) then

			self:GetToolObject():DrawToolScreen( TEX_SIZE, TEX_SIZE )

		else

			surface.SetFont( "GModToolScreen" )
			DrawScrollingText( "#tool." .. toolmode:GetString() .. ".name", 104, TEX_SIZE )

		end

	cam.End2D()
	render.PopRenderTarget()

end
