var ServersStore = Vue.observable({
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

var ServerActions = {
	getTypeData: function (type) {
		if (!ServersStore.types[type]) {
			setKey(ServersStore.types, type, Vue.observable({
				gamemodes: {},
				list: [],
			}));
		}
		return ServersStore.types[type];
	},

	getGamemode: function (name, type) {
		if (!ServersStore.types[type]) return;

		var data = this.getTypeData(type);
		if (data.gamemodes[name]) return data.gamemodes[name];

		var gm = Vue.observable({
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
			flags: {},
			hasflags: false,
		});

		setKey(data.gamemodes, name, gm);
		data.list.push(gm);

		return gm;
	},

	stopRefresh: function () {
		if (!ServersStore.type) return;
		luaRun("DoStopServers( %s )", ServersStore.type);
	},

	refresh: function () {
		var type = ServersStore.type;
		if (!type) return;

		ServersStore.requestNum[type] =
			(ServersStore.requestNum[type] || 0) + 1;

		var data = this.getTypeData(type);
		data.gamemodes = {};
		data.list = [];
		ResetGamemodeInfo();

		luaRun(
			"GetServers( %s, %s )",
			type,
			String(ServersStore.requestNum[type])
		);

		setKey(ServersStore.refreshing, type, true);
		setKey(ServersStore.serverCount, type, 0);
	},

	switchType: function (type) {
		if (ServersStore.type === type) return;

		this.stopRefresh();

		var firstTime = !ServersStore.types[type];

		this.getTypeData(type);

		ServersStore.type = type;
		ServersStore.currentGamemode = null;

		if (firstTime) {
			this.refresh();
		}
	},

	selectGamemode: function (gm) {
		ServersStore.currentGamemode = gm;
		if (gm) gm.server_offset = 0;
	},

	selectServer: function (server, event) {
		var current = ServersStore.currentGamemode;
		var self = this;

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
		ServersStore.playerListInterval = setInterval(function () {
			self.requestPlayerList(server.address);
			luaRun("PingServer( %s )", server.address);
		}, 10000);
	},

	requestPlayerList: function (address) {
		luaRun("GetPlayerList( %s )", address);
	},

	changeOrder: function (gm, order) {
		if (gm.orderByMain === order) {
			gm.orderReverse = !gm.orderReverse;
			return;
		}

		gm.orderByMain = order;
		gm.orderBy = [order, "recommended", "ping", "address"];
		gm.orderReverse = false;
	},

	gamemodeName: function (gm) {
		if (!gm) return "Unknown Gamemode";
		if (gm.info && gm.info.title) return gm.info.title;
		return gm.name;
	},

	joinServer: function (srv) {
		clearInterval(ServersStore.playerListInterval);
		ServersStore.joinIfHasSlot = false;

		if (srv.password)
			luaRun('RunConsoleCommand( "password", %s )', srv.password);

		luaRun("JoinServer( %s )", srv.address);

		this.stopRefresh();
	},

	toggleFavorite: function (server) {
		server.favorite = !server.favorite;

		if (server.favorite)
			luaRun(
				"serverlist.AddServerToFavorites( %s )",
				String(server.address)
			);
		else
			luaRun(
				"serverlist.RemoveServerFromFavorites( %s )",
				String(server.address)
			);
	},

	installGamemode: function (gm) {
		if (!gm || !gm.info || !gm.info.workshopid) return;
		luaRun("steamworks.Subscribe( %s )", String(gm.info.workshopid));
	},

	shouldShowInstall: function (gm) {
		if (!gm || !gm.info) return false;
		var wsid = gm.info.workshopid;
		if (!wsid || wsid === "") return false;
		return !Subscriptions.contains(String(wsid));
	},

	filterFlag: function (flag) {
		var current = ServersStore.currentGamemode;
		if (!current) return;

		if (current.filterFlags[flag] === false) {
			delKey(current.filterFlags, flag);
		} else if (current.filterFlags[flag] === true) {
			setKey(current.filterFlags, flag, undefined);
		} else {
			setKey(current.filterFlags, flag, true);
		}

		current.hasPreferFlags = objValues(current.filterFlags).some(
			function (v) {
				return v === true;
			}
		);
	},

	filterFlagClass: function (flag) {
		var flags = ServersStore.currentGamemode
			? ServersStore.currentGamemode.filterFlags
			: {};
		if (flags[flag] === undefined) return "";
		if (flags[flag] === true) return "prefer";
		return "avoid";
	},

	serverFilter: function (server) {
		var current = ServersStore.currentGamemode;
		var f = ServersStore.filters;

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

	gamemodeFilter: function (gm) {
		if (ServersStore.gmSearch) {
			var search = ServersStore.gmSearch.toLowerCase();
			var found = gm.name.toLowerCase().indexOf(search) !== -1;
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

	findServersAtAddress: function () {
		ServersStore.foundServers = [];
		if (ServersStore.findServerString.length <= 0) return;

		luaRun(
			"FindServersAtAddress( %s )",
			ServersStore.findServerString.trim()
		);
	},

	updateInfiniteScroll: function (elem) {
		var current = ServersStore.currentGamemode;
		if (!current) return;

		var offset = Math.max(
			Math.floor(elem.scrollTop / 26) - ServersStore.serversPerPage / 4,
			0
		);
		offset -= offset % 2;
		current.server_offset = offset;
	},
};
