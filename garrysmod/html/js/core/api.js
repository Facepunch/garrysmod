function SetInGame(inGame) {
	MenuStore.inGame = !!inGame;
}

function SetShowFavButton(show, fav) {
	MenuStore.showFavButton = !!show;
	MenuStore.isCurrentServerFav = !!fav;
}

function UpdateVersion(version, netVersion, branch) {
	GMOD_VERSION_INT = parseInt(netVersion.replace(/\./g, ""));

	MenuStore.version = version;
	MenuStore.branch = branch;
}

function UpdateLanguage(lang) {
	MenuStore.language = lang;
	for (var k in Lang.cache) Vue.delete(Lang.cache, k);
}

function UpdateLanguages(lang) {
	MenuStore.languages = [];
	for (var k in lang) {
		MenuStore.languages.push(lang[k].substr(0, lang[k].length - 4));
	}
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

function ReceiveFoundServers(data) {
	ServersStore.foundServers = data;
}

function FinishedServers(type) {
	setKey(ServersStore.refreshing, type, false);
}

function CalculateRank(server) {
	var recommended = server.ping;

	if (server.players === 0) recommended += 75;
	if (server.pass || server.version_c < 0) recommended += 300;
	if (server.isAnon) recommended += 1000;

	if (server.players >= 4) recommended -= 10;
	if (server.players >= 8) recommended -= 15;
	if (server.players >= 16) recommended -= 15;
	if (server.players >= 32) recommended -= 10;
	if (server.players >= 64) recommended -= 10;

	return recommended;
}

function GetHighestKey(obj) {
	var h = 0;
	var v = "";

	for (var k in obj) {
		if (h === 0 || obj[k] > h) {
			h = obj[k];
			v = k;
		}
	}

	return v;
}

function AddServer(
	type,
	id,
	ping,
	name,
	desc,
	map,
	players,
	maxplayers,
	botplayers,
	pass,
	lastplayed,
	address,
	gamemode,
	workshopid,
	isAnon,
	version,
	isFav,
	loc,
	gmcat
) {
	if (Number(id) !== ServersStore.requestNum[type]) return;

	if (!gamemode) gamemode = desc;
	if (maxplayers <= 1) return;

	version = parseInt(version) || 0;

	if (gmcat && ServersStore.gmCats.indexOf(gmcat) === -1) gmcat = "";
	if (loc && !loc.match(/^[a-zA-Z]+$/)) loc = "";

	var data = {
		ping: parseInt(ping),
		name: name.trim(),
		desc: desc,
		map: map,
		players: parseInt(players) - parseInt(botplayers),
		maxplayers: parseInt(maxplayers) - parseInt(botplayers),
		botplayers: parseInt(botplayers),
		pass: pass == "1",
		lastplayed: parseInt(lastplayed) * 1000,
		address: address,
		flag: loc.toLowerCase(),
		category: gmcat || "",
		gamemode: gamemode,
		password: "",
		workshopid: workshopid,
		isAnon: isAnon,
		version: FormatVersion(version),
		version_c:
			version > GMOD_VERSION_INT
				? 1
				: GMOD_VERSION_INT === version
					? 0
					: -1,
		favorite: isFav == "true",
	};

	if (data.flag === "eu") data.flag = "europeanunion";

	data.hasmap = DoWeHaveMap(data.map);

	var actualDate = new Date(data.lastplayed);
	data.lastplayedDate =
		pad(actualDate.getDate()) +
		"." +
		pad(actualDate.getMonth() + 1) +
		"." +
		actualDate.getFullYear();
	data.lastplayedTime =
		pad(actualDate.getHours()) + ":" + pad(actualDate.getMinutes());

	data.recommended = CalculateRank(data);

	data.listen = data.desc.indexOf("[L]") >= 0;
	if (data.listen) data.desc = data.desc.substr(4);

	var gm = ServerActions.getGamemode(data.gamemode, type);
	if (!gm) return;

	gm.servers.push(data);

	UpdateGamemodeInfo(data, type, gm);

	gm.num_servers += 1;
	gm.num_players += data.players;
	if (!data.isAnon) gm.sort_players += data.players;

	gm.element_class = "";
	if (gm.num_players === 0) gm.element_class = "noplayers";
	if (gm.num_players > 50) gm.element_class = "lotsofplayers";

	gm.order = gm.sort_players;

	setKey(
		ServersStore.serverCount,
		type,
		(ServersStore.serverCount[type] || 0) + 1
	);
}

function UpdateGamemodeInfo(server, type, gm) {
	var gi = GetGamemodeInfo(server.gamemode);

	if (server.desc == server.gamemode.toLowerCase()) {
		var names = Object.keys(gi.titles);
		for (var i = 0; i < names.length; i++) {
			var name = names[i];
			if (
				name != name.toLowerCase() &&
				name.toLowerCase() == server.gamemode.toLowerCase()
			) {
				server.desc = name;
				break;
			}
		}
	}

	gi.titles[server.desc] =
		(gi.titles[server.desc] || 0) + Math.min(server.players, 10);
	if (server.desc == server.gamemode) gi.titles[server.desc] = 0;
	gi.title = GetHighestKey(gi.titles);

	if (server.category !== "") {
		gi.categories[server.category] =
			(gi.categories[server.category] || 0) + 1;
		gi.tag = GetHighestKey(gi.categories);
		if (gi.tag) gi.tag_set = true;
	}

	if (!gi.tag_set) {
		var title = gi.title || "";
		if (
			title.toLowerCase().indexOf("roleplay") !== -1 ||
			title.indexOf(" RP") !== -1 ||
			title.indexOf("RP ") !== -1 ||
			title.indexOf("RP") === title.length - 2
		)
			gi.tag = "rp";
		else gi.tag = "";
	}

	if (server.workshopid != "" && server.workshopid != "0") {
		gi.wsid[server.workshopid] =
			(gi.wsid[server.workshopid] || 0) + 1;
		gi.workshopid = GetHighestKey(gi.wsid);
	}

	if (server.flag !== "") {
		setKey(gm.flags, server.flag, true);
		gm.hasflags = true;
	}
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

function SetPlayerList(serverip, players) {
	var current = ServersStore.currentGamemode;
	if (!current || !current.selected) return;
	if (current.selected.address != serverip) return;

	setKey(current.selected, "playerlist", players);
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
