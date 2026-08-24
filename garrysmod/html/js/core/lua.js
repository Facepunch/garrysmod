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
