var NavBar = {
	data: function () {
		return {
			Router: Router,
			MenuStore: MenuStore,
			MenuActions: MenuActions,
			t: t,
		};
	},
	computed: {
		sortedGames: function () {
			return sortByKeys(MenuStore.games, [
				"-installed",
				"-owned",
				"title",
			]);
		},
		sortedGamemodes: function () {
			return sortByKeys(
				MenuStore.gamemodes.filter(function (gm) {
					return gm.menusystem;
				}),
				"name"
			);
		},
	},
	template: "#tpl-navbar",
};
