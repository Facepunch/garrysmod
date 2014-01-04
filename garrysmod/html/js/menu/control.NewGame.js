
var ServerSettings = []
var scope = null;
var rootScope = null;

function ControllerNewGame( $scope, $element, $rootScope, $location )
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
		{ num: 1, label: 'Single player' },
		{ num: 2, label: '2 Players' },
		{ num: 4, label: '4 Players' },
		{ num: 8, label: '8 Players' },
		{ num: 16, label: '16 Players' },
		{ num: 32, label: '32 Players' },
		{ num: 64, label: '64 Players' },
		{ num: 128, label: '128 Players' },
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
	if ( !$rootScope.LastCategory )			$rootScope.LastCategory = $scope.CurrentCategory;

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
		if ( m.Name == $rootScope.Map )
			return "selected";

		return "";
	}

	$scope.SelectMap = function ( m )
	{
		$rootScope.Map = m;
		$rootScope.LastCategory = $scope.CurrentCategory
	}

	$scope.ClickMap = function ( m )
	{
		$scope.SelectMap( m.Name );

		if ( m.DoubleClick )
		{
			$scope.StartGame();
			return;
		}

		//
		// ng-dblclick doesn't work properly in engine, so we fake it!
		//
		m.DoubleClick = true;

		setTimeout( function()
		{
			m.DoubleClick = false;
		}, 500 )
	}

	$scope.FavMap = function ( m )
	{
		lua.Run( 'ToggleFavourite( "' + m.Name + '" )' );
	}

	$scope.IsFavMap = function( m )
	{
		if ( m.Category == "Favourites" ) return true;

		for ( var i = 0; i < gScope.MapList.length; i++ )
		{
			if ( gScope.MapList[i][ "category" ] == "Favourites" )
			{
				var obj = gScope.MapList[i][ "maps" ]
				for ( var map in obj )
				{
					if ( m.Name == ( obj[ map ].Name ) ) return true
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

		var iCount = 0;
		for ( k in maps )
		{
			if ( maps[k].Name.search( $scope.SearchText ) != -1 ) iCount++;
		}

		return iCount;
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