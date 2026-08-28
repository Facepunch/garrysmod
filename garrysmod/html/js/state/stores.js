window.addon = addonStore;
window.save = saveStore;
window.dupe = dupeStore;
window.demo = demoStore;

function OnSubscriptionsChanged() {
	var stores = [addonStore, saveStore, dupeStore, demoStore];
	for (var i = 0; i < stores.length; i++) {
		var store = stores[i];
		if (store.loading) continue;
		store.switchWithTag(
			store.category,
			store.offset,
			store.tagged,
			store.mapName
		);
	}
}
