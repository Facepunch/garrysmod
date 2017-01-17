
function Subscriptions()
{

}

//
// Initialize
//
Subscriptions.prototype.Init = function( scope )
{
	this.Scope = scope;
	this.Files = {}
}

//
// Contains
//
Subscriptions.prototype.Contains = function ( id )
{
	return this.Files[ id ] != null;
}

//
// IsEnabled
//
Subscriptions.prototype.Enabled = function ( id )
{
	return this.Files[id].mounted;
}

//
// ToggleMountTrick
//

Subscriptions.prototype.ToggleMountTrick = function( id )
{
	this.Files[id].mounted = !this.Files[id].mounted;
}

//
// IsEnabled
//
Subscriptions.prototype.SetAllEnabled = function( bBool )
{
	bBoolStr = bBool ? "true" : "false"

	for ( k in this.Files )
	{
		lua.Run( "steamworks.SetShouldMountAddon( %s, "+bBoolStr+" );", String( k ) )
		this.Files[k].mounted = bBool
	}
}

//
// Update - called from engine
//
Subscriptions.prototype.Update = function ( json )
{
	this.Files = {}

	for ( k in json )
	{
		this.Files[ String( json[k].wsid ) ] = json[k]
	}
}
