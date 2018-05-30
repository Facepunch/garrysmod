
addon = new WorkshopFiles();

function ControllerAddons( $scope, $element, $rootScope, $location )
{
	$rootScope.ShowBack = true;
	Scope = $scope;

	$scope.SelectedItems = {};
	$scope.PopupMessageDisplayed = false;
	$scope.PopupMessageDisplayedMessage = "addons.uninstallall.warning";

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

	$scope.AddonTypes =
	[
		"gamemode",
		"map",
		"weapon",
		"tool",
		"npc",
		"entity",
		"effects",
		"vehicle",
		"model"
	];

	addon.Init( 'addon', $scope, $rootScope );

	$scope.Switch( 'subscribed', 0 );

	$scope.Subscribe = function( file )
	{
		lua.Run( "steamworks.Subscribe( %s );", String( file.id ) );

		// Update files if viewing subscribed list?
	};

	$scope.Unsubscribe = function( file )
	{
		lua.Run( "steamworks.Unsubscribe( %s );", String( file.id ) );

		// Update files if viewing subscribed list?
	};

	$scope.DisableAllSubscribed = function()
	{
		subscriptions.SetAllEnabled( false );
		lua.Run( "steamworks.ApplyAddons();" );
	}

	$scope.EnableAllSubscribed = function()
	{
		subscriptions.SetAllEnabled( true );
		lua.Run( "steamworks.ApplyAddons();" );
	}

	$scope.UninstallAllSubscribed = function()
	{
		subscriptions.DeleteAll();
		lua.Run( "steamworks.ApplyAddons();" );
	}

	$scope.IsSubscribed = function( file )
	{
		return subscriptions.Contains( String( file.id ) );
	};

	$scope.IsEnabled = function( file )
	{
		return subscriptions.Enabled( String( file.id ) );
	};

	$scope.Disable = function( file )
	{
		lua.Run( "steamworks.SetShouldMountAddon( %s, false );", String( file.id ) )
		lua.Run( "steamworks.ApplyAddons();" )
	};

	$scope.Enable = function( file )
	{
		lua.Run( "steamworks.SetShouldMountAddon( %s, true );", String( file.id ) )
		lua.Run( "steamworks.ApplyAddons();" )
	};

	$scope.DisplayPopupMessage = function( txt, func )
	{
		$scope.PopupMessageDisplayed = true;
		$scope.PopupMessageDisplayedMessage = txt;
		$scope.PopupMessageDisplayedFunc = func;
	}
	$scope.ClosePopupMessage = function( txt, func )
	{
		$scope.PopupMessageDisplayed = false;
	}
	$scope.ExecutePopupFunction = function()
	{
		$scope.PopupMessageDisplayed = false;
		if ( $scope.PopupMessageDisplayedFunc ) {
			$scope.PopupMessageDisplayedFunc()
			$scope.PopupMessageDisplayedFunc = null;
		}
	}

	$scope.UnselectAll = function()
	{
		for ( var k in $scope.SelectedItems ) $scope.SelectedItems[ k ] = false;
	}
	$scope.EnableAllSelected = function()
	{
		for ( var k in $scope.SelectedItems ) {
			if ( !$scope.SelectedItems[ k ] ) continue;
			lua.Run( "steamworks.SetShouldMountAddon( %s, true );", String( k ) );
			$scope.SelectedItems[ k ] = false;
		}
		lua.Run( "steamworks.ApplyAddons();" )
	}
	$scope.DisableAllSelected = function()
	{
		for ( var k in $scope.SelectedItems ) {
			if ( !$scope.SelectedItems[ k ] ) continue;
			lua.Run( "steamworks.SetShouldMountAddon( %s, false );", String( k ) );
			$scope.SelectedItems[ k ] = false;
		}
		lua.Run( "steamworks.ApplyAddons();" )
	}
	$scope.UninstallAllSelected = function()
	{
		for ( var k in $scope.SelectedItems ) {
			if ( !$scope.SelectedItems[ k ] ) continue;
			lua.Run( "steamworks.Unsubscribe( %s );", String( k ) );
			$scope.SelectedItems[ k ] = false;
		}
		lua.Run( "steamworks.ApplyAddons();" )
	}
	$scope.IsAnySelected = function()
	{
		var count = 0;
		for ( var k in $scope.SelectedItems ) if ( $scope.SelectedItems[ k ] ) count++;
		return count > 0;
	}
}
