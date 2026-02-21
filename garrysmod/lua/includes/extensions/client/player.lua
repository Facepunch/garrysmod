
if ( SERVER ) then return end


local meta = FindMetaTable( "Player" )


local playerOptions = {}
local bindTranslation = {}
bindTranslation["slot1"] = 1
bindTranslation["slot2"] = 2
bindTranslation["slot3"] = 3
bindTranslation["slot4"] = 4
bindTranslation["slot5"] = 5
bindTranslation["slot6"] = 6
bindTranslation["slot7"] = 7
bindTranslation["slot8"] = 8
bindTranslation["slot9"] = 9
bindTranslation["slot0"] = 0

--[[---------------------------------------------------------
   Name:	PlayerOption
   Params: 	<name> <timeout> <input function> <draw function>
   Desc:	
-----------------------------------------------------------]]  
function meta:AddPlayerOption( name, timeout, in_func, draw_func )

	local option = {}
		option.timeout = timeout
		option.in_func = in_func
		option.draw_func = draw_func

	if (timeout != -1) then
		option.timeout = CurTime() + timeout
	end

	playerOptions[ name ] = option

end


local function hook_PlayerOptionInput( pl, bind, down )

	if (!down || !bindTranslation[bind]) then return end
	
	for k, v in pairs( playerOptions ) do
	
		if ( v.timeout == -1 || v.timeout > CurTime() ) then
		
			-- If the function returns true then remove this player option
			if ( v.in_func( bindTranslation[bind] ) ) then
				playerOptions[k] = nil
			end
			
			return true
		else
			playerOptions[k] = nil
		end
	end
	
end

hook.Add( "PlayerBindPress", "PlayerOptionInput", hook_PlayerOptionInput )

local function hook_PlayerOptionDraw()

	for k, v in pairs( playerOptions ) do
	
		if (v.draw_func) then v.draw_func() end
		return
		
	end

end

hook.Add( "HUDPaint", "PlayerOptionDraw", hook_PlayerOptionDraw )