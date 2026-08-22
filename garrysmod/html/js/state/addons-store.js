const AddonsStore = Vue.reactive({
	disabled: false,

	settingsOpen: false,
	filterEnabledOnly: false,
	filterDisabledOnly: false,
	ugcSortMethod: "subscribed",
	subscriptionSearchText: "",

	selectedItems: {},
	popupMessage: false,
	popupMessageKey: "addons.uninstallall.warning",
	popupMessageFiles: [],
	popupAction: null,

	createPresetOpen: false,
	importPresetOpen: false,
	importPresetLoading: false,
	loadPresetMenuOpen: false,
	loadPresetResub: false,
	presetSearchText: "",
	selectedPreset: undefined,
	presetNewAction: "",
	presetName: "",
	saveEnabled: true,
	saveDisabled: true,
	importSource: "",
});

const AddonActions = {
	isSubscribed(file) {
		return Subscriptions.contains(file.id);
	},
	isSubscribedID(id) {
		return Subscriptions.contains(id);
	},
	isEnabled(file) {
		return Subscriptions.enabled(file.id);
	},

	subscribe(file) {
		if (!file.info) file.info = { children: [] };

		if (file.info.children && file.info.children.length > 0) {
			const needsWarning = file.info.children.some(function (wsid) {
				return !Subscriptions.contains(wsid);
			});

			if (needsWarning) {
				for (const wsid of file.info.children) {
					luaRun("MenuGetAddonData( %s )", String(wsid));
				}

				AddonsStore.popupMessageFiles = file.info.children;
				this.displayPopupMessage("addons.addon_depends", function () {
					Subscriptions.subscribe(file.id);
				});
				return;
			}
		}

		Subscriptions.subscribe(file.id);
	},

	unsubscribe(file) {
		Subscriptions.unsubscribe(file.id);
	},

	markUnused(file) {
		Subscriptions.markUnused(file.id);
		addonStore.switchWithTag(
			addonStore.category,
			addonStore.offset,
			addonStore.tagged,
			addonStore.mapName,
		);
	},

	uninstallAllSubscribed() {
		Subscriptions.unsubscribeAll();
		Subscriptions.applyChanges();
	},
	disableAllSubscribed() {
		Subscriptions.setAllEnabled(false);
		Subscriptions.applyChanges();
	},
	enableAllSubscribed() {
		Subscriptions.setAllEnabled(true);
		Subscriptions.applyChanges();
	},

	disable(file) {
		Subscriptions.setShouldMountAddon(String(file.id), false);
		Subscriptions.applyChanges();
	},
	enable(file) {
		Subscriptions.setShouldMountAddon(String(file.id), true);
		Subscriptions.applyChanges();
	},

	displayPopupMessage(key, func) {
		AddonsStore.popupMessage = true;
		AddonsStore.popupMessageKey = key;
		AddonsStore.popupAction = func || null;
	},

	closePopupMessage(keepPresets) {
		AddonsStore.popupMessage = false;
		AddonsStore.popupMessageFiles = [];
		AddonsStore.createPresetOpen = false;
		AddonsStore.importPresetOpen = false;
		if (!keepPresets) {
			AddonsStore.loadPresetMenuOpen = false;
			AddonsStore.selectedPreset = undefined;
		}
	},

	executePopupAction() {
		const action = AddonsStore.popupAction;
		this.closePopupMessage(true);
		if (action) action();
	},

	unselectAll() {
		for (const k in AddonsStore.selectedItems)
			AddonsStore.selectedItems[k] = false;
	},

	selectAllPage() {
		for (const file of addonStore.files) {
			if (parseInt(file.id) < 1) continue;
			AddonsStore.selectedItems[file.id] = true;
		}
	},

	selectAll() {
		this.unselectAll();

		if (!addonStore.filesOther) return;

		for (const wsid of addonStore.filesOther) {
			if (parseInt(wsid) < 1) continue;
			AddonsStore.selectedItems[wsid] = true;
		}
	},

	toggleSelect(file, event) {
		const tag = event.target.nodeName.toLowerCase();
		if (
			tag !== "controls" &&
			tag !== "description" &&
			tag !== "workshopicon"
		)
			return;

		AddonsStore.selectedItems[file.id] =
			!AddonsStore.selectedItems[file.id];
		event.stopPropagation();
	},

	applyMountToSelected(b) {
		for (const k in AddonsStore.selectedItems) {
			if (!AddonsStore.selectedItems[k] || k < 1) continue;
			Subscriptions.setShouldMountAddon(k, b);
			AddonsStore.selectedItems[k] = false;
		}
		Subscriptions.applyChanges();
	},

	enableAllSelected() {
		this.applyMountToSelected(true);
	},
	disableAllSelected() {
		this.applyMountToSelected(false);
	},

	uninstallAllSelected() {
		for (const k in AddonsStore.selectedItems) {
			if (!AddonsStore.selectedItems[k]) continue;
			Subscriptions.unsubscribe(k);
			AddonsStore.selectedItems[k] = false;
		}
		Subscriptions.applyChanges();
	},

	isAnySelected() {
		return Object.values(AddonsStore.selectedItems).some(function (v) {
			return v;
		});
	},
	getSelectedCount() {
		return Object.values(AddonsStore.selectedItems).filter(function (v) {
			return v;
		}).length;
	},
	getSubscribedCount() {
		return Subscriptions.getCount();
	},

	openCreatePresetMenu() {
		AddonsStore.saveEnabled = true;
		AddonsStore.saveDisabled = true;
		AddonsStore.presetNewAction = "";
		AddonsStore.presetName = "";
		AddonsStore.createPresetOpen = true;
	},

	openImportPresetMenu() {
		this.openCreatePresetMenu();
		AddonsStore.importSource = "";
		AddonsStore.createPresetOpen = false;
		AddonsStore.importPresetOpen = true;
	},

	createNewPreset() {
		if (AddonsStore.presetName === "") return;

		const preset = {
			enabled: [],
			disabled: [],
			name: AddonsStore.presetName,
			newAction: AddonsStore.presetNewAction,
		};

		for (const id in Subscriptions.getAll()) {
			const mounted = SubscriptionsStore.files[id].mounted;
			if (mounted && AddonsStore.saveEnabled) preset.enabled.push(id);
			if (!mounted && AddonsStore.saveDisabled) preset.disabled.push(id);
		}

		luaRun("CreateNewAddonPreset( %s )", JSON.stringify(preset));

		AddonsStore.createPresetOpen = false;
	},

	openLoadPresetMenu() {
		luaRun("ListAddonPresets()");
		AddonsStore.loadPresetMenuOpen = true;
		AddonsStore.loadPresetResub = false;
		AddonsStore.selectedPreset = undefined;
		AddonsStore.presetSearchText = "";
	},

	selectPreset(name, newAction) {
		AddonsStore.selectedPreset = name;
		AddonsStore.presetNewAction = newAction;
	},

	deletePreset(name) {
		const self = this;
		this.displayPopupMessage(
			"addons.delete_preset_warn " + name,
			function () {
				luaRun("DeleteAddonPreset( %s )", name);
				AddonsStore.selectedPreset = undefined;
			},
		);
	},

	loadSelectedPreset() {
		const presetList = compatState.presetList;
		const preset = presetList[AddonsStore.selectedPreset];
		const newAct = AddonsStore.presetNewAction;

		if (AddonsStore.loadPresetResub) {
			for (const k in preset.disabled)
				if (!Subscriptions.contains(preset.disabled[k]))
					Subscriptions.subscribe(preset.disabled[k]);

			for (const k in preset.enabled)
				if (!Subscriptions.contains(preset.enabled[k]))
					Subscriptions.subscribe(preset.enabled[k]);

			Subscriptions.applyChanges();
		}

		const idsDone = {};
		for (const k in preset.disabled) {
			Subscriptions.setShouldMountAddon(preset.disabled[k], false);
			idsDone[preset.disabled[k]] = true;
		}
		for (const k in preset.enabled) {
			Subscriptions.setShouldMountAddon(preset.enabled[k], true);
			idsDone[preset.enabled[k]] = true;
		}

		if (newAct !== "") {
			for (const id in Subscriptions.getAll()) {
				if (!idsDone[id]) {
					Subscriptions.setShouldMountAddon(id, newAct == "enable");
				}
			}
		}

		Subscriptions.applyChanges();
		AddonsStore.loadPresetMenuOpen = false;
		AddonsStore.selectedPreset = undefined;
	},

	copySelectedPreset() {
		const presetList = compatState.presetList;
		const copy = JSON.parse(
			JSON.stringify(presetList[AddonsStore.selectedPreset]),
		);
		delete copy.$$hashKey;
		luaRun("SetClipboardText( %s )", JSON.stringify(copy));
	},

	importPreset() {
		if (AddonsStore.presetName === "") return;

		AddonsStore.importPresetOpen = false;

		const source = AddonsStore.importSource;

		if (source.indexOf("http") === 0 || /^([0-9]+)$/.test(source)) {
			AddonsStore.importPresetLoading = true;
			let match =
				/https?:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?(?:.*)id=([0-9]+)(?:.*)/.exec(
					source,
				);
			if (!match) match = /([0-9]+)/.exec(source);

			if (!match) {
				onImportPresetFailed();
				return;
			}

			const preset = {
				enabled: [],
				disabled: [],
				name: AddonsStore.presetName,
				newAction: AddonsStore.presetNewAction,
			};
			luaRun(
				"ImportAddonPreset( %s, %s )",
				match[1],
				JSON.stringify(preset),
			);
		} else {
			try {
				const imported = JSON.parse(source);
				const preset = {
					enabled: imported.enabled || [],
					disabled: imported.disabled || [],
					name: AddonsStore.presetName,
					newAction: AddonsStore.presetNewAction,
				};
				luaRun("CreateNewAddonPreset( %s )", JSON.stringify(preset));
			} catch (err) {
				onImportPresetFailed();
			}
		}
	},

	addonClasses(file) {
		const classes = [];
		if (this.isSubscribed(file)) {
			classes.push(this.isEnabled(file) ? "installed" : "disabled");
			if (Subscriptions.getInvalidReason(file.id))
				classes.push("invalid");
		}
		if (file.info && file.info.floating) classes.push("floating");
		return classes.join(" ");
	},

	addonDescription(file) {
		const invalid = Subscriptions.getInvalidReason(file.id);
		if (invalid) return invalid;
		if (!file.info) return "ERROR?";
		return file.info.description;
	},
};

const compatState = Vue.reactive({ presetList: {}, childTitles: {} });
