
local MenuGradient = Material( "html/img/gradient.png", "nocull smooth" )

local FreeMaterial = nil

local function CreateBackgroundMaterial( path )
	if ( FreeMaterial ) then
		FreeMaterial:SetDynamicImage( path )

		local ret = FreeMaterial
		FreeMaterial = nil
		return ret
	end

	return DynamicMaterial( path, "0100010" ) -- nocull smooth
end

local function FreeBackgroundMaterial( mat )
	if ( FreeMaterial ) then
		MsgN( "Warning! Menu shouldn't be releasing a material when one is already queued for use!" )
	end

	FreeMaterial = mat
end

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

	if ( !tbl.mat ) then return end

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
	if ( !img ) then
		print( "No main menu backgrounds found!" )
		return
	end

	-- We just rolled the same image, no thank you, reroll
	if ( Active && img == Active.Name && #Images > 1 ) then
		ChangeBackground()
		return
	end

	if ( Outgoing ) then
		FreeBackgroundMaterial( Outgoing.mat )
		Outgoing.mat = nil
	end

	Outgoing = Active
	if ( Outgoing ) then
		Outgoing.AlphaVel = 255
	end

	local mat = CreateBackgroundMaterial( img )
	if ( !mat || mat:IsError() ) then
		print( "Failed to create material for background ", img )
		table.RemoveByValue( Images, img )
		ChangeBackground()
		return
	end

	Active = {
		Ratio = mat:GetInt( "$realwidth" ) / mat:GetInt( "$realheight" ),
		Size = 1,
		Angle = 0,
		AngleVel = -( 5 / 30 ),
		SizeVel = 0.3 / 30,
		Alpha = 255,
		DieTime = 30,
		mat = mat,
		Name = img
	}

	if ( Active.Ratio < ScrW() / ScrH() ) then

		Active.Size = Active.Size + ( ( ScrW() / ScrH() ) - Active.Ratio )

	end

end
