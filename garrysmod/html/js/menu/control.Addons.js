
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
	}
	$scope.Unsubscribe = function( file )
	{
		subscriptions.Unsubscribe( file.id );
	}
	$scope.UninstallAllSubscribed = function()
	{
		subscriptions.UnsubscribeAll();
		subscriptions.ApplyChanges();
	}
	$scope.IsSubscribed = function( file )
	{
		return subscriptions.Contains( file.id );
	}

	$scope.DisableAllSubscribed = function()
	{
		subscriptions.SetAllEnabled( false );
		subscriptions.ApplyChanges();
	}
	$scope.EnableAllSubscribed = function()
	{
		subscriptions.SetAllEnabled( true );
		subscriptions.ApplyChanges();
	}
	$scope.IsEnabled = function( file )
	{
		return subscriptions.Enabled( file.id );
	}
	$scope.Disable = function( file )
	{
		subscriptions.SetShouldMountAddon( String( file.id ), false );
		subscriptions.ApplyChanges();
	}
	$scope.Enable = function( file )
	{
		subscriptions.SetShouldMountAddon( String( file.id ), true );
		subscriptions.ApplyChanges();
	}

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
		if ( $scope.PopupMessageDisplayedFunc )
		{
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
		for ( var k in $scope.SelectedItems )
		{
			if ( !$scope.SelectedItems[ k ] ) continue;

			subscriptions.SetShouldMountAddon( k, true );
			$scope.SelectedItems[ k ] = false;
		}
		subscriptions.ApplyChanges();
	}
	$scope.DisableAllSelected = function()
	{
		for ( var k in $scope.SelectedItems )
		{
			if ( !$scope.SelectedItems[ k ] ) continue;

			subscriptions.SetShouldMountAddon( k, false );
			$scope.SelectedItems[ k ] = false;
		}
		subscriptions.ApplyChanges();
	}
	$scope.UninstallAllSelected = function()
	{
		for ( var k in $scope.SelectedItems )
		{
			if ( !$scope.SelectedItems[ k ] ) continue;

			subscriptions.Unsubscribe( k );
			$scope.SelectedItems[ k ] = false;
		}
		subscriptions.ApplyChanges();
	}
	$scope.IsAnySelected = function()
	{
		for ( var k in $scope.SelectedItems )
		{
			if ( $scope.SelectedItems[ k ] ) return true;
		}
		return false;
	}
}

function UpdateAddonDisabledState( noaddons, noworkshop )
{
	if ( Scope ) {
		Scope.Disabled = noworkshop;
		UpdateDigest( Scope, 50 );
	}
}
