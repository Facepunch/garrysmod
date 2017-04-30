
if ( SERVER ) then return end

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

		local panel = vgui.Create( metatable.Base, parent, name or classname )
		if ( !panel ) then
			Error( "Tried to create panel with invalid base '" .. metatable.Base .. "'\n" );
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

	return vgui.CreateX( classname, parent, name or classname )

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
	mtable.Init = mtable.Init or function() end

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
	mtable.Init = mtable.Init or function() end

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
	mtable.Init = mtable.Init or function() end

	return mtable

end
