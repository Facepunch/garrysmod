
AddCSLuaFile()

properties.Add( "skin", 
{
	MenuLabel	=	"#skin",
	Order		=	601,
	MenuIcon	=	"icon16/picture_edit.png",
	
	Filter		=	function( self, ent, ply ) 

						if ( !IsValid( ent ) ) then return false end
						if ( ent:IsPlayer() ) then return false end
						if ( !gamemode.Call( "CanProperty", ply, "skin", ent ) ) then return false end

						return ent:SkinCount() > 1

					end,

	MenuOpen	=	function( self, option, ent, tr )

		--
		-- Add a submenu to our automatically created menu option
		--
		local submenu = option:AddSubMenu()


		--
		-- Create a check item for each skin
		--
		local num = ent:SkinCount();

		for i=0, num-1 do

			local option = submenu:AddOption( "Skin " .. i, function() self:SetSkin( ent, i ) end )
			if ( ent:GetSkin() == i ) then
				option:SetChecked( true )
			end

		end
		

	end,
					
	Action		=	function( self, ent )
	
						-- Nothing - we use SetBodyGroup below
						
					end,

	SetSkin =	function( self, ent, id )

						self:MsgStart()
							net.WriteEntity( ent )
							net.WriteUInt( id, 8 )
						self:MsgEnd()

					end,
					
	Receive		=	function( self, length, player )
					
						local ent		= net.ReadEntity()
						local skinid	= net.ReadUInt( 8 )
						
						if ( !self:Filter( ent, player ) ) then return end
																	
						ent:SetSkin( skinid )
						
					end	

});
