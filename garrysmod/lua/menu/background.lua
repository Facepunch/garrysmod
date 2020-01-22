
local MenuGradient = Material( "html/img/gradient.png", "nocull smooth" )

local Images = {}

local Active = nil
local Outgoing = nil

local function Think( tbl )

	tbl.Angle = tbl.Angle + ( tbl.AngleVel * FrameTime() )
	tbl.Size = tbl.Size + ( ( tbl.SizeVel / tbl.Size) * FrameTime() )

	if ( tbl.AlphaVel ) then
		tbl.Alpha = tbl.Alpha - tbl.AlphaVel * FrameTime()
	end

	if ( tbl.DieTime > 0 ) then
		tbl.DieTime = tbl.DieTime - FrameTime()

		if ( tbl.DieTime <= 0 ) then
			ChangeBackground()
		end
	end

end

local function Render( tbl )

	surface.SetMaterial( tbl.mat )
	surface.SetDrawColor( 255, 255, 255, tbl.Alpha )

	local w = ScrH() * tbl.Size * tbl.Ratio
	local h = ScrH() * tbl.Size

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	surface.DrawTexturedRectRotated( x, y, w, h, tbl.Angle )

end

local function ShouldBackgroundUpdate()

	return !IsInGame() && !IsInLoading()

end

function DrawBackground()

	if ( ShouldBackgroundUpdate() ) then

		if ( Active ) then
			Think( Active )
			Render( Active )
		end

		if ( Outgoing ) then

			Think( Outgoing )
			Render( Outgoing )

		end

	end

	surface.SetMaterial( MenuGradient )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, 1024, ScrH() )

end

function ClearBackgroundImages( img )

	Images = {}

end

function AddBackgroundImage( img )

	table.insert( Images, img )

end

local LastGamemode = "none"

function ChangeBackground( currentgm )

	if ( !ShouldBackgroundUpdate() ) then return end -- Don't try to load new images while in-game or loading

	if ( currentgm && currentgm == LastGamemode ) then return end
	if ( currentgm ) then LastGamemode = currentgm end

	local img = table.Random( Images )

	if ( !img ) then return end

	-- Remove the texture from memory
	-- There's a bit of internal magic going on here
	--[[
	local DoUnload = Outgoing != nil

	if ( Outgoing && Outgoing.Name == img ) then
		DoUnload = false
	end

	if ( Outgoing && Active && Outgoing.Name == Active.Name ) then
		DoUnload = false
	end

	if ( DoUnload ) then
		Outgoing.mat:SetUndefined( "$basetexture" )
	end
	]]

	Outgoing = Active
	if ( Outgoing ) then
		Outgoing.AlphaVel = 255
	end

	local mat = Material( img, "nocull smooth" )
	if ( !mat || mat:IsError() ) then return end

	Active = {
		Ratio = mat:GetInt( "$realwidth" ) / mat:GetInt( "$realheight" ),
		Size = 1,
		Angle = 0,
		AngleVel = -( 5 / 30 ),
		SizeVel = ( 0.3 / 30 ),
		Alpha = 255,
		DieTime = 30,
		mat = mat,
		Name = img
	}

	if ( Active.Ratio < ScrW() / ScrH() ) then

		Active.Size = Active.Size + ( ( ScrW() / ScrH() ) - Active.Ratio )

	end

end
