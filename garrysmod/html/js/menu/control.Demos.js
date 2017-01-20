
demo = new WorkshopFiles();

function ControllerDemos( $scope, $element, $rootScope, $location )
{
	$rootScope.ShowBack = true;
	Scope = $scope;

	demo.Init( 'demo', $scope, $rootScope );

	$scope.PlayDemo = function ( entry )
	{
		if ( entry.local )
			return lua.Run( "demo:Play( %s );", entry.info.file );

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		lua.Run( "demo:DownloadAndPlay( %s );", entry.info.fileid );

	}

	$scope.DemoToVideo = function ( entry )
	{
		if ( entry.local )
			return lua.Run( "demo:ToVideo( %s );", entry.info.file );

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		lua.Run( "demo:DownloadAndToVideo( %s );", entry.info.fileid );
	}

	$scope.DeleteLocal = function ( entry )
	{
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.info.file );
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.background );

		$scope.Switch( $scope.Category, $scope.Offset );
	}

	$scope.Switch( 'local', 0 );
}
