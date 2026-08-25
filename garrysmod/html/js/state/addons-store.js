var AddonsStore = Vue.observable({
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

var AddonActions = {
	isSubscribed: function (file) {
		return Subscriptions.contains(file.id);
	},
	isEnabled: function (file) {
		return Subscriptions.enabled(file.id);
	},

	subscribe: function (file) {
		if (!file.info) setKey(file, "info", { children: [] });

		if (file.info.children && file.info.children.length > 0) {
			var needsWarning = file.info.children.some(function (wsid) {
				return !Subscriptions.contains(wsid);
			});

			if (needsWarning) {
				for (var i = 0; i < file.info.children.length; i++) {
					var wsid = file.info.children[i];
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

	unsubscribe: function (file) {
		Subscriptions.unsubscribe(file.id);
	},

	markUnused: function (file) {
		Subscriptions.markUnused(file.id);
		addonStore.switchWithTag(
			addonStore.category,
			addonStore.offset,
			addonStore.tagged,
			addonStore.mapName
		);
	},

	uninstallAllSubscribed: function () {
		Subscriptions.unsubscribeAll();
		Subscriptions.applyChanges();
	},
	disableAllSubscribed: function () {
		Subscriptions.setAllEnabled(false);
		Subscriptions.applyChanges();
	},
	enableAllSubscribed: function () {
		Subscriptions.setAllEnabled(true);
		Subscriptions.applyChanges();
	},

	disable: function (file) {
		Subscriptions.setShouldMountAddon(String(file.id), false);
		Subscriptions.applyChanges();
	},
	enable: function (file) {
		Subscriptions.setShouldMountAddon(String(file.id), true);
		Subscriptions.applyChanges();
	},

	displayPopupMessage: function (key, func) {
		AddonsStore.popupMessage = true;
		AddonsStore.popupMessageKey = key;
		AddonsStore.popupAction = func || null;
	},

	closePopupMessage: function (keepPresets) {
		AddonsStore.popupMessage = false;
		AddonsStore.popupMessageFiles = [];
		AddonsStore.createPresetOpen = false;
		AddonsStore.importPresetOpen = false;
		if (!keepPresets) {
			AddonsStore.loadPresetMenuOpen = false;
			AddonsStore.selectedPreset = undefined;
		}
	},

	executePopupAction: function () {
		var action = AddonsStore.popupAction;
		this.closePopupMessage(true);
		if (action) action();
	},

	warnEnableAll: function () {
		this.displayPopupMessage("addons.enableall.warning", function () {
			AddonActions.enableAllSubscribed();
		});
	},

	warnDisableAll: function () {
		this.displayPopupMessage("addons.disableall.warning", function () {
			AddonActions.disableAllSubscribed();
		});
	},

	warnUninstallAll: function () {
		this.displayPopupMessage("addons.uninstallall.warning", function () {
			AddonActions.uninstallAllSubscribed();
		});
	},

	warnUninstallSelected: function () {
		this.displayPopupMessage(
			"addons.uninstall_selected.warning",
			function () {
				AddonActions.uninstallAllSelected();
			}
		);
	},

	unselectAll: function () {
		for (var k in AddonsStore.selectedItems)
			AddonsStore.selectedItems[k] = false;
	},

	selectAllPage: function () {
		for (var i = 0; i < addonStore.files.length; i++) {
			var file = addonStore.files[i];
			if (parseInt(file.id) < 1) continue;
			setKey(AddonsStore.selectedItems, file.id, true);
		}
	},

	selectAll: function () {
		this.unselectAll();

		for (var i = 0; i < addonStore.filesOther.length; i++) {
			var wsid = addonStore.filesOther[i];
			if (parseInt(wsid) < 1) continue;
			setKey(AddonsStore.selectedItems, wsid, true);
		}
	},

	toggleSelect: function (file, event) {
		var tag = event.target.nodeName.toLowerCase();
		if (
			tag !== "controls" &&
			tag !== "description" &&
			tag !== "workshopicon"
		)
			return;

		setKey(
			AddonsStore.selectedItems,
			file.id,
			!AddonsStore.selectedItems[file.id]
		);
		event.stopPropagation();
	},

	toggleCheckboxSelect: function (file, checked) {
		setKey(AddonsStore.selectedItems, file.id, checked);
	},

	applyMountToSelected: function (b) {
		for (var k in AddonsStore.selectedItems) {
			if (!AddonsStore.selectedItems[k] || k < 1) continue;
			Subscriptions.setShouldMountAddon(k, b);
			AddonsStore.selectedItems[k] = false;
		}
		Subscriptions.applyChanges();
	},

	enableAllSelected: function () {
		this.applyMountToSelected(true);
	},
	disableAllSelected: function () {
		this.applyMountToSelected(false);
	},

	uninstallAllSelected: function () {
		for (var k in AddonsStore.selectedItems) {
			if (!AddonsStore.selectedItems[k]) continue;
			Subscriptions.unsubscribe(k);
			AddonsStore.selectedItems[k] = false;
		}
		Subscriptions.applyChanges();
	},

	isAnySelected: function () {
		return objValues(AddonsStore.selectedItems).some(function (v) {
			return v;
		});
	},
	getSelectedCount: function () {
		return objValues(AddonsStore.selectedItems).filter(function (v) {
			return v;
		}).length;
	},
	getSubscribedCount: function () {
		return Subscriptions.getCount();
	},

	openCreatePresetMenu: function () {
		AddonsStore.saveEnabled = true;
		AddonsStore.saveDisabled = true;
		AddonsStore.presetNewAction = "";
		AddonsStore.presetName = "";
		AddonsStore.createPresetOpen = true;
	},

	openImportPresetMenu: function () {
		this.openCreatePresetMenu();
		AddonsStore.importSource = "";
		AddonsStore.createPresetOpen = false;
		AddonsStore.importPresetOpen = true;
	},

	createNewPreset: function () {
		if (AddonsStore.presetName === "") return;

		var preset = {
			enabled: [],
			disabled: [],
			name: AddonsStore.presetName,
			newAction: AddonsStore.presetNewAction,
		};

		for (var id in Subscriptions.getAll()) {
			var mounted = SubscriptionsStore.files[id].mounted;
			if (mounted && AddonsStore.saveEnabled) preset.enabled.push(id);
			if (!mounted && AddonsStore.saveDisabled) preset.disabled.push(id);
		}

		luaRun("CreateNewAddonPreset( %s )", JSON.stringify(preset));

		AddonsStore.createPresetOpen = false;
	},

	openLoadPresetMenu: function () {
		luaRun("ListAddonPresets()");
		AddonsStore.loadPresetMenuOpen = true;
		AddonsStore.loadPresetResub = false;
		AddonsStore.selectedPreset = undefined;
		AddonsStore.presetSearchText = "";
	},

	selectPreset: function (name, newAction) {
		AddonsStore.selectedPreset = name;
		AddonsStore.presetNewAction = newAction;
	},

	deletePreset: function (name) {
		this.displayPopupMessage(
			"addons.delete_preset_warn " + name,
			function () {
				luaRun("DeleteAddonPreset( %s )", name);
				AddonsStore.selectedPreset = undefined;
			}
		);
	},

	loadSelectedPreset: function () {
		var presetList = compatState.presetList;
		var preset = presetList[AddonsStore.selectedPreset];
		var newAct = AddonsStore.presetNewAction;

		if (AddonsStore.loadPresetResub) {
			for (var a in preset.disabled)
				if (!Subscriptions.contains(preset.disabled[a]))
					Subscriptions.subscribe(preset.disabled[a]);

			for (var b in preset.enabled)
				if (!Subscriptions.contains(preset.enabled[b]))
					Subscriptions.subscribe(preset.enabled[b]);

			Subscriptions.applyChanges();
		}

		var idsDone = {};
		for (var c in preset.disabled) {
			Subscriptions.setShouldMountAddon(preset.disabled[c], false);
			idsDone[preset.disabled[c]] = true;
		}
		for (var d in preset.enabled) {
			Subscriptions.setShouldMountAddon(preset.enabled[d], true);
			idsDone[preset.enabled[d]] = true;
		}

		if (newAct !== "") {
			for (var id in Subscriptions.getAll()) {
				if (!idsDone[id]) {
					Subscriptions.setShouldMountAddon(id, newAct == "enable");
				}
			}
		}

		Subscriptions.applyChanges();
		AddonsStore.loadPresetMenuOpen = false;
		AddonsStore.selectedPreset = undefined;
	},

	copySelectedPreset: function () {
		var presetList = compatState.presetList;
		var copy = JSON.parse(
			JSON.stringify(presetList[AddonsStore.selectedPreset])
		);
		luaRun("SetClipboardText( %s )", JSON.stringify(copy));
	},

	importPreset: function () {
		if (AddonsStore.presetName === "") return;

		AddonsStore.importPresetOpen = false;

		var source = AddonsStore.importSource;

		if (source.indexOf("http") === 0 || /^([0-9]+)$/.test(source)) {
			AddonsStore.importPresetLoading = true;
			var match =
				/https?:\/\/steamcommunity\.com\/sharedfiles\/filedetails\/\?(?:.*)id=([0-9]+)(?:.*)/.exec(
					source
				);
			if (!match) match = /([0-9]+)/.exec(source);

			if (!match) {
				onImportPresetFailed();
				return;
			}

			var preset = {
				enabled: [],
				disabled: [],
				name: AddonsStore.presetName,
				newAction: AddonsStore.presetNewAction,
			};
			luaRun(
				"ImportAddonPreset( %s, %s )",
				match[1],
				JSON.stringify(preset)
			);
		} else {
			try {
				var imported = JSON.parse(source);
				var newPreset = {
					enabled: imported.enabled || [],
					disabled: imported.disabled || [],
					name: AddonsStore.presetName,
					newAction: AddonsStore.presetNewAction,
				};
				luaRun("CreateNewAddonPreset( %s )", JSON.stringify(newPreset));
			} catch (err) {
				onImportPresetFailed();
			}
		}
	},

	addonClasses: function (file) {
		var classes = [];
		if (this.isSubscribed(file)) {
			classes.push(this.isEnabled(file) ? "installed" : "disabled");
			if (Subscriptions.getInvalidReason(file.id))
				classes.push("invalid");
		}
		if (file.info && file.info.floating) classes.push("floating");
		return classes.join(" ");
	},

	addonDescription: function (file) {
		var invalid = Subscriptions.getInvalidReason(file.id);
		if (invalid) return invalid;
		if (!file.info) return "ERROR?";
		return file.info.description;
	},
};

var compatState = Vue.observable({ presetList: {}, childTitles: {} });
