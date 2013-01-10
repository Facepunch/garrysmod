
function JS_Language( html )

	html:AddFunction( "language", "Update", function( phrase )

		return language.GetPhrase( phrase );

	end )

end

function JS_Utility( html )

	html:AddFunction( "util", "MotionSensorAvailable", function()

		return motionsensor.IsAvailable()

	end )

end