module( "redo", package.seeall )

if CLIENT then

	redo_maxstored = CreateClientConVar("redo_maxstored", "30", true, true)
	
	cvars.AddChangeCallback("redo_maxstored", function(name, old, new)
		net.Start("redoLimit")
		net.WriteInt(tonumber(new), 16)
		net.SendToServer()
	end)
	
	local function redo_message( len, text )
		notification.AddLegacy("Redone " .. ( text or "Item" ), 2, 3)
		surface.PlaySound( "buttons/button15.wav" )
	end
	
	net.Receive( "redone", redo_message )
	
	local function redo_clear()
		notification.AddLegacy("Redo History Cleared", 4, 3)
		surface.PlaySound("buttons/button14.wav")
	end
	
	net.Receive( "redoClear", redo_clear )
	
end

if SERVER then

	redo = {}

	local function updatelimit( len, ply )
		local max = math.Clamp(net.ReadInt(16), 0, 50)
	
		for i = 1, #redo[ply] - max do
			if redo[ply][i] then
				table.remove(redo[ply], i)
			end
		end
	end
	
	net.Receive( "redoLimit", updatelimit )
	
	function Clear( ply )
		if IsValid( ply ) then
			redo[ply] = {}
			net.Start( "redoClear" )
			net.Send( ply )
		end
	end
	
	function Do_Redo( ply )
		if hook.Run("OnRedo", ply ) then return end
		local buffer = redo[ply][#redo[ply]]
	
		if buffer and #redo[ply] > 0 then
		
			local entities, constraints = duplicator.Paste(client, buffer.Entities or {}, buffer.Constraints or {})
			undo.Create("Redone Item")
	
			for k,v in pairs(entities) do

				if IsValid(v:GetPhysicsObject()) and buffer.Entities[k].Velocity then
					v:GetPhysicsObject():SetVelocity(buffer.Entities[k].Velocity)
				end
				undo.AddEntity(v)
				v:SetSpawnEffect(false)
				
			end
	
			undo.SetCustomUndoText("Undone Redone Item")
			undo.SetPlayer(ply)
			undo.Finish()
	
			table.remove(redo[ply])
			net.Start( "redone" )
			net.Send( ply )
		end
	end
	
	util.AddNetworkString( "redoLimit" )
	util.AddNetworkString( "redoClear" )
	util.AddNetworkString( "redone" )
	
	concommand.Add("redo",              Do_Redo, nil, "", { FCVAR_DONTRECORD } )
	concommand.Add("redo_clearhistory", Clear,   nil, "", { FCVAR_DONTRECORD } )
	
	hook.Add("PlayerDisconnected", "clearRedo", function( ply )
		if redo[ply] then
			redo[ply] = nil
		end
	end)
	
end
