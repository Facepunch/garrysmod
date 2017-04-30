module( "undo", package.seeall )

-- undo.Create("Wheel")
-- undo.AddEntity( axis )
-- undo.AddEntity( constraint )
-- undo.SetPlayer( self.Owner )
-- undo.Finish()

if ( CLIENT ) then

	local ClientUndos = {}
	local bIsDirty = true
	
	--[[---------------------------------------------------------
		GetTable
		Returns the undo table for whatever reason
	-----------------------------------------------------------]]
	function GetTable()
		return ClientUndos
	end
	
	
	--[[---------------------------------------------------------
		UpdateUI
		Actually updates the UI. Removes old controls and 
		re-creates them using the new data.
	-----------------------------------------------------------]]
	local function UpdateUI()
	
		local Panel = controlpanel.Get( "Undo" )
		if ( !Panel ) then return end
		
		Panel:ClearControls()
		Panel:AddControl( "Header", { Description = "#spawnmenu.utilities.undo.help" } )

		local ComboBox = Panel:ListBox()
		ComboBox:SetTall( 500 )
		
		local NUM = 32
		local Count = 0
		for k, v in ipairs( ClientUndos ) do
		
			local Item = ComboBox:AddItem( tostring( v.Name ) )
			Item.DoClick = function() RunConsoleCommand( "gmod_undonum", tostring( v.Key ) ) end
			
			Count = Count + 1
			if ( Count > NUM ) then break end

		end

	end
	
	--[[---------------------------------------------------------
		AddUndo
		Called from server. Adds a new undo to our UI
	-----------------------------------------------------------]]
	local function AddUndo()

		local k 	= net.ReadInt(16);
		local v 	= net.ReadString();
		
		table.insert( ClientUndos, 1, { Key = k, Name = v } )
		
		MakeUIDirty()

	end
	
	net.Receive( "Undo_AddUndo", AddUndo )
	
	
	--[[---------------------------------------------------------
		Undone
		Called from server. Notifies us that one of our undos
		has been undone or made redundant. We act by updating 
		out data (We wait until the UI is viewed until updating)
	-----------------------------------------------------------]]
	local function Undone()

		local key = net.ReadInt(16);
		
		local NewUndo = {}
		local i = 1
		for k, v in ipairs( ClientUndos ) do
		
			if ( v.Key != key ) then
				NewUndo [ i ] = v
				i = i + 1
			end
		end
		
		ClientUndos = NewUndo
		NewUndo = nil
		
		MakeUIDirty()

	end
	
	net.Receive( "Undo_Undone", Undone )
	
	--[[---------------------------------------------------------
		MakeUIDirty
		Makes the UI dirty - it will re-create the controls
		the next time it is viewed. We also take this opportun
	-----------------------------------------------------------]]
	function MakeUIDirty()
	
		bIsDirty = true
	
	end
	
	--[[---------------------------------------------------------
		CPanelPaint
		Called when the inner panel of the undo CPanel is painted
		We hook onto this to determine when the panel is viewed.
		When it's viewed we update the UI if it's marked as dirty
	-----------------------------------------------------------]]
	local function CPanelUpdate( panel )
	
		-- This is kind of a shitty way of doing it - but we only want
		-- to update the UI when it's visible.
		if ( bIsDirty ) then
		
			-- Doing this in a timer so it calls it in a sensible place
			-- Calling in the paint function could cause all kinds of problems
			-- It's a hack but hey welcome to GMod!
			timer.Simple( 0, UpdateUI )
			bIsDirty = false
		
		end
	
	end
	
	--[[---------------------------------------------------------
		SetupUI
		Adds a hook (CPanelPaint) to the control panel paint
		function so we can determine when it is being drawn.
	-----------------------------------------------------------]]
	function SetupUI()
	
		local UndoPanel = controlpanel.Get( "Undo" )
		if (!UndoPanel) then return end

		-- Panels only think when they're visible
		UndoPanel.Think = CPanelUpdate
	
	end
	
	hook.Add( "PostReloadToolsMenu", "BuildUndoUI", SetupUI )

