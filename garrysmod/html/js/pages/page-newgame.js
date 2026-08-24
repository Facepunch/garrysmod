var NewGamePage = {
	data: function () {
		return {
			state: { playersDropdown: false },
			NewGameStore: NewGameStore,
			MenuStore: MenuStore,
			NewGameActions: NewGameActions,
			t: t,
		};
	},
	computed: {
		categories: function () {
			var self = this;
			return sortByKeys(NewGameStore.mapList, "order").filter(
				function (cat) {
					return self.NewGameActions.countFiltered(cat.maps) > 0;
				},
			);
		},
		maxPlayersLabel: function () {
			return "maxplayers_" + NewGameStore.maxPlayers;
		},
		maxPlayersOptions: function () {
			return NewGameStore.playerOptions;
		},
	},
	mounted: function () {
		var store = NewGameStore;

		if (!store.currentCategory) {
			if (store.savedMap && store.savedCategory) {
				store.map = store.savedMap;
				store.lastCategory = store.savedCategory;
			}

			store.currentCategory = store.lastCategory || "Sandbox";

			var favMaps = Object.keys(store.mapListFav);
			if (favMaps.length > 0 && !store.lastCategory) {
				store.currentCategory = "Favourites";
				if (!store.map) store.map = favMaps[0];
			}
		}

		if (localStorage.MaxPlayers) {
			var saved = parseInt(localStorage.MaxPlayers);
			if (store.playerOptions.indexOf(saved) !== -1)
				store.maxPlayers = saved;
		}

		luaRun("UpdateServerSettings()");

		setTimeout(function () {
			var elem = document.querySelector(".mapicon.selected");
			if (elem)
				elem.scrollIntoView({
					behavior: "smooth",
					block: "center",
				});
		}, 100);
	},
	methods: {
		categoryLabel: function (category) {
			if (!category || !category.category) return "";
			if (category.category === "Favourites")
				return t("newgame_favorite_maps");
			if (category.category === "Other")
				return t("spawnmenu.category.other");
			return category.category;
		},
		countText: function (count) {
			return (
				count +
				" " +
				(count === 1 ? t("newgame_map") : t("newgame_maps"))
			);
		},
		mapsInCategory: function (category) {
			var filtered = NewGameActions.filterMaps(
				category.maps,
				NewGameStore.search,
			);
			return filtered.slice().sort(function (a, b) {
				return a.localeCompare(b);
			});
		},
		mapClass: function (map) {
			return map === NewGameStore.map ? "selected" : "";
		},
		favClass: function (map) {
			return NewGameActions.isFavMap(map) ? "favmap" : "";
		},
	},
	template: "#tpl-newgame-page",
};
