var MenuStore = Vue.observable({
	version: "0",
	branch: "unknown",
	problemCount: 0,
	problemSeverity: 0,

	inGame: false,
	showFavButton: false,
	isCurrentServerFav: false,

	gamemode: "",
	gamemodeTitle: "",
	gamemodes: [],
	gamemodeDetails: {},

	languages: [],
	language: "en",
	games: [],

	popup: null,

	kinect: {
		available: false,
		showColor: false,
		color: "bottomleft",
		colorSize: "medium",
		colorOptions: ["topleft", "topright", "bottomleft", "bottomright"],
		sizeOptions: ["small", "medium", "large"],
	},
});

function GetGamemodeInfo(name) {
	var key = String(name).toLowerCase();
	if (!MenuStore.gamemodeDetails[key]) {
		Vue.set(
			MenuStore.gamemodeDetails,
			key,
			Vue.observable({
				title: name,
				name: key,
				titles: {},
				categories: {},
				wsid: {},
				tag: "",
				tag_set: false,
				workshopid: "",
			}),
		);
	}
	return MenuStore.gamemodeDetails[key];
}

function ResetGamemodeInfo() {
	MenuStore.gamemodeDetails = {};
}

var MenuActions = {
	togglePopup: function (name) {
		MenuStore.popup = MenuStore.popup === name ? null : name;
	},
	closePopups: function () {
		MenuStore.popup = null;
	},

	selectGamemode: function (gm) {
		MenuStore.gamemode = gm.name;
		MenuStore.gamemodeTitle = gm.title;
		luaRun('RunConsoleCommand( "gamemode", %s )', gm.name);
		MenuStore.popup = null;
	},

	selectLanguage: function (lang) {
		MenuStore.language = lang;
		for (var lk in Lang.cache) Vue.delete(Lang.cache, lk);
		luaRun('RunConsoleCommand( "gmod_language", %s )', lang);
		MenuStore.popup = null;
	},

	menuOption: function (command) {
		luaRun("RunGameUICommand( %s )", command);
	},

	gameMountChanged: function (mount) {
		luaRun(
			"engine.SetMounted( %s, " +
				(mount.mounted ? "true" : "false") +
				" )",
			String(mount.depot),
		);
	},

	backToGame: function () {
		luaRun("gui.HideGameUI()");
	},

	toggleServerFavorites: function (add) {
		luaRun(
			"server-list.AddCurrentServerToFavorites( " +
				(add ? "true" : "false") +
				" )",
		);
	},

	disconnect: function () {
		luaRun("RunConsoleCommand( 'disconnect' )");
	},

	openWorkshopFile: function (id) {
		if (!id) return;
		gmod.OpenWorkshopFile(String(id));
	},

	openFolder: function (foldername) {
		luaRun("OpenFolder( %s )", String(foldername));
	},

	openWorkshop: function () {
		luaRun("steamworks.OpenWorkshop()");
	},

	showNews: function () {
		if (MenuStore.branch !== "unknown")
			return luaRun(
				"gui.OpenURL( 'https://commits.facepunch.com/r/garrysmod.main' )",
			);

		luaRun("gui.OpenURL( 'http://gmod.facepunch.com/changes/' )");
	},

	toggleProblems: function () {
		luaRun("OpenProblemsPanel()");
	},

	updateKinect: function () {
		var kinect = MenuStore.kinect;

		if (kinect.showColor) luaRun("motionsensor.Start()");

		var positions = {
			topleft: ["32", "32"],
			topright: ["-32", "32"],
			bottomright: ["-32", "-32"],
			bottomleft: ["32", "-32"],
		};
		var pos = positions[kinect.color];
		if (pos) {
			luaRun('RunConsoleCommand( "sensor_color_x", %s )', pos[0]);
			luaRun('RunConsoleCommand( "sensor_color_y", %s )', pos[1]);
		}

		var scales = { small: "0.4", medium: "0.7", large: "1.0" };
		if (scales[kinect.colorSize]) {
			luaRun(
				'RunConsoleCommand( "sensor_color_scale", %s )',
				scales[kinect.colorSize],
			);
		}

		luaRun(
			'RunConsoleCommand( "sensor_color_show", %s )',
			kinect.showColor ? "1" : "0",
		);
	},
};

if (
	typeof util !== "undefined" &&
	typeof util.MotionSensorAvailable === "function"
) {
	MenuStore.kinect.available = !!util.MotionSensorAvailable();

	util.MotionSensorAvailable(function (available) {
		MenuStore.kinect.available = available;
	});
}

function matchesSelector(el, selector) {
	if (!el || el.nodeType !== 1) return false;
	if (el.matches) return el.matches(selector);
	if (el.webkitMatchesSelector) return el.webkitMatchesSelector(selector);
	return false;
}

function closestElement(el, selector) {
	var node = el;
	while (node && node.nodeType === 1) {
		if (matchesSelector(node, selector)) return node;
		node = node.parentNode;
	}
	return null;
}

function setupSoundHooks() {
	document.addEventListener("mouseover", function (e) {
		var target = closestElement(
			e.target,
			".options a, .noisy, .ui-sound-return",
		);
		if (target && (!e.relatedTarget || !target.contains(e.relatedTarget)))
			luaPlaySound("garrysmod/ui_hover.wav");
	});

	document.addEventListener("click", function (e) {
		if (closestElement(e.target, ".options a, .noisy"))
			luaPlaySound("garrysmod/ui_click.wav");
		else if (closestElement(e.target, ".ui-sound-return"))
			luaPlaySound("garrysmod/ui_return.wav");
	});
}
