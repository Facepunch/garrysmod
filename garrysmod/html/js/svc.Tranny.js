
var languageCache = {};
var languageCurrent = "";
var languageCurrentAttr = "en";

angular.module( "tranny", [] )

.directive( "ngTranny", function( $parse )
{
	return function( scope, element, attrs )
	{
		var strName = "";

		var update = function()
		{

			if ( !IN_ENGINE )
			{
				updateElement( strName );
				return;
			}

			var outStr_old = languageCache[ strName ] || language.Update( strName, function( outStr )
			{
				languageCache[ strName ] = outStr;
				updateElement( outStr );
			} );

			if ( outStr_old )
			{
				// Compatibility with Awesomium
				languageCache[ strName ] = outStr_old;
				updateElement( outStr_old );
			}
		};

		var updateElement = function( str )
		{
			if ( !IS_SPAWN_MENU && element.attr( "lang" ) != languageCurrentAttr )
				element.attr( "lang", languageCurrentAttr );
			
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
			strName = value;
			update();
		} );

		scope.$on( "languagechanged", function()
		{
			if ( languageCurrent != gScope.Language )
			{
				languageCurrent = gScope.Language;
				languageCurrentAttr = ( languageCurrent == "" || languageCurrent == "en-pt" ) ? "en" : languageCurrent;
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
