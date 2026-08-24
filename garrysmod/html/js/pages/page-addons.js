var AddonsPage = {
	data: function () {
		return {
			store: addonStore,
			AddonsStore: AddonsStore,
			AddonActions: AddonActions,
			MenuActions: MenuActions,
			Subscriptions: Subscriptions,
			t: t,
			num0: num0,
			getNiceSize: getNiceSize,
			compatState: compatState,
			categories: ["trending", "popular", "latest"],
			categoriesSecondary: [
				"followed",
				"favorite",
				"friends",
				"mine",
				"downloaded_ugc",
			],
			addonTypes: [
				"gamemode",
				"map",
				"weapon",
				"tool",
				"npc",
				"entity",
				"effects",
				"vehicle",
				"model",
			],
		};
	},
	computed: {
		headerKey: function () {
			var s = this.store;
			return s.tagged === "" || s.tagged === "Addon"
				? "addons." + s.category
				: "addons." + s.tagged;
		},
		headerSubKey: function () {
			var s = this.store;
			return s.tagged === "" || s.tagged === "Addon"
				? "addons." + s.category + ".subtitle"
				: "addons." + s.tagged + ".subtitle";
		},
		presetNames: function () {
			var self = this;
			return objValues(compatState.presetList).filter(function (preset) {
				return (
					preset.name
						.toLowerCase()
						.indexOf(
							self.AddonsStore.presetSearchText.toLowerCase(),
						) !== -1
				);
			});
		},
		selectedPresetData: function () {
			return compatState.presetList[AddonsStore.selectedPreset];
		},
	},
	mounted: function () {
		luaRun("UpdateAddonDisabledState()");
		addonStore.switch("subscribed", 0);
	},
	methods: {
		entryClass: function (file) {
			return AddonActions.addonClasses(file);
		},
		entryDescription: function (file) {
			return AddonActions.addonDescription(file);
		},
		childTitle: function (fileid) {
			return compatState.childTitles[String(fileid)] || fileid;
		},
		isUninstallWarning: function () {
			return (
				AddonsStore.popupMessageKey === "addons.uninstallall.warning" ||
				AddonsStore.popupMessageKey ===
					"addons.uninstall_selected.warning"
			);
		},
		popupConfirmClass: function () {
			return AddonsStore.popupMessageFiles.length > 0
				? "create big"
				: "warning big";
		},
		fileUpvotes: function (file) {
			if (!file.info) return 0;
			return file.info.up - file.info.down;
		},
		fileHasSize: function (file) {
			return !!(file.info && file.info.size);
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
		backgroundImage: function (file) {
			return "../" + (file.background || "img/downloading.png");
		},
		isSubscribed: function (file) {
			return AddonActions.isSubscribed(file);
		},
		isEnabledFile: function (file) {
			return AddonActions.isEnabled(file);
		},
		hasFloatingInfo: function (file) {
			return !!(file.info && file.info.floating);
		},
		showCheckbox: function (file) {
			return (
				this.store.category === "subscribed" &&
				!this.hasFloatingInfo(file)
			);
		},
	},
	template: "#tpl-addons-page",
};
