
function WorkshopTestData( type, namespace, perpage )
{
	if ( type == 'friends' )
	{
		namespace.ReceiveIndex( { totalresults: 0 } );
		return;
	}

	var items = { totalresults: perpage * 90, results: [ 1234, 12345, 123, 1337 ] };

	for ( var i = items.results.length; i < perpage; i++ )
	{
		items.results.push( Math.floor( Math.random() * 100000000 ) )
	}
	namespace.ReceiveIndex( items );


	namespace.ReceiveFileInfo( 1234, { "score": 0.95, "total": 22, "down": 1, "up": 21, "created": 1.33679e+009, "ownername": "garry :D", "description": "The name explains what to do.\n\nUse your crossbow to assasinate Breen and his bodyguards!", "tags": "save", "id": "71502490", "owner": "76561197965224200", "previewsize": 16322, "previewid": "540675364321761226", "updated": 1.33679e+009, "title": "Assasinate Breen.", "disabled": false, "installed": false, "banned": false, "size": 21733, "fileid": "540675364321760831" } )
	namespace.ReceiveFileInfo( 12345, { "score": 0, "total": 0, "down": 0, "up": 0, "created": 1.33679e+009, "description": "The name explains what to do.\n\nUse your crossbow to assasinate Breen and his bodyguards!", "tags": "save", "id": "71502490", "owner": "76561197965224200", "previewsize": 16322, "previewid": "540675364321761226", "updated": 1.33679e+009, "title": "Really long title that is actually really long it needs to be longer so long that it overflows the width for sure", "disabled": false, "installed": false, "banned": false, "size": 21733, "fileid": "540675364321760831" } )
	namespace.ReceiveFileInfo( 123, { "score": 0, "total": 0, "down": 0, "up": 0, "created": 1.33679e+009, "description": "fpei9ufaf9pwiufjawpif", "tags": "save", "id": "71502490", "owner": "76561197965224200", "previewsize": 16322, "previewid": "540675364321761226", "updated": 1.33679e+009, "title": "dfayhfuiofhawofiuawfihawofuawhfoaiuwf", "disabled": false, "installed": true, "banned": false, "size": 21733, "fileid": "540675364321760831" } )
	namespace.ReceiveFileInfo( 1337, { "floating": 1,"score": 0, "total": 0, "down": 0, "up": 0, "created": 1.33679e+009, "description": "FLOATING", "tags": "save", "id": "71502490", "owner": "76561197965224200", "previewsize": 16322, "previewid": "540675364321761226", "updated": 1.33679e+009, "title": "FLOATING FLOATING FLOATING FLOATING FLOATING FLOATING FLOATING FLOATING ", "disabled": false, "installed": true, "banned": false, "size": 21733, "fileid": "540675364321760831" } )

	namespace.ReceiveImage( 1234, "img/creation-play.png" );
	namespace.ReceiveImage( 12345, "img/localaddon.png" );

	subscriptions.Files[ "1234" ] = { mounted: false };
	subscriptions.Files[ "123" ] = { mounted: true };
}
