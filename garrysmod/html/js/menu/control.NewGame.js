
var ServerSettings = []
var scope = null;
var rootScope = null;

var savedMapName = null
var savedMapCategory = null

App.filter( 'mapFilter', function() {
	return function( items, search )
	{
		if ( !search ) return items;

		var addonMaps = [];
		for ( var addonName in gScope.AddonMapList )
		{
			if ( addonName.toLowerCase().indexOf( search.toLowerCase() ) == -1 ) continue;

			addonMaps = addonMaps.concat( gScope.AddonMapList[ addonName ] );
		}

		return items.filter( function( item, index, array )
		{
			if ( addonMaps.indexOf( item + ".bsp" ) != -1 ) return true;

			return item.toLowerCase().indexOf( search.toLowerCase() ) != -1;
		} );
	}
} );

function ControllerNewGame( $scope, $element, $rootScope, $location, $filter )
{
	if ( ( !$rootScope.Map || !$rootScope.LastCategory ) && savedMapName && savedMapCategory )
	{
		$rootScope.Map = savedMapName;
		$rootScope.LastCategory = savedMapCategory;
	}

	if ( !$scope.CurrentCategory && $rootScope.LastCategory )
	{
		$scope.CurrentCategory = $rootScope.LastCategory;
	}
	else if ( !$scope.CurrentCategory )
	{
		// Use Favourites or Sandbox as a default category, if none set
		$scope.CurrentCategory = "Sandbox";

		var favMaps = Object.keys( gScope.MapListFav );
		if ( favMaps.length > 0 )
		{
			$scope.CurrentCategory = "Favourites";
			if ( !$rootScope.Map ) $rootScope.Map = favMaps[0];
		}
	}

	// Scroll the selected map into view
	setTimeout( function() {
		var elem = document.querySelector( '.mapicon.selected' );
		if ( elem ) elem.scrollIntoView( { behavior: 'smooth', block: 'center' } );
	}, 100 );

	$scope.Players =
	[
		{ num: 1, label: 'maxplayers_1' },
		{ num: 2, label: 'maxplayers_2' },
		{ num: 4, label: 'maxplayers_4' },
		{ num: 8, label: 'maxplayers_8' },
		{ num: 16, label: 'maxplayers_16' },
		{ num: 32, label: 'maxplayers_32' },
		{ num: 64, label: 'maxplayers_64' },
		{ num: 128, label: 'maxplayers_128' },
	]

	$scope.MaxPlayersOption = $scope.Players[0];

	if ( localStorage.MaxPlayers )
	{
		var maxPlayers = localStorage.MaxPlayers;
		for ( var i = 0; i < $scope.Players.length; i++ )
		{
			if ( $scope.Players[i].num == maxPlayers )
			{
				$scope.MaxPlayersOption = $scope.Players[i];
				$rootScope.MaxPlayers = maxPlayers;
				break;
			}
		}
	}

	if ( !$rootScope.Map )				$rootScope.Map = "gm_flatgrass";
	if ( !$rootScope.MaxPlayers )		$rootScope.MaxPlayers = 1;
	if ( !$rootScope.ServerSettings )	$rootScope.ServerSettings = ServerSettings;
	if ( !$rootScope.LastCategory )		$rootScope.LastCategory = $scope.CurrentCategory;

	lua.Run( "UpdateServerSettings()" );

	rootScope = $rootScope;
	scope = $scope;

	$rootScope.ShowBack = true;

	$scope.SwitchCategory = function( cat )
	{
		$scope.CurrentCategory = cat;
	}

	$scope.MapClass = function( m )
	{
		if ( m == $rootScope.Map )
			return "selected";

		return "";
	}

	$scope.SelectMap = function ( m )
	{
		$rootScope.Map = m;
		$rootScope.LastCategory = $scope.CurrentCategory;
	}

	$scope.DblClickMap = function( m )
	{
		$scope.SelectMap( m );

		$scope.StartGame();
	}

	$scope.FavMap = function( m )
	{
		lua.Run( 'ToggleFavourite( %s )', m );
	}

	$scope.MapIcon = function( m, cat )
	{
		// BSP version 21
		if ( /*cat == "Left 4 Dead 2" || cat == "Portal 2" || cat == "CS: Global Offensive" || cat == "Blade Symphony" || cat == "Alien Swarm" || cat == "Dino D-Day" ||*/ cat == "INFRA" )
		{
			return "img/incompatible.png"
		}

		// Hopefully this also improves performance of the first click on "Start new game".
		if ( !IN_ENGINE || $scope.CurrentCategory != cat ) return "img/downloading.png"

		return "asset://mapimage/" + m;
	}

	$scope.IsFavMap = function( m )
	{
		return gScope.MapListFav[m.toLowerCase()] || false;
	}

	$scope.StartGame = function()
	{
		lua.Run( 'SaveLastMap( %s, %s )', $rootScope.Map, $rootScope.LastCategory );

		lua.Run( 'hook.Run( "StartGame" )' );
		lua.Run( 'RunConsoleCommand( "progress_enable" )' );

		lua.Run( 'RunConsoleCommand( "disconnect" )' );
		lua.Run( 'RunConsoleCommand( "maxplayers", %s )', String( $rootScope.MaxPlayers ) );

		if ( $rootScope.MaxPlayers > 0 )
		{
			lua.Run( 'RunConsoleCommand( "sv_cheats", "0" )' );
			//lua.Run( 'RunConsoleCommand( "commentary", "0" )' );
		}

		// $scope.ServerSettings gets changed from Lua between this point and the timeout below
		// Perhaps UpdateServerSettings() in mainmenu.lua shouldn't call to JS if the gamemode wasn't actually changed?
		// Or maybe this entire system needs changing
		$scope.ServerSettingsSaved = $scope.ServerSettings;

		setTimeout( function()
		{
			for ( k in $scope.ServerSettingsSaved.Numeric )
			{
				lua.Run( 'RunConsoleCommand( %s, %s )', $scope.ServerSettingsSaved.Numeric[ k ].name, String( $scope.ServerSettingsSaved.Numeric[ k ].Value ) );
			}

			for ( k in $scope.ServerSettingsSaved.Text )
			{
				lua.Run( 'RunConsoleCommand( %s, %s )', $scope.ServerSettingsSaved.Text[ k ].name, $scope.ServerSettingsSaved.Text[ k ].Value );
			}

			for ( k in $scope.ServerSettingsSaved.CheckBox )
			{
				lua.Run( 'RunConsoleCommand( %s, %s )', $scope.ServerSettingsSaved.CheckBox[ k ].name, $scope.ServerSettingsSaved.CheckBox[ k ].Value ? "1" : "0" );
			}

			lua.Run( 'RunConsoleCommand( "hostname", %s )', $scope.ServerSettingsSaved.hostname );
			lua.Run( 'RunConsoleCommand( "p2p_enabled", %s )', $scope.ServerSettingsSaved.p2p_enabled ? "1" : "0" );
			lua.Run( 'RunConsoleCommand( "p2p_friendsonly", %s )', $scope.ServerSettingsSaved.p2p_friendsonly ? "1" : "0" );
			lua.Run( 'RunConsoleCommand( "sv_lan", %s )', $scope.ServerSettingsSaved.sv_lan ? "1" : "0" );
			lua.Run( 'RunConsoleCommand( "maxplayers", %s )', String( $rootScope.MaxPlayers ) );
			lua.Run( 'RunConsoleCommand( "map", %s )', $rootScope.Map.trim() );

			$scope.ServerSettingsSaved = undefined;
		}, 200 );

		$location.url( "/" );
	}

	$scope.UpdateMaxPlayers = function( mp )
	{
		$scope.MaxPlayersOption = mp;
		$rootScope.MaxPlayers = $scope.MaxPlayersOption.num;
		localStorage.MaxPlayers = mp.num;
	}

	$scope.CountFiltered = function( maps )
	{
		if ( !$scope.SearchText )
			return maps.length;

		return $filter('mapFilter')( maps, $scope.SearchText ).length;
	}

	var oldSvLan = 0;
	var oldp2p = 0;

	$scope.CheckboxCheck = function()
	{
		$scope.ServerSettings.sv_lan = Number( $scope.ServerSettings.sv_lan ) == 1;
		$scope.ServerSettings.p2p_enabled = Number( $scope.ServerSettings.p2p_enabled ) == 1;

		if ( oldSvLan != $scope.ServerSettings.sv_lan && $scope.ServerSettings.sv_lan == true && $scope.ServerSettings.p2p_enabled == true )
		{
			$scope.ServerSettings.p2p_enabled = false;
		}
		else if ( oldp2p != $scope.ServerSettings.p2p_enabled && $scope.ServerSettings.p2p_enabled == true && $scope.ServerSettings.sv_lan == true )
		{
			$scope.ServerSettings.sv_lan = false;
		}

		oldp2p = $scope.ServerSettings.p2p_enabled;
		oldSvLan = $scope.ServerSettings.sv_lan;
		
		document.getElementById( "p2p_friendsonly" ).disabled = !$scope.ServerSettings.p2p_enabled;
	}
}

function SetLastMap( map, category )
{
	savedMapName = map;
	savedMapCategory = category;
}

function UpdateServerSettings( sttngs )
{
	sttngs.CheckBox = [];
	sttngs.Numeric = [];
	sttngs.Text = [];

	sttngs.maxplayers = parseInt( sttngs.maxplayers );
	sttngs.p2p_friendsonly = Number( sttngs.p2p_friendsonly ) == 1;
	sttngs.p2p_enabled = Number( sttngs.p2p_enabled ) == 1;
	sttngs.sv_lan = Number( sttngs.sv_lan ) == 1;

	if ( sttngs.settings )
	{
		for ( k in sttngs.settings )
		{
			var s = sttngs.settings[k]
			if ( s.type == "CheckBox" ) { s.Value = s.Value == "1"; sttngs.CheckBox.push( s ); }
			if ( s.type == "Numeric" ) { sttngs.Numeric.push( s ); }
			if ( s.type == "Text" ) { sttngs.Text.push( s ); }
		}
	}

	if ( rootScope )
	{
		rootScope.ServerSettings = sttngs;
		UpdateDigest( rootScope, 50 );
	}

	ServerSettings = sttngs;
}
