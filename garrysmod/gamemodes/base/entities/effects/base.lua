
--[[---------------------------------------------------------
	Returns the right shoot start position for a tracer - based on 'data'.
-----------------------------------------------------------]]
function EFFECT:GetTracerShootPos( Position, Ent, Attachment )

	self.ViewModelTracer = false

	if ( !IsValid( Ent ) ) then return Position end
	if ( !Ent:IsWeapon() ) then return Position end

	-- Shoot from the viewmodel
	if ( Ent:IsCarriedByLocalPlayer() && !LocalPlayer():ShouldDrawLocalPlayer() ) then

		local ViewModel = LocalPlayer():GetViewModel()

		if ( ViewModel:IsValid() ) then

			local att = ViewModel:GetAttachment( Attachment )
			if ( att ) then
				Position = att.Pos
				self.ViewModelTracer = true
			end

		end

	-- Shoot from the world model
	else

		local att = Ent:GetAttachment( Attachment )
		if ( att ) then
			Position = att.Pos
		end

	end

	return Position

end
