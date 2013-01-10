--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
--										 
--

list.Set( "RopeMaterials", "Rope", 				"cable/rope" )
list.Set( "RopeMaterials", "Cable 2", 			"cable/cable2" )
list.Set( "RopeMaterials", "XBeam", 			"cable/xbeam" )
list.Set( "RopeMaterials", "Red Laser", 		"cable/redlaser" )
list.Set( "RopeMaterials", "Blue Electric", 	"cable/blue_elec" )
list.Set( "RopeMaterials", "Physics Beam", 		"cable/physbeam" )
list.Set( "RopeMaterials", "Hydra", 			"cable/hydra" )

local PANEL = {}

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetItemWidth( 0.14 )
	self:SetItemHeight( 0.3 )
	self:SetAutoHeight( true )

	local mats = list.Get( "RopeMaterials" )
	for k, v in pairs( mats ) do
	
		self:AddMaterial( k, v )
	
	end

end

function PANEL:Paint( w, h )

	draw.RoundedBox( 4, 0, 0, w, h, Color( 128, 128, 128, 255 ) )

end


vgui.Register( "RopeMaterial", PANEL, "MatSelect" )