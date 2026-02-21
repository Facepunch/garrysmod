
function WorkshopFiles()
{

}

//
// Initialize
//
WorkshopFiles.prototype.Init = function( namespace, scope, RootScope )
{
	var self = this;

	this.NameSpace	= namespace;
	this.Scope		= scope;
	this.RootScope	= RootScope;

	this.Scope.Offset			= 0;
	this.Scope.TotalResults		= 0;
	this.Scope.Category			= "";
	this.Scope.Loading			= true;
	this.Scope.PerPage			= 5;

	// Addon Subscriptions menu exclusive
	this.Scope.SubscriptionSearchText = "";

	this.Scope.Go = function( delta )
	{
		if ( scope.Offset + delta >= scope.TotalResults ) return;
		if ( scope.Offset + delta < 0 ) return;

		scope.SwitchWithTag( scope.Category, scope.Offset + delta, scope.Tagged, scope.MapName )
	}

	this.Scope.GoToPage = function( page )
	{
		var Offset = ( page - 1 ) * scope.PerPage;

		if ( Offset >= scope.TotalResults ) return;
		if ( Offset < 0 ) return;

		scope.SwitchWithTag( scope.Category, Offset, scope.Tagged, scope.MapName )
	}

	this.Scope.Switch = function( type, offset )
	{
		this.SwitchWithTag( type, offset, "", scope.MapName );
	}

	this.Scope.HandleFilterChange = function( which )
	{
		if ( which == 1 ) scope.FilterDisabledOnly = false;
		if ( which == 0 ) scope.FilterEnabledOnly = false;
		scope.SwitchWithTag( scope.Category, 0, scope.Tagged, scope.MapName )
	}

	this.Scope.HandleSortChange = function()
	{
		scope.SwitchWithTag( scope.Category, 0, scope.Tagged, scope.MapName )
	}

	// Refresh current page, etc
	this.Scope.RefreshCurrentView = function()
	{
		scope.SwitchWithTag( scope.Category, scope.Offset, scope.Tagged, scope.MapName )
	}

	var hackyWackyTimer = 0;
	this.Scope.HandleOnSearch = function()
	{
		clearTimeout( hackyWackyTimer );
		hackyWackyTimer = setTimeout( function()
		{
			scope.SwitchWithTag( scope.Category, 0, scope.Tagged, scope.MapName )
		}, 500 );
	}

	this.Scope.SwitchWithTag = function( type, offset, searchtag, mapname )
	{
		clearTimeout( hackyWackyTimer );

		// Fills in perpage
		self.RefreshDimensions();

		if ( scope.Category != type || scope.Tagged != searchtag ) scope.TotalResults = 0;

		scope.Category	= type;
		scope.Tagged	= searchtag;
		scope.MapName	= mapname;
		scope.Offset	= offset;
		scope.Loading	= true;

		if ( !scope.Tagged ) scope.Tagged = '';

		if ( IS_SPAWN_MENU )
		{
			RootScope.Category		= type;
			RootScope.CreationType	= namespace;
			RootScope.Tagged		= searchtag;
		}

		var filter = "";
		if ( scope.FilterEnabledOnly ) filter = "enabledonly";
		if ( scope.FilterDisabledOnly ) filter = "disabledonly";

		self.UpdatePageNav();

		if ( !IN_ENGINE )
		{
			setTimeout( function() { WorkshopTestData( scope.Category, self, scope.PerPage ); }, 0 );
		}
		else
		{
			// fumble
			if ( scope.MapName && scope.Tagged )
			{
				gmod.FetchItems( self.NameSpace, scope.Category, scope.Offset, scope.PerPage, scope.Tagged + "," + scope.MapName, scope.SubscriptionSearchText, filter, scope.UGCSortMethod );
			}
			else if ( scope.MapName )
			{
				gmod.FetchItems( self.NameSpace, scope.Category, scope.Offset, scope.PerPage, scope.MapName, scope.SubscriptionSearchText, filter, scope.UGCSortMethod );
			}
			else
			{
				gmod.FetchItems( self.NameSpace, scope.Category, scope.Offset, scope.PerPage, scope.Tagged, scope.SubscriptionSearchText, filter, scope.UGCSortMethod );
			}
		}
	}

	this.Scope.Rate = function( entry, b )
	{
		if ( !entry.id ) return;
		if ( b && entry.info.voted_up ) return;
		if ( !b && entry.info.voted_down ) return;

		// Cast our vote
		gmod.Vote( entry.id, ( b ? "1" : "0" ) )

		// Update the scores locally (the votes don't update on the server straight away)
		if ( entry.info )
		{
			if ( b )
			{
				entry.info.voted_up = true;
				entry.info.voted_down = false;
			}
			else
			{
				entry.info.voted_up = false;
				entry.info.voted_down = true;
			}
			if ( b ) entry.info.up++; else entry.info.down++;
		}

		// And play a sound
		if ( b )	lua.PlaySound( "npc/roller/mine/rmine_chirp_answer1.wav" );
		else 		lua.PlaySound( "buttons/button10.wav" );

	}

	this.Scope.Favorite = function( entry, b )
	{
		if ( !entry.id ) return;

		// Update favorite button
		entry.info.favorite = b;

		// Set favorite status
		gmod.SetFavorite( entry.id, ( b ? "1" : "0" ) )

		// And play a sound
		if ( b )	lua.PlaySound( "npc/roller/mine/rmine_chirp_answer1.wav" );
		else 		lua.PlaySound( "buttons/button10.wav" );
	}

	this.Scope.PublishLocal = function( entry )
	{
		gmod.Publish( self.NameSpace, entry.info.file, entry.background )
	}
}

