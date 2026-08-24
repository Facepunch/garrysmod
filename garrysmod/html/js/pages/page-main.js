var MainPage = {
	data: function () {
		return {
			MenuStore: MenuStore,
			NewsStore: NewsStore,
			MenuActions: MenuActions,
			NewsActions: NewsActions,
			t: t,
		};
	},
	computed: {
		sortedNewsList: function () {
			return this.NewsStore.list.slice().sort(function (a, b) {
				return Date.parse(a.Date) - Date.parse(b.Date);
			});
		},
	},
	template: "#tpl-main-page",
};