end


if (!SERVER) then return end

local PlayerUndo = {}
-- PlayerUndo
--	- Player UniqueID
--		- Undo Table
--			- Name
--			- Entities (table of ents)
--			- Owner (player)

local Current_Undo = nil

util.AddNetworkString("Undo_Undone")
util.AddNetworkString("Undo_AddUndo")

--[[---------------------------------------------------------
	GetTable
	Returns the undo table for whatever reason
-----------------------------------------------------------]]
function GetTable()
	return PlayerUndo
end


--[[---------------------------------------------------------
	GetTable
	Save/Restore the undo tavles
-----------------------------------------------------------]]
local function Save( save )

	saverestore.WriteTable( PlayerUndo, save )

end

local function Restore( restore )

	PlayerUndo = saverestore.ReadTable( restore )

end

saverestore.AddSaveHook( "UndoTable", Save )
saverestore.AddRestoreHook( "UndoTable", Restore )

--[[---------------------------------------------------------
   Start a new undo
-----------------------------------------------------------]]
function Create( text )

	Current_Undo = {}
	Current_Undo.Name 			= text
	Current_Undo.Entities 		= {}
	Current_Undo.Owner 			= nil
	Current_Undo.Functions 		= {}
	
end

--[[---------------------------------------------------------
   Adds an entity to this undo (The entity is removed on undo)
-----------------------------------------------------------]]
function SetCustomUndoText( CustomUndoText )

	if ( !Current_Undo ) then return end
	
	Current_Undo.CustomUndoText = CustomUndoText
	
end

--[[---------------------------------------------------------
   Adds an entity to this undo (The entity is removed on undo)
-----------------------------------------------------------]]
function AddEntity( ent )

	if ( Current_Undo == nil ) then return end
	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end
	
	table.insert( Current_Undo.Entities, ent )
	
end

--[[---------------------------------------------------------
   Add a function to call to this undo
-----------------------------------------------------------]]
function AddFunction( func, ... )

	if ( Current_Undo == nil ) then return end
	if ( !func ) then return end
	
	table.insert( Current_Undo.Functions, { func, {...} } )
	
end

--[[---------------------------------------------------------
   Replace Entity
-----------------------------------------------------------]]
function ReplaceEntity( from, to )

	local ActionTaken = false

	for _, PlayerTable in pairs(PlayerUndo) do
		for _, UndoTable in pairs(PlayerTable) do
			if ( UndoTable.Entities ) then
		
				for key, ent in pairs( UndoTable.Entities ) do
					if ( ent == from ) then
						UndoTable.Entities[ key ] = to
						ActionTaken = true
					end
				end
				
			end
		end	
	end
	
	return ActionTaken
	
end


--[[---------------------------------------------------------
   Sets who's undo this is
-----------------------------------------------------------]]
function SetPlayer( player )

	if (Current_Undo == nil) then return end	
	if ( !player || !player:IsValid() ) then return end
	
	Current_Undo.Owner = player
	
end

--[[---------------------------------------------------------
   SendUndoneMessage
   Sends a message to notify the client that one of their 
   undos has been removed. They can then update their GUI.
-----------------------------------------------------------]]
local function SendUndoneMessage( ent, id, ply )

	if (!ply || !ply:IsValid()) then return end
	
	-- For further optimization we could queue up the ids and send them
	-- in one batch ever 0.5 seconds or something along those lines.
	
	net.Start( "Undo_Undone" )
	    net.WriteInt( id, 16 )
	net.Send( ply )

end

