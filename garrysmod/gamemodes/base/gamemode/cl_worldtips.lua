
surface.CreateFont( "GModWorldtip",
{
	font   = "Helvetica",
	size   = 20,
	weight = 700
})

local cl_drawworldtooltips = CreateConVar( "cl_drawworldtooltips", "1", FCVAR_ARCHIVE )

local TipColor     = Color( 250, 250, 200, 255 )
local TipTextColor = Color( 0, 0, 0, 255 )


/*
	Old func - deprecated
*/
function AddWorldTip( _, text, _, pos, ent )

	worldtip.AddFrame( "OldWorldTip", IsValid( ent ) && ent || pos, text )

end

local padding = 10
local offset  = 50
local function DrawWorldTip( tip )

	if ( !tip.text ) then return end

	if ( IsValid( tip.ent ) ) then
		if ( tip.offset ) then

			local pos = Vector( 0, 0, 0 )
			pos[tip.axis] = tip.offset

			tip.pos = tip.ent:LocalToWorld( pos )

		else
			tip.pos = tip.ent:GetPos()
		end
	end

	local pos = tip.pos:ToScreen()

	if ( !pos.visible ) then return end

	local bgcol = tip.bcol || TipColor
	local fgcol = tip.tcol || TipTextColor

	local x = 0
	local y = 0

	surface.SetFont( "GModWorldtip" )
	local w, h = surface.GetTextSize( tip.text )

	x = pos.x - w
	y = pos.y - h

	x = x - offset
	y = y - offset

	draw.RoundedBox( 8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, color_black )

	local verts = {}
	verts[1] = { x=x+w/1.5-2, y=y+h+2 }
	verts[2] = { x=x+w+2, y=y+h/2-1 }
	verts[3] = { x=pos.x-offset/2+2, y=pos.y-offset/2+2 }

	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, bgcol.a )
	surface.DrawPoly( verts )

	draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, bgcol )

	local verts = {}
	verts[1] = { x=x+w/1.5, y=y+h }
	verts[2] = { x=x+w, y=y+h/2 }
	verts[3] = { x=pos.x-offset/2-2, y=pos.y-offset/2-1.5 }

	draw.NoTexture()
	surface.SetDrawColor( bgcol.r, bgcol.g, bgcol.b, bgcol.a )
	surface.DrawPoly( verts )

	draw.DrawText( tip.text, "GModWorldtip", x + w/2, y, fgcol, TEXT_ALIGN_CENTER )

end


function GM:DrawWorldTips( tips )

	if ( !cl_drawworldtooltips:GetBool() ) then return true end

	local time = SysTime()

	for name, tip in pairs( tips ) do
		if ( tip.dietime > time || tip.dietime == -1 ) then
			DrawWorldTip( tip )
			tip.expired = false
		elseif ( !tip.expired ) then
			worldtip.Expired( name )
		end
	end

end
