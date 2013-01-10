

surface.CreateFont( "GModWorldtip",
{
	font		= "Helvetica",
	size		= 20,
	weight		= 700
})

local cl_drawworldtooltips = CreateConVar( "cl_drawworldtooltips", "1", { FCVAR_ARCHIVE } )
local WorldTip = nil

local TipColor = Color( 250, 250, 200, 255 )

--
-- Adds a hint to the queue
--
function AddWorldTip( unused1, text, unused2, pos, ent )

	WorldTip = {}
	
	WorldTip.dietime 	= SysTime() + 0.05
	WorldTip.text 		= text
	WorldTip.pos 		= pos
	WorldTip.ent 		= ent
	
end


local function DrawWorldTip( tip )

	if ( IsValid( tip.ent ) ) then	
		tip.pos = tip.ent:GetPos()
	end
	
	local pos = tip.pos:ToScreen()
	
	local black = Color( 0, 0, 0, 255 )
	local tipcol = Color( TipColor.r, TipColor.g, TipColor.b, 255 )
	
	local x = 0
	local y = 0
	local padding = 10
	local offset = 50
	
	surface.SetFont( "GModWorldtip" )
	local w, h = surface.GetTextSize( tip.text )
	
	x = pos.x - w 
	y = pos.y - h 
	
	x = x - offset
	y = y - offset

	draw.RoundedBox( 8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, black )
	
	
	local verts = {}
	verts[1] = { x=x+w/1.5-2, y=y+h+2 }
	verts[2] = { x=x+w+2, y=y+h/2-1 }
	verts[3] = { x=pos.x-offset/2+2, y=pos.y-offset/2+2 }
	
	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, tipcol.a )
	surface.DrawPoly( verts )
	
	
	draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tipcol )
	
	local verts = {}
	verts[1] = { x=x+w/1.5, y=y+h }
	verts[2] = { x=x+w, y=y+h/2 }
	verts[3] = { x=pos.x-offset/2, y=pos.y-offset/2 }
	
	draw.NoTexture()
	surface.SetDrawColor( tipcol.r, tipcol.g, tipcol.b, tipcol.a )
	surface.DrawPoly( verts )
	
	
	draw.DrawText( tip.text, "GModWorldtip", x + w/2, y, black, TEXT_ALIGN_CENTER )

end


function GM:PaintWorldTips()

	if ( !cl_drawworldtooltips:GetBool() ) then return end
	
	if ( WorldTip && WorldTip.dietime > SysTime() ) then
		DrawWorldTip( WorldTip )		
	end

end
