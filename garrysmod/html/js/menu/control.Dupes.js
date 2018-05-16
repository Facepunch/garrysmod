
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

	$scope.ReloadView = function()
	{
		if ( IS_SPAWN_MENU )
		{
			if ( $routeParams.Category )
			{
				$timeout( function() { $scope.SwitchWithTag( $routeParams.Category, 0, $routeParams.Tag ); }, 100 );
				return;
			}

			$timeout( function() { $scope.Switch( 'local', 0 ); }, 100 );
		}
		else
		{
			$scope.Switch( 'local', 0 );
		}
	}

	// This is just to fix the spawnmenu initial size being 512x512 for first few frames
	$scope.ReloadView();
	$( window ).resize( function() {
		//if ( $scope.ResizeTimeout ) $timeout.cancel( $scope.ResizeTimeout );
		//$scope.ResizeTimeout = $timeout( function() { $scope.ReloadView(); }, 250 );

		if ( $scope.ReloadedView ) return;
		$scope.ReloadedView = true;
		$scope.ResizeTimeout = $timeout( function() { $scope.ReloadView(); }, 250 );
	} );
}

function OnGameSaved()
{
	Scope.Switch( 'local', 0 );
}
