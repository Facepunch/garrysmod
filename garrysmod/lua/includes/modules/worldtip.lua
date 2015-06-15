
local isvector = isvector
local isentity = isentity
local istable  = istable
local IsValid  = IsValid
local SysTime  = SysTime
local pairs    = pairs
local assert   = assert
local math     = math
local table    = table
local timer    = timer

/*
	Name: worldtip
	Desc: Handles world/entity-based tooltips
*/
module( "worldtip" )

local WorldTips = {}
local EntInfo = {}
local Queue = {}

function GetTable()
	return WorldTips
end

/*
	Returns no. of active tips on an entity
*/
local function NumActive( ent )

	local count, time = 0, SysTime()

	for _, tip in pairs( WorldTips ) do
		if ( tip.ent == ent && !tip.expired ) then
			count = count + 1
		end
	end

	return count

end

/*
	Spaces out tips according to size & how many are active
*/
local function SpaceoutTips( ent )

	if ( !IsValid( ent ) || !EntInfo[ent] ) then return end

	local info, active, count = EntInfo[ent], NumActive( ent ), 1

	for _, tip in pairs( WorldTips ) do

		if ( info.NumTips == 1 ) then tip.offset = nil break end

		if ( tip.ent == ent && !tip.expired ) then
			tip.offset = info.Min + ( info.Diff / ( active + 1 ) ) * count
			count = count + 1
		end

	end

end

/*
	For perf - no need to space out so often
*/
local function QueueSpaceout( ent )
	if !Queue[ent] then
		timer.Create( "wtips_" .. ent:EntIndex(), 0.05, 1, function() SpaceoutTips( ent ) Queue[ent] = nil end )
		Queue[ent] = true
	end
end

/*
	Accessor for spaceout
*/
function Organize( ent )

	if ( IsValid( ent ) ) then
		QueueSpaceout( ent )
	else
		for _, tip in pairs( WorldTips ) do
			if ( tip.ent ) then QueueSpaceout( tip.ent ) end
		end
	end

end

/*
	Removes a world tooltip.
	The name or tip structure itself can be passed.
*/
function Remove( name )

	if ( !WorldTips[name] ) then
		if ( istable(name) && table.HasValue( WorldTips, name ) ) then
			name = table.KeyFromValue( WorldTips, name )
		else return end
	end

	local ent = WorldTips[name].ent

	if ( !WorldTips[name].volatile && IsValid(ent) ) then
		ent:RemoveCallOnRemove( "RemoveTip_" .. name )
		QueueSpaceout( ent )
	end

	WorldTips[name] = nil

	if ( ent && EntInfo[ent] ) then

		EntInfo[ent].NumTips = EntInfo[ent].NumTips - 1

		if ( EntInfo[ent].NumTips < 1 ) then
			EntInfo[ent] = nil
		end

	end

end

/*
	Called to handle expired tips
*/
function Expired( name )

	if ( !WorldTips[name] ) then return end

	if ( WorldTips[name].ent ) then QueueSpaceout( WorldTips[name].ent ) end

	if ( WorldTips[name].volatile ) then
		Remove( name )
	else
		WorldTips[name].expired = true
	end

end

/*
	Builds a new tooltip and returns it
*/
local function Create( name, tgt, text, len, bcol, tcol, volatile )

	if WorldTips[name] then Remove( name ) end

	local pos, axis
	local ent = IsValid( tgt ) && tgt || nil

	if ( ent ) then

		if ( !volatile ) then ent:CallOnRemove( "RemoveTip_" .. name, function() Remove( name ) end ) end

		if ( EntInfo[ent] ) then

			EntInfo[ent].NumTips = EntInfo[ent].NumTips + 1

			axis = EntInfo[ent].Axis

		else

			local min = ent:OBBMins()
			local diff = ent:OBBMaxs() - min
			local longest = math.Max( diff.z, diff.x, diff.y )

			if ( longest == diff.x ) then axis = "x"
			elseif ( longest == diff.y ) then axis = "y"
			else axis = "z"
			end

			EntInfo[ent] = {
				Min = min[axis],
				Diff = diff[axis],
				Axis = axis,
				NumTips = 1
			}

		end

	else
		if ( !isvector(tgt) ) then return end
		pos = tgt
	end

	len = len || -1

	WorldTips[name] = {
		dietime  = ( len < 0 && -1 || SysTime() + len ),
		text     = text,
		pos      = pos,
		ent      = ent,
		bcol     = bcol,
		tcol     = tcol,
		axis     = axis,
		volatile = volatile
	}

	if ( ent ) then QueueSpaceout( ent ) end

	return name, WorldTips[name]

end

/*
	Adds and returns a new world tooltip
*/
function Add( name, tgt, text, len, bcol, tcol )

	assert( name, "bad argument #1 to 'worldtip.Add' (value expected)" )

	return Create( name, tgt, text, len, bcol, tcol )

end

/*
	Adds or updates a volatile world tooltip
	Will be removed if not called in next frame
*/
function AddFrame( name, tgt, text, bcol, tcol )

	assert( name, "bad argument #1 to 'worldtip.AddFrame' (value expected)" )

	if ( WorldTips[name] && WorldTips[name].volatile ) then

		WorldTips[name].text = text
		WorldTips[name].dietime = SysTime() + 0.0625

		if ( isvector( tgt ) ) then WorldTips[name].pos = tgt end

	else

		Create( name, tgt, text, 0.0625, bcol, tcol, true )

	end

end

/*
	Gets a tip structure by name
*/
function Get( name )
	return WorldTips[name]
end

/*
	Returns all the tips on a given entity
*/
function GetTips( ent )

	if ( !IsValid( ent ) ) then return end

	local out = {}

	for name, tip in pairs( WorldTips ) do
		if ( tip.ent == ent ) then
			out[name] = tip
		end
	end

	return out

end

/*
	Removes all expired tips
*/
function RemoveExpired()

	local time = SysTime()
	for name, tip in pairs( WorldTips ) do
		if ( tip.expired ) then Remove( name ) end
	end

end

/*
	Removes all tooltips
*/
function RemoveAll()
	WorldTips = {}
	EntInfo = {}
end
Clear = RemoveAll -- Convenience
