const NewsStore = Vue.reactive({
	list: [],
	currentItem: null,
	hideNews: false,
	anyNewItems: false,
});

const NewsActions = {
	isNewItem(item) {
		const date = Date.parse(item.Date);
		if (!isNaN(date) && date > Date.now() - 302400000) {
			NewsStore.anyNewItems = true;
			this.setHideNews(false);
			return true;
		}
		return false;
	},

	selectItem(item) {
		this.setHideNews(false, true);
		NewsStore.currentItem = item;
	},

	openInSteam(url) {
		luaRun("gui.OpenURL( %s )", url);
	},

	setHideNews(hide, save) {
		NewsStore.hideNews = hide;

		if (save) {
			luaRun("SaveHideNews( %s )", hide ? "true" : "false");
		}
	},

	toggleNewsList() {
		this.setHideNews(!NewsStore.hideNews, true);
	},

	updateList(newslist, hide) {
		if (newslist && typeof newslist.length === "undefined") {
			newslist = Object.values(newslist);
		}

		this.setHideNews(hide);

		NewsStore.list = newslist || [];
		NewsStore.anyNewItems = false;
		NewsStore.currentItem = NewsStore.list[0] || null;

		for (const item of NewsStore.list) this.isNewItem(item);
	},
};
