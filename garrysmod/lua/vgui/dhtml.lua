
local PANEL = {}

AccessorFunc( PANEL, "m_bScrollbars",	"Scrollbars",	FORCE_BOOL )
AccessorFunc( PANEL, "m_bAllowLua",		"AllowLua",		FORCE_BOOL )

function PANEL:Init()

	self:SetScrollbars( true )
	self:SetAllowLua( false )

	self.JS = {}
	self.Callbacks = {}

	--
	-- Implement a console.log - because awesomium doesn't provide it for us anymore.
	--
	self:AddFunction( "console", "log", function( param ) self:ConsoleMessage( param ) end )

end

function PANEL:Think()

	if ( self.JS && !self:IsLoading() ) then

		for k, v in pairs( self.JS ) do

			self:RunJavascript( v )

		end

		self.JS = nil

	end

end

function PANEL:Paint()

	if ( self:IsLoading() ) then
		return true
	end

end

function PANEL:QueueJavascript( js )

	--
	-- Can skip using the queue if there's nothing else in it
	--
	if ( !self.JS && !self:IsLoading() ) then
		return self:RunJavascript( js )
	end

	self.JS = self.JS or {}

	table.insert( self.JS, js )
	self:Think()

end

function PANEL:Call( js )
	self:QueueJavascript( js )
end

local function BuildFunction( func, ... )

	--
	-- Build a Javascript-safe JS function call.
	-- To be run by either panel:RunFunction or panel:QueueFunction
	--
	-- First parameter is the JS function name,
	-- additional parameters are the values to provide to the function call.
	-- The values provided to the function call are treated as strings except where noted below.
	--
	
	local formatArgs = {}
	local safeArgs = {}
	
	for k, v in ipairs( { ... } ) do
	
		if isbool( v ) then -- Boolean
		
			formatArgs[ k ] = '%s'
			safeArgs[ k ] = v and true or false
			
		elseif isnumber( v ) then -- Numbers
		
			formatArgs[ k ] = '%s'
			safeArgs[ k ] = v
			
		elseif IsColor( v ) then -- Colors, convert to CSS format
		
			formatArgs[ k ] = '"%s"'
			
			if v.a == 255 then -- don't include alpha if it isn't needed
				-- returns "#rrggbb"
				safeArgs[ k ] = string.format( "#%02x%02x%02x", v.r, v.g, v.b )
				--// safeArgs[ k ] = v:ToHex()   -- should be replaced with this once PR#2312 is merged.
			else
				-- returns "rgba()", as required by Awesomium
				-- alpha has 3dp precision, as that's enough to accurately convert back to 0-255.
				safeArgs[ k ] = string.format( "rgba(%d,%d,%d,%.3f)", v.r, v.g, v.b, ( v.a / 255 ) )
				--// safeArgs[ k ] = v:ToHex()   -- should be replaced with this once PR#2312 is merged AND Awesomium is fully removed.
			end
			
		elseif istable( v ) then -- Tables, convert to json object
		
			formatArgs[ k ] = 'JSON.parse("%s")'
			safeArgs[ k ] = string.JavascriptSafe( util.TableToJSON( v ) )
			
		else -- Strings, and all else treated as strings
		
			formatArgs[ k ] = '"%s"'
			safeArgs[ k ] = string.JavascriptSafe( tostring( v ) )
			
		end
		
	end
	
	
	func = string.gsub( func, "[^%w%._]", "" ) -- Function name strips any characters that aren't underscore "_", dot ".", or alphanumeric.

	return string.format( [[ %s( ]] .. table.concat( formatArgs, ", " ) .. [[ ); ]], func, unpack( safeArgs ) )
	
end

function PANEL:RunFunction( func, ... )

	--
	-- Build and Run a Javascript function immediately.
	--
	self:RunJavascript( BuildFunction( func, ... ) )
	
end

function PANEL:QueueFunction( func, ... )

	--
	-- Build and Queue a Javascript function.
	--
	self:QueueJavascript( BuildFunction( func, ... ) )
	
end

function PANEL:ConsoleMessage( msg, file, line )

	if ( !isstring( msg ) ) then msg = "*js variable*" end

	--
	-- Handle error messages
	--
	if ( isstring( file ) && isnumber( line ) ) then

		if ( #file > 64 ) then
			file = string.sub( file, 1, 64 ) .. "..."
		end

		MsgC( Color( 255, 160, 255 ), "[HTML] " )
		MsgC( Color( 255, 255, 255 ), file, ":", line, ": ", msg, "\n" )
		return

	end

	--
	-- Handle Lua execution
	--
	if ( self.m_bAllowLua && msg:StartsWith( "RUNLUA:" ) ) then

		local strLua = msg:sub( 8 )

		SELF = self
		RunString( strLua )
		SELF = nil
		return

	end

	--
	-- Plain ol' console.log
	--
	MsgC( Color( 255, 160, 255 ), "[HTML] " )
	MsgC( Color( 255, 255, 255 ), msg, "\n" )

end

--
-- Called by the engine when a callback function is called
--
function PANEL:OnCallback( obj, func, args )

	--
	-- Use AddFunction to add functions to this.
	--
	local f = self.Callbacks[ obj .. "." .. func ]

	if ( f ) then
		return f( unpack( args ) )
	end

end

--
-- Add a function to Javascript
--
function PANEL:AddFunction( obj, funcname, func )

	--
	-- Create the `object` if it doesn't exist
	--
	if ( !self.Callbacks[ obj ] ) then
		self:NewObject( obj )
		self.Callbacks[ obj ] = true
	end

	--
	-- This creates the function in javascript (which redirects to c++ which calls OnCallback here)
	--
	self:NewObjectCallback( obj, funcname )

	--
	-- Store the function so OnCallback can find it and call it
	--
	self.Callbacks[ obj .. "." .. funcname ] = func

end

--
-- Called when this panel begins loading a page
--
function PANEL:OnBeginLoadingDocument( url )
end

--
-- Called when this panel successfully loads a page
--
function PANEL:OnFinishLoadingDocument( url )
end

--
-- Called when this panel's DOM has been set up. You can run JavaScript in here
--
function PANEL:OnDocumentReady( url )
end

--
-- Called when a this panel tries to open a child (such as a popup or new tab)
--
function PANEL:OnChildViewCreated( sourceURL, targetURL, isPopup )
end

--
-- Called when the title of the loaded document has changed
--
function PANEL:OnChangeTitle( title )
end

--
-- Called when the target URL of the frame has changed, this happens when you hover over a link
--
function PANEL:OnChangeTargetURL( url )
end

derma.DefineControl( "DHTML", "A shape", PANEL, "Awesomium" )
