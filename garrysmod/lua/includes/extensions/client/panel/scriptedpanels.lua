--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2007
--										 
--


if ( SERVER ) then return end

--[[---------------------------------------------------------
   Name: vgui extensions
-----------------------------------------------------------]]

--[[

  -------
   Panel
  -------
  
   PANEL:Init()
	Overrides paint function for panel.
	Return true to cause it to not draw the default panel
  
  PANEL:Paint()
	Overrides paint function for panel.
	Return true to cause it to not draw the default panel
	
  PANEL:PaintOver()
	Like Paint except drawn after everything else has drawn.
	
  PANEL:OnMousePressed( mousecode )
  PANEL:OnMouseReleased( mousecode )
	Called when the mouse is pressed/released on the panel.
	Return true to not allow any default actions
	
  PANEL:OnMouseWheeled( delta )
	Called when the mouse is wheeled over the panel
	
  PANEL:OnKeyCodePressed( keycode )
	Called when a key is pressed
	Return true to swallow the key
	
  PANEL:OnKeyCodeTyped( keycode )
	Called when a key is typed
	Return true to swallow the key
	
  PANEL:Think()
	Called every frame the panel is visible
	
  PANEL:ApplySchemeSettings( --/todo--/ )
	You should use this to apply colours/fonts to your panel and its children

  PANEL:PerformLayout( )
	Use this to position your panel and its children
	
  PANEL:ActionSignal( key, value, ... )
	Receive an ActionSignal (various things are broadcast here)
	
  PANEL:OnCursorEntered()
	Cursor has entered the panel
	
  PANEL:OnCursorExited()
	Cursor has exited the panel
	
  PANEL:OnCursorMoved( x, y )
	Cursor has moved inside panel (or the panel has exclusive focus)
	Return a bool to override default CursorMoved route
	
  PANEL:OnFocusChanged( bGained )
	The panel has lost or gained focus
	
  --------
   Button
  --------
	
  PANEL::DoClick( local_x, local_y )
	Called when a the button is clicked
	
  ------
   HTML
  ------
  
  PANEL::StatusChanged( text )
	The text in the status bar has changed
	
  PANEL::ProgressChanged( progress )
	Loading progress changed
	
  PANEL::FinishedURL( url )
	Finished loading a specific URL
	
  PANEL::OpeningURL( url, target )
	Page wants to open URL.
	Return true to not load URL.
	
 ---------------
 - Member Vars -
 ---------------
	
  All
	Hovered			- 	bool (true if panel is hovered)
	
  Button
	Selected		-	bool (true if button is selected)
	Depressed		-	bool (true if button is depressed)
	Armed			-	bool (true if button is hovered)
	DefaultButton	-	bool (true if button is default button)
	
  HTML
	Progress		-	float (Progress bar amount between 0-1)
	Status			-	string (Status Bar Text)
	URL				-	string (Current URL)
	
--]]



local PanelFactory = {}

local panel_metatable = FindMetaTable( "Panel" )

baseclass.Set( "Panel",				panel_metatable )
baseclass.Set( "Label",				panel_metatable )
baseclass.Set( "EditablePanel",		panel_metatable )

-- Keep the old function
vgui.CreateX = vgui.Create

function vgui.GetControlTable( name )
	return PanelFactory[ name ]
end

function vgui.Create( classname, parent, name, ... )

	-- Is this a user-created panel?
	if ( PanelFactory[ classname ] ) then
	
		local metatable = PanelFactory[ classname ]
		
		local panel = vgui.Create( metatable.Base, parent, name )
		if ( !panel ) then
			Error( "Tried to create panel with invalid base '"..metatable.Base.."'\n" );
		end

		table.Merge( panel:GetTable(), metatable )
		panel.BaseClass = PanelFactory[ metatable.Base ]
		panel.ClassName = classname
		
		-- Call the Init function if we have it
		if ( panel.Init ) then
			panel:Init()	
		end
			
		panel:Prepare()
		
		return panel
	
	end
	
	return vgui.CreateX( classname, parent, name )

end


function vgui.CreateFromTable( metatable, parent, name, ... )

	if ( !istable( metatable ) ) then return nil end

	local panel = vgui.Create( metatable.Base, parent, name )
	
	table.Merge( panel:GetTable(), metatable )
	panel.BaseClass = PanelFactory[ metatable.Base ]
	panel.ClassName = classname
	
	-- Call the Init function if we have it
	if ( panel.Init ) then
		panel:Init()
	end
	
	panel:Prepare()
	
	return panel

end

function vgui.Register( name, mtable, base )

	-- Remove the global
	PANEL = nil

	-- Default base is Panel
	mtable.Base = base or "Panel"	
	
	PanelFactory[ name ] = mtable
	baseclass.Set( name, mtable )

	local mt = {}
	mt.__index = function( t, k )
	
		if ( PanelFactory[ mtable.Base ] && PanelFactory[ mtable.Base ][k] ) then return PanelFactory[ mtable.Base ][k] end
		return panel_metatable[k]

	end

	setmetatable( mtable, mt )

	return mtable

end

function vgui.RegisterTable( mtable, base )

	-- Remove the global
	PANEL = nil

	mtable.Base = base or "Panel"
	
	return mtable
	
end

function vgui.RegisterFile( filename )

	local OldPanel = PANEL

	PANEL = {}
	
	-- The included file should fill the PANEL global.
	include( filename )
	
	local mtable = PANEL
	PANEL = OldPanel

	mtable.Base = mtable.Base or "Panel"
	
	return mtable
	
end
