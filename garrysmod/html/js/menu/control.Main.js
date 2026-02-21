
var scope = null
var rootScope = null;

function ControllerMain( $scope, $element, $rootScope )
{
	$rootScope.ShowBack = false;

	scope = $scope;
	rootScope = $rootScope;

	$scope.NewsList = [];
	$scope.CurrentNewsItem = null;
	$scope.HideNews = false;
	$scope.AnyNewNewsItems = false;

	if ( !IN_ENGINE )
	{
		$rootScope.NewsList = [
			{ HeaderImage: 'img/whatsnew.png', Title: 'December 2018 Hotfix', SummaryHtml: 'A security hotfix', Url: 'https://google.com/?q=1', Date: Date.now() },
			{ HeaderImage: 'img/whatsnew.png', Title: 'December 2018 Coldfix', SummaryHtml: 'A very long security hotfix example indeed like it is so long that i dont know how I will fit this stuff in the box', Url: 'https://google.com/?q=4' , Date: 0 },
			{ Title: 'Post without an image', SummaryHtml: 'They are very hard to make', Url: 'https://google.com/?q=2', Date: Date.now() - 604800000 - 10000 },
			{ HeaderImage: 'img/whatsnew.png', Title: 'December 2018 is a very long Security Hotfix that means we need to handle this', SummaryHtml: 'A security hotfix', Url: 'https://google.com/?q=3', Date: Date.now() - 604800000 + 10000 },
		]
	}

	$scope.NewsItemClass = function( NewsItem )
	{
		// If newer than a 3.5 days, force show news
		if ( Date.parse( NewsItem.Date ) > Date.now() - 302400000 )
		{
			$scope.AnyNewNewsItems = true; // Kind of a hack to do this here
			$scope.SetHideNewsList( false );
			return "new";
		}
		return "";
	}

	$scope.NewsItemBackground = function( url )
	{
		return "background-image: url( " + url + " )";
	}

	$scope.SelectItem = function( item )
	{
		$scope.SetHideNewsList( false, true );

		$scope.CurrentNewsItem = item;
	}

	$scope.OpenInSteam = function( url )
	{
		lua.Run( "gui.OpenURL( %s )", url );
	}

	$scope.SetHideNewsList = function( bHide, bSave )
	{
		$scope.HideNews = bHide;
		$rootScope.HideNews = $scope.HideNews;

		if ( bSave )
		{
			lua.Run( "SaveHideNews( %s )", $scope.HideNews ? "true" : "false" );
		}
	}
	$scope.ToggleNewsList = function()
	{
		$scope.SetHideNewsList( !$scope.HideNews, true );

		//$scope.CurrentNewsItem = undefined;
	}

	// Load it all up
	if ( $rootScope.NewsList )
	{
		$scope.NewsList = $rootScope.NewsList;
		$scope.SetHideNewsList( $rootScope.HideNews );
		$scope.CurrentNewsItem = $scope.NewsList[ 0 ];
	}
	else
	{
		lua.Run( "LoadNewsList()" );
	}
}

function UpdateNewsList( newslist, hide )
{
	scope.SetHideNewsList( hide );
	scope.NewsList = newslist;
	scope.CurrentNewsItem = /*scope.HideNews ? undefined :*/ newslist[ 0 ];

	if ( rootScope )
	{
		rootScope.HideNews = hide
		rootScope.NewsList = newslist;
		UpdateDigest( rootScope, 50 );
	}
}
