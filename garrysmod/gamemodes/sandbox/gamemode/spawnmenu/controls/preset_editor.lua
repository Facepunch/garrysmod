--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
--										 
--

local PANEL = {}

AccessorFunc( PANEL, "m_strType", 		"Type" )
AccessorFunc( PANEL, "m_ConVars", 		"ConVars" )
AccessorFunc( PANEL, "m_PresetControl", "PresetControl" )



--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	-- This needs to be drawn on top of the spawn menu..
	self:SetDrawOnTop( true )

	self:SetSize( 450, 350 )
	self:SetTitle( "Preset Editor" )
	
	self.PresetList = vgui.Create( "DListBox", self )
	
	self.pnlEditor = vgui.Create( "DPanel", self )
			
		self.pnlDetails = vgui.Create( "DPanel", self.pnlEditor )
		
		self.pnlModify = vgui.Create( "DPanel", self.pnlEditor )
	
			-- TODO: ICON!
			self.btnDelete = vgui.Create( "DButton", self.pnlModify )
			self.btnDelete.DoClick = function() self:Delete() end
			
			self.txtRename = vgui.Create( "DTextEntry", self.pnlModify )
		
			self.btnRename = vgui.Create( "DButton", self.pnlModify )
			self.btnRename:SetText( "#Rename" )
			self.btnRename.DoClick = function() self:Rename() end
	
	self.pnlAdd = vgui.Create( "DPanel", self )
	
		self.txtName = vgui.Create( "DTextEntry", self.pnlAdd )
		
		self.btnAdd = vgui.Create( "DButton", self.pnlAdd )
		self.btnAdd:SetText( "#Add Preset" )
		self.btnAdd.DoClick = function() self:Add() end
		
	self.pnlClose = vgui.Create( "DPanel", self )
	
		self.btnCloseIt = vgui.Create( "DButton", self.pnlClose )
		self.btnCloseIt:SetText( "#Close" )
		self.btnCloseIt.DoClick = function() self:Remove() end
	
end

--[[---------------------------------------------------------
   Name: SetType
-----------------------------------------------------------]]
function PANEL:SetType( strType )
	self.m_strType = strType
	self:Update()
end


--[[---------------------------------------------------------
   Name: Update
-----------------------------------------------------------]]
function PANEL:Update()

	self.PresetList:Clear()

	local Presets = presets.GetTable( self.m_strType )
	local sortedPresets, i = {}, 1
	for name in pairs( Presets ) do
		sortedPresets[i] = name
		i = i + 1
	end
	table.sort( sortedPresets )

	for _, name in ipairs( sortedPresets ) do
	
		local item = self.PresetList:AddItem( name )
		item.Data = Presets[name]
	
	end

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	DFrame.PerformLayout( self )
	
	self.pnlClose:SetSize( 100, 30 )
	self.pnlClose:AlignRight( 10 )
	self.pnlClose:AlignBottom( 10 )
	self.btnCloseIt:StretchToParent( 5, 5, 5, 5 )
	
	self.pnlAdd:StretchToParent( 10, 10, 10, 10 )
	self.pnlAdd:CopyHeight( self.pnlClose )
	self.pnlAdd:AlignBottom( 10 )
	self.pnlAdd:StretchRightTo( self.pnlClose, 10 )

		self.btnAdd:SetSize( 80, 20 )
		self.btnAdd:AlignRight( 5 )
		self.btnAdd:CenterVertical()
		
		self.txtName:SetPos( 5, 5 )
		self.txtName:StretchRightTo( self.btnAdd, 5 )
		self.txtName:CenterVertical()
	
	self.PresetList:StretchToParent( 10, 25, 5, 5 )
	self.PresetList:StretchBottomTo( self.pnlAdd, 10 )
	self.PresetList:SetWide( 130 )
	
	self.pnlEditor:CopyBounds( self.PresetList )
	self.pnlEditor:MoveRightOf( self.PresetList, 5 )
	self.pnlEditor:StretchToParent( nil, nil, 10, nil )
		
		self.pnlModify:StretchToParent( 5, 5, 5, 5 )
		self.pnlModify:SetTall( 30 )
		self.pnlModify:AlignBottom( 5 )
		
			self.btnDelete:SetSize( 20, 20 )
			self.btnDelete:AlignRight( 5 ) 
			self.btnDelete:CenterVertical()
			
			self.btnRename:SetSize( 50, 20 )
			self.btnRename:MoveLeftOf( self.btnDelete, 5 )
			self.btnRename:CenterVertical()
			
			self.txtRename:StretchToParent( 5, 5, 5, 5 )
			self.txtRename:StretchRightTo( self.btnRename, 5 )
		
		self.pnlDetails:CopyBounds( self.pnlModify )
		self.pnlDetails:AlignTop( 5 )
		self.pnlDetails:StretchBottomTo( self.pnlModify, 5 )
		

end

--[[---------------------------------------------------------
   Name: 
-----------------------------------------------------------]]
function PANEL:Delete()

	local Selected = self.PresetList:GetSelected()
	if (!Selected) then return end
	
	presets.Remove( self.m_strType, Selected:GetValue() )
	self:Update()
	
	if ( self.m_PresetControl ) then
		self.m_PresetControl:Update()
	end

end

--[[---------------------------------------------------------
   Name: 
-----------------------------------------------------------]]
function PANEL:Rename()

	local Selected = self.PresetList:GetSelected()
	if (!Selected) then return end
	
	local ToName = self.txtRename:GetValue()
	if (!ToName || ToName == "") then return end
	
	-- Todo, Handle name collision
	
	presets.Rename( self.m_strType, Selected:GetValue(), ToName )
	self:Update()
	
	self.PresetList:SelectByName( ToName )
	
	self.txtRename:SetText( "" )
	
	if ( self.m_PresetControl ) then
		self.m_PresetControl:Update()
	end

end

--[[---------------------------------------------------------
   Name: 
-----------------------------------------------------------]]
function PANEL:Add()

	if ( !self.m_ConVars ) then return end
	
	local ToName = self.txtName:GetValue()
	if (!ToName || ToName == "") then return end
	
	-- Todo, Handle name collision
	local tabValues = {}
	
	for k, v in pairs( self.m_ConVars ) do
		tabValues[ v ] = GetConVarString( v )
	end
		
	presets.Add( self.m_strType, ToName, tabValues )
	self:Update()
	
	self.PresetList:SelectByName( ToName )
	
	self.txtName:SetText( "" )
	
	if ( self.m_PresetControl ) then
		self.m_PresetControl:Update()
	end

end

vgui.Register( "PresetEditor", PANEL, "DFrame" )
