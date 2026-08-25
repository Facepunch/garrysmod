function startCreationsApp(kind) {
	var isSaves = kind === "saves";
	var store = isSaves ? saveStore : dupeStore;
	var titleKey = isSaves ? "saves" : "dupes";
	var subCategories = isSaves
		? ["scenes", "machines", "buildings", "courses", "others"]
		: ["posed", "scenes", "machines", "vehicles", "buildings", "others"];

	window.SetMap = function (mapname) {
		store.mapName = mapname;
	};

	if (!isSaves) {
		window.SetDupeSaveState = function (b) {
			store.saveEnabled = !!b;
		};
		store.saveEnabled = false;
	}

	window.ShowLocalDupes = function () {
		store.switch("local", 0);
	};

	var CreationApp = {
		data: function () {
			return {
				store: store,
				titleKey: titleKey,
				subCategories: subCategories,
				myCategories: ["local", "subscribed_ugc"],
				categories: ["trending", "popular", "latest"],
				categoriesSecondary: [
					"followed",
					"favorite",
					"friends",
					"mine",
				],
				t: t,
				saveDisabled: !isSaves,
			};
		},
		methods: {
			applyRoute: function () {
				var match = /^#\/list\/([^/]*)\/(?:([^/]*)\/)?/.exec(
					window.location.hash || ""
				);
				if (match && match[1] && match[1] !== "list") {
					store.switchWithTag(
						match[1],
						0,
						match[2] || "",
						store.mapName
					);
				} else {
					store.switch("local", 0);
				}
			},
			saveAction: function () {
				this.saveDisabled = true;

				if (isSaves) gmod.SaveSave();
				else gmod.SaveDupe();

				if (isSaves) {
					var self = this;
					setTimeout(function () {
						self.saveDisabled = false;
					}, 5000);
				}
			},
		},
		mounted: function () {
			store.refreshDimensions();
			this.applyRoute();

			window.addEventListener("hashchange", this.applyRoute);
			window.addEventListener("resize", function () {
				setTimeout(function () {
					store.refreshDimensions();
					store.go(0);
				}, 250);
			});
		},
		template: "#tpl-creations-app",
	};

	var ContentPage = {
		data: function () {
			return { store: store, titleKey: titleKey, t: t };
		},
		template: "#tpl-creations-content",
	};

	Vue.config.ignoredElements = CUSTOM_ELEMENTS;

	Vue.component("WbPagination", WbPagination);
	Vue.component("WbEntry", WbEntry);

	new Vue({
		el: "#app",
		template:
			"<div><creations-app></creations-app><content-page></content-page></div>",
		components: {
			CreationsApp: CreationApp,
			ContentPage: ContentPage,
		},
	});
}
