const ServersPage = {
	setup() {
		Vue.onMounted(function () {
			if (!ServersStore.type) ServerActions.switchType("internet");
		});

		Vue.onUnmounted(function () {
			ServerActions.stopRefresh();
			clearInterval(ServersStore.playerListInterval);
		});

		return {
			ServersStore,
			ServerActions,
			MenuStore,
			MenuActions,
			Subscriptions,
			t,
			sortByKeys,
		};
	},
	computed: {
		gamemodeList() {
			const type = this.typeData;
			if (!type) return [];
			return sortByKeys(
				type.list.filter(function (gm) {
					return ServerActions.gamemodeFilter(gm);
				}),
				[ServersStore.gmSort, "-num_players", "name"],
			);
		},
		typeData() {
			return ServersStore.types[ServersStore.type];
		},
		sortedServers() {
			const current = ServersStore.currentGamemode;
			if (!current) return [];

			return sortByKeys(
				current.servers.filter(function (sv) {
					return ServerActions.serverFilter(sv);
				}),
				current.orderBy,
				current.orderReverse,
			).slice(
				current.server_offset,
				current.server_offset + ServersStore.serversPerPage,
			);
		},
		postPlaceholderHeight() {
			const current = ServersStore.currentGamemode;
			if (!current) return 0;
			return (
				Math.max(
					current.servers.length -
						ServersStore.serversPerPage -
						current.server_offset,
					0,
				) * 22
			);
		},
	},
	methods: {
		onScroll(event) {
			ServerActions.updateInfiniteScroll(event.target);
		},
		toggleGmTag(cat, checked) {
			if (checked) ServersStore.gmFilterTags[cat] = true;
			else delete ServersStore.gmFilterTags[cat];

			ServersStore.gmHasFilterTags =
				Object.keys(ServersStore.gmFilterTags).length > 0;
		},
		reverseGmTag(cat) {
			for (const c of ServersStore.gmCats)
				ServersStore.gmFilterTags[c] = true;
			delete ServersStore.gmFilterTags[cat];
			ServersStore.gmHasFilterTags = true;
		},
		serverClass(server) {
			return {
				missingmap: !server.hasmap,
				empty: server.players === 0,
				activeserver:
					ServersStore.currentGamemode &&
					ServersStore.currentGamemode.selected === server,
			};
		},
		serverRank(server) {
			if (server.recommended < 50) return "rank5";
			if (server.recommended < 100) return "rank4";
			if (server.recommended < 200) return "rank3";
			if (server.recommended < 300) return "rank2";
			return "rank1";
		},
		playerTime(time) {
			return formatSeconds(time);
		},
		flagIcon(event) {
			event.target.src = "img/unk_flag.png";
		},
		gmIconError(event) {
			event.target.src = "../gamemodes/base/icon24.png";
		},
	},
	template: `
<div class="page server-browser">

	<div class="options">
		<ul>
			<li><h2>{{ t('server_list') }}</h2></li>
			<li class="small" style="margin-top: -1.5em;">{{ ServersStore.serverCount[ServersStore.type] || 0 }} {{ t('servers_servercount') }}</li>
			<li class="small">{{ typeData ? typeData.list.length : 0 }} {{ t('servers_gmcount') }}</li>
			<li>&nbsp;</li>
			<li><a :class="{ active: ServersStore.type === 'internet' }" @click="ServerActions.switchType( 'internet' )">{{ t('servers_internet') }}</a></li>
			<li><a :class="{ active: ServersStore.type === 'favorite' }" @click="ServerActions.switchType( 'favorite' )">{{ t('servers_favorites') }}</a></li>
			<li><a :class="{ active: ServersStore.type === 'history' }" @click="ServerActions.switchType( 'history' )">{{ t('servers_history') }}</a></li>
			<li><a :class="{ active: ServersStore.type === 'lan' }" @click="ServerActions.switchType( 'lan' )">{{ t('servers_local') }}</a></li>
			<li v-if="(ServersStore.currentGamemode == null && !ServersStore.refreshing[ServersStore.type]) || ServersStore.refreshing[ServersStore.type]">&nbsp;</li>
			<li v-if="ServersStore.currentGamemode == null && !ServersStore.refreshing[ServersStore.type]"><a @click="ServerActions.refresh()">{{ t('servers_refresh') }}</a></li>
			<li v-if="ServersStore.refreshing[ServersStore.type]"><a @click="ServerActions.stopRefresh()">{{ t('servers_stoprefresh') }}</a></li>
			<li>&nbsp;</li>
			<li><a @click="MenuActions.menuOption( 'OpenServerBrowser' )">{{ t('legacy_browser') }}</a></li>
			<li>&nbsp;</li>
			<li class="filters-separator"></li>

			<li class="filters" v-if="ServersStore.currentGamemode == null">
				<span>{{ t('addons.sort_by') }}</span><br/>
				<input id="gms_players" type="radio" value="-order" v-model="ServersStore.gmSort"/><label for="gms_players">{{ t('gmsort_players') }}</label><br/>
				<input id="gms_servers" type="radio" value="-num_servers" v-model="ServersStore.gmSort"/><label for="gms_servers">{{ t('gmsort_servers') }}</label><br/>
				<input id="gms_name" type="radio" value="info.title" v-model="ServersStore.gmSort"/><label for="gms_name">{{ t('gmsort_name') }}</label><br/>
				<span>{{ t('addons.filter_by') }}</span><br/>
				<div v-for="cat in ServersStore.gmCats" :key="cat">
					<input type="checkbox" :id="'gmfltr_hide_' + cat" :checked="!!ServersStore.gmFilterTags[cat]" @change="toggleGmTag( cat, $event.target.checked )"/>
					<label :for="'gmfltr_hide_' + cat">{{ t('gmfltr_hide_' + cat) }}</label>
					<img class="filter-reverse" src="img/remove.png" @click="reverseGmTag( cat )"/><br/>
				</div>
				<input type="text" v-model="ServersStore.gmSearch" class="gamemode-search" :placeholder="t('gmsearch_placeholder')" /><br/>
			</li>

			<li class="filters" v-if="ServersStore.currentGamemode != null">
				<label for="SVFilterPlyMin">{{ t('svfltr_ply_limit') }}</label><br/>
				<input id="SVFilterPlyMin" v-model.number="ServersStore.filters.plyMin" type="number" class="input-small" placeholder="0" min="0" max="128" step="8"/>
				&nbsp;-&nbsp;
				<input v-model.number="ServersStore.filters.plyMax" type="number" class="input-small" placeholder="128" min="0" max="128" step="8"/><br/>
				<label for="SVFilterMaxPing">{{ t('svfltr_ping_limit') }}</label><br/>
				<input id="SVFilterMaxPing" v-model.number="ServersStore.filters.maxPing" type="number" class="input-small" placeholder="2000" min="0" max="2500" step="20"/><br/>
				<input type="checkbox" id="sv_notfull" v-model="ServersStore.filters.notFull"/><label for="sv_notfull">{{ t('svfltr_not_full') }}</label><br/>
				<input type="checkbox" id="sv_notempty" v-model="ServersStore.filters.hasPlayers"/><label for="sv_notempty">{{ t('svfltr_has_players') }}</label><br/>
				<input type="checkbox" id="sv_nopass" v-model="ServersStore.filters.hidePassword"/><label for="sv_nopass"><span>{{ t('svfltr_no_password') }}</span> <img class="passworded" src='img/server-passworded.png'/></label><br/>
				<input type="checkbox" id="sv_outdated" v-model="ServersStore.filters.hideOutdated"/><label for="sv_outdated">{{ t('svfltr_outdated') }}</label>

				<div class="flags-filter" v-if="ServersStore.currentGamemode.hasflags">
					<img v-for="(flag, index) in Object.keys(ServersStore.currentGamemode.flags)" :key="flag"
						class="flag" :class="ServerActions.filterFlagClass( flag )"
						:src="'asset://garrysmod/materials/flags16/' + flag + '.png'"
						@click="ServerActions.filterFlag( flag )" @error="flagIcon" loading="lazy"/>
				</div>
			</li>
		</ul>
	</div>

	<div class="innerpage" v-if="ServersStore.currentGamemode == null">
		<h1 class="menu-header">
			<span>{{ t('servers_gamemodes') }}</span>
			<small>{{ t('servers_gamemodes.subtitle') }}</small>
		</h1>

		<div class='gamemodes-panel'>
			<div class="gamemodes-scroll scrollable">
				<div v-for="gm in gamemodeList" :key="gm.name" class='gamemode' :class="gm.element_class" @click="ServerActions.selectGamemode( gm )">
					<img :src="'../gamemodes/' + gm.name + '/icon24.png'" @error="gmIconError"/>
					<div class='stats'>{{ gm.num_players }}
						<span>{{ gm.num_players === 1 ? t('servers_player_on') : t('servers_players_on') }}</span>
						{{ gm.num_servers }}
						<span>{{ gm.num_servers === 1 ? t('servers_server') : t('servers_servers') }}</span>
					</div>
					<div class='name'>
						{{ ServerActions.gamemodeName( gm ) }}<tag v-if="gm.info && gm.info.tag">{{ t('gmfltr_hide_' + gm.info.tag) }}</tag>
					</div>
					<span class='install-gamemode' v-if="ServerActions.shouldShowInstall( gm )" @click.stop="ServerActions.install-gamemode( gm )">&nbsp;</span>
				</div>
			</div>

			<div class='add-favorite' v-if="ServersStore.type === 'favorite'">
				<div class="header">
					<span>{{ t('servers_find_title') }}</span>
					<div class="fav-inputs">
						<input type="text" v-model="ServersStore.findServerString" placeholder="127.0.0.1:27015"/>
						<button @click="ServerActions.findServersAtAddress(); ServerActions.refresh();">{{ t('servers_find') }}</button>
					</div>
				</div>

				<div class="found-servers server-list" v-if="ServersStore.foundServers.length > 0">
					<div v-for="server in ServersStore.foundServers" :key="server.address" class="server">
						<name>
							<a class='favbutton' :class="{ favorited: server.favorite }" @click="ServerActions.toggleFavorite( server ); ServerActions.refresh();"></a>
							<img class="passworded" src='img/server-passworded.png' v-if="server.pass"/>
							<span>{{ server.name }}</span>
						</name>
						<ping>{{ server.ping }}</ping>
						<players>{{ server.players }} / {{ server.maxplayers }}</players>
						<map>{{ server.map }}</map>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="innerpage" v-if="ServersStore.currentGamemode != null">

		<h1 class="menu-header">
			<span>{{ ServerActions.gamemodeName( ServersStore.currentGamemode ) }}</span>
			<small>{{ t('join_a_server') }}</small>
		</h1>

		<div class='install-gamemode' v-if="ServerActions.shouldShowInstall( ServersStore.currentGamemode )" @click="ServerActions.install-gamemode( ServersStore.currentGamemode )">{{ t('servers_install_gamemode') }}</div>

		<div class='controls' style='position: absolute; left: 0; right: 0; margin-top: 5px;'>
			<input type="text" v-model="ServersStore.currentGamemode.search" class="searchbox" :placeholder="t('svsearch_placeholder')" />
			<a class='btn-blue' @click="ServerActions.selectGamemode(null)"><img src='img/bg_arrow_left.png' /> {{ t('return_to_gamemodes') }}</a>
		</div>

		<div class="server-layout">
			<div class='server-list'>
				<div class='header'>
					<name @click="ServerActions.changeOrder( ServersStore.currentGamemode, 'name' )">{{ t('server_name_header') }}</name>
					<map @click="ServerActions.changeOrder( ServersStore.currentGamemode, 'map' )">{{ t('server_mapname') }}</map>
					<players @click="ServerActions.changeOrder( ServersStore.currentGamemode, '-players' )">{{ t('server_players') }}</players>
					<ping @click="ServerActions.changeOrder( ServersStore.currentGamemode, 'ping' )">{{ t('server_ping') }}</ping>
					<rank @click="ServerActions.changeOrder( ServersStore.currentGamemode, 'recommended' )">{{ t('server_ranking') }}</rank>
				</div>

				<div class='body scrollable' @scroll="onScroll">
					<div :style="{ height: (ServersStore.currentGamemode.server_offset * 22) + 'px' }"></div>

					<div v-for="server in sortedServers" :key="server.address"
						class="server" :class="serverClass( server )"
						@mouseup="ServerActions.selectServer( server, $event )" @dblclick="ServerActions.joinServer( server )">
						<name>
							<a class='favbutton' :class="{ favorited: server.favorite }" @click.stop="ServerActions.toggleFavorite( server )"></a>
							<img class="flag" :src="'asset://garrysmod/materials/flags16/' + server.flag + '.png'" @error="flagIcon" v-if="server.flag" loading="lazy"/>
							<img class="passworded" src='img/server-passworded.png' v-if="server.pass" loading="lazy"/>
							<span>{{ server.name }}
								<tag :class="{ future: server.version_c > 0 }" v-if="server.version_c !== 0"><ver_str>{{ server.version_c > 0 ? t('server_ver_new') : t('server_ver_old') }}</ver_str>: {{ server.version }}</tag>
							</span>
						</name>
						<lastvisited v-if="server.lastplayed !== 0"><lbl>{{ t('server_lastvisit') }}</lbl> {{ server.lastplayedDate }} <span class='lasttime'>{{ server.lastplayedTime }}</span></lastvisited>
						<map>{{ server.map }}</map>
						<players>{{ server.players }} / {{ server.maxplayers }}</players>
						<ping>{{ server.ping }}</ping>
						<rank :class="serverRank( server )"><span class='bar'></span></rank>
					</div>

					<div :style="{ height: postPlaceholderHeight + 'px' }"></div>
				</div>
			</div>

			<div class='serverinfo' v-if="ServersStore.currentGamemode.selected">
				<span class="close-btn" @click="ServerActions.selectServer( null, $event )"></span>
				<div>
					<header>
						<div class="cell" style="padding-bottom: 5px; padding-right: 8px;">
							<name>{{ ServersStore.currentGamemode.selected.name }}</name>
							<address>{{ ServersStore.currentGamemode.selected.address }}</address>
						</div>
					</header>

					<players>
						<table style="font-size: 12px; padding: 8px; width: 100%;">
							<tr style="color: #999; font-weight: bold;">
								<td class="pname">{{ t('playerlist_name') }}</td>
								<td style="text-align: center;">{{ t('playerlist_score') }}</td>
								<td style="text-align: right;">{{ t('playerlist_time') }}</td>
							</tr>
							<tr v-for="player in [...Object.values(ServersStore.currentGamemode.selected.playerlist || {})].sort((a,b) => a.time - b.time)" :key="player.name">
								<td class="pname">{{ player.name }}</td>
								<td style="text-align: center;">{{ player.score }}</td>
								<td style="text-align: right;">{{ playerTime( player.time ) }}</td>
							</tr>
						</table>
					</players>

					<footer>
						<div class="cell" style="padding-top: 5px;">
							<input type='password' v-model="ServersStore.currentGamemode.selected.password" v-if="ServersStore.currentGamemode.selected.pass" @keyup.enter="ServerActions.joinServer( ServersStore.currentGamemode.selected )" :placeholder="t('password')" />

							<div v-if="ServersStore.currentGamemode.selected.players >= ServersStore.currentGamemode.selected.maxplayers">
								<input type="checkbox" v-model="ServersStore.joinIfHasSlot" id="join_if_not_full" />
								<label for="join_if_not_full">{{ t('sv_join_if_not_full') }}</label>
							</div>

							<button :class="ServersStore.currentGamemode.selected.players < ServersStore.currentGamemode.selected.maxplayers ? 'btn-primary' : 'btn-primary-disabled'"
								@click="ServerActions.joinServer( ServersStore.currentGamemode.selected )">
								{{ ServersStore.currentGamemode.selected.players < ServersStore.currentGamemode.selected.maxplayers ? t('servers_join_server') : t('servers_join_server_full') }}
							</button>
						</div>
					</footer>
				</div>
			</div>
		</div>
	</div>

</div>`,
};
