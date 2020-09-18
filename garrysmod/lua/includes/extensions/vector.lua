local meta = FindMetaTable( "Vector" )

--[[---------------------------------------------------------
	Converts Vector To Color - alpha precision lost, must reset
-----------------------------------------------------------]]
function meta:ToColor( )
	return Color( self[1] * 255, self[2] * 255, self[3] * 255 )
end

function meta:ClampLength( max )
	if self:LengthSqr() > max * max then
		self:Normalize()
		self:Mul( max )
	end
end

function meta.SmoothDamp( current, target, current_velocity, smooth_time, max_speed, delta_time )
	smooth_time = math.max( 1e-4, smooth_time )
	max_speed = max_speed or math.huge
	delta_time = delta_time or FrameTime()

	local omega = 2 / smooth_time
	local x = omega * delta_time
	local max_length = max_speed * smooth_time
	local exp = 1 / ( 1 + x + 0.48 * x * x + 0.235 * x * x * x )

	local delta = current - target
	delta:ClampLength( max_length )

	local new_target = current - delta

	local tmp = ( current_velocity + ( delta * omega ) ) * delta_time
	local output = new_target + ( delta + tmp ) * exp

	current_velocity:Sub( tmp * omega )
	current_velocity:Mul( exp )

	if ( target - current ):Dot( output - target ) > 0 then
		output = target

		current_velocity[1] = 0
		current_velocity[2] = 0
		current_velocity[3] = 0
	end

	return output, current_velocity
end
