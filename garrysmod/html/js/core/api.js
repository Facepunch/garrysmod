function SetInGame(inGame) {
	MenuStore.inGame = !!inGame;
}

function SetShowFavButton(show, fav) {
	MenuStore.showFavButton = !!show;
	MenuStore.isCurrentServerFav = !!fav;
}

function UpdateGamemodes(gm) {
	MenuStore.gamemodes = [];
	for (var k in gm) {
		MenuStore.gamemodes.push(gm[k]);
	}
}

function UpdateCurrentGamemode(gm) {
	if (MenuStore.gamemode === gm) return;

	MenuStore.gamemode = gm;

	for (var i = 0; i < MenuStore.gamemodes.length; i++) {
		var g = MenuStore.gamemodes[i];
		if (g.name === gm) MenuStore.gamemodeTitle = g.title;
	}
}

function SetProblemCount(num, severity) {
	MenuStore.problemCount = num;
	MenuStore.problemSeverity = severity;
}

function UpdateVersion(version, netVersion, branch) {
	GMOD_VERSION_INT = parseInt(netVersion.replace(/\./g, ""));

	MenuStore.version = version;
	MenuStore.branch = branch;
}

function UpdateLanguages(lang) {
	MenuStore.languages = [];
	for (var k in lang) {
		MenuStore.languages.push(lang[k].substr(0, lang[k].length - 4));
	}
}

function UpdateLanguage(lang) {
	MenuStore.language = lang;
	for (var k in Lang.cache) Vue.delete(Lang.cache, k);
}

function UpdateGames(games) {
	MenuStore.games = [];

	for (var k in games) {
		var game = games[k];
		game.mounted = Number(game.mounted) == 1;
		game.installed = Number(game.installed) == 1;
		game.owned = Number(game.owned) == 1;

		MenuStore.games.push(game);
	}
}

function UpdateNewsList(newslist, hide) {
	NewsActions.updateList(newslist, hide);
}

function UpdateAddonMaps(inmaps) {
	NewGameStore.addonMapList = inmaps || {};
}

function UpdateMaps(inmaps) {
	var mapList = [];
	var favList = {};
	var mapIndex = {};

	for (var k in inmaps) {
		var order = k;
		if (k === "Sandbox") order = "2";
		if (k === "Favourites") order = "1";

		var maps = [];
		for (var v in inmaps[k]) {
			maps.push(inmaps[k][v]);
			mapIndex[inmaps[k][v].toLowerCase()] = true;
			if (k === "Favourites") favList[inmaps[k][v].toLowerCase()] = true;
		}

		mapList.push({ order: order, category: k, maps: maps });
	}

	NewGameStore.mapList = mapList;
	NewGameStore.mapListFav = favList;
	NewGameStore.mapIndex = mapIndex;
}

function SetLastMap(map, category) {
	NewGameStore.savedMap = map;
	NewGameStore.savedCategory = category;
}

function UpdateServerSettings(sttngs) {
	sttngs.CheckBox = [];
	sttngs.Numeric = [];
	sttngs.Text = [];

	sttngs.maxplayers = parseInt(sttngs.maxplayers);
	sttngs.p2p_friendsonly = Number(sttngs.p2p_friendsonly) == 1;
	sttngs.p2p_enabled = Number(sttngs.p2p_enabled) == 1;
	sttngs.sv_lan = Number(sttngs.sv_lan) == 1;

	if (sttngs.settings) {
		for (var k in sttngs.settings) {
			var s = sttngs.settings[k];
			if (!s.text) s.text = s.name;

			if (s.type === "CheckBox") {
				s.Value = s.Value == "1";
				sttngs.CheckBox.push(s);
			} else if (s.type === "Numeric") {
				sttngs.Numeric.push(s);
			} else {
				sttngs.Text.push(s);
			}
		}
	}

	for (var key in sttngs)
		setKey(NewGameStore.serverSettings, key, sttngs[key]);
}

function FinishedServers(type) {
	setKey(ServersStore.refreshing, type, false);
}

function UpdateServer(
	address,
	ping,
	name,
	map,
	players,
	maxplayers,
	botplayers,
	pass
) {
	var current = ServersStore.currentGamemode;
	if (!current || !current.selected) {
		clearInterval(ServersStore.playerListInterval);
		return;
	}

	var server = current.selected;
	if (server.address != address) return;

	server.ping = parseInt(ping);
	server.name = String(name).trim();
	server.map = map;
	server.players = parseInt(players) - parseInt(botplayers);
	server.maxplayers = parseInt(maxplayers) - parseInt(botplayers);
	server.botplayers = parseInt(botplayers);
	server.pass = pass == "1";

	if (ServersStore.joinIfHasSlot && server.players < server.maxplayers) {
		ServerActions.joinServer(server);
	}
}

function ReceiveFoundServers(data) {
	ServersStore.foundServers = data;
}

function UpdateAddonDisabledState(noaddons, noworkshop) {
	AddonsStore.disabled = noworkshop;
}

function ReceivedChildAddonInfo(info) {
	setKey(compatState.childTitles, String(info.id), info.title);
}

function OnImportPresetFailed() {
	AddonsStore.importPresetLoading = false;
	AddonActions.displayPopupMessage("addons.import_preset_notcollection");
}

function OnReceivePresetList(list) {
	compatState.presetList = list;
	AddonsStore.importPresetLoading = false;
}

function OnGameSaved() {
	saveStore.switch("local", 0);
}

window.subscriptions = Subscriptions;
