function getNiceSize(size) {
	if (!size || size <= 0) return "0 Bytes";
	if (size < 1000) return size + " Bytes";
	if (size < 1000 * 1000) return Math.round(size / 1000, 2) + " KB";
	if (size < 1000 * 1000 * 1000)
		return Math.round(size / (1000 * 1000), 2) + " MB";
	return Math.round(size / (1000 * 1000 * 1000), 2) + " GB";
}

function StripWeirdSymbols(name) {
	let ret = String(name).replace(
		/[\u2100-\u23FF\u2580-\u259F\u25A0-\u25FF\u2600-\u26FF\u2700-\u27BF\u2B00-\u2BFF]/g,
		"",
	);
	ret = ret.replace(/([\uD83C|\uD83D|\uD83E][\uDC00-\uDFFF])/g, "");
	return ret;
}

function pad(num) {
	return (num < 10 ? "0" : "") + num.toString();
}

function FormatVersion(ver) {
	if (!ver) return "Unknown version";

	const y = Math.floor(ver / 10000);
	const m = Math.floor((ver - y * 10000) / 100);
	const d = ver - y * 10000 - m * 100;
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

function sortByKeys(list, keys, reverse) {
	const specs = Array.isArray(keys) ? keys.slice() : [keys];
	if (reverse) specs.push("__reverse__");

	return list.slice().sort(function (a, b) {
		for (const spec of specs) {
			let dir = 1;
			let key = spec;

			if (key === "__reverse__") {
				dir = -1;
				key = null;
			} else if (typeof key === "string" && key.startsWith("-")) {
				dir = -1;
				key = key.substr(1);
			}

			const av = key === null ? a : resolvePath(a, key);
			const bv = key === null ? b : resolvePath(b, key);

			if (av === bv) continue;

			const result =
				typeof av === "string" || typeof bv === "string"
					? String(av ?? "").localeCompare(String(bv ?? ""))
					: (av ?? 0) < (bv ?? 0)
						? -1
						: 1;

			return result * dir;
		}

		return 0;
	});
}
