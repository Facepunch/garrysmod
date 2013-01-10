
var ServerSettings = []
var scope = null;

function ControllerNewGame( $scope, $element, $rootScope, $location )
{
	$scope.CurrentCategory = "Sandbox";

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
	
	if ( !$rootScope.Map )				$rootScope.Map = "gm_flatgrass";
	if ( !$rootScope.MaxPlayers )		$rootScope.MaxPlayers = 1;
	if ( !$rootScope.ServerSettings )	$rootScope.ServerSettings = ServerSettings;

	lua.Run( "UpdateServerSettings()" );

	scope = $rootScope;
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

	$scope.StartGame = function()
	{
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



function MapImageError( element )
{
	element.src = "../maps/noicon.png";
	return true;
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
	
	if ( scope )
	{
		scope.ServerSettings = sttngs;
		UpdateDigest( scope, 50 );
	}

	ServerSettings = sttngs;
}