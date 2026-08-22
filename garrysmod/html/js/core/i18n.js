const Lang = Vue.reactive({
	cache: {},
});

function t(str) {
	if (str == null) return "";

	const parts = String(str).split(" ");
	const key = parts.shift();
	const suffix = parts.join(" ");

	let base = Lang.cache[key];

	if (base == null) {
		base = key;

		if (window.language) {
			const cached = language.Update(key, function (outStr) {
				Lang.cache[key] = outStr;
			});

			if (cached != null) {
				Lang.cache[key] = cached;
				base = cached;
			}
		}
	}

	return base + (suffix ? " " + suffix : "");
}
