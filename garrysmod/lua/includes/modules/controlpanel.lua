
local ControlPanels = {}

module( "controlpanel", package.seeall )

function Get( name )

	if ( !IsValid( ControlPanels[ name ] ) ) then
	
		local cp = vgui.Create( "ControlPanel" )
		if ( !cp ) then
		
			debug.Trace()
			Error( "controlpanel.Get() - Error creating a ControlPanel!\nYou're calling this function too early! Call it in a hook!\n" )
			return nil
		
		end
		
		cp:SetVisible( false )
		cp.Name = name
		ControlPanels[ name ] = cp
	
	end
	
	return ControlPanels[ name ]
	
end


function Clear()

	ControlPanels = {}

end