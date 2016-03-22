
dupe = new WorkshopFiles();

function ControllerDupes($scope, $rootScope, $location, $timeout, $routeParams)
{
	$rootScope.ShowBack = true;
	Scope = $scope;

	dupe.Init( 'ws_dupe', $scope, $rootScope );

	$scope.ArmDupe = function( entry )
	{
		if ( !IN_ENGINE ) return;

		if ( entry.local ) {
			gmod.ArmDupe( entry.info.file );
			return;
		}

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		gmod.DownloadDupe( entry.info.fileid );
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
			$timeout( function() { $scope.SwitchWithTag( $routeParams.Category, 0, $routeParams.Tag ); }, 10 );
			return;
		}

		$timeout( function() { $scope.SwitchWithTag( 'trending', 0, '' ); }, 10 );
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
