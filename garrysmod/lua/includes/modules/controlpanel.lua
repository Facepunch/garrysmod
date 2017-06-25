
local ControlPanels = {}

module("controlpanel", package.seeall)

function Get(name)

	if (not IsValid( ControlPanels[ name ])) then

		local cp = vgui.Create("ControlPanel")
		if (not cp) then

			debug.Trace()
			Error("controlpanel.Get() - Error creating a ControlPanelnot \nYou're calling this function too earlynot  Call it in a hooknot \n")
			return nil

		end

		cp:SetVisible(false)
		cp.Name = name
		ControlPanels[ name ] = cp

	end

	return ControlPanels[ name ]

end


function Clear()

	ControlPanels = {}

end