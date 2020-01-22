
App = angular.module( 'CDupesApp', [ 'tranny' ] );

App.config( function ( $routeProvider, $locationProvider )
{
	$routeProvider.when( '/', { templateUrl: 'template/creations/dupes.html' } );
	$routeProvider.when( '/list/:Category/:Tag/', { templateUrl: 'template/creations/dupes.html' } );
} );

var CreationScope		= null;
var CreationLocation	= null;

function CDupes( $scope, $timeout, $location )
{
	CreationScope		= $scope;
	CreationLocation	= $location;

	CreationScope.MyCategories =
	[
		"local",
		"subscribed_ugc",
		//"favorites_ugc"
	];

	CreationScope.Categories =
	[
		"trending",
		"popular",
		"latest"
	];

	CreationScope.CategoriesSecondary =
	[
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
	// No extra slash at the end so its always different from the real path and thus a redirection will always happen
	CreationLocation.path( "/list/local/" );

	CreationScope.$apply();
}
