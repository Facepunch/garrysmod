function getNiceSize(size) {
	if (!size || size <= 0) return "0 Bytes";
	if (size < 1000) return size + " Bytes";
	if (size < 1000 * 1000) return Math.round(size / 1000, 2) + " KB";
	if (size < 1000 * 1000 * 1000)
		return Math.round(size / (1000 * 1000), 2) + " MB";
	return Math.round(size / (1000 * 1000 * 1000), 2) + " GB";
}

function num0(value) {
	return Math.round(Number(value) || 0).toLocaleString("en-US");
}

function pad(num) {
	return (num < 10 ? "0" : "") + num.toString();
}

function FormatVersion(ver) {
	if (!ver) return "Unknown version";

	var y = Math.floor(ver / 10000);
	var m = Math.floor((ver - y * 10000) / 100);
	var d = ver - y * 10000 - m * 100;
	return (y > 99 ? pad(y) : "20" + pad(y)) + "." + pad(m) + "." + pad(d);
}

function formatSeconds(value) {
	if (value == null) return "";
	if (value < 60) return Math.floor(value) + " sec";
	if (value < 60 * 60) return Math.floor(value / 60) + " min";
	if (value < 60 * 60 * 24) return Math.floor(value / 60 / 60) + " hr";
	return "a long time";
}

function resolvePath(obj, path) {
	return String(path)
		.split(".")
		.reduce(function (o, k) {
			return o == null ? o : o[k];
		}, obj);
}

function objValues(obj) {
	var out = [];
	for (var k in obj) {
		if (Object.prototype.hasOwnProperty.call(obj, k)) out.push(obj[k]);
	}
	return out;
}

function setKey(obj, key, value) {
	if (!obj) return;
	if (Object.prototype.hasOwnProperty.call(obj, key)) obj[key] = value;
	else Vue.set(obj, key, value);
}

function delKey(obj, key) {
	if (obj && Object.prototype.hasOwnProperty.call(obj, key))
		Vue.delete(obj, key);
}

function sortByKeys(list, keys, reverse) {
	var specs = Array.isArray(keys) ? keys.slice() : [keys];
	if (reverse) specs.push("__reverse__");

	return list.slice().sort(function (a, b) {
		for (var i = 0; i < specs.length; i++) {
			var dir = 1;
			var key = specs[i];

			if (key === "__reverse__") {
				dir = -1;
				key = null;
			} else if (typeof key === "string" && key.indexOf("-") === 0) {
				dir = -1;
				key = key.substr(1);
			}

			var av = key === null ? a : resolvePath(a, key);
			var bv = key === null ? b : resolvePath(b, key);

			if (av === bv) continue;

			var result;

			if (typeof av === "string" || typeof bv === "string") {
				result = String(av == null ? "" : av).localeCompare(
					String(bv == null ? "" : bv)
				);
			} else {
				var an = av == null ? 0 : av;
				var bn = bv == null ? 0 : bv;
				result = an < bn ? -1 : 1;
			}

			return result * dir;
		}

		return 0;
	});
}
