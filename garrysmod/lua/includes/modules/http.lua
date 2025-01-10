
local HTTP = HTTP

--[[---------------------------------------------------------
	HTTP Module. Interaction with HTTP.
-----------------------------------------------------------]]
module( "http" )

--[[---------------------------------------------------------

	Get the contents of a webpage.

	Callback should be

	function callback( (args optional), contents, size )

-----------------------------------------------------------]]
function Fetch( url, onsuccess, onfailure, header )

	local request = {
		url			= url,
		method		= "get",
		headers		= header or {},

		success = function( code, body, headers )

			if ( !onsuccess ) then return end

			onsuccess( body, body:len(), headers, code )

		end,

		failed = function( err )

			if ( !onfailure ) then return end

			onfailure( err )

		end
	}

	local success = HTTP( request )
	if ( !success && onfailure ) then onfailure( "HTTP failed" ) end

end

function Post( url, params, onsuccess, onfailure, header )

	local request = {
		url			= url,
		method		= "post",
		parameters	= params,
		headers		= header or {},

		success = function( code, body, headers )

			if ( !onsuccess ) then return end

			onsuccess( body, body:len(), headers, code )

		end,

		failed = function( err )

			if ( !onfailure ) then return end

			onfailure( err )

		end
	}

	local success = HTTP( request )
	if ( !success && onfailure ) then onfailure( "HTTP failed" ) end

end

--[[

Or use HTTP( table )

local request = {
	url			= "http://pastebin.com/raw.php?i=3jsf50nL",
	method		= "post",

	parameters = {
		id			= "548",
		country		= "England"
	}

	success = function( code, body, headers )

		Msg( "Request Successful\n" )
		Msg( "Code: ", code, "\n" )
		Msg( "Body Length:\n", body:len(), "\n" )
		Msg( "Body:\n", body, "\n" )
		PrintTable( headers )

	end,

	failed = function( reason )
		Msg( "Request failed: ", reason, "\n" )
	end
}

HTTP( request )

--]]





-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
-- https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
local HTTPcodes = {

	--[[--------------------
		 Successful 2XX
	--------------------]]--
	[200] = {"OK",					"The resource has been obtained"},
	[201] = {"Created",				"The request succeeded, and a new resource was created as a result"},
	[202] = {"Accepted",			"The request has been received but not yet acted upon"},
	[203] = {"Non-Authoritative Information",	"This response code means the returned metadata is not exactly the same as is available from the origin server"},
	[204] = {"No Content",			"The request has been send with no errors also there is no content to send for this request, but the headers may be useful"},
	[205] = {"Reset Content",		"This response tells the client to reset the document view, so for example to clear the content of a form, reset a canvas state, or to refresh the UI"},
	[206] = {"Partial Content", 	"The request has succeeded and the body contains the requested ranges of data, as described in the Range header of the request"},
	[207] = {"Multi-Status",		"This response code indicates that there might be a mixture of responses"},
	[208] = {"Already Reported",	"This response code is used in a 207 (207 Multi-Status) response to save space and avoid conflicts"},


	--[[--------------------
		Client Error 4XX
	--------------------]]--
	[400] = {"Bad Request",			"The server was unable to interpret the request given invalid syntax"},
	[401] = {"Unauthorized",		"Authentication is required to get the requested response"},
	[403] = {"Forbidden",			"You don't have the necessary permissions for certain content, so the server is refusing to grant an appropriate response"},
	[404] = {"Not Found",			"The server was unable to find the requested content"},
	[405] = {"Method Not Allowed",	"The requested method is known to the server but it has been disabled and cannot be used"},
	[408] = {"Request Timeout",		"A timeout has occurred while processing an HTTP request"},
	[409] = {"Conflict",			"The server encountered a conflict with the request sent with the current state of the server"},
	[410] = {"Gone",				"The requested content has been deleted from the server"},
	[411] = {"Length Required",		"The server rejected the request because the Content-Length is not defined"},
	[429] = {"Rate limit reached for requests",	"This error message indicates that you have hit your assigned rate limit for the API"},


	--[[--------------------
		Server Error 5XX
	--------------------]]--
	[500] = {"Internal Server Error",	"This response means that the server encountered an unexpected condition that prevented it from fulfilling the request"},
	[501] = {"Not Implemented",		"This response means that the server does not support the functionality required to fulfill the request"},
	[502] = {"Bad Gateway",			"This response means that the server, while acting as a gateway or proxy, received an invalid response from the upstream server"},
	[503] = {"Service Unavailable",	"This response means that the server is not ready to handle the request"},
	[504] = {"Gateway Timeout",		"This response means that the server, while acting as a gateway or proxy, did not get a response in time from the upstream server that it needed in order to complete the request"},
	[505] = {"HTTP Version Not Supported",	"This response status code indicates that the HTTP version used in the request is not supported by the server"},
	[507] = {"Insufficient Storage",	"This operation couldn't succeed, maybe because the request it's too large to fit on a disk"},
	[508] = {"Loop Detected", 	"This status indicates that the entire operation failed, the server terminated an operation because it encountered an infinite loop"},
}

function GetStatusDescription(code)
	if not HTTPcodes[code] then return nil end

	local name, message = HTTPcodes[code][1], HTTPcodes[code][2]
	return name, message
end
