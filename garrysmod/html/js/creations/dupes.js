
var IS_SPAWN_MENU = true;

App = angular.module( 'CDupesApp', [ 'ngRoute', 'tranny' ] );

App.config( function( $routeProvider, $compileProvider, $locationProvider, $controllerProvider )
{
	$routeProvider.when( '/', { templateUrl: 'template/creations/dupes.html' } );
	$routeProvider.when( '/list/:Category/', { templateUrl: 'template/creations/dupes.html' } );
	$routeProvider.when( '/list/:Category/:Tag/', { templateUrl: 'template/creations/dupes.html' } );
	
	$controllerProvider.register( 'CDupes', CDupes );
	$controllerProvider.register( 'ControllerDupes', ControllerDupes );
} );

var CreationScope		= null;

function CDupes( $scope, $timeout, $location )
{
	CreationScope		= $scope;

	CreationScope.MyCategories =
	[
		"local",
		"subscribed_ugc"
	];

	CreationScope.Categories =
	[
		"trending",
		"popular",
		"latest"
	];

	CreationScope.CategoriesSecondary =
	[
		"followed",
		"favorite",
		"friends",
		"mine"
	];

	CreationScope.SubCategories =
	[
		"posed",
		"scenes",
		"machines",
		"vehicles",
		"buildings",
		"others"
	];

	CreationScope.DupeDisabled = "disabled";

	$scope.IfElse = function ( b, a, c )
	{
		if ( b ) return a;
		return c;
	}

	$scope.OpenWorkshopFile = function( id )
	{
		if ( !id || !IN_ENGINE ) return;
		gmod.OpenWorkshopFile( id );
	}

	$scope.SaveDupe = function()
	{
		$scope.DupeDisabled = "disabled";
		if ( IN_ENGINE ) gmod.SaveDupe();
	}
}

//
// Enable the dupe save button
//
function SetDupeSaveState( b )
{
	CreationScope.DupeDisabled = b ? "" : "disabled";
	UpdateDigest( CreationScope, 10 );
}

//
// Show the local dupes (we've just saved)
//
function ShowLocalDupes()
{
	Scope.Switch( 'local', 0 );
}


function WindowResized()
{
	// dupe is from control.Dupes.js
	dupe.RefreshDimensions();
	dupe.UpdatePageNav();

	// Refresh HTML
	dupe.DigestUpdate = setTimeout( function()
	{
		self.DigestUpdate = 0;
		Scope.Go( 0 );
	}, 500 )
}
