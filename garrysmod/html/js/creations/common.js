
var IN_ENGINE		= navigator.userAgent.indexOf( "Valve Source Client" ) != -1;
var IS_SPAWN_MENU	= true

function UpdateDigest( scope, timeout )
{
	if ( !scope ) return;
	if ( scope.DigestUpdate ) return;

	scope.DigestUpdate = setTimeout( function ()
	{
		scope.DigestUpdate = 0;
		scope.$digest();

	}, timeout )
}

App.filter( 'startFrom', function ()
{
	return function ( input, start )
	{
		start = +start; //parse to int
		return input.slice( start );
	}
});
