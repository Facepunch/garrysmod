function luaFormat(cmd, args) {
	var str = "";
	var arg = 0;

	for (var i = 0; i < cmd.length; i++) {
		if (cmd[i] === "%") {
			i++;

			if (cmd[i] === "s") {
				str +=
					'"' + String(args[arg++]).replace(/["\\]/g, "\\$&") + '"';
				continue;
			}

			if (cmd[i] === "i") {
				str += args[arg++];
				continue;
			}
		}

		str += cmd[i];
	}

	return str;
}

function luaArgs(args) {
	return Array.prototype.slice.call(args);
}

function luaRun(cmd) {
	var args = luaArgs(arguments).slice(1);

	if (typeof lua !== "undefined" && typeof lua.Run === "function") {
		lua.Run.apply(lua, [cmd].concat(args));
		return;
	}

	console.log("RUNLUA:" + (args.length ? luaFormat(cmd, args) : cmd));
}

function luaPlaySound(name) {
	if (typeof lua !== "undefined" && typeof lua.PlaySound === "function") {
		lua.PlaySound(String(name));
		return;
	}

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
