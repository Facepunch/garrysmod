

hook.Add( "PostRender", "RenderDupeIcon", function()

	--
	-- g_ClientSaveDupe is set in transport.lua when receiving a dupe from the server
	--
	if ( !g_ClientSaveDupe ) then return end

	--
	-- Remove the global straight away
	--
	local Dupe = g_ClientSaveDupe;
	g_ClientSaveDupe = nil

	local FOV = 17
	
	--
	-- This is gonna take some cunning to look awesome!
	--
	local Size		= Dupe.Maxs - Dupe.Mins;
	local Radius	= Size:Length() * 0.5;
	local CamDist	= Radius / math.sin( math.rad( FOV ) / 2 ) -- Works out how far the camera has to be away based on radius + fov!
	local Center	= LerpVector( 0.5, Dupe.Mins, Dupe.Maxs );
	local CamPos	= Center + Vector( -1, 0, 0.5 ):GetNormal() * CamDist;
	local EyeAng	= ( Center - CamPos ):GetNormal():Angle();
	
	--
	-- The base view
	--
	local view = 
	{
		type		= "3D",
		origin		= CamPos,
		angles		= EyeAng,
		x			= 0,
		y			= 0,
		w			= 512,
		h			= 512,
		aspect		= 1,
		fov			= FOV
	}

	--
	-- Create a bunch of entities we're gonna use to render.
	--
	local entities = {}

	for k, v in pairs( Dupe.Entities ) do

		if ( v.Class == "prop_ragdoll" ) then

			entities[k] = ClientsideRagdoll( v.Model or "error.mdl", RENDERGROUP_OTHER )

			if ( istable( v.PhysicsObjects ) ) then
			
				for boneid, v in pairs( v.PhysicsObjects ) do

					local obj = entities[k]:GetPhysicsObjectNum( boneid )
					if ( IsValid( obj ) ) then
						obj:SetPos( v.Pos )
						obj:SetAngles( v.Angle )
					end
				
				end

				entities[ k ]:InvalidateBoneCache()

			end

		else

			entities[ k ] = ClientsideModel( v.Model or "error.mdl", RENDERGROUP_OTHER )

		end

	end


	--
	-- DRAW THE BLUE BACKGROUND
	--
	render.SetMaterial( Material( "gui/dupe_bg.png" ) )
	render.DrawScreenQuadEx( 0, 0, 512, 512 )
			

	--
	-- BLACK OUTLINE
	-- AWESOME BRUTE FORCE METHOD
	--
	render.SuppressEngineLighting( true )

	local BorderSize	= CamDist * 0.004
	local Up			= EyeAng:Up() * BorderSize
	local Right			= EyeAng:Right() * BorderSize

	render.SetColorModulation( 1, 1, 1, 1 )
	render.MaterialOverride( Material( "models/debug/debugwhite" ) )

	-- Render each entity in a circle
	for k, v in pairs( Dupe.Entities ) do

		for i=0, math.pi*2, 0.2 do

			view.origin = CamPos + Up * math.sin( i ) + Right * math.cos( i )

			cam.Start( view )

				render.Model( 
				{
					model	=	v.Model,
					pos		=	v.Pos,
					angle	=	v.Angle,

				}, entities[k] )

			cam.End()

		end

	end

	-- Because ee just messed up the depth
	render.ClearDepth()
	render.SetColorModulation( 0, 0, 0, 1 )

	-- Try to keep the border size consistent with zoom size
	local BorderSize	= CamDist * 0.002
	local Up			= EyeAng:Up() * BorderSize
	local Right			= EyeAng:Right() * BorderSize

	-- Render each entity in a circle
	for k, v in pairs( Dupe.Entities ) do

		for i=0, math.pi*2, 0.2 do
			
			view.origin = CamPos + Up * math.sin( i ) + Right * math.cos( i )
			cam.Start( view )

			render.Model( 
			{
				model	=	v.Model,
				pos		=	v.Pos,
				angle	=	v.Angle,
				skin	=	v.Skin
			}, entities[k] )

			cam.End()
				
		end

	end


	--
	-- ACUAL RENDER!
	--

	-- We just fucked the depth up - so clean it
	render.ClearDepth()

	-- Set up the lighting. This is over-bright on purpose - to make the ents pop
	render.SetModelLighting( 0, 0, 0, 0 )
	render.SetModelLighting( 1, 2, 2, 2 )
	render.SetModelLighting( 2, 3, 2, 0 )
	render.SetModelLighting( 3, 0.5, 2.0, 2.5 )
	render.SetModelLighting( 4, 3, 3, 3 ) -- top
	render.SetModelLighting( 5, 0, 0, 0 )
	render.MaterialOverride( nil )

	view.origin = CamPos
	cam.Start( view )

	-- Render each model
	for k, v in pairs( Dupe.Entities ) do

		render.SetColorModulation( 1, 1, 1, 1 )

		if ( istable( v.EntityMods ) ) then
				
			if ( istable( v.EntityMods.colour ) ) then
				render.SetColorModulation( v.EntityMods.colour.Color.r/255, v.EntityMods.colour.Color.g/255, v.EntityMods.colour.Color.b/255, v.EntityMods.colour.Color.a/255 )
			end

			if ( istable( v.EntityMods.material ) ) then
				render.MaterialOverride( Material( v.EntityMods.material.MaterialOverride ) )
			end

		end
		
		render.Model( 
		{
			model	=	v.Model,
			pos		=	v.Pos,
			angle	=	v.Angle,
			skin	=	v.Skin
		}, entities[k] )
			
		render.MaterialOverride( nil )

	end

	cam.End()

	-- Enable lighting again (or it will affect outside of this loop!)
	render.SuppressEngineLighting( false )
	render.SetColorModulation( 1, 1, 1, 1 )

	--
	-- Finished with the entities - remove them all
	--
	for k, v in pairs( entities ) do
		v:Remove()
	end
		
	--
	-- This captures a square of the render target, copies it to a jpeg file 
	-- and returns it to us as a (binary) string.
	--
	local jpegdata = render.Capture(
	{
		format		=	"jpeg",
		x			=	0,
		y			=	0,
		w			=	512,
		h			=	512,
		quality		=	95
	});

	--
	-- Encode and compress the dupe
	--
	local Dupe = util.TableToJSON( Dupe )
	if ( !isstring( Dupe ) ) then
		Msg( "There was an error converting the dupe to a json string" );
	end

	Dupe = util.Compress( Dupe )

	--
	-- And save it! (filename is automatic md5 in dupes/)
	--
	if ( engine.WriteDupe( Dupe, jpegdata ) ) then

		-- Disable the save button!!
		hook.Run( "DupeSaveUnavailable" )
		hook.Run( "DupeSaved" )

		MsgN( "Saved!" )
		
		-- TODO: Open tab and show dupe!

	end
		

end )
