var SubscriptionsStore = Vue.observable({
	files: {},
	filesUGC: {},
});

var Subscriptions = {
	contains: function (id) {
		id = String(id);
		if (SubscriptionsStore.filesUGC[id] != null) return true;
		return SubscriptionsStore.files[id] != null;
	},

	enabled: function (id) {
		return SubscriptionsStore.files[String(id)]
			? SubscriptionsStore.files[String(id)].mounted
			: false;
	},

	getInvalidReason: function (id) {
		var file = SubscriptionsStore.files[String(id)];
		if (!file) return undefined;
		return file.invalid_reason;
	},

	setAllEnabled: function (b) {
		for (var k in SubscriptionsStore.files) {
			this.setShouldMountAddon(k, b);
		}
	},

	subscribe: function (wsid) {
		luaRun("steamworks.Subscribe( %s )", String(wsid));
	},
	unsubscribe: function (wsid) {
		luaRun("steamworks.Unsubscribe( %s )", String(wsid));
	},
	markUnused: function (wsid) {
		luaRun("steamworks.MarkDownloadedItemAsUnused( %s )", String(wsid));
	},
	applyChanges: function () {
		luaRun("steamworks.ApplyAddons()");
	},

	setShouldMountAddon: function (wsid, b) {
		luaRun(
			"steamworks.SetShouldMountAddon( %s, " +
				(b ? "true" : "false") +
				" )",
			String(wsid)
		);
	},

	unsubscribeAll: function () {
		for (var k in SubscriptionsStore.files) {
			this.unsubscribe(k);
		}
	},

	getAll: function () {
		return SubscriptionsStore.files;
	},

	getCount: function () {
		return Object.keys(SubscriptionsStore.files).length;
	},

	Update: function (json) {
		var oldNum = Object.keys(SubscriptionsStore.files).length;

		var files = {};
		for (var k in json) {
			var wsid = String(json[k].wsid);
			if (wsid === "0") continue;
			files[wsid] = json[k];
		}

		SubscriptionsStore.files = files;

		var newNum = Object.keys(files).length;
		if (oldNum < newNum) OnSubscriptionsChanged();
	},

	UpdateUGC: function (json) {
		var oldNum = Object.keys(SubscriptionsStore.filesUGC).length;

		var files = {};
		for (var k in json) {
			files[String(json[k].wsid)] = json[k];
		}

		SubscriptionsStore.filesUGC = files;

		var newNum = Object.keys(files).length;
		if (oldNum < newNum) OnSubscriptionsChanged();
	},
};
