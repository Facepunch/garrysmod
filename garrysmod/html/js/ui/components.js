function num0(value) {
	return Math.round(Number(value) || 0).toLocaleString("en-US");
}

var WbPagination = {
	props: ["store"],
	template: "#tpl-wb-pagination",
};

var WbEntry = {
	props: ["file", "store", "mode", "standalone"],
	methods: {
		t: t,
		num0: num0,
		isSubscribed: function () {
			return Subscriptions.contains(this.file.id);
		},
		openWorkshopFile: function () {
			MenuActions.openWorkshopFile(this.file.id);
		},
		rate: function (b) {
			this.store.rate(this.file, b);
		},
		favorite: function (b) {
			this.store.favorite(this.file, b);
		},
		publishLocal: function () {
			this.store.publishLocal(this.file);
		},
		deleteLocal: function () {
			this.store.deleteLocal(this.file);
		},
		subscribe: function () {
			Subscriptions.subscribe(this.file.id);
		},
		unsubscribe: function () {
			Subscriptions.unsubscribe(this.file.id);
		},
		loadSave: function () {
			if (this.file.local) {
				gmod.LoadSave(this.file.info.file);
				return;
			}
			gmod.DownloadSave(this.file.info.id);
		},
		armDupe: function () {
			if (this.file.local) {
				gmod.ArmDupe(this.file.info.file);
				return;
			}
			gmod.DownloadDupe(this.file.info.id);
		},
		playDemo: function () {
			if (this.file.local)
				return luaRun("demo:Play( %s )", this.file.info.file);
			luaRun("demo:DownloadAndPlay( %s )", this.file.info.id);
		},
		demoToVideo: function () {
			if (this.file.local)
				return luaRun("demo:ToVideo( %s )", this.file.info.file);
			luaRun("demo:DownloadAndToVideo( %s )", this.file.info.id);
		},
		iconStyle: function () {
			return {
				width: Math.round(this.store.iconWidth) + "px",
				height: Math.round(this.store.iconHeight) + "px",
			};
		},
		previewStyle: function () {
			var half = -Math.round(this.store.iconMax * 0.5);
			return {
				width: Math.round(this.store.iconMax) + "px",
				height: Math.round(this.store.iconMax) + "px",
				marginLeft: half + "px",
				marginTop: half + "px",
			};
		},
		imageStyle: function () {
			return {
				width: Math.round(this.store.iconMax) + "px",
				height: Math.round(this.store.iconMax) + "px",
			};
		},
		upvotes: function () {
			return this.file.info.up - this.file.info.down;
		},
	},
	template: "#tpl-wb-entry",
};
