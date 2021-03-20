
function Subscriptions()
{
}

Subscriptions.prototype.Init = function( scope )
{
	this.Scope = scope;
	this.Files = {};
	this.FilesUGC = {};
}

Subscriptions.prototype.Contains = function( id )
{
	id = String( id );
	if ( this.FilesUGC[ id ] != null ) return true;
	return this.Files[ id ] != null;
}

Subscriptions.prototype.Enabled = function( id )
{
	return this.Files[ String( id ) ].mounted;
}

Subscriptions.prototype.GetInvalidReason = function( id )
{
	if ( !this.Files[ String( id ) ] ) return;
	return this.Files[ String( id ) ].invalid_reason;
}

Subscriptions.prototype.SetAllEnabled = function( bBool )
{
	for ( k in this.Files )
	{
		this.SetShouldMountAddon( k, bBool );
	}
}

Subscriptions.prototype.Subscribe = function( wsid )
{
	lua.Run( "steamworks.Subscribe( %s )", String( wsid ) );
}
Subscriptions.prototype.Unsubscribe = function( wsid )
{
	lua.Run( "steamworks.Unsubscribe( %s )", String( wsid ) );
}

Subscriptions.prototype.ApplyChanges = function()
{
	lua.Run( "steamworks.ApplyAddons()" )
}

Subscriptions.prototype.SetShouldMountAddon = function( wsid, bBool )
{
	bBool = bBool ? "true" : "false";
	lua.Run( "steamworks.SetShouldMountAddon( %s, " + bBool + " )", String( wsid ) );
}

Subscriptions.prototype.UnsubscribeAll = function()
{
	for ( k in this.Files )
	{
		this.Unsubscribe( k );
	}
}

// Ew
Subscriptions.prototype.GetAll = function()
{
	return this.Files;
}

// Called from engine for Subscriptions
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
