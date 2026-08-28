function luaRun(cmd) {
	var args = Array.prototype.slice.call(arguments, 1);

	if (typeof lua !== "undefined") {
		lua.Run.apply(lua, [cmd].concat(args));
		return;
	}

	console.log("RUNLUA:", cmd, args.join(" "));
}

function luaPlaySound(name) {
	luaRun("surface.PlaySound( %s )", String(name));
}

function closestElement(el, selector) {
	var node = el;
	while (node && node.nodeType === 1) {
		var matches = node.matches || node.webkitMatchesSelector;
		if (matches && matches.call(node, selector)) return node;
		node = node.parentNode;
	}
	return null;
}

function setupSoundHooks() {
	document.addEventListener("mouseover", function (e) {
		var target = closestElement(
			e.target,
			".options a, .noisy, .ui-sound-return"
		);
		if (target && (!e.relatedTarget || !target.contains(e.relatedTarget)))
			luaPlaySound("garrysmod/ui_hover.wav");
	});

	document.addEventListener("click", function (e) {
		if (closestElement(e.target, ".options a, .noisy"))
			luaPlaySound("garrysmod/ui_click.wav");
		else if (closestElement(e.target, ".ui-sound-return"))
			luaPlaySound("garrysmod/ui_return.wav");
	});
}