--[[---------------------------------------------------------
   Finish
-----------------------------------------------------------]]
function Finish( NiceText )

	if (Current_Undo == nil) then return end
	if (Current_Undo.Owner == nil) then return end
	if (!Current_Undo.Owner:IsValid()) then return end
	
	local index = Current_Undo.Owner:UniqueID()
	PlayerUndo[ index ] = PlayerUndo[ index ] or {}
	
	local id = table.insert( PlayerUndo[ index ], Current_Undo )
	
	NiceText = NiceText or Current_Undo.Name
	
	net.Start( "Undo_AddUndo" )
		net.WriteInt( id, 16 )
		net.WriteString( NiceText )
	net.Send( Current_Undo.Owner )
	
	-- Have one of the entities in the undo tell us when it gets undone.
	if ( Current_Undo.Entities[1] ) then
	
		local ent = Current_Undo.Entities[ 1 ]
		ent:CallOnRemove( "undo"..id, SendUndoneMessage, id, Current_Undo.Owner )
	
	end
	
			
	Current_Undo = nil
	
end

--[[---------------------------------------------------------
   Undos an undo
-----------------------------------------------------------]]
function Do_Undo( undo )

	if ( !undo ) then return false end
	
	local count = 0
	
	-- Call each function
	if ( undo.Functions ) then
		for index, func in pairs( undo.Functions ) do
		
			func[1]( undo, unpack(func[2]) )
			count = count + 1
			
		end
	end
	
	-- Remove each entity in this undo
	if ( undo.Entities ) then
		for index, entity in pairs( undo.Entities ) do
		
			if ( entity:IsValid() ) then
				entity:Remove()
				count = count + 1
			end
			
		end
	end
	
	if (count > 0) then
		if ( undo.CustomUndoText ) then
			undo.Owner:SendLua( 'hook.Run("OnUndo","' .. undo.Name .. '","' .. undo.CustomUndoText .. '")' )
		else
			undo.Owner:SendLua( 'hook.Run("OnUndo","' .. undo.Name .. '")' )
		end
	end
	
	return count;
	
end

--[[---------------------------------------------------------
   Console command 
-----------------------------------------------------------]]
local function CC_UndoLast( pl, command, args )

	local index = pl:UniqueID()
	PlayerUndo[ index ] = PlayerUndo[ index ] or {}
	
	local last = nil
	local lastk = nil
	
	for k, v in pairs( PlayerUndo[ index ] ) do
	
		lastk = k
		last = v
	
	end
	
	-- No undos
	if (!last) then	return end
	
	-- This is quite messy, but if the player rejoined the server
	-- 'Owner' might no longer be a valid entity. So replace the Owner
	-- with the player that is doing the undoing
	last.Owner = pl
	
	local count = Do_Undo( last )
	
	net.Start( "Undo_Undone" )
		net.WriteInt( lastk, 16 )
	net.Send( pl )
	
	PlayerUndo[ index ][ lastk ] = nil
	
	-- If our last undo object is already deleted then compact
	-- the undos until we hit one that does something
	if ( count == 0 ) then
		CC_UndoLast( pl )
	end

end

--[[---------------------------------------------------------
   Console command 
-----------------------------------------------------------]]
local function CC_UndoNum( pl, command, args )

	if (!args[1]) then return end	
	local index = pl:UniqueID()
	PlayerUndo[ index ] = PlayerUndo[ index ] or {}
	
	local UndoNum = tonumber( args[1] )
	
	-- Delete the undo whatever happens
	--umsg.Start( "Undone", pl )
	--	umsg.Long( UndoNum )
	--umsg.End()
	
	if ( !PlayerUndo[ index ][ UndoNum ] ) then return end
	
	-- Undo!
	Do_Undo( PlayerUndo[ index ][ UndoNum ] )
	PlayerUndo[ index ][ UndoNum ] = nil

end

concommand.Add("undo",					CC_UndoLast, nil, "", { FCVAR_DONTRECORD } )
concommand.Add("gmod_undo",				CC_UndoLast, nil, "", { FCVAR_DONTRECORD } )
concommand.Add("gmod_undonum",			CC_UndoNum, nil, "", { FCVAR_DONTRECORD } )
