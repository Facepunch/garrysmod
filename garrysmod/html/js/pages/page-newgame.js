const NewGamePage = {
	setup() {
		const state = Vue.reactive({ playersDropdown: false });

		Vue.onMounted(function () {
			const store = NewGameStore;

			if (!store.currentCategory) {
				if (store.savedMap && store.savedCategory) {
					store.map = store.savedMap;
					store.lastCategory = store.savedCategory;
				}

				store.currentCategory = store.lastCategory || "Sandbox";

				const favMaps = Object.keys(store.mapListFav);
				if (favMaps.length > 0 && !store.lastCategory) {
					store.currentCategory = "Favourites";
					if (!store.map) store.map = favMaps[0];
				}
			}

			if (localStorage.MaxPlayers) {
				const saved = parseInt(localStorage.MaxPlayers);
				if (store.playerOptions.includes(saved))
					store.maxPlayers = saved;
			}

			luaRun("UpdateServerSettings()");

			setTimeout(function () {
				const elem = document.querySelector(".mapicon.selected");
				if (elem)
					elem.scrollIntoView({
						behavior: "smooth",
						block: "center",
					});
			}, 100);
		});

		return { state, NewGameStore, MenuStore, NewGameActions, t };
	},
	computed: {
		categories() {
			return sortByKeys(NewGameStore.mapList, "order").filter(
				function (cat) {
					return NewGameActions.countFiltered(cat.maps) > 0;
				},
			);
		},
		maxPlayersLabel() {
			return "maxplayers_" + NewGameStore.maxPlayers;
		},
	},
	methods: {
		mapsInCategory(category) {
			const filtered = NewGameActions.filterMaps(
				category.maps,
				NewGameStore.search,
			);
			return filtered.slice().sort(function (a, b) {
				return a.localeCompare(b);
			});
		},
		mapClass(map) {
			return map === NewGameStore.map ? "selected" : "";
		},
		favClass(map) {
			return NewGameActions.isFavMap(map) ? "favmap" : "";
		},
	},
	template: `
<div class="page">

	<div class="maplist icons">

		<div class="controls">
			<ul>
				<li v-for="cat in categories" :key="cat.category"
					class="noisy category" :class="{ active: cat.category === NewGameStore.currentCategory }"
					@click="NewGameActions.switchCategory( cat.category )">
					<div class='name'>
						<span v-if="cat.category !== 'Favourites' && cat.category !== 'Other'">{{ cat.category }}</span>
						<span v-if="cat.category === 'Favourites'">{{ t('newgame_favorite_maps') }}</span>
						<span v-if="cat.category === 'Other'">{{ t('spawnmenu.category.other') }}</span>
					</div>
					<div class='count'>{{ NewGameActions.countFiltered( cat.maps ) }}</div>
				</li>
			</ul>

			<div class='search'>
				<input type="text" class="search" v-model="NewGameStore.search" :placeholder="t('searchbar_placeholder')" />
			</div>
		</div>

		<div class="scrollable" style="margin: 0px; top: 0px; left: 200px">
			<ul class="category" v-for="cat in categories" :key="'list-' + cat.category" v-show="cat.category === NewGameStore.currentCategory">
				<li>
					<span v-if="cat.category !== 'Favourites' && cat.category !== 'Other'">{{ cat.category }}</span><span v-if="cat.category === 'Favourites'">{{ t('newgame_favorite_maps') }}</span><span v-if="cat.category === 'Other'">{{ t('spawnmenu.category.other') }}</span>
					<small class="count-note">{{ NewGameActions.countFiltered( cat.maps ) }} {{ NewGameActions.countFiltered( cat.maps ) === 1 ? t('newgame_map') : t('newgame_maps') }}</small>
				</li>

				<li v-for="map in mapsInCategory( cat )" :key="cat.category + '-' + map"
					class="icon mapicon" :class="[mapClass( map ), favClass( map )]">
					<img @click="NewGameActions.toggleFavMap( map )" class="favtoggle" src="img/empty.png" loading="lazy"/>
					<img @click="NewGameActions.selectMap( map )" @dblclick="NewGameActions.startGame()" :src="NewGameActions.mapIcon( map, cat.category )" class="thumbnail" loading="lazy"/><br />
					<span>{{ map }}</span>
				</li>
			</ul>
		</div>
	</div>

	<gamesettings>
		<div class="dropdown" style="margin: 10px;">
			<div class="label" @click="state.playersDropdown = !state.playersDropdown">
				<span>{{ t(maxPlayersLabel) }}</span>
				<i class='caret'></i>
			</div>
			<div class="contents" v-show="state.playersDropdown" @click="state.playersDropdown = false">
				<div v-for="num in NewGameStore.playerOptions" :key="num" @click="NewGameActions.updateMaxPlayers( num )">
					{{ t('maxplayers_' + num) }}
				</div>
			</div>
		</div>

		<div class="scrollable" style="bottom: 80px; top: 32px">
			<div class='control control-text' v-if="NewGameStore.maxPlayers > 1">
				<label for="ServerSettings_hostname">{{ t('server_name') }}</label>
				<input id="ServerSettings_hostname" type="text" v-model="NewGameStore.serverSettings.hostname" />
			</div>

			<div class='control' v-if="NewGameStore.maxPlayers > 1">
				<input id="ServerSettings_sv_lan" type="checkbox" v-model="NewGameStore.serverSettings.sv_lan" @change="NewGameActions.onCheckboxChange()" />
				<label for="ServerSettings_sv_lan">{{ t('lan_server') }}</label>
			</div>

			<div class='control' v-if="NewGameStore.maxPlayers > 1">
				<input id="ServerSettings_p2p_enabled" type="checkbox" v-model="NewGameStore.serverSettings.p2p_enabled" @change="NewGameActions.onCheckboxChange()" />
				<label for="ServerSettings_p2p_enabled">{{ t('p2p_server') }}</label>
			</div>

			<div class='control control-sub' v-if="NewGameStore.maxPlayers > 1">
				<input id="p2p_friendsonly" type="checkbox" v-model="NewGameStore.serverSettings.p2p_friendsonly" :disabled="!NewGameStore.serverSettings.p2p_enabled" />
				<label for="p2p_friendsonly">{{ t('p2p_server_friendsonly') }}</label>
			</div>

			<div class='control control-text' v-for="s in NewGameStore.serverSettings.Text" :key="'t-' + s.name" v-show="NewGameStore.maxPlayers > 1 || s.Singleplayer">
				<label :for="'ServerSettings_text_' + s.name">{{ t(s.text) }}</label>
				<input :id="'ServerSettings_text_' + s.name" type="text" v-model="s.Value"/>
			</div>

			<div class='control control-numeric' v-for="s in NewGameStore.serverSettings.Numeric" :key="'n-' + s.name" v-show="NewGameStore.maxPlayers > 1 || s.Singleplayer">
				<label :for="'ServerSettings_num_' + s.name">{{ t(s.text) }}</label>
				<input :id="'ServerSettings_num_' + s.name" type="text" v-model="s.Value"/>
			</div>

			<div class='control' v-for="s in NewGameStore.serverSettings.CheckBox" :key="'c-' + s.name" v-show="NewGameStore.maxPlayers > 1 || s.Singleplayer">
				<input :id="'ServerSettings_check_' + s.name" type="checkbox" v-model="s.Value" />
				<label :for="'ServerSettings_check_' + s.name">{{ t(s.text) }}</label>
			</div>
		</div>

		<bottom>
			<button class='btn-primary' @click="NewGameActions.startGame()">{{ t('start_game') }}</button>
		</bottom>
	</gamesettings>

</div>`,
};
