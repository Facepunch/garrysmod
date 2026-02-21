
var lua =
{
	Run: function ( cmd )
	{
		if ( arguments.length == 1 )
		{
			console.log( "RUNLUA:" + cmd );
			return;
		}


		var str = "";
		var arg = 1;

		//
		// Build the string!
		//
		for ( var i = 0; i<cmd.length; i++ )
		{
			if ( cmd[i] == '%' )
			{
				i++;

				if ( cmd[i] == 's' )
				{
					str += "\"";
					str += arguments[arg].replace(/["\\]/g, '\\$&');
					str += "\"";

					arg++;
					continue;
				}

				if ( cmd[i] == 'i' )
				{
					str += arguments[arg];
					arg++;
					continue;
				}
			}

			str += cmd[i];
		}

		console.log( "RUNLUA:" + str );

	},

	PlaySound: function( name )
	{
		lua.Run( "surface.PlaySound( %s )", String( name ) )
	}
}
