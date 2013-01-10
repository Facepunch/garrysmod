--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
--										 
--

local PANEL = {}

AccessorFunc( PANEL, "m_ConVar1", 				"ConVar1" )
AccessorFunc( PANEL, "m_ConVar2", 				"ConVar2" )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.NumPad1 = vgui.Create( "DBinder", self )
	self.Label1 = vgui.Create( "DLabel", self )
	self.Label1:SetDark( true )
	
	self.NumPad2 = vgui.Create( "DBinder", self )
	self.Label2 = vgui.Create( "DLabel", self )
	self.Label2:SetDark( true )
	
	self:SetPaintBackground( false )

	self:SetHeight( 200 )

end

--[[---------------------------------------------------------
   Name: SetLabel1
-----------------------------------------------------------]]
function PANEL:SetLabel1( txt )
	if ( !txt ) then return end
	self.Label1:SetText( txt )
end

--[[---------------------------------------------------------
   Name: SetLabel2
-----------------------------------------------------------]]
function PANEL:SetLabel2( txt )
	if ( !txt ) then return end
	self.Label2:SetText( txt )
end

--[[---------------------------------------------------------
   Name: SetConVar1
-----------------------------------------------------------]]
function PANEL:SetConVar1( cvar )
	self.NumPad1:SetConVar( cvar )
	self.m_ConVar1 = cvar
end

--[[---------------------------------------------------------
   Name: SetConVar2
-----------------------------------------------------------]]
function PANEL:SetConVar2( cvar )
	self.NumPad2:SetConVar( cvar )
	self.m_ConVar2 = cvar
end

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	self:SetTall( 70 )

	self.NumPad1:InvalidateLayout( true )
	self.NumPad1:SetSize( 100, 50 )
	self.NumPad2:InvalidateLayout( true )
	self.NumPad2:SetSize( 100, 50 )

	self.Label1:SizeToContents()

	if ( !self.m_ConVar2 ) then

		self.NumPad2:SetVisible( false )
		self.Label2:SetVisible( false )

		self.NumPad1:Center()
		self.NumPad1:AlignTop( 20 )

		self.Label1:CenterHorizontal()
		self.Label1:AlignTop( 0 )

	else

		self.Label2:SizeToContents()

		self.NumPad2:SetVisible( true )
		self.Label2:SetVisible( true )

		self.NumPad1:CenterHorizontal( 0.25 )
		self.Label1:CenterHorizontal( 0.25 )
		self.NumPad1:AlignTop( 20 )
	
		self.NumPad2:CenterHorizontal( 0.75 )
		self.Label2:CenterHorizontal( 0.75 )
		self.NumPad2:AlignTop( 20 )
		self.Label2:AlignTop( 0 )

	end	


end



vgui.Register( "CtrlNumPad", PANEL, "DPanel" )