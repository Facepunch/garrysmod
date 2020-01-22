
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

	$scope.Disabled = false;
	lua.Run( "UpdateAddonDisabledState();" );

	addon.Init( 'addon', $scope, $rootScope );

	$scope.Switch( 'subscribed', 0 );

	$scope.Subscribe = function( file )
	{
		subscriptions.Subscribe( file.id );

		// Update files if viewing subscribed list?
	};

	$scope.Unsubscribe = function( file )
	{
		subscriptions.Unsubscribe( file.id );

		// Update files if viewing subscribed list?
	};

	$scope.UninstallAllSubscribed = function()
	{
		subscriptions.UnsubscribeAll();
		lua.Run( "steamworks.ApplyAddons();" );
	}

	$scope.IsSubscribed = function( file )
	{
		return subscriptions.Contains( file.id );
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

	$scope.IsEnabled = function( file )
	{
		return subscriptions.Enabled( file.id );
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

function UpdateAddonDisabledState( noaddons, noworkshop )
{
	if ( Scope ) {
		Scope.Disabled = noworkshop;
		UpdateDigest( Scope, 50 );
	}
}
