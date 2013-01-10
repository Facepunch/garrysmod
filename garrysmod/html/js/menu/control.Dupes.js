
dupe = new WorkshopFiles();

function ControllerDupes($scope, $rootScope, $location, $timeout, $routeParams) 
{

	$rootScope.ShowBack = true;	
	Scope = $scope;

	dupe.Init( 'ws_dupe', $scope, $rootScope );

	$scope.ArmDupe = function( entry )
	{
		if ( entry.local )
			return lua.Run( "ws_dupe:Arm( %s );", entry.info.file );

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		lua.Run( "ws_dupe:DownloadAndArm( %s );", entry.info.fileid );

	}

	$scope.DeleteLocal = function( entry )
	{
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.info.file );
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.background );
		
		$scope.Switch( $scope.Category, $scope.Offset );
	}

	$scope.DoSave = function()
	{
		lua.Run( "RunConsoleCommand( \"gm_save\", \"spawnmenu\" );" );

		$( '.savegamebutton' ).css( 'opacity', '0.3' );
		$( '.savegamebutton' ).css( 'pointer-events', 'none' );

		setTimeout( function()
		{
			$( '.savegamebutton' ).css( 'opacity', '1.0' );
			$( '.savegamebutton' ).css( 'pointer-events', 'auto' );

		}, 5000 );
	}

	if (IS_SPAWN_MENU) 
	{
		if ($routeParams.Category) 
		{
			$timeout(function () { $scope.SwitchWithTag( $routeParams.Category, 0, $routeParams.Tag ); }, 10 );
			return;
		}

		$timeout(function () { $scope.SwitchWithTag( 'trending', 0, '' ); }, 10 );
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