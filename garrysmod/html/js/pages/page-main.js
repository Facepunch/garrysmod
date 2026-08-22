const MainPage = {
	setup() {
		return { MenuStore, NewsStore, MenuActions, NewsActions, t };
	},
	template: `
<div class="page">

	<div class="options">
		<ul>
			<li><img :src="'../gamemodes/' + MenuStore.gamemode + '/logo.png'" /></li>
			<li>&nbsp;</li>
			<li v-if="MenuStore.inGame"><a @click="MenuActions.backToGame()">{{ t('resume_game') }}</a></li>
			<li v-if="MenuStore.inGame">&nbsp;</li>
			<li><a href="#/newgame/">{{ t('new_game') }}</a></li>
			<li><a href="#/servers/">{{ t('find_mp_game') }}</a></li>
			<li>&nbsp;</li>
			<li><a href="#/addons/">{{ t('addons') }}</a></li>
			<li><a href="#/dupes/">{{ t('dupes') }}</a></li>
			<li><a href="#/saves/">{{ t('saves') }}</a></li>
			<li><a href="#/demos/">{{ t('demos') }}</a></li>
			<li>&nbsp;</li>
			<li><a @click="MenuActions.menuOption( 'OpenOptionsDialog' )">{{ t('options') }}</a></li>
			<li>&nbsp;</li>
			<li v-if="MenuStore.inGame"><a @click="MenuActions.menuOption( 'Disconnect' )">{{ t('disconnect') }}</a></li>
			<li><a @click="MenuActions.menuOption( 'Quit' )">{{ t('quit') }}</a></li>
		</ul>
	</div>

	<div class="news" v-show="NewsStore.list.length > 0">
		<div class="news-item" v-if="NewsStore.currentItem" :style="{ backgroundImage: 'url(' + NewsStore.currentItem.HeaderImage + ')' }" v-show="!NewsStore.hideNews">
			<div>
				<span @click="NewsActions.openInSteam( NewsStore.currentItem.Url )">{{ NewsStore.currentItem.Title }}</span>
				<font>{{ NewsStore.currentItem.SummaryHtml }}</font>
			</div>
		</div>
		<div class='news-buttons'>
			<div @click="NewsActions.toggleNewsList()" v-show="!NewsStore.hideNews && !NewsStore.anyNewItems"><img src="../materials/icon16/cross.png"></div>
			<div v-for="item in [...NewsStore.list].sort((a, b) => Date.parse(a.Date) - Date.parse(b.Date))" :key="item.Url"
				:class="{ selected: item.Url === NewsStore.currentItem.Url }"
				@click="NewsActions.selectItem(item)"></div>
		</div>
	</div>

</div>`,
};
