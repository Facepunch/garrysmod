local string = string
local math = math

--[[---------------------------------------------------------
   Name: string.ToTable( string )
-----------------------------------------------------------]]
function string.ToTable ( str )
	local tbl = {}
	
	for i = 1, string.len( str ) do
		tbl[i] = string.sub( str, i, i )
	end
	
	return tbl
end

--[[---------------------------------------------------------
   Name: string.JavascriptSafe( string )
   Desc: Takes a string and escapes it for insertion into a JavaScript string
-----------------------------------------------------------]]
local javascript_escape_replacements = {
	["\\"] = "\\\\",
	["\0"] = "\\x00" ,
	["\b"] = "\\b" ,
	["\t"] = "\\t" ,
	["\n"] = "\\n" ,
	["\v"] = "\\v" ,
	["\f"] = "\\f" ,
	["\r"] = "\\r" ,
	["\""] = "\\\"",
	["\'"] = "\\\'"
}

function string.JavascriptSafe( str )

	str = str:gsub( ".", javascript_escape_replacements )

	-- U+2028 and U+2029 are treated as line separators in JavaScript, handle separately as they aren't single-byte
	str = str:gsub( "\226\128\168", "\\\226\128\168" )
	str = str:gsub( "\226\128\169", "\\\226\128\169" )

	return str

end

--[[---------------------------------------------------------
   Name: string.PatternSafe( string )
   Desc: Takes a string and escapes it for insertion into a Lua pattern
-----------------------------------------------------------]]
local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

function string.PatternSafe( str )

	return ( str:gsub( ".", pattern_escape_replacements ) )

end

--[[---------------------------------------------------------
   Name: string.HTMLEncode( string )
   Desc: Converts a string to its HTML entities
   Desc: The html_entities table is taken straight from PHP's
-----------------------------------------------------------]]

