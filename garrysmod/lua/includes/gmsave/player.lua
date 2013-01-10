
function gmsave.PlayerSave( ent )

	local tab = {}
	
	tab.Origin = ent:GetPos()
	tab.Angle = ent:GetAngles()

	return tab;

end


function gmsave.PlayerLoad( ent, tab )

	if ( tab == nil ) then return end
	
	if ( tab.Origin ) then ent:SetPos( tab.Origin ) end
	if ( tab.Angle ) then ent:SetEyeAngles( tab.Angle ) end
	
end
