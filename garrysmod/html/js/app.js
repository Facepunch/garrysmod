const Router = Vue.reactive({ path: "/" });

const Routes = {
	"/": "MainPage",
	"/newgame/": "NewGamePage",
	"/servers/": "ServersPage",
	"/addons/": "AddonsPage",
	"/demos/": "DemosPage",
	"/saves/": "SavesPage",
	"/dupes/": "DupesPage",
};

function currentRoutePath() {
	let hash = window.location.hash.replace(/^#/, "");
	if (!Routes[hash]) {
		const normalized = hash.endsWith("/") ? hash : hash + "/";
		if (Routes[normalized]) return normalized;
		return "/";
	}
	return hash;
}

function navigate(path) {
	window.location.hash = "#" + path;
}

window.addEventListener("hashchange", function () {
	Router.path = currentRoutePath();
	MenuActions.closePopups();
});

Router.path = currentRoutePath();

const App = {
	setup() {
		return {
			currentPage: Vue.computed(function () {
				return Routes[Router.path] || "MainPage";
			}),
			MenuStore,
			MenuActions,
			t,
		};
	},
	template: `
<div id="version" @click="MenuActions.showNews()" v-show="MenuStore.version">
	<span v-if="MenuStore.branch !== 'unknown'">You are on the {{ MenuStore.branch }} branch. Click here to find out more. ( </span>{{ MenuStore.version }}<span v-if="MenuStore.branch !== 'unknown'"> )</span>
</div>

<component :is="currentPage"></component>

<NavBar></NavBar>`,
};

function startApp() {
	luaRun("UpdateMapList()");
	luaRun("UpdateLanguages()");
	luaRun("LoadNewsList()");

	const app = Vue.createApp(App);

	app.config.compilerOptions.isCustomElement = function (tag) {
		return CUSTOM_ELEMENTS.includes(tag);
	};

	app.component("NavBar", NavBar);
	app.component("WbPagination", WbPagination);
	app.component("WbEntry", WbEntry);

	app.component("MainPage", MainPage);
	app.component("NewGamePage", NewGamePage);
	app.component("ServersPage", ServersPage);
	app.component("AddonsPage", AddonsPage);
	app.component("SavesPage", SavesPage);
	app.component("DupesPage", DupesPage);
	app.component("DemosPage", DemosPage);

	app.mount("#app");

	setupSoundHooks();
}