local html_entities = {['"']="&quot;",["'"]="&#039;",["<"]="&lt;",[">"]="&gt;",[" "]="&nbsp;",["¡"]="&iexcl;",["¢"]="&cent;",["£"]="&pound;",["¤"]="&curren;",["¥"]="&yen;",["¦"]="&brvbar;",["§"]="&sect;",["¨"]="&uml;",["©"]="&copy;",["ª"]="&ordf;",["«"]="&laquo;",["¬"]="&not;",["­"]="&shy;",["®"]="&reg;",["¯"]="&macr;",["°"]="&deg;",["±"]="&plusmn;",["²"]="&sup2;",["³"]="&sup3;",["´"]="&acute;",["µ"]="&micro;",["¶"]="&para;",["·"]="&middot;",["¸"]="&cedil;",["¹"]="&sup1;",["º"]="&ordm;",["»"]="&raquo;",["¼"]="&frac14;",["½"]="&frac12;",["¾"]="&frac34;",["¿"]="&iquest;",["À"]="&Agrave;",["Á"]="&Aacute;",["Â"]="&Acirc;",["Ã"]="&Atilde;",["Ä"]="&Auml;",["Å"]="&Aring;",["Æ"]="&AElig;",["Ç"]="&Ccedil;",["È"]="&Egrave;",["É"]="&Eacute;",["Ê"]="&Ecirc;",["Ë"]="&Euml;",["Ì"]="&Igrave;",["Í"]="&Iacute;",["Î"]="&Icirc;",["Ï"]="&Iuml;",["Ð"]="&ETH;",["Ñ"]="&Ntilde;",["Ò"]="&Ograve;",["Ó"]="&Oacute;",["Ô"]="&Ocirc;",["Õ"]="&Otilde;",["Ö"]="&Ouml;",["×"]="&times;",["Ø"]="&Oslash;",["Ù"]="&Ugrave;",["Ú"]="&Uacute;",["Û"]="&Ucirc;",["Ü"]="&Uuml;",["Ý"]="&Yacute;",["Þ"]="&THORN;",["ß"]="&szlig;",["à"]="&agrave;",["á"]="&aacute;",["â"]="&acirc;",["ã"]="&atilde;",["ä"]="&auml;",["å"]="&aring;",["æ"]="&aelig;",["ç"]="&ccedil;",["è"]="&egrave;",["é"]="&eacute;",["ê"]="&ecirc;",["ë"]="&euml;",["ì"]="&igrave;",["í"]="&iacute;",["î"]="&icirc;",["ï"]="&iuml;",["ð"]="&eth;",["ñ"]="&ntilde;",["ò"]="&ograve;",["ó"]="&oacute;",["ô"]="&ocirc;",["õ"]="&otilde;",["ö"]="&ouml;",["÷"]="&divide;",["ø"]="&oslash;",["ù"]="&ugrave;",["ú"]="&uacute;",["û"]="&ucirc;",["ü"]="&uuml;",["ý"]="&yacute;",["þ"]="&thorn;",["ÿ"]="&yuml;",["Œ"]="&OElig;",["œ"]="&oelig;",["Š"]="&Scaron;",["š"]="&scaron;",["Ÿ"]="&Yuml;",["ƒ"]="&fnof;",["ˆ"]="&circ;",["˜"]="&tilde;",["Α"]="&Alpha;",["Β"]="&Beta;",["Γ"]="&Gamma;",["Δ"]="&Delta;",["Ε"]="&Epsilon;",["Ζ"]="&Zeta;",["Η"]="&Eta;",["Θ"]="&Theta;",["Ι"]="&Iota;",["Κ"]="&Kappa;",["Λ"]="&Lambda;",["Μ"]="&Mu;",["Ν"]="&Nu;",["Ξ"]="&Xi;",["Ο"]="&Omicron;",["Π"]="&Pi;",["Ρ"]="&Rho;",["Σ"]="&Sigma;",["Τ"]="&Tau;",["Υ"]="&Upsilon;",["Φ"]="&Phi;",["Χ"]="&Chi;",["Ψ"]="&Psi;",["Ω"]="&Omega;",["α"]="&alpha;",["β"]="&beta;",["γ"]="&gamma;",["δ"]="&delta;",["ε"]="&epsilon;",["ζ"]="&zeta;",["η"]="&eta;",["θ"]="&theta;",["ι"]="&iota;",["κ"]="&kappa;",["λ"]="&lambda;",["μ"]="&mu;",["ν"]="&nu;",["ξ"]="&xi;",["ο"]="&omicron;",["π"]="&pi;",["ρ"]="&rho;",["ς"]="&sigmaf;",["σ"]="&sigma;",["τ"]="&tau;",["υ"]="&upsilon;",["φ"]="&phi;",["χ"]="&chi;",["ψ"]="&psi;",["ω"]="&omega;",["ϑ"]="&thetasym;",["ϒ"]="&upsih;",["ϖ"]="&piv;",[" "]="&ensp;",[" "]="&emsp;",[" "]="&thinsp;",["‌"]="&zwnj;",["‍"]="&zwj;",["‎"]="&lrm;",["‏"]="&rlm;",["–"]="&ndash;",["—"]="&mdash;",["‘"]="&lsquo;",["’"]="&rsquo;",["‚"]="&sbquo;",["“"]="&ldquo;",["”"]="&rdquo;",["„"]="&bdquo;",["†"]="&dagger;",["‡"]="&Dagger;",["•"]="&bull;",["…"]="&hellip;",["‰"]="&permil;",["′"]="&prime;",["″"]="&Prime;",["‹"]="&lsaquo;",["›"]="&rsaquo;",["‾"]="&oline;",["⁄"]="&frasl;",["€"]="&euro;",["ℑ"]="&image;",["℘"]="&weierp;",["ℜ"]="&real;",["™"]="&trade;",["ℵ"]="&alefsym;",["←"]="&larr;",["↑"]="&uarr;",["→"]="&rarr;",["↓"]="&darr;",["↔"]="&harr;",["↵"]="&crarr;",["⇐"]="&lArr;",["⇑"]="&uArr;",["⇒"]="&rArr;",["⇓"]="&dArr;",["⇔"]="&hArr;",["∀"]="&forall;",["∂"]="&part;",["∃"]="&exist;",["∅"]="&empty;",["∇"]="&nabla;",["∈"]="&isin;",["∉"]="&notin;",["∋"]="&ni;",["∏"]="&prod;",["∑"]="&sum;",["−"]="&minus;",["∗"]="&lowast;",["√"]="&radic;",["∝"]="&prop;",["∞"]="&infin;",["∠"]="&ang;",["∧"]="&and;",["∨"]="&or;",["∩"]="&cap;",["∪"]="&cup;",["∫"]="&int;",["∴"]="&there4;",["∼"]="&sim;",["≅"]="&cong;",["≈"]="&asymp;",["≠"]="&ne;",["≡"]="&equiv;",["≤"]="&le;",["≥"]="&ge;",["⊂"]="&sub;",["⊃"]="&sup;",["⊄"]="&nsub;",["⊆"]="&sube;",["⊇"]="&supe;",["⊕"]="&oplus;",["⊗"]="&otimes;",["⊥"]="&perp;",["⋅"]="&sdot;",["⌈"]="&lceil;",["⌉"]="&rceil;",["⌊"]="&lfloor;",["⌋"]="&rfloor;",["⟨"]="&lang;",["⟩"]="&rang;",["◊"]="&loz;",["♠"]="&spades;",["♣"]="&clubs;",["♥"]="&hearts;",["♦"]="&diams;"}

