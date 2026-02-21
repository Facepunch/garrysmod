
surface.CreateFont( "GModWorldtip",
{
	font		= "Helvetica",
	size		= 20,
	weight		= 700
})

local cl_drawworldtooltips = CreateConVar( "cl_drawworldtooltips", "1", { FCVAR_ARCHIVE }, "Whether tooltips should draw when looking at certain Sandbox entities." )
local WorldTip = nil

local tipPadding = 10
local tipOffset = 50
local tipBGColor = Color( 0, 0, 0, 255 )
local tipColor = Color( 250, 250, 200, 255 )

--
-- Adds a hint to the queue
--
function AddWorldTip( unused1, text, unused2, pos, ent )

	WorldTip = {}

	WorldTip.dietime = SysTime() + 0.05
	WorldTip.text 	= text
	WorldTip.pos 	= pos
	WorldTip.ent 	= ent

end

local function DrawWorldTip( tip )

	if ( IsValid( tip.ent ) ) then
		tip.pos = tip.ent:GetPos()
	end

	local pos = tip.pos:ToScreen()

	surface.SetFont( "GModWorldtip" )
	local w, h = surface.GetTextSize( tip.text )

	local x = pos.x - w - tipOffset
	local y = pos.y - h - tipOffset

	draw.RoundedBox( 8, x - tipPadding - 2, y - tipPadding - 2, w + tipPadding * 2 + 4, h + tipPadding * 2 + 4, tipBGColor )

	local verts = {}
	verts[1] = { x = x + w / 1.5 - 2, y = y + h + 2 }
	verts[2] = { x = x + w + 2, y = y + h / 2 - 1 }
	verts[3] = { x = pos.x - tipOffset / 2 + 2, y = pos.y - tipOffset / 2 + 2 }

	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, tipColor.a )
	surface.DrawPoly( verts )

	draw.RoundedBox( 8, x - tipPadding, y - tipPadding, w + tipPadding * 2, h + tipPadding * 2, tipColor )

	local verts = {}
	verts[1] = { x = x + w / 1.5, y = y + h }
	verts[2] = { x = x + w, y = y + h / 2 }
	verts[3] = { x = pos.x - tipOffset / 2, y = pos.y - tipOffset / 2 }

	draw.NoTexture()
	surface.SetDrawColor( tipColor.r, tipColor.g, tipColor.b, tipColor.a )
	surface.DrawPoly( verts )

	draw.DrawText( tip.text, "GModWorldtip", x + w / 2, y, tipBGColor, TEXT_ALIGN_CENTER )

end


function GM:PaintWorldTips()

	if ( !cl_drawworldtooltips:GetBool() ) then return end

	if ( WorldTip && WorldTip.dietime > SysTime() ) then
		DrawWorldTip( WorldTip )
	end

end
