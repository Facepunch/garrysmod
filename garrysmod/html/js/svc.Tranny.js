if (!IN_ENGINE)
{
	window.language = {
		Update: function( str ) { return str; }
	}
}


angular.module( 'tranny', [] )

.directive( 'ngTranny', function ( $parse )
{
	return function ( scope, element, attrs )
	{
		var strName = "";

		var update = function()
		{
			$(element).html( language.Update( strName ) );
		}
		
		scope.$watch( attrs.ngTranny, function ( value ) 
		{
			strName = value;
			update();			
		});

		scope.$on( 'languagechanged', function()
		{
			update();
		})

	}
} )

.directive( 'ngSeconds', function ( $parse )
{
	return function ( scope, element, attrs )
	{
		var strName = "";

		scope.$watch( attrs.ngSeconds, function ( value )
		{
			if ( value < 60 )
				return $(element).html( Math.floor(value) + " sec" );

			if ( value < 60 * 60 )
				return $( element ).html( Math.floor(value / 60) + " min" );

			if ( value < 60 * 60 * 24 )
				return $( element ).html( Math.floor( value / 60 / 60 ) + " hr" );
			
			$( element ).html( "a long time" );

		});

	}
} );

