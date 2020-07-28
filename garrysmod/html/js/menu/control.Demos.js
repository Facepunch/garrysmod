
demo = new WorkshopFiles();

function ControllerDemos( $scope, $element, $rootScope, $location )
{
	$rootScope.ShowBack = true;
	Scope = $scope;

	demo.Init( 'demo', $scope, $rootScope );

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
		"mine",
	];

	$scope.Disabled = false;
	if ( !IS_SPAWN_MENU ) lua.Run( "UpdateAddonDisabledState();" );

	$scope.Subscribe = function( file ) { subscriptions.Subscribe( file.id ); }
	$scope.Unsubscribe = function( file ) { subscriptions.Unsubscribe( file.id ); }
	$scope.IsSubscribed = function( file ) { return subscriptions.Contains( String( file.id ) ); };

	$scope.PlayDemo = function ( entry )
	{
		if ( entry.local )
			return lua.Run( "demo:Play( %s );", entry.info.file );

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		lua.Run( "demo:DownloadAndPlay( %s );", entry.info.id );

	}

	$scope.DemoToVideo = function ( entry )
	{
		if ( entry.local )
			return lua.Run( "demo:ToVideo( %s );", entry.info.file );

		//
		// TODO: Some kind of `please wait` while we download 200kb
		//

		lua.Run( "demo:DownloadAndToVideo( %s );", entry.info.id );
	}

	$scope.DeleteLocal = function ( entry )
	{
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.info.file );
		lua.Run( "file.Delete( %s, \"MOD\" );", entry.background );

		$scope.Switch( $scope.Category, $scope.Offset );
	}

	$scope.Switch( 'local', 0 );
}
