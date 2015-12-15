
var IN_ENGINE = navigator.userAgent.indexOf( "Valve Source Client" ) != -1;
var IS_SPAWN_MENU = true

var App = angular.module( 'CreationsApp', [ 'tranny' ] );

App.config( function ( $routeProvider, $locationProvider )
{
	$routeProvider.when( '/', { templateUrl: 'template/creations/saves.html', controller: 'ControllerSaves' } );
	$routeProvider.when( '/saves/:Category/:MapName/', { templateUrl: 'template/creations/saves.html', controller: ControllerSaves } );
	$routeProvider.when( '/dupes/:Category/:MapName/', { templateUrl: 'template/creations/dupes.html', controller: ControllerDupes } );
} );


function UpdateDigest( scope, timeout )
{
	if ( !scope ) return;
	if ( scope.DigestUpdate ) return;

	scope.DigestUpdate = setTimeout( function ()
	{
		scope.DigestUpdate = 0;
		scope.$digest();
	}, timeout )
}

//We already have a limitTo filter built-in to angular,
//let's make a startFrom filter
App.filter( 'startFrom', function ()
{
	return function( input, start )
	{
		start = +start; //parse to int
		return input.slice( start );
	}
} );

var CreationScope = null;
var CreationLocation = null;

function CCreations( $scope, $timeout, $location )
{
	CreationScope		= $scope;
	CreationLocation	= $location;

	CreationScope.DupeDisabled = "disabled";

	CreationScope.Categories =
	[
		"trending",
		"popular",
		"latest",
		"friends",
		"",
		"local",
		"mine",
	];

	$scope.IfElse = function( b, a, c )
	{
		if ( b ) return a;
		return c;
	}

	$scope.OpenWorkshopFile = function( id )
	{
		if ( !id ) return;
		gmod.OpenWorkshopFile( id );
	}

	$scope.SaveSave = function()
	{
		gmod.SaveSave();

		$scope.SaveDisabled = "disabled";

		$timeout( function()
		{
			$scope.SaveDisabled = "";
		}, 5000 );
	}

	$scope.SaveDupe = function()
	{
		$scope.DupeDisabled = "disabled";
		gmod.SaveDupe();
	}

	SetMap( 'gm_construct' );

	//setTimeout( function() { ShowLocalDupes(); }, 2000 );
}

function SetMap( mapname )
{
	CreationScope.MapName = mapname;
	UpdateDigest( CreationScope, 10 );
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
	CreationLocation.path( "/dupes/local/" + Math.random() + "/" ); // Lolz, hackz
	CreationScope.$apply();
}
