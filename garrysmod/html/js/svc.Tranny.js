
angular.module( 'tranny', [] )

.directive( 'ngTranny', function ( $parse )
{
	return function ( scope, element, attrs )
	{
		var strName = "";

		var update = function()
		{
			if ( IN_ENGINE == false ) return;

			var langText = language.Update( strName );

			var children = $( element ).contents().filter( function() { return this.nodeType == 3; } )
			var replaced = false;
			children.each( function()
			{
				if ( $( this ).text().trim().length !== 0 )
				{
					if ( replaced )
					{
						$( this ).remove();
						return true; // Skip to next iteration
					}
					$( this ).replaceWith( langText );
					replaced = true;
				}
			} );
			if ( children.length === 0 )
			{
				$( element ).html( langText );
			}

			$( element ).attr( "placeholder", langText );
		};

		scope.$watch( attrs.ngTranny, function ( value )
		{
			strName = value;
			update();
		} );

		scope.$on( 'languagechanged', function()
		{
			update();
		} );

	};
} )

.directive( 'ngSeconds', function ( $parse )
{
	return function ( scope, element, attrs )
	{
		var strName = "";

		scope.$watch( attrs.ngSeconds, function ( value )
		{
			if ( value < 60 )
				return $(element).html( Math.floor( value ) + " sec" );

			if ( value < 60 * 60 )
				return $( element ).html( Math.floor( value / 60 ) + " min" );

			if ( value < 60 * 60 * 24 )
				return $( element ).html( Math.floor( value / 60 / 60 ) + " hr" );

			$( element ).html( "a long time" );

		} );

	};
} );
