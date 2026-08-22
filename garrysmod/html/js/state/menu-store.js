const MenuStore = Vue.reactive({
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
	const key = String(name).toLowerCase();
	if (!MenuStore.gamemodeDetails[key]) {
		MenuStore.gamemodeDetails[key] = Vue.reactive({
			title: name,
			name: key,
		});
	}
	return MenuStore.gamemodeDetails[key];
}

function ResetGamemodeInfo() {
	MenuStore.gamemodeDetails = {};
}

const MenuActions = {
	togglePopup(name) {
		MenuStore.popup = MenuStore.popup === name ? null : name;
	},
	closePopups() {
		MenuStore.popup = null;
	},

	selectGamemode(gm) {
		MenuStore.gamemode = gm.name;
		MenuStore.gamemodeTitle = gm.title;
		luaRun('RunConsoleCommand( "gamemode", %s )', gm.name);
		MenuStore.popup = null;
	},

	selectLanguage(lang) {
		MenuStore.language = lang;
		for (const k in Lang.cache) delete Lang.cache[k];
		luaRun('RunConsoleCommand( "gmod_language", %s )', lang);
		MenuStore.popup = null;
	},

	menuOption(command) {
		luaRun("RunGameUICommand( %s )", command);
	},

	gameMountChanged(mount) {
		luaRun(
			"engine.SetMounted( %s, " +
				(mount.mounted ? "true" : "false") +
				" )",
			String(mount.depot),
		);
	},

	backToGame() {
		luaRun("gui.HideGameUI()");
	},

	toggleServerFavorites(add) {
		luaRun(
			"server-list.AddCurrentServerToFavorites( " +
				(add ? "true" : "false") +
				" )",
		);
	},

	disconnect() {
		luaRun("RunConsoleCommand( 'disconnect' )");
	},

	openWorkshopFile(id) {
		if (!id) return;
		gmod.OpenWorkshopFile(String(id));
	},

	openFolder(foldername) {
		luaRun("OpenFolder( %s )", String(foldername));
	},

	openWorkshop() {
		luaRun("steamworks.OpenWorkshop()");
	},

	showNews() {
		if (MenuStore.branch !== "unknown")
			return luaRun(
				"gui.OpenURL( 'https://commits.facepunch.com/r/garrysmod.main' )",
			);

		luaRun("gui.OpenURL( 'http://gmod.facepunch.com/changes/' )");
	},

	toggleProblems() {
		luaRun("OpenProblemsPanel()");
	},

	updateKinect() {
		const kinect = MenuStore.kinect;

		if (kinect.showColor) luaRun("motionsensor.Start()");

		const positions = {
			topleft: ["32", "32"],
			topright: ["-32", "32"],
			bottomright: ["-32", "-32"],
			bottomleft: ["32", "-32"],
		};
		const pos = positions[kinect.color];
		if (pos) {
			luaRun('RunConsoleCommand( "sensor_color_x", %s )', pos[0]);
			luaRun('RunConsoleCommand( "sensor_color_y", %s )', pos[1]);
		}

		const scales = { small: "0.4", medium: "0.7", large: "1.0" };
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

function setupSoundHooks() {
	document.addEventListener("mouseover", function (e) {
		const target = e.target.closest(".options a, .noisy, .ui-sound-return");
		if (target && (!e.relatedTarget || !target.contains(e.relatedTarget)))
			luaPlaySound("garrysmod/ui_hover.wav");
	});

	document.addEventListener("click", function (e) {
		if (e.target.closest(".options a, .noisy"))
			luaPlaySound("garrysmod/ui_click.wav");
		else if (e.target.closest(".ui-sound-return"))
			luaPlaySound("garrysmod/ui_return.wav");
	});
}
