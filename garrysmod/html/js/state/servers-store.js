const ServersStore = Vue.reactive({
	type: null,
	types: {},
	requestNum: {},
	refreshing: {},
	serverCount: {},

	gmCats: ["rp", "pvp", "pve", "other", "none"],
	gmSort: "-order",
	gmFilterTags: {},
	gmHasFilterTags: false,
	gmSearch: "",

	serversPerPage: 128,

	currentGamemode: null,
	foundServers: [],
	findServerString: "",

	filters: {
		hasPlayers: false,
		notFull: false,
		hidePassword: false,
		hideOutdated: false,
		maxPing: 2000,
		plyMin: 0,
		plyMax: 128,
	},

	joinIfHasSlot: false,

	playerListInterval: 0,
});

const ServerActions = {
	getTypeData(type) {
		if (!ServersStore.types[type]) {
			ServersStore.types[type] = Vue.reactive({
				gamemodes: {},
				list: [],
			});
		}
		return ServersStore.types[type];
	},

	getGamemode(name, type) {
		if (!ServersStore.types[type]) return;

		const data = this.getTypeData(type);
		if (data.gamemodes[name]) return data.gamemodes[name];

		const gm = Vue.reactive({
			name: name,
			servers: [],
			num_servers: 0,
			num_players: 0,
			server_offset: 0,
			sort_players: 0,
			orderByMain: "recommended",
			orderBy: ["recommended", "ping", "address"],
			orderReverse: false,
			info: GetGamemodeInfo(name),
			filterFlags: {},
			hasPreferFlags: false,
			selected: null,
			search: "",
			element_class: "",
			order: 0,
		});

		data.gamemodes[name] = gm;
		data.list.push(gm);

		return gm;
	},

	stopRefresh() {
		if (!ServersStore.type) return;
		luaRun("DoStopServers( %s )", ServersStore.type);
	},

	refresh() {
		const type = ServersStore.type;
		if (!type) return;

		ServersStore.requestNum[type] =
			(ServersStore.requestNum[type] || 0) + 1;

		const data = this.getTypeData(type);
		data.gamemodes = {};
		data.list.length = 0;
		ResetGamemodeInfo();

		luaRun(
			"GetServers( %s, %s )",
			type,
			String(ServersStore.requestNum[type]),
		);

		ServersStore.refreshing[type] = true;
		ServersStore.serverCount[type] = 0;
	},

	switchType(type) {
		if (ServersStore.type === type) return;

		this.stopRefresh();

		const firstTime = !ServersStore.types[type];

		this.getTypeData(type);

		ServersStore.type = type;
		ServersStore.currentGamemode = null;

		if (firstTime) {
			this.refresh();
		}
	},

	selectGamemode(gm) {
		ServersStore.currentGamemode = gm;
		if (gm) gm.server_offset = 0;
	},

	selectServer(server, event) {
		const current = ServersStore.currentGamemode;

		if (server == null) {
			if (current) current.selected = null;
			clearInterval(ServersStore.playerListInterval);
			return;
		}

		if (event && event.which !== 1) {
			luaRun("SetClipboardText( %s )", server.address);
			event.preventDefault();
			return;
		}

		current.selected = server;
		ServersStore.joinIfHasSlot = false;

		this.requestPlayerList(server.address);

		clearInterval(ServersStore.playerListInterval);
		ServersStore.playerListInterval = setInterval(() => {
			this.requestPlayerList(server.address);
			luaRun("PingServer( %s )", server.address);
		}, 10000);
	},

	requestPlayerList(address) {
		luaRun("GetPlayerList( %s )", address);
	},

	changeOrder(gm, order) {
		if (gm.orderByMain === order) {
			gm.orderReverse = !gm.orderReverse;
			return;
		}

		gm.orderByMain = order;
		gm.orderBy = [order, "recommended", "ping", "address"];
		gm.orderReverse = false;
	},

	gamemodeName(gm) {
		if (!gm) return "Unknown Gamemode";
		if (gm.info && gm.info.title) return StripWeirdSymbols(gm.info.title);
		return StripWeirdSymbols(gm.name);
	},

	joinServer(srv) {
		clearInterval(ServersStore.playerListInterval);
		ServersStore.joinIfHasSlot = false;

		if (srv.password)
			luaRun('RunConsoleCommand( "password", %s )', srv.password);

		luaRun("JoinServer( %s )", srv.address);

		this.stopRefresh();
	},

	toggleFavorite(server) {
		server.favorite = !server.favorite;

		if (server.favorite)
			luaRun(
				"serverlist.AddServerToFavorites( %s )",
				String(server.address),
			);
		else
			luaRun(
				"serverlist.RemoveServerFromFavorites( %s )",
				String(server.address),
			);
	},

	installGamemode(gm) {
		if (!gm || !gm.info || !gm.info.workshopid) return;
		luaRun("steamworks.Subscribe( %s )", String(gm.info.workshopid));
	},

	shouldShowInstall(gm) {
		if (!gm || !gm.info) return false;
		const wsid = gm.info.workshopid;
		if (!wsid || wsid === "") return false;
		return !Subscriptions.contains(String(wsid));
	},

	filterFlag(flag) {
		const current = ServersStore.currentGamemode;
		if (!current) return;

		if (current.filterFlags[flag] === false) {
			delete current.filterFlags[flag];
		} else if (current.filterFlags[flag] === true) {
			current.filterFlags[flag] = undefined;
		} else {
			current.filterFlags[flag] = true;
		}

		current.hasPreferFlags = Object.values(current.filterFlags).some(
			function (v) {
				return v === true;
			},
		);
	},

	filterFlagClass(flag) {
		const flags = ServersStore.currentGamemode
			? ServersStore.currentGamemode.filterFlags
			: {};
		if (flags[flag] === undefined) return "";
		if (flags[flag] === true) return "prefer";
		return "avoid";
	},

	serverFilter(server) {
		const current = ServersStore.currentGamemode;
		const f = ServersStore.filters;

		if (
			current.search &&
			server.name.toLowerCase().indexOf(current.search.toLowerCase()) ===
				-1 &&
			server.address.indexOf(current.search) === -1 &&
			String(server.map)
				.toLowerCase()
				.indexOf(current.search.toLowerCase()) === -1
		)
			return false;

		if (server.players < 1 && f.hasPlayers) return false;
		if (server.players >= server.maxplayers && f.notFull) return false;
		if (server.pass && f.hidePassword) return false;
		if (server.ping > f.maxPing) return false;
		if (server.players < f.plyMin) return false;
		if (server.players > f.plyMax) return false;
		if (server.version_c < 0 && f.hideOutdated) return false;
		if (server.flag && current.filterFlags[server.flag] === false)
			return false;
		if (current.hasPreferFlags && current.filterFlags[server.flag] !== true)
			return false;

		return true;
	},

	gamemodeFilter(gm) {
		if (ServersStore.gmSearch) {
			const search = ServersStore.gmSearch.toLowerCase();
			let found = gm.name.toLowerCase().indexOf(search) !== -1;
			if (
				!found &&
				gm.info &&
				String(gm.info.title).toLowerCase().indexOf(search) !== -1
			)
				found = true;
			if (!found) return false;
		}

		if (
			ServersStore.gmHasFilterTags &&
			gm.info &&
			!ServersStore.gmFilterTags[gm.info.tag ? gm.info.tag : "none"]
		)
			return false;

		return true;
	},

	findServersAtAddress() {
		ServersStore.foundServers = [];
		if (ServersStore.findServerString.length <= 0) return;

		luaRun(
			"FindServersAtAddress( %s )",
			ServersStore.findServerString.trim(),
		);
	},

	updateInfiniteScroll(elem) {
		const current = ServersStore.currentGamemode;
		if (!current) return;

		let offset = Math.max(
			Math.floor(elem.scrollTop / 22) - ServersStore.serversPerPage / 4,
			0,
		);
		offset -= offset % 2;
		current.server_offset = offset;
	},
};

