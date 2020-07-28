
function Subscriptions()
{

}

//
// Initialize
//
Subscriptions.prototype.Init = function( scope )
{
	this.Scope = scope;
	this.Files = {};
	this.FilesUGC = {};
}

//
// Contains
//
Subscriptions.prototype.Contains = function( id )
{
	id = String( id );
	if ( this.FilesUGC[ id ] != null ) return true;
	return this.Files[ id ] != null;
}

//
// IsEnabled
//
Subscriptions.prototype.Enabled = function( id )
{
	return this.Files[ String( id ) ].mounted;
}

//
// SetAllEnabled
//
Subscriptions.prototype.SetAllEnabled = function( bBool )
{
	bBool = bBool ? "true" : "false";

	for ( k in this.Files )
	{
		lua.Run( "steamworks.SetShouldMountAddon( %s, " + bBool + " );", String( k ) );
	}
}

Subscriptions.prototype.Subscribe = function( wsid )
{
	lua.Run( "steamworks.Subscribe( %s );", String( wsid ) );
}

Subscriptions.prototype.Unsubscribe = function( wsid )
{
	lua.Run( "steamworks.Unsubscribe( %s );", String( wsid ) );
}

//
// DeleteAll
//
Subscriptions.prototype.UnsubscribeAll = function()
{
	for ( k in this.Files )
	{
		lua.Run( "steamworks.Unsubscribe( %s );", String( k ) );
	}
}

//
// Update - called from engine
//
Subscriptions.prototype.Update = function( json )
{
	this.Files = {};

	for ( k in json )
	{
		this.Files[ String( json[k].wsid ) ] = json[ k ];
	}
}

// Called from engine for dupes/saves/demos
Subscriptions.prototype.UpdateUGC = function( json )
{
	this.FilesUGC = {};

	for ( k in json )
	{
		this.FilesUGC[ String( json[k].wsid ) ] = json[ k ];
	}

	UpdateDigest( this.Scope, 50 );
}
