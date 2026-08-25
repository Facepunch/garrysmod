function createWorkshopPage(config) {
	return {
		data: function () {
			return {
				store: config.store,
				AddonsStore: AddonsStore,
				MenuActions: MenuActions,
				t: t,
				mode: config.mode,
				titleKey: config.titleKey,
				myCategories: config.myCategories,
				categories: ["trending", "popular", "latest"],
				categoriesSecondary: config.categoriesSecondary,
				subCategories: config.subCategories,
			};
		},
		mounted: function () {
			luaRun("UpdateAddonDisabledState()");
			config.store.switch("local", 0);
		},
		template: "#tpl-workshop-page",
	};
}

var SavesPage = createWorkshopPage({
	store: saveStore,
	mode: "saves",
	titleKey: "saves",
	myCategories: ["local", "subscribed_ugc"],
	categoriesSecondary: ["followed", "favorite", "friends", "mine"],
	subCategories: ["scenes", "machines", "buildings", "courses", "others"],
});

var DupesPage = createWorkshopPage({
	store: dupeStore,
	mode: "dupes",
	titleKey: "dupes",
	myCategories: ["local", "subscribed_ugc"],
	categoriesSecondary: ["followed", "favorite", "friends", "mine"],
	subCategories: [
		"posed",
		"scenes",
		"machines",
		"vehicles",
		"buildings",
		"others",
	],
});

var DemosPage = createWorkshopPage({
	store: demoStore,
	mode: "demos",
	titleKey: "demos",
	myCategories: ["local", "subscribed_ugc"],
	categoriesSecondary: ["followed", "favorite", "friends", "mine"],
	subCategories: [],
});
