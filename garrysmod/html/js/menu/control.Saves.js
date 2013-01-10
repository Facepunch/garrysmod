
save = new WorkshopFiles();

function ControllerSaves($scope, $rootScope, $location, $timeout, $routeParams) {

	$rootScope.ShowBack = true;	
	Scope = $scope;

	save.Init( 'ws_save', $scope, $rootScope );

	$scope.LoadSave = function( entry )
	{
		if ( entry.local )
			return lua.Run( "ws_save:Load( %s );", entry.info.file );

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		lua.Run( "ws_save:DownloadAndLoad( %s );", entry.info.fileid );

	}

	$scope.DeleteLocal = function( entry )
	{
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.info.file );
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.background );
		
		$scope.Switch( $scope.Category, $scope.Offset );
	}

	if ( IS_SPAWN_MENU ) 
	{
		if ($routeParams.Category) 
		{
			$timeout(function () { $scope.SwitchWithTag( $routeParams.Category, 0, $routeParams.Tag, $scope.MapName ); }, 100 );
			return;
		}

		$timeout(function () { $scope.SwitchWithTag('trending', 0, $scope.MapName ); }, 100 );
	}
	else 
	{
		$scope.Switch('local', 0);
	}
}

function OnGameSaved()
{
	Scope.Switch( 'local', 0 );
}