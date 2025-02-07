var IN_ENGINE = navigator.userAgent.indexOf( "Valve Source Client" ) != -1;
var IS_SPAWN_MENU = false;

var App = angular.module( 'MenuApp', [ 'ngRoute', 'tranny', 'ui' ] );

App.config( function( $routeProvider, $compileProvider, $locationProvider, $controllerProvider )
{
	$routeProvider.when('/', { templateUrl: 'template/main.html' } );
	$routeProvider.when('/addons/', { templateUrl: 'template/addon_list.html' } );
	$routeProvider.when('/newgame/', { templateUrl: 'template/newgame.html' } );
	$routeProvider.when('/servers/', { templateUrl: 'template/servers.html' } );
	$routeProvider.when('/demos/', { templateUrl: 'template/demos.html' } );
	$routeProvider.when('/saves/', { templateUrl: 'template/saves.html' } );
	$routeProvider.when('/dupes/', { templateUrl: 'template/dupes.html' } );

	$controllerProvider.register( 'MenuController', MenuController );
	$controllerProvider.register( 'ControllerMain', ControllerMain );
	$controllerProvider.register( 'ControllerNewGame', ControllerNewGame );
	$controllerProvider.register( 'ControllerServers', ControllerServers );
	$controllerProvider.register( 'ControllerAddons', ControllerAddons );
	$controllerProvider.register( 'ControllerDupes', ControllerDupes );
	$controllerProvider.register( 'ControllerSaves', ControllerSaves );
	$controllerProvider.register( 'ControllerDemos', ControllerDemos );

	//Update trusted protocols to include asset://
	$compileProvider.imgSrcSanitizationTrustedUrlList( /^\s*((https?|ftp|file|blob|asset):|data:image\/)/ ); //Default: /^\s*((https?|ftp|file|blob):|data:image\/)/
	$compileProvider.aHrefSanitizationTrustedUrlList( /^\s*(https?|s?ftp|mailto|tel|file|asset):/ ); //Default: /^\s*(https?|s?ftp|mailto|tel|file):/

	//Default prefix is '!'. Gmod doesn't use this.
	$locationProvider.hashPrefix( '' );

	//Disable debug info for "a significant performance boost" https://docs.angularjs.org/api/ng/provider/$compileProvider#debugInfoEnabled
	$compileProvider.debugInfoEnabled( false ); //Comment out for debugging
} );

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

//We already have a limitTo filter built-in to angular,
//let's make a startFrom filter
App.filter( 'startFrom', function()
{
	return function( input, start )
	{
		if ( !input ) return input;

		start = +start; //parse to int
		return input.slice( start );
	}
} );