function CalculateRank(server) {
	let recommended = server.ping;

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
	let h = 0;
	let v = "";

	for (const k in obj) {
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
	gmcat,
) {
	if (Number(id) !== ServersStore.requestNum[type]) return;

	if (!gamemode) gamemode = desc;
	if (maxplayers <= 1) return;

	version = parseInt(version) || 0;

	if (gmcat && ServersStore.gmCats.indexOf(gmcat) === -1) gmcat = "";
	if (loc && !loc.match(/^[a-zA-Z]+$/)) loc = "";

	const data = {
		ping: parseInt(ping),
		name: StripWeirdSymbols(name.trim()),
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

	const actualDate = new Date(data.lastplayed);
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

	const gm = ServerActions.getGamemode(data.gamemode, type);
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

	ServersStore.serverCount[type] = (ServersStore.serverCount[type] || 0) + 1;
}

function UpdateGamemodeInfo(server, type, gm) {
	const gi = GetGamemodeInfo(server.gamemode);

	if (!gi.titles) gi.titles = {};

	if (server.desc == server.gamemode.toLowerCase()) {
		for (const name of Object.keys(gi.titles)) {
			if (
				name != name.toLowerCase() &&
				name.toLowerCase() == server.gamemode.toLowerCase()
			) {
				server.desc = name;
				break;
			}
		}
	}

	if (!gi.titles[server.desc]) gi.titles[server.desc] = 0;
	gi.titles[server.desc] += Math.min(server.players, 10);
	if (server.desc == server.gamemode) gi.titles[server.desc] = 0;
	gi.title = GetHighestKey(gi.titles);

	if (server.category !== "") {
		if (!gi.categories) gi.categories = {};
		if (!gi.categories[server.category]) gi.categories[server.category] = 1;
		else gi.categories[server.category]++;
		gi.tag = GetHighestKey(gi.categories);
		if (gi.tag) gi.tag_set = true;
	}

	if (!gi.tag_set) {
		const title = gi.title || "";
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
		if (!gi.wsid) gi.wsid = {};
		if (!gi.wsid[server.workshopid]) gi.wsid[server.workshopid] = 1;
		else gi.wsid[server.workshopid]++;
		gi.workshopid = GetHighestKey(gi.wsid);
	}

	if (server.flag !== "") {
		if (!gm.flags) gm.flags = {};
		gm.flags[server.flag] = true;
		gm.hasflags = true;
	}
}

function SetPlayerList(serverip, players) {
	const current = ServersStore.currentGamemode;
	if (!current || !current.selected) return;
	if (current.selected.address != serverip) return;

	current.selected.playerlist = players;
}
