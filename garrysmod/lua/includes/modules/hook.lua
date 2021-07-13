local gmod                        = gmod
local pairs                        = pairs
local isfunction        = isfunction
local isnumber                = isnumber
local isstring                = isstring
local IsValid                = IsValid
local setmetatable                = setmetatable
module( "hook" )

local HookTable = {}
local HookTableMeta = { __index = HookTable }
local HOOK_FUNC, HOOK_NAME, HOOK_FUNC_ORIGINAL, HOOK_PRIORITY, HOOK_NEXT = 1, 2, 3, 4, 5

function HookTable.New()

	return setmetatable( {}, HookTableMeta )

end

function HookTable:Add( name, func, priority )

	local runfunc
	if ( isstring( name ) ) then
		runfunc = func
	else
		runfunc = function( ... )
			if ( IsValid( name ) ) then
				return func( name, ... )
			end
			self:Remove( name )
		end
	end

	local addhook = {}
	addhook[ HOOK_FUNC ] = runfunc
	addhook[ HOOK_NAME ] = name
	addhook[ HOOK_FUNC_ORIGINAL ] = func
	addhook[ HOOK_PRIORITY ] = priority

	self:Remove( name )

	if ( self.root ) then
		local v, prev = self.root
		while v do
			if ( addhook[ HOOK_PRIORITY ] < v[ HOOK_PRIORITY ] ) then
				if ( v == self.root ) then
					self.root = addhook
				else
					prev[ HOOK_NEXT ] = addhook
				end
				addhook[ HOOK_NEXT ] = v
				break
			elseif ( !v[ HOOK_NEXT ] ) then
				v[ HOOK_NEXT ] = addhook
				break
			end
			prev = v
			v = v[ HOOK_NEXT ]
		end
	else
		self.root = addhook
	end
end

function HookTable:Remove( name )

	local v, prev = self.root
	while v do
		if ( v[ HOOK_NAME ] == name ) then
			if ( v == self.root ) then
				self.root = v[ HOOK_NEXT ]
			else
				prev[ HOOK_NEXT ] = v[ HOOK_NEXT ]
			end
			break
		end
		prev = v
		v = v[ HOOK_NEXT ]
	end

end

function HookTable:GetTable()

	local hooks = {}

	local v = self.root
	while v do
		hooks[ v[ HOOK_NAME ] ] = v[ HOOK_FUNC_ORIGINAL ]
		v = v[ HOOK_NEXT ]
	end

	return hooks

end

local Hooks = {}

--[[---------------------------------------------------------
    Name: GetTable
    Desc: Returns a table of all hooks.
-----------------------------------------------------------]]
function GetTable()

	local hooks = {}
	for k, v in pairs( Hooks ) do
		hooks[ k ] = v:GetTable()
	end
	return hooks

end


--[[---------------------------------------------------------
    Name: Add
    Args: string hookName, any identifier, function func
    Desc: Add a hook to listen to the specified event.
-----------------------------------------------------------]]
function Add( event_name, name, func, priority )

	if ( !isfunction( func ) ) then return end
	if ( !isstring( event_name ) ) then return end
	if ( priority == nil ) then priority = 0 elseif ( !isnumber( priority ) ) then return end

	if ( Hooks[ event_name ] == nil ) then
		Hooks[ event_name ] = HookTable.New()
	end

	Hooks[ event_name ]:Add( name, func, priority )

end


--[[---------------------------------------------------------
    Name: Remove
    Args: string hookName, identifier
    Desc: Removes the hook with the given indentifier.
-----------------------------------------------------------]]
function Remove( event_name, name )

	if ( !isstring( event_name ) ) then return end
	if ( !Hooks[ event_name ] ) then return end

	Hooks[ event_name ]:Remove( name )

end


--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Run( name, ... )
	return Call( name, gmod and gmod.GetGamemode() or nil, ... )
end


--[[---------------------------------------------------------
    Name: Run
    Args: string hookName, table gamemodeTable, vararg args
    Desc: Calls hooks associated with the hook name.
-----------------------------------------------------------]]
function Call( name, gm, ... )

	--
	-- Run hooks
	--
	local hooktable = Hooks[ name ]
	if ( hooktable != nil ) then

		local a, b, c, d, e, f
		local v = hooktable.root
		while v do
			a, b, c, d, e, f = v[ HOOK_FUNC ]( ... )
			
			--
			-- Hook returned a value - it overrides the gamemode function
			--
			if ( a != nil ) then
				return a, b, c, d, e, f
			end
			v = v[ HOOK_NEXT ]
		end
	end
	
	--
	-- Call the gamemode function
	--
	if ( !gm ) then return end
	
	local GamemodeFunction = gm[ name ]
	if ( GamemodeFunction == nil ) then return end
			
	return GamemodeFunction( gm, ... )        
	
end
