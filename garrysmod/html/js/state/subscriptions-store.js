const SubscriptionsStore = Vue.reactive({
	files: {},
	filesUGC: {},
});

const Subscriptions = {
	contains(id) {
		id = String(id);
		if (SubscriptionsStore.filesUGC[id] != null) return true;
		return SubscriptionsStore.files[id] != null;
	},

	enabled(id) {
		return SubscriptionsStore.files[String(id)]
			? SubscriptionsStore.files[String(id)].mounted
			: false;
	},

	getInvalidReason(id) {
		const file = SubscriptionsStore.files[String(id)];
		if (!file) return undefined;
		return file.invalid_reason;
	},

	setAllEnabled(b) {
		for (const k in SubscriptionsStore.files) {
			this.setShouldMountAddon(k, b);
		}
	},

	subscribe(wsid) {
		luaRun("steamworks.Subscribe( %s )", String(wsid));
	},
	unsubscribe(wsid) {
		luaRun("steamworks.Unsubscribe( %s )", String(wsid));
	},
	markUnused(wsid) {
		luaRun("steamworks.MarkDownloadedItemAsUnused( %s )", String(wsid));
	},
	applyChanges() {
		luaRun("steamworks.ApplyAddons()");
	},

	setShouldMountAddon(wsid, b) {
		luaRun(
			"steamworks.SetShouldMountAddon( %s, " +
				(b ? "true" : "false") +
				" )",
			String(wsid),
		);
	},

	unsubscribeAll() {
		for (const k in SubscriptionsStore.files) {
			this.unsubscribe(k);
		}
	},

	getAll() {
		return SubscriptionsStore.files;
	},

	getCount() {
		return Object.keys(SubscriptionsStore.files).length;
	},

	Update(json) {
		const oldNum = Object.keys(SubscriptionsStore.files).length;

		const files = {};
		for (const k in json) {
			const wsid = String(json[k].wsid);
			if (wsid === "0") continue;
			files[wsid] = json[k];
		}

		SubscriptionsStore.files = files;

		const newNum = Object.keys(files).length;
		if (oldNum < newNum) OnSubscriptionsChanged();
	},

	UpdateUGC(json) {
		const oldNum = Object.keys(SubscriptionsStore.filesUGC).length;

		const files = {};
		for (const k in json) {
			files[String(json[k].wsid)] = json[k];
		}

		SubscriptionsStore.filesUGC = files;

		const newNum = Object.keys(files).length;
		if (oldNum < newNum) OnSubscriptionsChanged();
	},
};