function string.HTMLEncode( str )

	if (html_entities[str] ~= nil) then

		return html_entities[str]

	else

		str = ( str:gsub( "&", "&amp;" ) )

		for i,v in pairs( html_entities ) do

			str = ( str:gsub( string.PatternSafe( i ), v ) )

		end

		return str

	end

end

--[[---------------------------------------------------------
   Name: string.HTMLDecode( string )
   Desc: Converts HTML entities back to a normal string
   Desc: The html_entities_reverse table is taken straight from PHP's
-----------------------------------------------------------]]

local html_entities_reverse = {["&quot;"]='"',["&amp;"]="&",["&#039;"]="'",["&lt;"]="<",["&gt;"]=">",["&nbsp;"]=" ",["&iexcl;"]="¡",["&cent;"]="¢",["&pound;"]="£",["&curren;"]="¤",["&yen;"]="¥",["&brvbar;"]="¦",["&sect;"]="§",["&uml;"]="¨",["&copy;"]="©",["&ordf;"]="ª",["&laquo;"]="«",["&not;"]="¬",["&shy;"]="­",["&reg;"]="®",["&macr;"]="¯",["&deg;"]="°",["&plusmn;"]="±",["&sup2;"]="²",["&sup3;"]="³",["&acute;"]="´",["&micro;"]="µ",["&para;"]="¶",["&middot;"]="·",["&cedil;"]="¸",["&sup1;"]="¹",["&ordm;"]="º",["&raquo;"]="»",["&frac14;"]="¼",["&frac12;"]="½",["&frac34;"]="¾",["&iquest;"]="¿",["&Agrave;"]="À",["&Aacute;"]="Á",["&Acirc;"]="Â",["&Atilde;"]="Ã",["&Auml;"]="Ä",["&Aring;"]="Å",["&AElig;"]="Æ",["&Ccedil;"]="Ç",["&Egrave;"]="È",["&Eacute;"]="É",["&Ecirc;"]="Ê",["&Euml;"]="Ë",["&Igrave;"]="Ì",["&Iacute;"]="Í",["&Icirc;"]="Î",["&Iuml;"]="Ï",["&ETH;"]="Ð",["&Ntilde;"]="Ñ",["&Ograve;"]="Ò",["&Oacute;"]="Ó",["&Ocirc;"]="Ô",["&Otilde;"]="Õ",["&Ouml;"]="Ö",["&times;"]="×",["&Oslash;"]="Ø",["&Ugrave;"]="Ù",["&Uacute;"]="Ú",["&Ucirc;"]="Û",["&Uuml;"]="Ü",["&Yacute;"]="Ý",["&THORN;"]="Þ",["&szlig;"]="ß",["&agrave;"]="à",["&aacute;"]="á",["&acirc;"]="â",["&atilde;"]="ã",["&auml;"]="ä",["&aring;"]="å",["&aelig;"]="æ",["&ccedil;"]="ç",["&egrave;"]="è",["&eacute;"]="é",["&ecirc;"]="ê",["&euml;"]="ë",["&igrave;"]="ì",["&iacute;"]="í",["&icirc;"]="î",["&iuml;"]="ï",["&eth;"]="ð",["&ntilde;"]="ñ",["&ograve;"]="ò",["&oacute;"]="ó",["&ocirc;"]="ô",["&otilde;"]="õ",["&ouml;"]="ö",["&divide;"]="÷",["&oslash;"]="ø",["&ugrave;"]="ù",["&uacute;"]="ú",["&ucirc;"]="û",["&uuml;"]="ü",["&yacute;"]="ý",["&thorn;"]="þ",["&yuml;"]="ÿ",["&OElig;"]="Œ",["&oelig;"]="œ",["&Scaron;"]="Š",["&scaron;"]="š",["&Yuml;"]="Ÿ",["&fnof;"]="ƒ",["&circ;"]="ˆ",["&tilde;"]="˜",["&Alpha;"]="Α",["&Beta;"]="Β",["&Gamma;"]="Γ",["&Delta;"]="Δ",["&Epsilon;"]="Ε",["&Zeta;"]="Ζ",["&Eta;"]="Η",["&Theta;"]="Θ",["&Iota;"]="Ι",["&Kappa;"]="Κ",["&Lambda;"]="Λ",["&Mu;"]="Μ",["&Nu;"]="Ν",["&Xi;"]="Ξ",["&Omicron;"]="Ο",["&Pi;"]="Π",["&Rho;"]="Ρ",["&Sigma;"]="Σ",["&Tau;"]="Τ",["&Upsilon;"]="Υ",["&Phi;"]="Φ",["&Chi;"]="Χ",["&Psi;"]="Ψ",["&Omega;"]="Ω",["&alpha;"]="α",["&beta;"]="β",["&gamma;"]="γ",["&delta;"]="δ",["&epsilon;"]="ε",["&zeta;"]="ζ",["&eta;"]="η",["&theta;"]="θ",["&iota;"]="ι",["&kappa;"]="κ",["&lambda;"]="λ",["&mu;"]="μ",["&nu;"]="ν",["&xi;"]="ξ",["&omicron;"]="ο",["&pi;"]="π",["&rho;"]="ρ",["&sigmaf;"]="ς",["&sigma;"]="σ",["&tau;"]="τ",["&upsilon;"]="υ",["&phi;"]="φ",["&chi;"]="χ",["&psi;"]="ψ",["&omega;"]="ω",["&thetasym;"]="ϑ",["&upsih;"]="ϒ",["&piv;"]="ϖ",["&ensp;"]=" ",["&emsp;"]=" ",["&thinsp;"]=" ",["&zwnj;"]="‌",["&zwj;"]="‍",["&lrm;"]="‎",["&rlm;"]="‏",["&ndash;"]="–",["&mdash;"]="—",["&lsquo;"]="‘",["&rsquo;"]="’",["&sbquo;"]="‚",["&ldquo;"]="“",["&rdquo;"]="”",["&bdquo;"]="„",["&dagger;"]="†",["&Dagger;"]="‡",["&bull;"]="•",["&hellip;"]="…",["&permil;"]="‰",["&prime;"]="′",["&Prime;"]="″",["&lsaquo;"]="‹",["&rsaquo;"]="›",["&oline;"]="‾",["&frasl;"]="⁄",["&euro;"]="€",["&image;"]="ℑ",["&weierp;"]="℘",["&real;"]="ℜ",["&trade;"]="™",["&alefsym;"]="ℵ",["&larr;"]="←",["&uarr;"]="↑",["&rarr;"]="→",["&darr;"]="↓",["&harr;"]="↔",["&crarr;"]="↵",["&lArr;"]="⇐",["&uArr;"]="⇑",["&rArr;"]="⇒",["&dArr;"]="⇓",["&hArr;"]="⇔",["&forall;"]="∀",["&part;"]="∂",["&exist;"]="∃",["&empty;"]="∅",["&nabla;"]="∇",["&isin;"]="∈",["&notin;"]="∉",["&ni;"]="∋",["&prod;"]="∏",["&sum;"]="∑",["&minus;"]="−",["&lowast;"]="∗",["&radic;"]="√",["&prop;"]="∝",["&infin;"]="∞",["&ang;"]="∠",["&and;"]="∧",["&or;"]="∨",["&cap;"]="∩",["&cup;"]="∪",["&int;"]="∫",["&there4;"]="∴",["&sim;"]="∼",["&cong;"]="≅",["&asymp;"]="≈",["&ne;"]="≠",["&equiv;"]="≡",["&le;"]="≤",["&ge;"]="≥",["&sub;"]="⊂",["&sup;"]="⊃",["&nsub;"]="⊄",["&sube;"]="⊆",["&supe;"]="⊇",["&oplus;"]="⊕",["&otimes;"]="⊗",["&perp;"]="⊥",["&sdot;"]="⋅",["&lceil;"]="⌈",["&rceil;"]="⌉",["&lfloor;"]="⌊",["&rfloor;"]="⌋",["&lang;"]="⟨",["&rang;"]="⟩",["&loz;"]="◊",["&spades;"]="♠",["&clubs;"]="♣",["&hearts;"]="♥",["♦"]="&diams;"}

