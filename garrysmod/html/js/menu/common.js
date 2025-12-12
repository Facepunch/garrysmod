// Shared functions and App config for MenuApp, and the spawnmenu's CDupesApp and CSavesApp
// Must be loaded after menu/menuApp.js, creations/dupes.js, creations/saves.js

var IN_ENGINE		= navigator.userAgent.indexOf( "Valve Source Client" ) != -1;
var IS_AWESOMIUM 	= navigator.userAgent.toLowerCase().indexOf("awesomium") != -1;

function UpdateDigest( scope, timeout )
{
	if ( !scope ) return;
	if ( scope.DigestUpdate ) return;

	scope.DigestUpdate = setTimeout( function()
	{
		scope.DigestUpdate = 0;
		scope.$digest();

	}, timeout );
}

// We already have a limitTo filter built-in to angular,
// let's make a startFrom filter
App.filter( 'startFrom', function()
{
	return function( input, start )
	{
		if ( !input ) return input;

		start = +start; //parse to int
		return input.slice( start );
	}
} );

// AngularJS configuration
App.config( function( $routeProvider, $compileProvider, $locationProvider, $controllerProvider )
{
	// Update trusted protocols to include asset://
	// Default: /^\s*((https?|ftp|file|blob):|data:image\/)/
	$compileProvider.imgSrcSanitizationTrustedUrlList( /^\s*((https?|ftp|file|blob|asset):|data:image\/)/ ); 
	// Default: /^\s*(https?|s?ftp|mailto|tel|file):/
	$compileProvider.aHrefSanitizationTrustedUrlList( /^\s*(https?|s?ftp|mailto|tel|file|asset):/ );

	// Default prefix is '!'. Gmod doesn't use this.
	$locationProvider.hashPrefix( '' );
	
	// AngularJS 1.8.2 doesn't apply 'href' on <a> unless ng-href is present. This breaks hover styles in Awesomium compared to 1.1.2.
	// So we're copying the htmlAnchorDirective from https://github.com/angular/angular.js/blob/master/src/ng/directive/a.js
	// and re-adding an empty href where needed.
	if ( IS_AWESOMIUM )
	{
		$compileProvider.directive( 'a', function( $compile )
		{
			return {
				restrict: 'E',
				compile: function( element, attr )
				{
					if ( attr.href || attr.xlinkHref ) return;
					
					return function( scope, element )
					{
						if ( element[0].nodeName.toLowerCase() !== 'a') return;

						if ( !attr.href && !attr.ngHref ) element.attr( "href", "" ); // Re-add an empty href. see above comment.

						var href = toString.call( element.prop( 'href' ) ) === '[object SVGAnimatedString]' ? 'xlink:href' : 'href';
						element.on( 'click', function( event ) {
							if ( !element.attr( href ) ) event.preventDefault();
						} );
					};
				}
			};
		} );
	}


	// Disable debug info for "a significant performance boost" https://docs.angularjs.org/api/ng/provider/$compileProvider#debugInfoEnabled
	$compileProvider.debugInfoEnabled( false ); //Comment out for debugging

	// Additional directives not used. Disabling them improves performance.
	$compileProvider.commentDirectivesEnabled( false );
	$compileProvider.cssClassDirectivesEnabled( false );
} );