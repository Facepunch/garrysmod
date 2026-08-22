const NavBar = {
	setup() {
		return { MenuStore, MenuActions, Router, t, sortByKeys };
	},
	computed: {
		sortedGames() {
			return sortByKeys(MenuStore.games, [
				"-installed",
				"-owned",
				"title",
			]);
		},
		sortedGamemodes() {
			return sortByKeys(
				MenuStore.gamemodes.filter(function (gm) {
					return gm.menusystem;
				}),
				"name",
			);
		},
	},
	template: `
<div id="NavBar">

	<div class="group left">
		<a href="#/" class="button ui-sound-return" v-show="Router.path !== '/'" id="BackToMenu"><img src='img/back_to_main_menu.png' loading="lazy"><span>{{ t('back_to_main_menu') }}</span></a>
	</div>

	<div class="group center">
		<div class="button bigicon" v-if="MenuStore.inGame" @click="MenuActions.backToGame()"><a href="#/"><img src='img/back_to_game.png' loading="lazy"><span>{{ t('back_to_game') }}</span></a></div>
		<div class="button bigicon hidelabel" v-if="MenuStore.inGame && MenuStore.showFavButton && !MenuStore.isCurrentServerFav" @click="MenuActions.toggleServerFavorites( true )"><a href="#/"><img src='img/favourite_server.png' loading="lazy"><span>{{ t('favorite_this_server') }}</span></a></div>
		<div class="button bigicon hidelabel" v-if="MenuStore.inGame && MenuStore.showFavButton && MenuStore.isCurrentServerFav" @click="MenuActions.toggleServerFavorites( false )"><a href="#/"><img src='img/favourite_server_del.png' loading="lazy"><span>{{ t('unfavorite_this_server') }}</span></a></div>
	</div>

	<div class="group right">
		<div class="button smallicon hidelabel" style="overflow: visible;" @click="MenuActions.toggleProblems()"><img src='img/error.png'>
			<span>{{ t('problems') }}</span>
			<number v-if="MenuStore.problemCount > 0" :class="MenuStore.problemSeverity > 0 ? 'severity' + MenuStore.problemSeverity : ''">{{ MenuStore.problemCount }}</number>
		</div>
		<div class="button smallicon" v-if="MenuStore.kinect.available" @click="MenuActions.togglePopup( 'kinect' )"><img src='img/kinect.png' loading="lazy"><span></span></div>
		<div class="button smallicon hidelabel" @click="MenuActions.togglePopup( 'games' )"><img src='img/games.png'><span>{{ t('games') }}</span></div>
		<div class="button smallicon" @click="MenuActions.togglePopup( 'language' )"><img style="margin-top: 9px;" :src="'../resource/localization/' + MenuStore.language + '.png'"><span></span></div>
		<div class="button bigicon" @click="MenuActions.togglePopup( 'gamemode' )"><img :src="'../gamemodes/' + MenuStore.gamemode + '/icon24.png'"><span>{{ MenuStore.gamemodeTitle }}</span></div>
	</div>

</div>

<ul class="gamemode-list popup" v-show="MenuStore.popup === 'gamemode'">
	<li v-for="gm in sortedGamemodes" :key="gm.name" @click="MenuActions.selectGamemode( gm )">
		<img :src="'../gamemodes/' + gm.name + '/icon24.png'" loading="lazy"><span>{{ gm.title }}</span>
	</li>
</ul>

<ul class="language-list popup" v-show="MenuStore.popup === 'language'">
	<li v-for="lang in MenuStore.languages" :key="lang" @click="MenuActions.selectLanguage( lang )">
		<img :src="'../resource/localization/' + lang + '.png'" loading="lazy">
	</li>
</ul>

<ul class="games-list popup" v-show="MenuStore.popup === 'games'">
	<li class="notowned"><img src='img/notowned.png' width="16" height="16" loading="lazy"> <span>{{ t('game_not_owned') }}</span></li>
	<li class="notinstalled"><img src='img/notinstalled.png' width="16" height="16" loading="lazy"> <span>{{ t('game_not_installed') }}</span></li>
	<hr/>
	<li v-for="game in sortedGames" :key="game.folder || game.title"
		class="game-item" :class="{ notowned: !game.owned, notinstalled: !game.installed }">
		<input type="checkbox" v-model="game.mounted" v-if="game.installed" @change="MenuActions.gameMountChanged( game )"/>
		<img src='img/notowned.png' v-if="!game.owned" width="16" height="16" loading="lazy">
		<img src='img/notinstalled.png' v-if="game.owned && !game.installed" width="16" height="16" loading="lazy">
		<img :src="'../materials/games/16/' + game.folder + '.png'" style="margin-left: 20px;" loading="lazy">
		<span style="margin-left: 16px;">{{ game.title }}</span>
	</li>
</ul>

<ul class="kinect-settings popup" v-show="MenuStore.popup === 'kinect'">
	<li>
		<div>
			<p>
				<label style="display: block">
					<input type="checkbox" v-model="MenuStore.kinect.showColor" @change="MenuActions.updateKinect()"> <span>{{ t('motionsensor.showcolor') }}</span>
				</label>
			</p>

			<div v-if="MenuStore.kinect.showColor">
				<span>{{ t('motionsensor.colorpos') }}</span>
				<p style="margin-left: 5px;">
					<label v-for="option in MenuStore.kinect.colorOptions" :key="option" style="display: block">
						<input type="radio" name="kinect.color" :value="option" v-model="MenuStore.kinect.color" @change="MenuActions.updateKinect()">
						<span>{{ t('motionsensor.showcolor.' + option) }}</span>
					</label>
				</p>
			</div>

			<div v-if="MenuStore.kinect.showColor">
				<span>{{ t('motionsensor.colorsize') }}</span>
				<p style="margin-left: 5px;">
					<label v-for="option in MenuStore.kinect.sizeOptions" :key="option" style="display: block">
						<input type="radio" name="kinect.color_size" :value="option" v-model="MenuStore.kinect.colorSize" @change="MenuActions.updateKinect()">
						<span>{{ t('motionsensor.colorsize.' + option) }}</span>
					</label>
				</p>
			</div>
		</div>
	</li>
</ul>`,
};
