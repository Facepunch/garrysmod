
save = new WorkshopFiles();

function ControllerSaves($scope, $rootScope, $location, $timeout, $routeParams)
{
	$rootScope.ShowBack = true;
	Scope = $scope;

	save.Init( 'ws_save', $scope, $rootScope );

	$scope.MyCategories =
	[
		"local",
		"subscribed_ugc",
		//"favorites_ugc"
	];

	$scope.Categories =
	[
		"trending",
		"popular",
		"latest"
	];

	$scope.CategoriesSecondary =
	[
		"friends",
		"mine"
	];

	$scope.SubCategories =
	[
		"scenes",
		"machines",
		"buildings",
		"courses",
		"others"
	];

	$scope.Disabled = false;
	if ( !IS_SPAWN_MENU ) lua.Run( "UpdateAddonDisabledState();" );

	$scope.Subscribe = function( file ) { subscriptions.Subscribe( file.id ); }
	$scope.Unsubscribe = function( file ) { subscriptions.Unsubscribe( file.id ); }
	$scope.IsSubscribed = function( file ) { return subscriptions.Contains( String( file.id ) ); };

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

		gmod.DownloadSave( entry.info.id );
	}

	$scope.DeleteLocal = function( entry )
	{
		if ( IN_ENGINE )
		{
			gmod.DeleteLocal( entry.info.file );
			gmod.DeleteLocal( entry.background );
		}

		$scope.Switch( $scope.Category, $scope.Offset );
	}

	$scope.ReloadView = function()
	{
		if ( IS_SPAWN_MENU )
		{
			if ( $routeParams.Category )
			{
				$timeout( function() { $scope.SwitchWithTag( $routeParams.Category, 0, $routeParams.Tag, $scope.MapName ); }, 100 );
				return;
			}

			$timeout( function() { $scope.SwitchWithTag( 'local', 0, $scope.MapName ); }, 100 );
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
