
var IS_SPAWN_MENU = false;

var App = angular.module( 'MenuApp', [ 'ngRoute', 'tranny' ] );

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
} );