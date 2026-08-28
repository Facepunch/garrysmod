var NewGameStore = Vue.observable({
	mapList: [],
	mapListFav: {},
	addonMapList: {},
	mapIndex: {},

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
		settings: {},
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

var NewGameActions = {
	filterMaps: function (maps, search) {
		if (!search) return maps;

		var addonMaps = [];
		for (var addonName in NewGameStore.addonMapList) {
			if (addonName.toLowerCase().indexOf(search.toLowerCase()) === -1)
				continue;

			var list = NewGameStore.addonMapList[addonName];
			for (var i = 0; i < list.length; i++) addonMaps.push(list[i]);
		}

		return maps.filter(function (map) {
			if (addonMaps.indexOf(map + ".bsp") !== -1) return true;
			return map.toLowerCase().indexOf(search.toLowerCase()) !== -1;
		});
	},

	countFiltered: function (maps) {
		if (!NewGameStore.search) return maps.length;
		return this.filterMaps(maps, NewGameStore.search).length;
	},

	switchCategory: function (category) {
		NewGameStore.currentCategory = category;
	},

	selectMap: function (map) {
		NewGameStore.map = map;
		NewGameStore.lastCategory = NewGameStore.currentCategory;
	},

	isFavMap: function (map) {
		return NewGameStore.mapListFav[map.toLowerCase()] || false;
	},

	toggleFavMap: function (map) {
		luaRun("ToggleFavourite( %s )", map);
	},

	mapIcon: function (map, category) {
		if (category === "INFRA") return "img/incompatible.png";
		if (NewGameStore.currentCategory !== category)
			return "img/downloading.png";
		return "asset://mapimage/" + map;
	},

	updateMaxPlayers: function (num) {
		NewGameStore.maxPlayers = num;
		localStorage.MaxPlayers = num;
	},

	onCheckboxChange: function () {
		var s = NewGameStore.serverSettings;

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

	startGame: function () {
		var state = NewGameStore;

		luaRun("SaveLastMap( %s, %s )", state.map, state.lastCategory);

		luaRun('hook.Run( "StartGame" )');
		luaRun('RunConsoleCommand( "progress_enable" )');

		luaRun('RunConsoleCommand( "disconnect" )');
		luaRun(
			'RunConsoleCommand( "maxplayers", %s )',
			String(state.maxPlayers)
		);

		if (state.maxPlayers > 0) {
			luaRun('RunConsoleCommand( "sv_cheats", "0" )');
		}

		var saved = JSON.parse(JSON.stringify(state.serverSettings));

		setTimeout(function () {
			for (var k in saved.Numeric)
				luaRun(
					"RunConsoleCommand( %s, %s )",
					saved.Numeric[k].name,
					String(saved.Numeric[k].Value)
				);

			for (var j in saved.Text)
				luaRun(
					"RunConsoleCommand( %s, %s )",
					saved.Text[j].name,
					saved.Text[j].Value
				);

			for (var m in saved.CheckBox)
				luaRun(
					"RunConsoleCommand( %s, %s )",
					saved.CheckBox[m].name,
					saved.CheckBox[m].Value ? "1" : "0"
				);

			luaRun('RunConsoleCommand( "hostname", %s )', saved.hostname);
			luaRun(
				'RunConsoleCommand( "p2p_enabled", %s )',
				saved.p2p_enabled ? "1" : "0"
			);
			luaRun(
				'RunConsoleCommand( "p2p_friendsonly", %s )',
				saved.p2p_friendsonly ? "1" : "0"
			);
			luaRun(
				'RunConsoleCommand( "sv_lan", %s )',
				saved.sv_lan ? "1" : "0"
			);
			luaRun(
				'RunConsoleCommand( "maxplayers", %s )',
				String(state.maxPlayers)
			);
			luaRun('RunConsoleCommand( "map", %s )', String(state.map).trim());
		}, 200);

		navigate("/");
	},
};