function string.HTMLDecode( str )

	if (html_entities_reverse[str] ~= nil) then

		return html_entities_reverse[str]

	else

		for i,v in pairs( html_entities_reverse ) do
			
			str = ( str:gsub( string.PatternSafe( i ), v ) )

		end

		return str

	end

end

--[[---------------------------------------------------------
   Name: string.URLEncode( string )
   Desc: Takes a string and "encodes" it for compatibility in URLs
-----------------------------------------------------------]]

function string.URLEncode( str )

	str = string.gsub( str, "([^%w%-%_%.%~])", function( hex )
		return string.format( "%%%02X", string.byte( hex ) )
	end )
	return ( str )

end

--[[---------------------------------------------------------
   Name: string.URLDecode( string )
   Desc: Takes a string and "decodes" it from compatibility in URLs
-----------------------------------------------------------]]

function string.URLDecode( str )

	str = string.gsub( string.gsub( str, "+", " " ), "%%(%x%x)", function( hex )
		return string.char( tonumber( hex, 16 ) )
	end )
	return ( str )

end

--[[---------------------------------------------------------
   Name: explode(seperator ,string)
   Desc: Takes a string and turns it into a table
   Usage: string.explode( " ", "Seperate this string")
-----------------------------------------------------------]]
local totable = string.ToTable
local string_sub = string.sub
local string_gsub = string.gsub
local string_gmatch = string.gmatch
function string.Explode(separator, str, withpattern)
	if (separator == "") then return totable( str ) end
	 
	local ret = {}
	local index,lastPosition = 1,1
	 
	-- Escape all magic characters in separator
	if not withpattern then separator = separator:PatternSafe() end
	 
	-- Find the parts
	for startPosition,endPosition in string_gmatch( str, "()" .. separator.."()" ) do
		ret[index] = string_sub( str, lastPosition, startPosition-1)
		index = index + 1
		 
		-- Keep track of the position
		lastPosition = endPosition
	end
	 
	-- Add last part by using the position we stored
	ret[index] = string_sub( str, lastPosition)
	return ret
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
end

