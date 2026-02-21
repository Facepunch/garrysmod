
var languageCache = {};
var languageCurrent = "";

angular.module( "tranny", [] )

.directive( "ngTranny", function( $parse )
{
	return function( scope, element, attrs )
	{
		var strName = "";
		var strSuffix = "";

		var update = function()
		{
			var text = strName + ( strSuffix ? " " + strSuffix : "" );

			if ( !IN_ENGINE )
			{
				updateElement( text );
				return;
			}

			var outStr_old = languageCache[ strName ] || language.Update( strName, function( outStr )
			{
				languageCache[ strName ] = outStr;
				var updatedText = outStr + ( strSuffix ? " " + strSuffix : "" );
				updateElement( updatedText );
			} );

			if ( outStr_old )
			{
				// Compatibility with Awesomium
				languageCache[ strName ] = outStr_old;
				var updatedText = outStr_old + ( strSuffix ? " " + strSuffix : "" );
				updateElement( updatedText );
			}
		};

		var updateElement = function( str )
		{
			if ( "placeholder" in element[0] )
			{
				if ( element.attr( "placeholder" ) != str )
					element.attr( "placeholder", str );
			}
			else if ( element.text() != str )
			{
				element.text( str );
			}
		};

		scope.$watch( attrs.ngTranny, function( value )
		{
			var parts = value.split( " " );
			strName = parts.shift();
			strSuffix = parts.join( " " );
			update();
		} );

		scope.$on( "languagechanged", function()
		{
			if ( languageCurrent != gScope.Language )
			{
				languageCurrent = gScope.Language;
				languageCache = {};
			}
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
