
addon = new WorkshopFiles();

function ControllerAddons( $scope, $element, $rootScope, $location )
{
	$rootScope.ShowBack = true;
	Scope = $scope;

	// This is kind of annoying way of doing things
	$scope.CreatePresetOpen = false;
	$scope.CreatePresetSaveEnabled = true;
	$scope.CreatePresetSaveDisabled = true;
	$scope.CreatePresetNewAct = "disable";
	$scope.CreatePresetName = "";

	$scope.ImportPresetOpen = false;
	$scope.ImportPresetLoading = false;
	$scope.ImportPresetSource = "";

	$scope.PresetList = {}
	$scope.PresetSearchText = "";
	$scope.LoadPresetMenuOpen = false;
	$scope.LoadPresetResub = false;
	$scope.SelectedPreset = undefined;

	$scope.SelectedItems = {};
	$scope.PopupMessageDisplayed = false;
	$scope.PopupMessageFiles = [];
	$scope.PopupMessageDisplayedMessage = "addons.uninstallall.warning";

	// For testing
	if ( !IN_ENGINE )
	{
		for ( var i = 0; i < 24; i++ )
		{
			$scope.PresetList[ "test" + i ] = { name: "test name " + i, enabled: ["1"], disabled: [], newAction: "" }
		}
	}

	$scope.Categories =
	[
		"trending",
		"popular",
		"latest"
	];

	$scope.CategoriesSecondary =
	[
		"followed",
		"favorite",
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
	$scope.UGCSettingsOpen = false;
	$scope.UGCSortMethod = "subscribed";

	lua.Run( "UpdateAddonDisabledState()" );

	addon.Init( "addon", $scope, $rootScope );

	$scope.Switch( "subscribed", 0 );

	$scope.Subscribe = function( file )
	{
		if ( !file.info ) file.info = { children: [] };

		if ( file.info.children.length > 0 )
		{
			var needsWarning = false;
			for ( var i = 0; i < file.info.children.length; i++ )
			{
				var wsid = file.info.children[ i ];
				if ( !$scope.IsSubscribedID( wsid ) )
				{
					needsWarning = true;
					break;
				}
			}

			if ( needsWarning )
			{
				for ( var i = 0; i < file.info.children.length; i++ )
				{
					var wsid = file.info.children[ i ];
					lua.Run( "MenuGetAddonData( %s )", String( wsid ) );
				}

				$scope.PopupMessageFiles = file.info.children;
				$scope.DisplayPopupMessage( "addons.addon_depends", function()
				{
					subscriptions.Subscribe( file.id );
				} );
				return;
			}
		}

		subscriptions.Subscribe( file.id );
	}
	$scope.Unsubscribe = function( file )
	{
		subscriptions.Unsubscribe( file.id );
	}
	$scope.SubscribeByID = function( fileId )
	{
		subscriptions.Subscribe( fileId );
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
	$scope.IsSubscribedID = function( fileID )
	{
		return subscriptions.Contains( fileID );
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
	$scope.ClosePopupMessage = function( notPresetLoad )
	{
		$scope.PopupMessageDisplayed = false;
		$scope.PopupMessageFiles = [];

		$scope.CreatePresetOpen = false;
		$scope.ImportPresetOpen = false;
		if ( !notPresetLoad )
		{
			$scope.LoadPresetMenuOpen = false;
			$scope.SelectedPreset = undefined;
		}
	}
	$scope.ExecutePopupFunction = function()
	{
		$scope.ClosePopupMessage( true );
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
	$scope.SelectAllPage = function()
	{
		//$scope.UnselectAll(); // Unselect items that might be not in $scope.Files

		for ( var k in $scope.Files )
		{
			if ( parseInt( $scope.Files[ k ].id ) < 1 ) continue;
			$scope.SelectedItems[ $scope.Files[ k ].id ] = true;
		}
	}
	$scope.SelectAll = function()
	{
		$scope.UnselectAll(); // Unselect items that might be not in $scope.FilesOther

		if ( !$scope.FilesOther ) return;

		for ( var k in $scope.FilesOther )
		{
			var wsid = $scope.FilesOther[ k ];
			if ( parseInt( wsid ) < 1 ) continue;
			$scope.SelectedItems[ wsid ] = true;
		}
	}
	$scope.SelectAllSubs = function()
	{
		$scope.UnselectAll(); // Unselect items that might be not in subscriptions.GetAll()

		for ( var k in subscriptions.GetAll() ) $scope.SelectedItems[ k ] = true;
	}
	$scope.ToggleSelect = function( file, event )
	{
		var en = event.target.nodeName.toLowerCase();
		if ( en != "controls" && en != "description" && en != "workshopicon" ) return;

		$scope.SelectedItems[file.id] = !$scope.SelectedItems[file.id];
		if ( event ) event.stopPropagation();
	}
	$scope.EnableAllSelected = function()
	{
		for ( var k in $scope.SelectedItems )
		{
			if ( !$scope.SelectedItems[ k ] || k < 1 ) continue;

			subscriptions.SetShouldMountAddon( k, true );
			$scope.SelectedItems[ k ] = false;
		}
		subscriptions.ApplyChanges();
	}
	$scope.DisableAllSelected = function()
	{
		for ( var k in $scope.SelectedItems )
		{
			if ( !$scope.SelectedItems[ k ] || k < 1 ) continue;

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
	$scope.GetSelectedCount = function()
	{
		var i = 0;
		for ( var k in $scope.SelectedItems )
		{
			if ( !$scope.SelectedItems[ k ] ) continue;

			i++;
		}
		return i;
	}
	$scope.GetSubscribedCount = function()
	{
		return subscriptions.GetCount();
	}

	$scope.ToggleSettings = function()
	{
		$scope.UGCSettingsOpen = !$scope.UGCSettingsOpen;
	}

	$scope.OpenImportPresetMenu = function()
	{
		// Reset to defaults..
		$scope.CreatePresetSaveEnabled = true;
		$scope.CreatePresetSaveDisabled = true;
		$scope.CreatePresetNewAct = "disable";
		$scope.CreatePresetName = "";
		$scope.ImportPresetSource = "";

		$scope.ImportPresetOpen = true
	}

	$scope.OpenCreatePresetMenu = function()
	{
		// Reset to defaults..
		$scope.CreatePresetSaveEnabled = true;
		$scope.CreatePresetSaveDisabled = true;
		$scope.CreatePresetNewAct = "disable";
		$scope.CreatePresetName = "";

		$scope.CreatePresetOpen = true;
	}
	$scope.CreateNewPreset = function()
	{
		if ( $scope.CreatePresetName == "" ) return;

		var newPreset = {
			enabled: [], disabled: [],
			name: $scope.CreatePresetName,
			newAction: $scope.CreatePresetNewAct
		}

		var files = subscriptions.GetAll();
		for ( var id in files )
		{
			var enabled = files[ id ].mounted;

			if ( enabled && $scope.CreatePresetSaveEnabled ) newPreset.enabled.push( id );
			if ( !enabled && $scope.CreatePresetSaveDisabled ) newPreset.disabled.push( id );
		}

		lua.Run( "CreateNewAddonPreset( %s )", JSON.stringify( newPreset ) );

		$scope.CreatePresetOpen = false;
	}

	$scope.OpenLoadPresetMenu = function()
	{
		lua.Run( "ListAddonPresets()" );
		$scope.LoadPresetMenuOpen = true;
		$scope.LoadPresetResub = false;
		$scope.SelectedPreset = undefined;
		$scope.PresetSearchText = "";
	}
	$scope.SelectPreset = function( preset, newAction )
	{
		$scope.SelectedPreset = preset;
		$scope.CreatePresetNewAct = newAction;
	}
	$scope.DeletePreset = function( preset )
	{
		$scope.DisplayPopupMessage( "addons.delete_preset_warn " + preset, function() {
			lua.Run( "DeleteAddonPreset( %s )", preset );
			$scope.SelectedPreset = undefined;
		} );
	}
	$scope.LoadSelectedPreset = function()
	{
		var preset = $scope.PresetList[ $scope.SelectedPreset ];
		var newAct = $scope.CreatePresetNewAct;

		// Resub to missing stuff
		if ( $scope.LoadPresetResub )
		{
			for ( var k in preset.disabled )
			{
				var id = preset.disabled[ k ];
				if ( !subscriptions.Contains( id ) ) subscriptions.Subscribe( id );
			}
			for ( var k in preset.enabled )
			{
				var id = preset.enabled[ k ];
				if ( !subscriptions.Contains( id ) ) subscriptions.Subscribe( id );
			}
			subscriptions.ApplyChanges();
		}

		var IDsDone = {};
		for ( var k in preset.disabled )
		{
			var id = preset.disabled[ k ];
			subscriptions.SetShouldMountAddon( id, false );
			IDsDone[ id ] = true;
		}
		for ( var k in preset.enabled )
		{
			var id = preset.enabled[ k ];
			subscriptions.SetShouldMountAddon( id, true );
			IDsDone[ id ] = true;
		}

		if ( newAct != "" )
		{
			var files = subscriptions.GetAll();
			for ( var id in files )
			{
				if ( !IDsDone[ id ] )
				{
					subscriptions.SetShouldMountAddon( id, newAct == "enable" );
				}
			}
		}

		subscriptions.ApplyChanges();
		$scope.LoadPresetMenuOpen = false;
		$scope.SelectedPreset = undefined;
	}

	$scope.CopySelectedPreset = function()
	{
		var preset = $scope.PresetList[ $scope.SelectedPreset ];
		var oldHashKey = preset[ "$$hashKey" ]; // Bit of a hack
		preset[ "$$hashKey" ] = undefined;
		lua.Run( "SetClipboardText( %s )", JSON.stringify( preset ) );
		preset[ "$$hashKey" ] = oldHashKey;
	}

	$scope.ImportPreset = function()
	{
		if ( $scope.CreatePresetName == "" ) return;

		$scope.ImportPresetOpen = false;

		// Try extracting workshop ID
		if ( $scope.ImportPresetSource.indexOf( "http" ) === 0 || /^([0-9]+)$/.test( $scope.ImportPresetSource ) )
		{
			$scope.ImportPresetLoading = true;
			var re = /https?:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?(?:.*)id=([0-9]+)(?:.*)/;
			var d = re.exec( $scope.ImportPresetSource );

			// Try just the ID
			if ( !d || !d[ 1 ] )
			{
				var re2 = /([0-9]+)/;
				d = re2.exec( $scope.ImportPresetSource );
			}

			if ( !d || !d[ 1 ] )
			{
				OnImportPresetFailed();
			}
			else
			{
				var newPreset = {
					enabled: [], disabled: [],
					name: $scope.CreatePresetName,
					newAction: $scope.CreatePresetNewAct
				}

				lua.Run( "ImportAddonPreset( %s, %s )", d[ 1 ], JSON.stringify( newPreset ) );
			}
		}
		else
		{
			try
			{
				var importedPreset = JSON.parse( $scope.ImportPresetSource );
				var newPreset = {
					enabled: importedPreset.enabled || [],
					disabled: importedPreset.disabled || [],
					name: $scope.CreatePresetName,
					newAction: $scope.CreatePresetNewAct
				}

				lua.Run( "CreateNewAddonPreset( %s )", JSON.stringify( newPreset ) );
			}
			catch ( err )
			{
				OnImportPresetFailed();
			}
		}
	}

	$scope.GetAddonClasses = function( file )
	{
		var classes = [];
		if ( $scope.IsSubscribed( file ) )
		{
			classes.push( $scope.IsEnabled( file ) ? "installed" : "disabled" );
			if ( subscriptions.GetInvalidReason( file.id ) ) classes.push( "invalid" );
		}

		if ( file.info && file.info.floating ) classes.push( "floating" );

		return classes.join( " " );
	}

	$scope.GetAddonDescription = function( file )
	{
		var invalid = subscriptions.GetInvalidReason( file.id )
		if ( invalid ) return invalid;

		if ( !file.info ) return "ERROR?";

		return file.info.description
	}

	$scope.GetNiceSize = function( size )
	{
		if ( !size || size <= 0 ) return "0 Bytes"
		if ( size < 1000 ) return size + " Bytes"
		if ( size < 1000 * 1000 ) return Math.round( size / 1000, 2 ) + " KB"
		if ( size < 1000 * 1000 * 1000 ) return Math.round( size / ( 1000 * 1000 ), 2 ) + " MB"

		return Math.round( size / ( 1000 * 1000 * 1000 ), 2 ) + " GB"
	}
}

function ReceivedChildAddonInfo( info )
{
	var elem = document.getElementById( "wsid" + info.id )
	elem.innerText = info.title
}

function OnReceivePresetList( list )
{
	if ( !Scope ) return;

	Scope.PresetList = list;
	Scope.ImportPresetLoading = false;
	UpdateDigest( Scope, 50 );
}

function OnImportPresetFailed()
{
	if ( !Scope ) return;

	Scope.ImportPresetLoading = false;
	Scope.DisplayPopupMessage( "addons.import_preset_notcollection" );
	UpdateDigest( Scope, 50 );
}

function UpdateAddonDisabledState( noaddons, noworkshop )
{
	if ( !Scope ) return;

	Scope.Disabled = noworkshop;
	UpdateDigest( Scope, 50 );
}

function OnSubscriptionsChanged()
{
	if ( !Scope || !Scope.RefreshCurrentView ) return;

	Scope.RefreshCurrentView();
}
