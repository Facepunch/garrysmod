
local PANEL = {}

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetDrawBackground( false )
	self:SetSize( 128, 128 )
	self:SetText( "" )
	
end

function PANEL:OnDepressionChanged( b )
	
	if ( IsValid( self.checkbox ) ) then
		self.checkbox:SetVisible( !b )
	end

end

function PANEL:Setup( name, icon )

	self.name = name
	self.icon = icon

	self:SetMaterial( icon )
	self:SetName( name )
	
	self.PP = list.Get( "PostProcess" )[ name ]
	if ( !self.PP ) then return end
	
	self.DoClick = function()
	
		if ( self.PP.onclick ) then
			return self.PP.onclick()
		end

		if ( !self.PP.cpanel ) then return end
		
		if ( !IsValid(self.cp) ) then
		
			self.cp = vgui.Create( "ControlPanel" )
			self.cp:SetName( name )
			self.cp:FillViaFunction( self.PP.cpanel )
		
		end
		
		spawnmenu.ActivateToolPanel( 1, self.cp )
		
	end
	
	if ( self.PP.convar ) then
	
		self.checkbox = self:Add( "DCheckBox" )
		self.checkbox:SetConVar( self.PP.convar )
		self.checkbox:SetSize( 20, 20 )
		self.checkbox:SetPos( self:GetWide() - 20 - 8, 8 )
				
		self.Enabled = function() return self.checkbox:GetChecked() end
	
	elseif ( self.ConVars ) then
	
		self.checkbox = self:Add( "DCheckBox" )
		self.checkbox:SetSize( 20, 20 )
		self.checkbox:SetPos( self:GetWide() - 20 - 8, 8 )

		self.checkbox.OnChange = function( pnl, on ) 
		
				for k, v in pairs( self.ConVars ) do
							
					if ( on ) then 
						RunConsoleCommand( k, v.on ) 
					else
						RunConsoleCommand( k, v.off or "" ) 
					end 
				
				end
		
		end
		
		self.checkbox.Think = function( pnl, on ) 
		
				local good = true
		
				for k, v in pairs( self.ConVars ) do

					if ( GetConVarString( k ) != v.on ) then 
						good = false
					end 
				
				end
			
				pnl:SetChecked( good )
		
		end
		
		self.Enabled = function() return checkbox:GetChecked() end
	
	end
	
end

function PANEL:DoRightClick()

	local pCanvas = self:GetSelectionCanvas()
	if ( IsValid( pCanvas ) && pCanvas:NumSelectedChildren() > 0 ) then
		return hook.Run( "SpawnlistOpenGenericMenu", pCanvas )
	end

	self:OpenMenu()

end

function PANEL:DoClick()

end

function PANEL:OpenMenu()

end

function PANEL:Enabled()
	return false
end

function PANEL:ToTable( bigtable )

	local tab = {}
	
	tab.type	= "postprocess"
	tab.name	= self.name
	tab.icon	= self.icon
	tab.convars	= self.ConVars

	table.insert( bigtable, tab )
	

end

function PANEL:Copy()
	
	local copy = vgui.Create( "PostProcessIcon", self:GetParent() )
	copy:CopyBounds( self )
	copy.ConVars = self.ConVars
	copy:Setup( self.name, self.icon )	
	
	return copy;
	
end

vgui.Register( "PostProcessIcon", PANEL, "ContentIcon" )


spawnmenu.AddContentType( "postprocess", function( container, obj )

	if ( !obj.name ) then return end
	if ( !obj.icon ) then return end
	
	local icon = vgui.Create( "PostProcessIcon", container )
	
	if ( obj.convars ) then 
		icon.ConVars = obj.convars
	end
	
	icon:Setup( obj.name, obj.icon )
		
	container:Add( icon )

end )