--[[---------------------------------------------------------
   Name: Implode(seperator ,Table)
   Desc: Takes a table and turns it into a string
   Usage: string.Implode( " ", {"This", "Is", "A", "Table"})
-----------------------------------------------------------]]
function string.Implode(seperator,Table) return 
	table.concat(Table,seperator) 
end

--[[---------------------------------------------------------
   Name: GetExtensionFromFilename(path)
   Desc: Returns extension from path
   Usage: string.GetExtensionFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetExtensionFromFilename( path )
	return path:match( "%.([^%.]+)$" )
end

--[[---------------------------------------------------------
   Name: StripExtension( path )
-----------------------------------------------------------]]
function string.StripExtension( path )

	local i = path:match( ".+()%.%w+$" )
	if ( i ) then return path:sub(1, i-1) end
	return path

end

--[[---------------------------------------------------------
   Name: GetPathFromFilename(path)
   Desc: Returns path from filepath
   Usage: string.GetPathFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetPathFromFilename(path)
	return path:match( "^(.*[/\\])[^/\\]-$" ) or ""
end
--[[---------------------------------------------------------
   Name: GetFileFromFilename(path)
   Desc: Returns file with extension from path
   Usage: string.GetFileFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetFileFromFilename(path)
	return path:match( "[\\/]([^/\\]+)$" ) or ""
end

--[[-----------------------------------------------------------------
   Name: FormattedTime( TimeInSeconds, Format )
   Desc: Given a time in seconds, returns formatted time
		 If 'Format' is not specified the function returns a table 
		 conatining values for hours, mins, secs, ms

   Examples: string.FormattedTime( 123.456, "%02i:%02i:%02i")  ==> "02:03:45"
			 string.FormattedTime( 123.456, "%02i:%02i")       ==> "02:03"
			 string.FormattedTime( 123.456, "%2i:%02i")        ==> " 2:03"
			 string.FormattedTime( 123.456 )        		==> {h = 0, m = 2, s = 3, ms = 45}
-------------------------------------------------------------------]]

function string.FormattedTime( seconds, Format )
	if not seconds then seconds = 0 end
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds / 60) % 60)
	local millisecs = ( seconds - math.floor( seconds ) ) * 100
	seconds = math.floor(seconds % 60)
	
	if Format then
		return string.format( Format, minutes, seconds, millisecs )
	else
		return { h=hours, m=minutes, s=seconds, ms=millisecs }
	end
end

--[[---------------------------------------------------------
   Name: Old time functions
-----------------------------------------------------------]]

function string.ToMinutesSecondsMilliseconds( TimeInSeconds )	return string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i")	end
function string.ToMinutesSeconds( TimeInSeconds )		return string.FormattedTime( TimeInSeconds, "%02i:%02i")	end

local function pluralizeString(str, quantity)
	return str .. ((quantity ~= 1) and "s" or "")
end

function string.NiceTime( seconds )

	if ( seconds == nil ) then return "a few seconds" end

	if ( seconds < 60 ) then
		local t = math.floor( seconds )
		return t .. pluralizeString(" second", t);
	end

	if ( seconds < 60 * 60 ) then
		local t = math.floor( seconds / 60 )
		return t .. pluralizeString(" minute", t);
	end

	if ( seconds < 60 * 60 * 24 ) then
		local t = math.floor( seconds / (60 * 60) )
		return t .. pluralizeString(" hour", t);
	end

	if ( seconds < 60 * 60 * 24 * 7 ) then
		local t = math.floor( seconds / (60 * 60 * 24) )
		return t .. pluralizeString(" day", t);
	end
	
	if ( seconds < 60 * 60 * 24 * 7 * 52 ) then
		local t = math.floor( seconds / (60 * 60 * 24 * 7) )
		return t .. pluralizeString(" week", t);
	end

	local t = math.floor( seconds / (60 * 60 * 24 * 7 * 52) )
	return t .. pluralizeString(" year", t);

end

function string.Left(str, num)
	return string.sub(str, 1, num)
end

function string.Right(str, num)
	return string.sub(str, -num)
end


function string.Replace( str, tofind, toreplace )
	tofind = tofind:PatternSafe()
	toreplace = toreplace:gsub( "%%", "%%%1" )
	return ( str:gsub( tofind, toreplace ) )
end

--[[---------------------------------------------------------
   Name: Trim(s)
   Desc: Removes leading and trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.Trim( s, char )
	if char then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
   Name: TrimRight(s)
   Desc: Removes trailing spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimRight( s, char )
	if char then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
   Name: TrimLeft(s)
   Desc: Removes leading spaces from a string.
		 Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimLeft( s, char )
	if char then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.+)$" ) or s
end

function string.NiceSize( size )
	
	size = tonumber( size )

	if ( size <= 0 ) then return "0" end
	if ( size < 1024 ) then return size .. " Bytes" end
	if ( size < 1024 * 1024 ) then return math.Round( size / 1024, 2 ) .. " KB" end
	if ( size < 1024 * 1024 * 1024 ) then return math.Round( size / (1024*1024), 2 ) .. " MB" end
	
	return math.Round( size / (1024*1024*1024), 2 ) .. " GB"

end

-- Note: These use Lua index numbering, not what you'd expect
-- ie they start from 1, not 0.

function string.SetChar( s, k, v )

	local start = s:sub( 0, k-1 )
	local send = s:sub( k+1 )
	
	return start .. v .. send

end

function string.GetChar( s, k )

	return s:sub( k, k )

end

local meta = getmetatable( "" )

function meta:__index( key )
	local val = string[ key ]
	if ( val ) then
		return val
	elseif ( tonumber( key ) ) then
		return self:sub( key, key )
	else
		error( "attempt to index a string value with bad key ('" .. tostring( key ) .. "' is not part of the string library)", 2 )
	end
end

function string.StartWith( String, Start )

   return string.sub( String, 1, string.len (Start ) ) == Start

end

function string.EndsWith( String, End )

   return End == '' or string.sub( String, -string.len( End ) ) == End

end

function string.FromColor( color )

   return Format( "%i %i %i %i", color.r, color.g, color.b, color.a );

end

function string.ToColor( str )

	local col = Color( 255, 255, 255, 255 )

	col.r, col.g, col.b, col.a = str:match("(%d+) (%d+) (%d+) (%d+)")

	col.r = tonumber( col.r )
	col.g = tonumber( col.g )
	col.b = tonumber( col.b )
	col.a = tonumber( col.a )

	return col

end

function string.Comma( number )

	local number, k = tostring( number ), nil

	while true do  
		number, k = string.gsub( number, "^(-?%d+)(%d%d%d)", '%1,%2')
		if ( k == 0 ) then break end
	end

	return number

end