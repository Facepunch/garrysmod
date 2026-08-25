function createWorkshopStore(nameSpace) {
	var store = Vue.observable({
		nameSpace: nameSpace,

		offset: 0,
		totalResults: 0,
		numResults: 0,
		category: "",
		tagged: "",
		mapName: null,
		loading: true,
		perPage: 5,

		files: [],
		filesOther: [],

		page: 1,
		pages: [],

		iconWidth: 180,
		iconHeight: 180,
		iconMax: 181,

		searchTimer: 0,

		saveEnabled: false,
	});

	store.go = function (delta) {
		if (store.offset + delta >= store.totalResults) return;
		if (store.offset + delta < 0) return;

		store.switchWithTag(
			store.category,
			store.offset + delta,
			store.tagged,
			store.mapName
		);
	};

	store.goToPage = function (page) {
		var offset = (page - 1) * store.perPage;

		if (offset >= store.totalResults) return;
		if (offset < 0) return;

		store.switchWithTag(
			store.category,
			offset,
			store.tagged,
			store.mapName
		);
	};

	store.switch = function (type, offset) {
		store.switchWithTag(type, offset, "", store.mapName);
	};

	store.switchWithTag = function (type, offset, searchtag, mapname) {
		clearTimeout(store.searchTimer);

		store.refreshDimensions();

		if (store.category !== type || store.tagged !== searchtag)
			store.totalResults = 0;

		store.category = type;
		store.tagged = searchtag || "";
		store.mapName = mapname;
		store.offset = offset;
		store.loading = true;

		var filter = "";
		var searchText = "";
		var sortMethod = "subscribed";

		if (typeof AddonsStore !== "undefined") {
			if (AddonsStore.filterEnabledOnly) filter = "enabledonly";
			if (AddonsStore.filterDisabledOnly) filter = "disabledonly";
			searchText = AddonsStore.subscriptionSearchText || "";
			sortMethod = AddonsStore.ugcSortMethod || "subscribed";
		}

		store.updatePageNav();

		var tag = store.tagged;
		if (store.mapName && store.tagged)
			tag = store.tagged + "," + store.mapName;
		else if (store.mapName) tag = store.mapName;

		gmod.FetchItems(
			store.nameSpace,
			store.category,
			store.offset,
			store.perPage,
			tag,
			searchText,
			filter,
			sortMethod
		);
	};

	store.handleFilterChange = function () {
		store.switchWithTag(store.category, 0, store.tagged, store.mapName);
	};

	store.handleSortChange = function () {
		store.switchWithTag(store.category, 0, store.tagged, store.mapName);
	};

	store.handleOnSearch = function () {
		clearTimeout(store.searchTimer);
		store.searchTimer = setTimeout(function () {
			store.switchWithTag(store.category, 0, store.tagged, store.mapName);
		}, 500);
	};

	store.rate = function (entry, b) {
		if (!entry.id) return;
		if (!entry.info) return;
		if (b && entry.info.voted_up) return;
		if (!b && entry.info.voted_down) return;

		gmod.Vote(entry.id, b ? "1" : "0");

		if (b) {
			entry.info.voted_up = true;
			entry.info.voted_down = false;
			entry.info.up++;
		} else {
			entry.info.voted_up = false;
			entry.info.voted_down = true;
			entry.info.down++;
		}

		luaPlaySound(
			b
				? "npc/roller/mine/rmine_chirp_answer1.wav"
				: "buttons/button10.wav"
		);
	};

	store.favorite = function (entry, b) {
		if (!entry.id) return;
		if (entry.info) entry.info.favorite = b;

		gmod.SetFavorite(entry.id, b ? "1" : "0");

		luaPlaySound(
			b
				? "npc/roller/mine/rmine_chirp_answer1.wav"
				: "buttons/button10.wav"
		);
	};

	store.publishLocal = function (entry) {
		gmod.Publish(store.nameSpace, entry.info.file, entry.background);
	};

	store.deleteLocal = function (entry) {
		gmod.DeleteLocal(entry.info.file);
		gmod.DeleteLocal(entry.background);

		store.switch(store.category, store.offset);
	};

	store.ReceiveLocal = function (data) {
		store.loading = false;
		store.totalResults = Math.max(store.totalResults, data.totalresults);
		store.numResults = data.results.length;

		store.files = data.results.map(function (result, k) {
			return {
				order: k,
				local: true,
				background: result.preview,
				filled: true,
				info: {
					title: result.name,
					file: result.file,
					description: result.description,
				},
			};
		});

		store.updatePageNav();
	};

	store.ReceiveIndex = function (data) {
		store.loading = false;
		store.totalResults = Math.max(store.totalResults, data.totalresults);
		store.numResults = data.numresults;

		store.files = [];
		for (var k in data.results) {
			store.files.push({
				order: k,
				id: data.results[k],
				filled: false,
				info: {},
				extra: data.extraresults ? data.extraresults[k] : {},
				background: null,
			});
		}

		store.filesOther = [];
		if (data.otherresults) {
			for (var j in data.otherresults) {
				store.filesOther.push(data.otherresults[j]);
			}
		}

		store.updatePageNav();
	};

	store.ReceiveFileInfo = function (id, data) {
		if (!data) return;

		for (var i = 0; i < store.files.length; i++) {
			var file = store.files[i];
			if (String(file.id) !== String(id)) continue;

			file.filled = true;
			file.info = data;
		}
	};

	store.ReceiveFileUserInfo = function (id, data) {
		for (var i = 0; i < store.files.length; i++) {
			var file = store.files[i];
			if (String(file.id) !== String(id)) continue;

			if (file.info) {
				file.info.favorite = data.favorite;
				file.info.voted_up = data.voted_up;
				file.info.voted_down = data.voted_down;
			}
		}
	};

	store.ReceiveUserName = function (id, data) {
		for (var i = 0; i < store.files.length; i++) {
			var file = store.files[i];
			if (!file.filled || !file.info || file.info.owner != id) continue;

			file.info.ownername = data;
		}
	};

	store.ReceiveImage = function (id, url) {
		for (var i = 0; i < store.files.length; i++) {
			var file = store.files[i];
			if (String(file.id) !== String(id)) continue;

			file.background = url;
		}
	};

	store.refreshDimensions = function () {
		var container = document.querySelector("workshopcontainer");
		var rect = container
			? container.getBoundingClientRect()
			: { width: 1024, height: 768 };

		var w = Math.max(180, rect.width - 16);
		var h = Math.max(180, rect.height - 16 - 48);

		var iconswide = Math.floor(w / 180);
		var iconstall = Math.floor(h / 180);

		if (iconswide > 6) iconswide = 6;
		if (iconstall > 4) iconstall = 4;

		store.perPage = iconswide * iconstall;

		store.iconWidth = Math.floor(w / iconswide) - 26;
		store.iconHeight = Math.floor(h / iconstall) - 26;
		store.iconMax = Math.max(store.iconWidth, store.iconHeight) + 1;
	};

	store.updatePageNav = function () {
		store.page = Math.floor(store.offset / store.perPage) + 1;

		var maxPages = 32;
		var realMaxPages = Math.ceil(store.totalResults / store.perPage);

		var pageOfPages = Math.floor((store.page - 1) / maxPages);
		var pageOffset = pageOfPages * maxPages;

		store.pages = [];
		for (
			var i = pageOffset + 1;
			i < Math.min(realMaxPages + 1, pageOffset + 1 + maxPages);
			i++
		) {
			store.pages.push(i);
		}
	};

	return store;
}

var addonStore = createWorkshopStore("addon");
var saveStore = createWorkshopStore("ws_save");
var dupeStore = createWorkshopStore("ws_dupe");
var demoStore = createWorkshopStore("demo");
