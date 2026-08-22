function luaFormat(cmd, args) {
	let str = "";
	let arg = 0;

	for (let i = 0; i < cmd.length; i++) {
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

function luaRun(cmd, ...args) {
	if (typeof lua !== "undefined" && typeof lua.Run === "function") {
		lua.Run(cmd, ...args);
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
