--[[   _                                
	( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DHTML

--]]


PANEL = {}

AccessorFunc( PANEL, "m_bScrollbars", 			"Scrollbars", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bAllowLua", 			"AllowLua", 		FORCE_BOOL )

--[[---------------------------------------------------------

-----------------------------------------------------------]]
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
	self:Think();

end

function PANEL:Call( js )
	self:QueueJavascript( js )
end

function PANEL:ConsoleMessage( msg )

	if ( !isstring( msg ) ) then msg = "*js variable*" end

	if ( self.m_bAllowLua && msg:StartWith( "RUNLUA:" ) ) then
	
		local strLua = msg:sub( 8 )

		SELF = self
		RunString( strLua );
		SELF = nil
		return; 

	end

	MsgC( Color( 255, 160, 255 ), "[HTML] " );
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
	self.Callbacks[ obj .. "." .. funcname ] = func;

end


derma.DefineControl( "DHTML", "A shape", PANEL, "Awesomium" )