//
// Received a local list of files (think saves on disk)
//
WorkshopFiles.prototype.ReceiveLocal = function( data )
{
	this.Scope.Loading		= false;
	this.Scope.TotalResults	= Math.max( this.Scope.TotalResults, data.totalresults );
	this.Scope.NumResults	= data.results.length;

	this.Scope.Files = []

	for ( var k in data.results )
	{
		var entry =
		{
			order		: k,
			local		: true,
			background	: data.results[k].preview,
			filled		: true,
			info		:
			{
				title	: data.results[k].name,
				file	: data.results[k].file,
				description	: data.results[k].description,
			}
		};

		this.Scope.Files.push( entry );
	}

	this.UpdatePageNav();
	this.Changed();
}

//
// The index contains the number of saves,
// and the save id's - but no details.
// (they come later)
//
WorkshopFiles.prototype.ReceiveIndex = function( data )
{
	this.Scope.Loading		= false;
	this.Scope.TotalResults	= Math.max( this.Scope.TotalResults, data.totalresults );
	this.Scope.NumResults	= data.numresults;

	this.Scope.Files = [];
	for ( var k in data.results )
	{
		var entry =
		{
			order	: k,
			id		: data.results[k],
			filled	: false,
			extra	: data.extraresults ? data.extraresults[ k ] : {},
		};

		this.Scope.Files.push( entry );
	}

	this.Scope.FilesOther = [];
	if ( data.otherresults )
	{
		for ( var j in data.otherresults )
		{
			this.Scope.FilesOther.push( data.otherresults[ j ] );
		}
	}

	this.UpdatePageNav();
	this.Changed();
}

//
// ReceiveFileInfo
//
WorkshopFiles.prototype.ReceiveFileInfo = function( id, data )
{
	for ( var k in this.Scope.Files )
	{
		if ( this.Scope.Files[k].id != id ) continue;

		this.Scope.Files[k].filled	= true;
		this.Scope.Files[k].info	= data;

		this.Changed();
	}
}
WorkshopFiles.prototype.ReceiveFileUserInfo = function( id, data )
{
	for ( var k in this.Scope.Files )
	{
		if ( this.Scope.Files[k].id != id ) continue;

		this.Scope.Files[k].info.favorite = data.favorite;
		this.Scope.Files[k].info.voted_up = data.voted_up;
		this.Scope.Files[k].info.voted_down = data.voted_down;

		this.Changed();
	}
}

//
// ReceiveUserName
//
WorkshopFiles.prototype.ReceiveUserName = function( id, data )
{
	for ( var k in this.Scope.Files )
	{
		if ( !this.Scope.Files[k].filled || !this.Scope.Files[k] || this.Scope.Files[k].info.owner != id ) continue;

		this.Scope.Files[k].filled	= true;
		this.Scope.Files[k].info.ownername = data;

		this.Changed();
	}
}

//
// ReceiveImage
//
WorkshopFiles.prototype.ReceiveImage = function( id, url )
{
	for ( var k in this.Scope.Files )
	{
		if ( this.Scope.Files[k].id != id ) continue;

		this.Scope.Files[k].background = url;
		this.Changed();
	}
}

WorkshopFiles.prototype.Changed = function()
{
	this.Scope.$digest();

	// An update is queued - so chill
	if ( this.DigestUpdate ) return;

	var self = this;

	// Update the digest in 10ms
	this.DigestUpdate = setTimeout( function()
	{
		self.DigestUpdate = 0;
		self.Scope.$digest();
	}, 10 )
}

WorkshopFiles.prototype.RefreshDimensions = function()
{
	var w = Math.max( 180, $( "workshopcontainer" ).width() );
	var h = Math.max( 180, $( "workshopcontainer" ).height() - 48 );

	var iconswide = Math.floor( w / 180 );
	var iconstall = Math.floor( h / 180 );

	if ( iconswide > 6 ) iconswide = 6;
	if ( iconstall > 4 ) iconstall = 4;

	self.Scope.PerPage = iconswide * iconstall;

	self.Scope.IconWidth	= Math.floor( w / iconswide ) - 26;
	self.Scope.IconHeight	= Math.floor( h / iconstall ) - 26;
	self.Scope.IconMax		= Math.max( self.Scope.IconWidth, self.Scope.IconHeight ) + 1;
}

WorkshopFiles.prototype.UpdatePageNav = function()
{
	self.Scope.Page = Math.floor( self.Scope.Offset / self.Scope.PerPage ) + 1;

	var maxPages = 32;
	var realMaxPages = Math.ceil( self.Scope.TotalResults / self.Scope.PerPage )
	self.Scope.NumPages = Math.min( realMaxPages, maxPages );

	var pageOfPages = Math.floor( ( self.Scope.Page - 1 ) / ( maxPages ) );
	var pageOffset = pageOfPages * maxPages;

	self.Scope.Pages = [];
	for ( var i = pageOffset + 1; i < Math.min( realMaxPages + 1, pageOffset + 1 + maxPages ); i++ )
	{
		self.Scope.Pages.push( i );
	}
}
