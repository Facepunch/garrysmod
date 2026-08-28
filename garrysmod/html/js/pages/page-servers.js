var ServersPage = {
	data: function () {
		return {
			ServersStore: ServersStore,
			ServerActions: ServerActions,
			MenuStore: MenuStore,
			MenuActions: MenuActions,
			Subscriptions: Subscriptions,
			t: t,
			sortByKeys: sortByKeys,
		};
	},
	computed: {
		gamemodeList: function () {
			var type = this.typeData;
			if (!type) return [];
			return sortByKeys(
				type.list.filter(function (gm) {
					return ServerActions.gamemodeFilter(gm);
				}),
				[ServersStore.gmSort, "-num_players", "name"]
			);
		},
		typeData: function () {
			return ServersStore.types[ServersStore.type];
		},
		sortedServers: function () {
			var current = ServersStore.currentGamemode;
			if (!current) return [];

			return sortByKeys(
				current.servers.filter(function (sv) {
					return ServerActions.serverFilter(sv);
				}),
				current.orderBy,
				current.orderReverse
			).slice(
				current.server_offset,
				current.server_offset + ServersStore.serversPerPage
			);
		},
		postPlaceholderHeight: function () {
			var current = ServersStore.currentGamemode;
			if (!current) return 0;
			return (
				Math.max(
					current.servers.length -
						ServersStore.serversPerPage -
						current.server_offset,
					0
				) * 26
			);
		},
		selectedPlayerList: function () {
			var current = ServersStore.currentGamemode;
			if (!current || !current.selected || !current.selected.playerlist)
				return [];

			var list = [];
			for (var name in current.selected.playerlist) {
				var player = current.selected.playerlist[name];
				list.push({
					name: name,
					score: player.score,
					time: player.time,
				});
			}

			list.sort(function (a, b) {
				return a.time - b.time;
			});
			return list;
		},
	},
	mounted: function () {
		if (!ServersStore.type) ServerActions.switchType("internet");
	},
	beforeDestroy: function () {
		ServerActions.stopRefresh();
		clearInterval(ServersStore.playerListInterval);
	},
	methods: {
		onScroll: function (event) {
			ServerActions.updateInfiniteScroll(event.target);
		},
		toggleGmTag: function (cat, checked) {
			if (checked) setKey(ServersStore.gmFilterTags, cat, true);
			else delKey(ServersStore.gmFilterTags, cat);

			ServersStore.gmHasFilterTags =
				Object.keys(ServersStore.gmFilterTags).length > 0;
		},
		reverseGmTag: function (cat) {
			for (var i = 0; i < ServersStore.gmCats.length; i++)
				setKey(ServersStore.gmFilterTags, ServersStore.gmCats[i], true);
			delKey(ServersStore.gmFilterTags, cat);
			ServersStore.gmHasFilterTags = true;
		},
		serverClass: function (server) {
			return {
				missingmap: !server.hasmap,
				empty: server.players === 0,
				activeserver:
					ServersStore.currentGamemode &&
					ServersStore.currentGamemode.selected === server,
			};
		},
		serverRank: function (server) {
			if (server.recommended < 50) return "rank5";
			if (server.recommended < 100) return "rank4";
			if (server.recommended < 200) return "rank3";
			if (server.recommended < 300) return "rank2";
			return "rank1";
		},
		playerTime: function (time) {
			return formatSeconds(time);
		},
		flagIcon: function (event) {
			event.target.src = "img/unk_flag.png";
		},
		gmIconError: function (event) {
			event.target.src = "../gamemodes/base/icon24.png";
		},
		gmFlags: function () {
			var current = ServersStore.currentGamemode;
			if (!current || !current.flags) return [];
			return Object.keys(current.flags);
		},
		playerOnLabel: function (num) {
			return num === 1 ? t("servers_player_on") : t("servers_players_on");
		},
		serverLabel: function (num) {
			return num === 1 ? t("servers_server") : t("servers_servers");
		},
	},
	template: "#tpl-servers-page",
};
