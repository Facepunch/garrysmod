var NewsStore = Vue.observable({
	list: [],
	currentItem: null,
	hideNews: false,
	anyNewItems: false,
});

var NewsActions = {
	isNewItem: function (item) {
		var date = Date.parse(item.Date);
		if (!isNaN(date) && date > Date.now() - 302400000) {
			NewsStore.anyNewItems = true;
			this.setHideNews(false);
			return true;
		}
		return false;
	},

	selectItem: function (item) {
		this.setHideNews(false, true);
		NewsStore.currentItem = item;
	},

	openInSteam: function (url) {
		luaRun("gui.OpenURL( %s )", url);
	},

	setHideNews: function (hide, save) {
		NewsStore.hideNews = hide;

		if (save) {
			luaRun("SaveHideNews( %s )", hide ? "true" : "false");
		}
	},

	toggleNewsList: function () {
		this.setHideNews(!NewsStore.hideNews, true);
	},

	updateList: function (newslist, hide) {
		if (newslist && typeof newslist.length === "undefined") {
			newslist = objValues(newslist);
		}

		this.setHideNews(hide);

		NewsStore.list = newslist || [];
		NewsStore.anyNewItems = false;
		NewsStore.currentItem = NewsStore.list[0] || null;

		for (var i = 0; i < NewsStore.list.length; i++)
			this.isNewItem(NewsStore.list[i]);
	},
};
