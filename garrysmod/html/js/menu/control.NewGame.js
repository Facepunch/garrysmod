
var ServerSettings = []
var scope = null;
var rootScope = null;

function ControllerNewGame( $scope, $element, $rootScope, $location, $filter )
{

	for ( var i = 0; i < gScope.MapList.length; i++ )
	{
		if ( gScope.MapList[i][ "category" ] == "Favourites" )
		{
			if ( !$scope.CurrentCategory ) $scope.CurrentCategory = "Favourites";
		}
	}

	if ( !$scope.CurrentCategory ) $scope.CurrentCategory = "Sandbox";

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

	if ( localStorage.MaxPlayers ) {
		var maxPlayers = localStorage.MaxPlayers;
		for (var i = 0; i < $scope.Players.length; i++) {
			if ( $scope.Players[i].num == maxPlayers ) {
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
	lua.Run( "LoadLastMap()" );

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
		$rootScope.LastCategory = $scope.CurrentCategory
	}

	$scope.DoubleClick = ""
	$scope.ClickMap = function( m )
	{
		$scope.SelectMap( m );

		if ( $scope.DoubleClick == m )
		{
			$scope.StartGame();
			return;
		}

		//
		// ng-dblclick doesn't work properly in engine, so we fake it!
		//
		$scope.DoubleClick = m;

		setTimeout( function()
		{
			$scope.DoubleClick = "";
		}, 500 )
	}

	$scope.FavMap = function( m )
	{
		lua.Run( 'ToggleFavourite( "' + m + '" )' );
	}

	$scope.MapIcon = function( m, cat )
	{
		// BSP version 21
		if ( cat == "Left 4 Dead 2" || cat == "Portal 2"  || cat == "CS: Global Offensive" || cat == "Blade Symphony" || cat == "Alien Swarm" || cat == "Dino D-Day" )
		{
			return "img/incompatible.png"
		}

		return "asset://mapimage/" + m
	}

	$scope.IsFavMap = function( m )
	{
		for ( var i = 0; i < gScope.MapList.length; i++ )
		{
			if ( gScope.MapList[i][ "category" ] == "Favourites" )
			{
				var obj = gScope.MapList[i][ "maps" ]
				for ( var map in obj )
				{
					if ( m == ( obj[ map ] ) ) return true
				}
			}
		}

		return false;
	}

	$scope.FavMapHover = function( m )
	{
		if ( this.IsFavMap( m ) ) return "faviconremove";
		return "faviconadd";
	}

	$scope.FavMapClass = function( m )
	{
		if ( this.IsFavMap( m ) ) return "favtoggle_always";
		return "favtoggle";
	}

	$scope.StartGame = function()
	{
		lua.Run( 'SaveLastMap( "' + $rootScope.Map + '", "' + $rootScope.LastCategory + '" )' );

		lua.Run( 'hook.Run( "StartGame" )' )
		lua.Run( 'RunConsoleCommand( "progress_enable" )' )

		lua.Run( 'RunConsoleCommand( "disconnect" )' )
		lua.Run( 'RunConsoleCommand( "maxplayers", "'+$rootScope.MaxPlayers+'" )' )

		if ( $rootScope.MaxPlayers > 0 )
		{
			lua.Run( 'RunConsoleCommand( "sv_cheats", "0" )' )
			lua.Run( 'RunConsoleCommand( "commentary", "0" )' )
		}

		setTimeout( function()
		{
			for ( k in $scope.ServerSettings.Numeric )
			{
				lua.Run( 'RunConsoleCommand( "'+$scope.ServerSettings.Numeric[k].name+'", "'+$scope.ServerSettings.Numeric[k].Value+'" )' )
			}

			for ( k in $scope.ServerSettings.Text )
			{
				lua.Run( 'RunConsoleCommand( "' + $scope.ServerSettings.Text[k].name + '", "' + $scope.ServerSettings.Text[k].Value + '" )' )
			}

			for ( k in $scope.ServerSettings.CheckBox )
			{
				lua.Run( 'RunConsoleCommand( "' + $scope.ServerSettings.CheckBox[k].name + '", "' + ($scope.ServerSettings.CheckBox[k].Value?1:0) + '" )' )
			}

			lua.Run( 'RunConsoleCommand( "hostname", "'+$rootScope.ServerSettings.hostname+'" )' )
			lua.Run( 'RunConsoleCommand( "sv_lan", "'+($rootScope.ServerSettings.sv_lan?1:0)+'" )' )
			lua.Run( 'RunConsoleCommand( "maxplayers", "'+$rootScope.MaxPlayers+'" )' )
			lua.Run( 'RunConsoleCommand( "map", "'+$rootScope.Map+'" )' )
			lua.Run( 'RunConsoleCommand( "hostname", "'+$rootScope.ServerSettings.hostname+'" )' )
		}, 200 );

		$location.url( "/" )
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

		return $filter('filter')(maps, $scope.SearchText).length;
	}
}

function SetLastMap( map, category )
{

	if ( scope ) {
		scope.CurrentCategory = category;
		UpdateDigest( scope, 50 );
	}

	if ( rootScope ) {
		rootScope.Map = map;
		rootScope.LastCategory = category;
		UpdateDigest( rootScope, 50 );
	}

}

function UpdateServerSettings( sttngs )
{
	sttngs.CheckBox = []
	sttngs.Numeric = []
	sttngs.Text = []

	sttngs.sv_lan		= parseInt( sttngs.sv_lan );
	sttngs.maxplayers	= parseInt( sttngs.maxplayers );

	if ( sttngs.settings )
	{
		for ( k in sttngs.settings )
		{
			var s = sttngs.settings[k]
			if ( s.type == "CheckBox" ){ s.Value = s.Value == "1"; sttngs.CheckBox.push( s ); }
			if ( s.type == "Numeric" ){	sttngs.Numeric.push( s ); }
			if ( s.type == "Text" ){	sttngs.Text.push( s ); }
		}
	}

	if ( rootScope )
	{
		rootScope.ServerSettings = sttngs;
		UpdateDigest( rootScope, 50 );
	}

	ServerSettings = sttngs;
}
