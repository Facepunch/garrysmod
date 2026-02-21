
var IS_SPAWN_MENU = true;

App = angular.module( 'CSavesApp', [ 'ngRoute', 'tranny' ] );

App.config( function( $routeProvider, $compileProvider, $locationProvider, $controllerProvider )
{
	$routeProvider.when( '/', { templateUrl: 'template/creations/saves.html' } );
	$routeProvider.when( '/list/:Category/', { templateUrl: 'template/creations/saves.html' } );
	$routeProvider.when( '/list/:Category/:Tag/', { templateUrl: 'template/creations/saves.html' } );
	
	$controllerProvider.register( 'CSaves', CSaves );
	$controllerProvider.register( 'ControllerSaves', ControllerSaves );
} );

var CreationScope		= null;

function CSaves( $scope, $timeout, $location )
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
		"scenes",
		"machines",
		"buildings",
		"courses",
		"others"
	];

	$scope.IfElse = function( b, a, c )
	{
		if ( b ) return a;
		return c;
	}

	$scope.OpenWorkshopFile = function( id )
	{
		if ( !id || !IN_ENGINE ) return;
		gmod.OpenWorkshopFile( id );
	}

	$scope.SaveSave = function()
	{
		if ( IN_ENGINE ) gmod.SaveSave();

		$scope.SaveDisabled = "disabled";

		$timeout( function()
		{
			$scope.SaveDisabled = "";
		}, 5000 );
	}

	SetMap( 'gm_construct' );
}

//
// Sets the current map - so we get the right saves
//
function SetMap( mapname )
{
	CreationScope.MapName = mapname;
	UpdateDigest( CreationScope, 10 );
}

function WindowResized()
{
	// save is from control.Saves.js
	save.RefreshDimensions();
	save.UpdatePageNav();

	// Refresh HTML
	save.DigestUpdate = setTimeout( function()
	{
		self.DigestUpdate = 0;
		Scope.Go( 0 );
	}, 500 )
}
