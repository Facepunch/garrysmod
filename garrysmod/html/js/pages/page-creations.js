function startCreationsApp(kind) {
	const isSaves = kind === "saves";
	const store = isSaves ? saveStore : dupeStore;
	const titleKey = isSaves ? "saves" : "dupes";
	const subCategories = isSaves
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

	window.WindowResized = function () {
		store.refreshDimensions();
		store.updatePageNav();
		setTimeout(function () {
			store.go(0);
		}, 500);
	};

	const CreationApp = {
		setup() {
			function applyRoute() {
				const match = /^#\/list\/([^/]*)\/(?:([^/]*)\/)?/.exec(
					window.location.hash || "",
				);
				if (match && match[1] && match[1] !== "list") {
					store.switchWithTag(
						match[1],
						0,
						match[2] || "",
						store.mapName,
					);
				} else {
					store.switch("local", 0);
				}
			}

			Vue.onMounted(function () {
				store.refreshDimensions();
				applyRoute();

				window.addEventListener("hashchange", applyRoute);
				window.addEventListener("resize", function () {
					setTimeout(function () {
						store.refreshDimensions();
						store.go(0);
					}, 250);
				});
			});

			return {
				store,
				titleKey,
				subCategories,
				myCategories: ["local", "subscribed_ugc"],
				categories: ["trending", "popular", "latest"],
				categoriesSecondary: [
					"followed",
					"favorite",
					"friends",
					"mine",
				],
				t,
			};
		},
		data() {
			return { saveDisabled: !isSaves };
		},
		computed: {
			isSavesFlag() {
				return isSaves;
			},
		},
		methods: {
			saveAction() {
				this.saveDisabled = true;

				if (isSaves) gmod.SaveSave();
				else gmod.SaveDupe();

				if (isSaves) {
					setTimeout(
						function () {
							this.saveDisabled = false;
						}.bind(this),
						5000,
					);
				}
			},
		},
		template: `
<div class="options">
	<ul>
		<li class="headline">{{ t(titleKey) }}</li>
		<li class="subtitle"></li>

		<li v-for="cat in myCategories" :key="'m' + cat">
			<a :href="'#/list/' + cat + '/'" :class="{ active: store.category === cat }">{{ t(titleKey + '.' + cat) }}</a>
			<ul v-if="cat === store.category && cat !== 'local'" style="margin-top: 4px; margin-bottom: 15px;">
				<li v-for="tag in subCategories" :key="'m' + cat + tag">
					<a :href="'#/list/' + cat + '/' + tag + '/'" :class="{ active: store.tagged === tag }">{{ t(titleKey + '.' + tag) }}</a>
				</li>
			</ul>
		</li>

		<li>&nbsp;</li>

		<li v-for="cat in categories" :key="cat">
			<a :href="'#/list/' + cat + '/'" :class="{ active: store.category === cat }">{{ t(titleKey + '.' + cat) }}</a>
			<ul v-if="cat === store.category" style="margin-top: 4px; margin-bottom: 15px;">
				<li v-for="tag in subCategories" :key="cat + tag">
					<a :href="'#/list/' + cat + '/' + tag + '/'" :class="{ active: store.tagged === tag }">{{ t(titleKey + '.' + tag) }}</a>
				</li>
			</ul>
		</li>

		<li>&nbsp;</li>

		<li v-for="cat in categoriesSecondary" :key="'s' + cat">
			<a :href="'#/list/' + cat + '/'" :class="{ active: store.category === cat }">{{ t(titleKey + '.' + cat) }}</a>
			<ul v-if="cat === store.category" style="margin-top: 4px; margin-bottom: 15px;">
				<li v-for="tag in subCategories" :key="'s' + cat + tag">
					<a :href="'#/list/' + cat + '/' + tag + '/'" :class="{ active: store.tagged === tag }">{{ t(titleKey + '.' + tag) }}</a>
				</li>
			</ul>
		</li>

		<li>&nbsp;</li>

		<li><button @click="saveAction()" :disabled="saveDisabled"
			:class="[isSavesFlag ? 'savegamebutton' : 'savedupebutton', saveDisabled ? 'disabled' : '']">..
		</button></li>
	</ul>
</div>`,
	};

	const ContentPage = {
		setup() {
			return { store, titleKey, t };
		},
		template: `
<div class="page">
	<div style="position: absolute; left: 0px; top: 0px; bottom: 0px; right: 0px;">
		<workshopcontainer>
			<workshopmessage v-if="store.loading">{{ t(titleKey + '.loading') }}</workshopmessage>
			<workshopmessage v-if="(store.totalResults === 0 || store.numResults === 0) && !store.loading">{{ t(titleKey + '.noneonmap') }}</workshopmessage>

			<WbEntry v-for="file in store.files" :key="file.order" :file="file" :store="store" :mode="titleKey === 'saves' ? 'saves' : 'dupes'" standalone></WbEntry>

			<center>
				<WbPagination :store="store"></WbPagination>
			</center>
		</workshopcontainer>
	</div>
</div>`,
	};

	const app = Vue.createApp({
		template: "<CreationsApp></CreationsApp><ContentPage></ContentPage>",
	});

	app.component("CreationsApp", CreationApp);
	app.component("ContentPage", ContentPage);
	app.component("WbPagination", WbPagination);
	app.component("WbEntry", WbEntry);
	app.config.compilerOptions.isCustomElement = function (tag) {
		return CUSTOM_ELEMENTS.includes(tag);
	};
	app.mount("#app");
}
