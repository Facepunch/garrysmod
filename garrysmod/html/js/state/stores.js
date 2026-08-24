var addonStore = createWorkshopStore("addon");
var saveStore = createWorkshopStore("ws_save");
var dupeStore = createWorkshopStore("ws_dupe");
var demoStore = createWorkshopStore("demo");

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
