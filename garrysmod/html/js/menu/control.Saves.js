
save = new WorkshopFiles();

function ControllerSaves($scope, $rootScope, $location, $timeout, $routeParams)
{

	$rootScope.ShowBack = true;
	Scope = $scope;

	save.Init( 'ws_save', $scope, $rootScope );

	Scope.Categories =
	[
		"trending",
		"popular",
		"latest"
	];

	Scope.SubCategories =
	[
		"scenes",
		"machines",
		"buildings",
		"courses",
		"others"
	];

	$scope.LoadSave = function( entry )
	{
		if ( !IN_ENGINE ) return;

		if ( entry.local ) {
			gmod.LoadSave( entry.info.file );
			return;
		}

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		gmod.DownloadSave( entry.info.fileid );
	}

	$scope.DeleteLocal = function( entry )
	{
		if ( IN_ENGINE )
		{
			gmod.DeleteLocal( entry.info.file );
			gmod.DeleteLocal( entry.info.background );
		}

		$scope.Switch( $scope.Category, $scope.Offset );
	}

	if ( IS_SPAWN_MENU )
	{
		if ( $routeParams.Category )
		{
			$timeout( function() { $scope.SwitchWithTag( $routeParams.Category, 0, $routeParams.Tag, $scope.MapName ); }, 100 );
			return;
		}

		$timeout( function() { $scope.SwitchWithTag( 'trending', 0, $scope.MapName ); }, 100 );
	}
	else
	{
		$scope.Switch( 'local', 0 );
	}
}

function OnGameSaved()
{
	Scope.Switch( 'local', 0 );
}
