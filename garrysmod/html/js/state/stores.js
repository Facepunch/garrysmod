const addonStore = createWorkshopStore("addon");
const saveStore = createWorkshopStore("ws_save");
const dupeStore = createWorkshopStore("ws_dupe");
const demoStore = createWorkshopStore("demo");

window.addon = addonStore;
window.save = saveStore;
window.dupe = dupeStore;
window.demo = demoStore;

function OnSubscriptionsChanged() {
	for (const store of [addonStore, saveStore, dupeStore, demoStore]) {
		if (store.loading) continue;
		store.switchWithTag(
			store.category,
			store.offset,
			store.tagged,
			store.mapName,
		);
	}
}
