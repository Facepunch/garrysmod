var Router = Vue.observable({ path: "/" });

var Routes = {
	"/": "MainPage",
	"/newgame/": "NewGamePage",
	"/servers/": "ServersPage",
	"/addons/": "AddonsPage",
	"/demos/": "DemosPage",
	"/saves/": "SavesPage",
	"/dupes/": "DupesPage",
};

function currentRoutePath() {
	var hash = window.location.hash.replace(/^#/, "");
	if (!Routes[hash]) {
		var normalized =
			hash.charAt(hash.length - 1) === "/" ? hash : hash + "/";
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

var App = {
	data: function () {
		return {
			Router: Router,
			MenuStore: MenuStore,
			MenuActions: MenuActions,
			t: t,
		};
	},
	computed: {
		pageComponent: function () {
			return Routes[this.Router.path] || "MainPage";
		},
	},
};

function registerComponents() {
	Vue.component("NavBar", NavBar);
	Vue.component("WbPagination", WbPagination);
	Vue.component("WbEntry", WbEntry);

	Vue.component("MainPage", MainPage);
	Vue.component("NewGamePage", NewGamePage);
	Vue.component("ServersPage", ServersPage);
	Vue.component("AddonsPage", AddonsPage);
	Vue.component("SavesPage", SavesPage);
	Vue.component("DupesPage", DupesPage);
	Vue.component("DemosPage", DemosPage);
}

function startApp() {
	luaRun("UpdateMapList()");
	luaRun("UpdateLanguages()");
	luaRun("LoadNewsList()");

	if (typeof util !== "undefined") {
		MenuStore.kinect.available = !!util.MotionSensorAvailable();
	}

	Vue.config.ignoredElements = CUSTOM_ELEMENTS;

	registerComponents();

	App.template = "#tpl-app";

	new Vue(App).$mount("#app");

	setupSoundHooks();
}
