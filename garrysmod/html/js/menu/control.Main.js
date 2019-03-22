
var scope = null
var rootScope = null;

function ControllerMain( $scope, $element, $rootScope )
{
	$rootScope.ShowBack = false;

	scope = $scope;
	rootScope = $rootScope;

	$scope.NewsList = [];
	$scope.CurrentNewsItem = null;

	if ( !IN_ENGINE )
	{
		$rootScope.NewsList = [
			{ HeaderImage: 'example.jpg', Title: 'December 2018 Hotfix', SummaryHtml: 'A security hotfix', Url: 'https://google.com/?q=1' },
			{ Title: 'Post without an image', SummaryHtml: 'They are very hard to make', Url: 'https://google.com/?q=2' },
			{ HeaderImage: 'example.jpg', Title: 'December 2018 is a very long Security Hotfix that means we need to handle this', SummaryHtml: 'A security hotfix', Url: 'https://google.com/?q=3' },
			{ HeaderImage: 'example.jpg', Title: 'December 2018 Hotfix', SummaryHtml: 'A very long security hotfix example indeed like it is so long that i dont know how I will fit this stuff in the box', Url: 'https://google.com/?q=4' },
		]
	}

	if ( $rootScope.NewsList )
	{
		$scope.NewsList = $rootScope.NewsList;
		$scope.CurrentNewsItem = $scope.NewsList[ 0 ];
	}

	lua.Run( "LoadNewsList()" );

	$scope.NewsItemBackground = function( url )
	{
		return "background-image: url( " + url + " )";
	}

	$scope.SelectItem = function( item )
	{
		$scope.CurrentNewsItem = item;
	}

	$scope.OpenInSteam = function( url )
	{
		lua.Run( "gui.OpenURL( '" + url + "' )" );
	}
}

function UpdateNewsList( newslist )
{
	scope.NewsList = newslist;
	scope.CurrentNewsItem = newslist[ 0 ];

	if ( rootScope )
	{
		rootScope.NewsList = newslist;
		UpdateDigest( rootScope, 50 );
	}
}
