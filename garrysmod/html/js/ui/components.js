function num0(value) {
	return Math.round(Number(value) || 0).toLocaleString("en-US");
}

const WbPagination = {
	props: ["store"],
	template: `
<pagination v-if="!store.loading && store.totalResults > 0">
	<a class="back" @click="store.go( store.perPage * -1 )">&nbsp;</a>
	<a class="next" @click="store.go( store.perPage * 1 )">&nbsp;</a>
	<div class="pages">
		<span v-for="p in store.pages" :key="p"><a :class="{ active: p === store.page }" class="page" @click="store.goToPage( p )"><img src="img/pagination_page.png?1" /></a></span><br/>
	</div>
	<span class="pagenum">{{ store.page }}</span>
</pagination>`,
};

const WbEntry = {
	props: ["file", "store", "mode", "standalone"],
	methods: {
		t,
		num0,
		isSubscribed() {
			return Subscriptions.contains(this.file.id);
		},
		openWorkshopFile() {
			MenuActions.openWorkshopFile(this.file.id);
		},
		rate(b) {
			this.store.rate(this.file, b);
		},
		favorite(b) {
			this.store.favorite(this.file, b);
		},
		publishLocal() {
			this.store.publishLocal(this.file);
		},
		deleteLocal() {
			this.store.deleteLocal(this.file);
		},
		subscribe() {
			Subscriptions.subscribe(this.file.id);
		},
		unsubscribe() {
			Subscriptions.unsubscribe(this.file.id);
		},
		loadSave() {
			if (this.file.local) {
				gmod.LoadSave(this.file.info.file);
				return;
			}
			gmod.DownloadSave(this.file.info.id);
		},
		armDupe() {
			if (this.file.local) {
				gmod.ArmDupe(this.file.info.file);
				return;
			}
			gmod.DownloadDupe(this.file.info.id);
		},
		playDemo() {
			if (this.file.local)
				return luaRun("demo:Play( %s )", this.file.info.file);
			luaRun("demo:DownloadAndPlay( %s )", this.file.info.id);
		},
		demoToVideo() {
			if (this.file.local)
				return luaRun("demo:ToVideo( %s )", this.file.info.file);
			luaRun("demo:DownloadAndToVideo( %s )", this.file.info.id);
		},
	},
	template: `
<workshopicon v-if="!store.loading" :style="{ width: Math.round(store.iconWidth)+'px', height: Math.round(store.iconHeight)+'px' }" :class="{ installed: isSubscribed() }">
	<preview v-if="file.background" :style="{ width: Math.round(store.iconMax)+'px', height: Math.round(store.iconMax)+'px', marginLeft: -Math.round(store.iconMax*0.5)+'px', marginTop: -Math.round(store.iconMax*0.5)+'px' }">
		<img :src="'../'+file.background" :style="{ width: Math.round(store.iconMax)+'px', height: Math.round(store.iconMax)+'px' }" loading="lazy"/>
	</preview>

	<name>
		<label @click="openWorkshopFile()">{{ file.info.title }}<span v-if="!file.info.title">{{ t('ugc.loading') }}</span></label>
	</name>
	<author v-if="!file.local">{{ file.info.ownername }}<span v-if="!file.info.ownername">{{ t('ugc.loading') }}</span></author>
	<votes v-if="!file.local && (file.info.up - file.info.down) > 0" style="color: #4a4">+{{ num0(file.info.up - file.info.down) }}</votes>
	<votes v-if="!file.local && (file.info.up - file.info.down) < 0" style="color: #a44">{{ num0(file.info.up - file.info.down) }}</votes>
	<description>{{ file.info.description }}</description>

	<controls>
		<left>
			<control :class="{ disabled: file.info.voted_up }" v-if="!file.local" @click="rate(true)"><img src="img/thumb-up.png" loading="lazy"/></control>
			<control :class="{ disabled: file.info.voted_down }" v-if="!file.local" @click="rate(false)"><img src="img/thumb-down.png" loading="lazy"/></control>
			<control v-if="!file.local && !file.info.favorite" @click="favorite(true)"><img src="img/favourite_addon.png" loading="lazy"/></control>
			<control v-if="!file.local && file.info.favorite" @click="favorite(false)"><img src="img/favourite_addon_remove.png" loading="lazy"/></control>
			<control v-if="file.local" @click="publishLocal()">{{ t(mode+'.publish') }}</control>
			<control v-if="file.local" @click="deleteLocal()">{{ t(mode+'.delete') }}</control>
			<control v-if="standalone && !file.local" @click="openWorkshopFile()">{{ t(mode+'.commentandrate') }}</control>
		</left>

		<right>
			<control v-if="mode === 'saves'" @click="loadSave()">{{ t('saves.load') }}</control>
			<control v-if="mode === 'dupes'" @click="armDupe()">{{ t('dupes.arm') }}</control>
			<template v-if="mode === 'demos'">
				<control @click="demoToVideo()">{{ t('demos.video') }}</control>
				<control @click="playDemo()">{{ t('demos.play') }}</control>
			</template>
			<template v-else>
				<control v-if="!file.local && !isSubscribed()" @click="subscribe()">{{ t('ugc.subscribe') }}</control>
				<control v-if="!file.local && isSubscribed()" @click="unsubscribe()">{{ t('ugc.unsubscribe') }}</control>
			</template>
		</right>
	</controls>
</workshopicon>`,
};
