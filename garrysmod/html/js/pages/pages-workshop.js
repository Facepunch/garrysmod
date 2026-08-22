function createWorkshopPage(config) {
	return {
		setup() {
			Vue.onMounted(function () {
				luaRun("UpdateAddonDisabledState()");
				config.store.switch("local", 0);
			});

			return { store: config.store, AddonsStore, MenuActions, t };
		},
		data() {
			return {
				mode: config.mode,
				titleKey: config.titleKey,
				myCategories: config.myCategories,
				categories: ["trending", "popular", "latest"],
				categoriesSecondary: config.categoriesSecondary,
				subCategories: config.subCategories,
			};
		},
		template: `
<div class="page">

	<div class="options">
		<ul>
			<li><h2>{{ t(titleKey) }}</h2></li>

			<li v-for="cat in myCategories" :key="'m' + cat">
				<a @click="store.switch( cat, 0 )" :class="{ active: store.category === cat }">{{ t(titleKey + '.' + cat) }}</a>
				<ul v-if="store.category === cat && cat !== 'local' && subCategories.length > 0" style="margin-top: 4px; margin-bottom: 15px;">
					<li v-for="tag in subCategories" :key="cat + tag">
						<a @click="store.switchWithTag( cat, 0, tag )" :class="{ active: store.tagged === tag }">{{ t(titleKey + '.' + tag) }}</a>
					</li>
				</ul>
			</li>

			<li>&nbsp;</li>

			<li v-for="cat in categories" :key="cat">
				<a @click="store.switch( cat, 0 )" :class="{ active: store.category === cat }">{{ t(titleKey + '.' + cat) }}</a>
				<ul v-if="store.category === cat && subCategories.length > 0" style="margin-top: 4px; margin-bottom: 15px;">
					<li v-for="tag in subCategories" :key="cat + tag">
						<a @click="store.switchWithTag( cat, 0, tag )" :class="{ active: store.tagged === tag }">{{ t(titleKey + '.' + tag) }}</a>
					</li>
				</ul>
			</li>

			<li>&nbsp;</li>

			<li v-for="cat in categoriesSecondary" :key="'s' + cat">
				<a @click="store.switch( cat, 0 )" :class="{ active: store.category === cat }">{{ t(titleKey + '.' + cat) }}</a>
				<ul v-if="store.category === cat && subCategories.length > 0" style="margin-top: 4px; margin-bottom: 15px;">
					<li v-for="tag in subCategories" :key="cat + tag">
						<a @click="store.switchWithTag( cat, 0, tag )" :class="{ active: store.tagged === tag }">{{ t(titleKey + '.' + tag) }}</a>
					</li>
				</ul>
			</li>

			<li>&nbsp;</li>

			<li><a @click="MenuActions.openFolder( mode )">{{ t(titleKey + '.openfolder') }}</a></li>
		</ul>
	</div>

	<div class="page-content">

		<h1 class="menu-header"><span>{{ t(titleKey + '.' + store.category) }}</span><small>{{ t(titleKey + '.' + store.category + '.subtitle') }}</small></h1>

		<workshopcontainer>
			<workshopmessage v-if="store.loading">{{ t(titleKey + '.loading') }}</workshopmessage>
			<workshopmessage v-if="(store.totalResults === 0 || store.numResults === 0) && !store.loading && (!AddonsStore.disabled || store.category !== 'subscribed_ugc')">{{ t(titleKey + '.none') }}</workshopmessage>
			<workshopmessage v-if="store.totalResults === 0 && !store.loading && AddonsStore.disabled && store.category === 'subscribed_ugc'">{{ t('ugc.disabled') }}</workshopmessage>

			<WbEntry v-for="file in store.files" :key="file.order" :file="file" :store="store" :mode="mode" v-show="!store.loading"></WbEntry>

			<center>
				<WbPagination :store="store"></WbPagination>
			</center>
		</workshopcontainer>

	</div>

</div>`,
	};
}

const SavesPage = createWorkshopPage({
	store: saveStore,
	mode: "saves",
	titleKey: "saves",
	myCategories: ["local", "subscribed_ugc"],
	categoriesSecondary: ["followed", "favorite", "friends", "mine"],
	subCategories: ["scenes", "machines", "buildings", "courses", "others"],
});

const DupesPage = createWorkshopPage({
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

const DemosPage = createWorkshopPage({
	store: demoStore,
	mode: "demos",
	titleKey: "demos",
	myCategories: ["local", "subscribed_ugc"],
	categoriesSecondary: ["followed", "favorite", "friends", "mine"],
	subCategories: [],
});
