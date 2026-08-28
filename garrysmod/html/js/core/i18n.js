var Lang = Vue.observable({
	cache: {},
});

function t(str) {
	if (str == null) return "";

	var parts = String(str).split(" ");
	var key = parts.shift();
	var suffix = parts.join(" ");

	var base = Lang.cache[key];

	if (base == null) {
		base = key;

		if (window.language) {
			var cached = language.Update(key, function (outStr) {
				Vue.set(Lang.cache, key, outStr);
			});

			if (cached != null) {
				Vue.set(Lang.cache, key, cached);
				base = cached;
			}
		}
	}

	return base + (suffix ? " " + suffix : "");
}
