
addon = new WorkshopFiles();

function ControllerAddons( $scope, $element, $rootScope, $location )
{
	$rootScope.ShowBack = true;
	Scope = $scope;

	$scope.Categories =
	[
		"trending",
		"popular",
		"latest",
	];

	$scope.CategoriesSecondary =
	[
		"friends",
		"mine",
	];

	$scope.AddonTypes =
	[
		"gamemode",
		"map",
		"weapon",
		"tool",
		"npc",
		"vehicle",
		"model"
	];

	addon.Init( 'addon', $scope, $rootScope );

	$scope.Switch( 'subscribed', 0 );

	$scope.Subscribe = function( file )
	{
		lua.Run( "steamworks.Subscribe( %s );", String( file.id ) )

		// Update files if viewing subscribed list?
	};

	$scope.Unsubscribe = function ( file )
	{
		lua.Run( "steamworks.Unsubscribe( %s );", String( file.id ) )

		// Update files if viewing subscribed list?
	};

	$scope.DisableAllSubscribed = function()
	{
		subscriptions.SetAllEnabled( false );
		lua.Run( "steamworks.ApplyAddons();" )
	}

	$scope.EnableAllSubscribed=function()
	{
		subscriptions.SetAllEnabled( true );
		lua.Run( "steamworks.ApplyAddons();" )
	}

	$scope.IsSubscribed = function ( file )
	{
		return subscriptions.Contains( String(file.id) );
	};

	$scope.IsEnabled = function ( file )
	{
		return subscriptions.Enabled( String( file.id ) );
	};

	$scope.Disable = function ( file )
	{
		lua.Run( "steamworks.SetShouldMountAddon( %s, false );", String( file.id ) )
		lua.Run( "steamworks.ApplyAddons();" )
	};

	$scope.Enable = function ( file )
	{
		lua.Run( "steamworks.SetShouldMountAddon( %s, true );", String( file.id ) )
		lua.Run( "steamworks.ApplyAddons();" )
	};
}
