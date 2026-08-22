const NewGameStore = Vue.reactive({
	mapList: [],
	mapListFav: {},
	addonMapList: {},

	savedMap: null,
	savedCategory: null,

	serverSettings: {
		hostname: "",
		sv_lan: false,
		p2p_enabled: false,
		p2p_friendsonly: false,
		maxplayers: 1,
		Text: [],
		Numeric: [],
		CheckBox: [],
	},

	map: "gm_flatgrass",
	lastCategory: null,
	currentCategory: null,
	search: "",

	playerOptions: [1, 2, 4, 8, 16, 32, 64, 128],
	maxPlayers: 1,
});

function DoWeHaveMap(map) {
	return NewGameStore.mapIndex[map.toLowerCase()] || false;
}

const NewGameActions = {
	filterMaps(maps, search) {
		if (!search) return maps;

		const addonMaps = [];
		for (const addonName in NewGameStore.addonMapList) {
			if (addonName.toLowerCase().indexOf(search.toLowerCase()) === -1)
				continue;

			for (const m of NewGameStore.addonMapList[addonName])
				addonMaps.push(m);
		}

		return maps.filter(function (map) {
			if (addonMaps.indexOf(map + ".bsp") !== -1) return true;
			return map.toLowerCase().indexOf(search.toLowerCase()) !== -1;
		});
	},

	countFiltered(maps) {
		if (!NewGameStore.search) return maps.length;
		return this.filterMaps(maps, NewGameStore.search).length;
	},

	switchCategory(category) {
		NewGameStore.currentCategory = category;
	},

	selectMap(map) {
		NewGameStore.map = map;
		NewGameStore.lastCategory = NewGameStore.currentCategory;
	},

	isFavMap(map) {
		return NewGameStore.mapListFav[map.toLowerCase()] || false;
	},

	toggleFavMap(map) {
		luaRun("ToggleFavourite( %s )", map);
	},

	mapIcon(map, category) {
		if (category === "INFRA") return "img/incompatible.png";
		if (NewGameStore.currentCategory !== category)
			return "img/downloading.png";
		return "asset://mapimage/" + map;
	},

	updateMaxPlayers(num) {
		NewGameStore.maxPlayers = num;
		localStorage.MaxPlayers = num;
	},

	onCheckboxChange() {
		const s = NewGameStore.serverSettings;
		s.sv_lan = Number(s.sv_lan) == 1;
		s.p2p_enabled = Number(s.p2p_enabled) == 1;

		if (this._oldSvLan !== s.sv_lan && s.sv_lan && s.p2p_enabled) {
			s.p2p_enabled = false;
		} else if (
			this._oldP2p !== s.p2p_enabled &&
			s.p2p_enabled &&
			s.sv_lan
		) {
			s.sv_lan = false;
		}

		this._oldP2p = s.p2p_enabled;
		this._oldSvLan = s.sv_lan;
	},

	startGame() {
		const state = NewGameStore;

		luaRun("SaveLastMap( %s, %s )", state.map, state.lastCategory);

		luaRun('hook.Run( "StartGame" )');
		luaRun('RunConsoleCommand( "progress_enable" )');

		luaRun('RunConsoleCommand( "disconnect" )');
		luaRun(
			'RunConsoleCommand( "maxplayers", %s )',
			String(state.maxPlayers),
		);

		if (state.maxPlayers > 0) {
			luaRun('RunConsoleCommand( "sv_cheats", "0" )');
		}

		const saved = JSON.parse(JSON.stringify(state.serverSettings));

		setTimeout(function () {
			for (const k in saved.Numeric)
				luaRun(
					"RunConsoleCommand( %s, %s )",
					saved.Numeric[k].name,
					String(saved.Numeric[k].Value),
				);

			for (const k in saved.Text)
				luaRun(
					"RunConsoleCommand( %s, %s )",
					saved.Text[k].name,
					saved.Text[k].Value,
				);

			for (const k in saved.CheckBox)
				luaRun(
					"RunConsoleCommand( %s, %s )",
					saved.CheckBox[k].name,
					saved.CheckBox[k].Value ? "1" : "0",
				);

			luaRun('RunConsoleCommand( "hostname", %s )', saved.hostname);
			luaRun(
				'RunConsoleCommand( "p2p_enabled", %s )',
				saved.p2p_enabled ? "1" : "0",
			);
			luaRun(
				'RunConsoleCommand( "p2p_friendsonly", %s )',
				saved.p2p_friendsonly ? "1" : "0",
			);
			luaRun(
				'RunConsoleCommand( "sv_lan", %s )',
				saved.sv_lan ? "1" : "0",
			);
			luaRun(
				'RunConsoleCommand( "maxplayers", %s )',
				String(state.maxPlayers),
			);
			luaRun('RunConsoleCommand( "map", %s )', String(state.map).trim());
		}, 200);

		navigate("/");
	},
};
