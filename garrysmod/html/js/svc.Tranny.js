
var languageCache = {};

angular.module( 'tranny', [] )

.directive( 'ngTranny', function ( $parse )
{
	return function( scope, element, attrs )
	{
		var strName = "";
		var strSuffix = "";

		var update = function()
		{
			var text = strName + " " + strSuffix;
			
			if ( !IN_ENGINE )
			{
				element.text( text );
				element.attr( "placeholder", text );
				return;
			}

			var outStr_old = languageCache[ strName ] || language.Update( strName, function( outStr )
			{
				languageCache[ strName ] = outStr;
				var updatedText = outStr + " " + strSuffix;
				element.text( updatedText );
				element.attr( "placeholder", updatedText );
			} );

			if ( outStr_old )
			{
				// Compatibility with Awesomium
				languageCache[ strName ] = outStr_old;
				var updatedText = outStr_old + " " + strSuffix;
				element.text( updatedText );
				element.attr( "placeholder", updatedText );
			}
		};

		scope.$watch( attrs.ngTranny, function( value )
		{
			var parts = value.split( " " );
			strName = parts.shift();
			strSuffix = parts.join( " " );
			update();
		} );

		scope.$on( 'languagechanged', function()
		{
			languageCache = {};
			update();
		} );

	}
} )

.directive( 'ngSeconds', function ( $parse )
{
	return function ( scope, element, attrs )
	{
		scope.$watch( attrs.ngSeconds, function ( value )
		{
			if ( value < 60 )
				return element.text( Math.floor( value ) + " sec" );

			if ( value < 60 * 60 )
				return element.text( Math.floor( value / 60 ) + " min" );

			if ( value < 60 * 60 * 24 )
				return element.text( Math.floor( value / 60 / 60 ) + " hr" );

			element.text( "a long time" );

		});

	}
} );
