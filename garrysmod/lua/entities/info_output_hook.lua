DEFINE_BASECLASS( "base_point" )

local this, meta, hooks, fmt

hooks = { }

meta = FindMetaTable( "Entity" )

fmt = "%s __this,%s"

function meta:HookOutput( name, uid, func )
	if not IsValid( this ) then
		this = ents.Create( "info_output_hook" )
			this:SetName( "__this" )
		this:Spawn( )
	end

	hooks[ self ] = hooks[ ent ] or { }
	hooks[ self ][ name ] = hooks[ self ][ name ] or { }
	hooks[ self ][ name ][ uid ] = func

	self:Fire( "AddOutput", fmt:format( name, name ), 0 )
end

function meta:UnhookOutput( name, uid )
	if not IsValid( this ) then
		this = ents.Create( "info_output_hook" )
			this:SetName( "__this" )
		this:Spawn( )
	end

	hooks[ self ] = hooks[ ent ] or { }
	hooks[ self ][ name ] = hooks[ self ][ name ] or { }
	hooks[ self ][ name ][ uid ] = nil
end

function ENT:Initialize( )
end

function ENT:AcceptInput( name, activator, caller, data )
	local ok, err
	
	if hooks[ caller ] then
		if hooks[ caller ][ name ] then
			for k, v in pairs( hooks[ caller ][ name ] ) do
				
				if IsValid( k ) then
					ok, err = pcall( v, k, caller, activator, data )
				else
					ok, err = pcall( v, caller, activator, data )
				end
				
				if not ok then
					ErrorNoHalt( "Output hook failed: " .. name .. "::" .. k .. " - " .. err .. "\n" )
				end
			end
		end
	end
	
	return true
end

function ENT:OnRemove( )
	this = ents.Create( "info_output_hook" )
		this:SetName( "__this" )
	this:Spawn( )
end
