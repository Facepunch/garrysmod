
local PreviewCache = {}
local InfoCache = {}
local VoteCache = {}
local ListCache = {}

function WorkshopFileBase( namespace, requiredtags )

	local ret = {}
	ret.HTML = nil

	function ret:Fetch( type, offset, perpage, extratags, searchText, filter )

		local tags = table.Copy( requiredtags )
		for k, v in pairs( extratags ) do
			if ( v == "" ) then continue end
			table.insert( tags, v )
		end

		if ( type == "local" ) then
			return self:FetchLocal( offset, perpage )
		end
		if ( type == "subscribed" ) then
			return self:FetchSubscribed( offset, perpage, tags, searchText, false, filter )
		end
		if ( type == "subscribed_ugc" ) then
			return self:FetchSubscribed( offset, perpage, tags, searchText, true, filter )
		end

		local userid = "0"
		if ( type == "mine" ) then userid = "1" end

		local cachename = type .. "-" .. string.concat( tags, "/" ) .. offset .. "-" .. perpage .. "-" .. userid

		if ( ListCache[ cachename ] ) then
			self:FillFileInfo( ListCache[ cachename ] )
			return
		end

		steamworks.GetList( type, tags, offset, perpage, 0, userid, function( data )
			ListCache[ cachename ] = data
			self:FillFileInfo( data )
		end )

	end

	function ret:FetchSubscribed( offset, perpage, tags, searchText, isUGC, filter )

		local subscriptions = {}
		if ( isUGC ) then
			subscriptions = engine.GetUserContent()
		else
			subscriptions = engine.GetAddons()
		end

		for id, e in pairs( subscriptions ) do
			if ( e.timeadded == 0 ) then e.timeadded = os.time() end
		end
		table.sort( subscriptions, function( a, b )
			return a.timeadded > b.timeadded
		end )

		-- First build a list of items that fit our search terms
		local searchedItems = {}
		for id, sub in pairs( subscriptions ) do

			-- Search for tags
			local found = true
			for id, tag in pairs( tags ) do
				if ( !sub.tags:lower():find( tag ) ) then found = false end
			end
			if ( !found ) then continue end

			-- Search for searchText
			if ( searchText:Trim() != "" ) then
				if ( !sub.title:lower():find( searchText:lower() ) ) then continue end
			end

			if ( filter && filter == "enabledonly" ) then
				if ( !steamworks.ShouldMountAddon( sub.wsid ) ) then continue end
			end
			if ( filter && filter == "disabledonly" ) then
				if ( steamworks.ShouldMountAddon( sub.wsid ) ) then continue end
			end

			searchedItems[ #searchedItems + 1 ] = sub

		end

		-- Build the page!
		local data = {
			totalresults = #searchedItems,
			results = {}
		}

		local i = 0
		while ( i < perpage ) do

			if ( searchedItems[ offset + i + 1 ] ) then
				table.insert( data.results, searchedItems[ offset + i + 1 ].wsid )
			end

			i = i + 1

		end

		self:FillFileInfo( data )

	end

	function ret:RetrieveUserName( steamid )
		steamworks.RequestPlayerInfo( steamid, function( name )
			self.HTML:Call( namespace .. ".ReceiveUserName( \"" .. steamid:JavascriptSafe() .. "\", \"" .. name:JavascriptSafe() .. "\" )" )
		end )
	end

	function ret:FillFileInfo( results )

		--
		-- File info failed..
		--
		if ( !results ) then return end

		--
		-- Send the file index..
		--
		local json = util.TableToJSON( results, false )
		self.HTML:Call( namespace .. ".ReceiveIndex( " .. json .. " )" )

		--
		-- Request info on each file..
		--
		for k, v in pairs( results.results ) do

			v = v:JavascriptSafe()

			--
			-- Got it cached?
			--
			if ( PreviewCache[ v ] ) then

				self.HTML:Call( namespace .. ".ReceiveImage( \"" .. v .. "\", \"" .. PreviewCache[ v ] .. "\" )" )

			end

			--
			-- Get the file information
			--
			if ( InfoCache[ v ] ) then

				self.HTML:Call( namespace .. ".ReceiveFileInfo( \"" .. v .. "\", " .. InfoCache[ v ] .. " )" )

			else

				steamworks.FileInfo( v, function( result )

					if ( !result && result.error != nil ) then return end

					if ( result.description ) then
						result.description = string.gsub( result.description, "%[img%]([^%]]*)%[/img%]", "" ) -- Gotta remove inner content of img tags
						result.description = string.gsub( result.description, "%[([^%]]*)%]", "" )
						result.description = string.Trim( result.description )
					end

					if ( !result.ownername || result.ownername == "" || result.ownername == "[unknown]" ) then
						self:RetrieveUserName( result.owner )
					end

					local json = util.TableToJSON( result, false )
					InfoCache[ v ] = json
					self.HTML:Call( namespace .. ".ReceiveFileInfo( \"" .. v .. "\", " .. json .. " )" )

					--
					-- Now we have the preview id - get the preview image!
					--
					if ( !PreviewCache[ v ] ) then

						steamworks.Download( result.previewid, false, function( name )

							-- Download failed
							if ( !name ) then return end

							PreviewCache[ v ] = name:JavascriptSafe()
							self.HTML:Call( namespace .. ".ReceiveImage( \"" .. v .. "\", \"" .. PreviewCache[ v ] .. "\" )" )

						end )

					end

				end )
			end

			--
			-- Get the current voting stats
			--
			self:CountVotes( v )

		end

	end

	function ret:CountVotes( id )

		id = id:JavascriptSafe()

		if ( VoteCache[ id ] ) then

			self.HTML:Call( namespace .. ".ReceiveVoteInfo( \"" .. id .. "\", " .. VoteCache[ id ] .. " )" )

		else

			steamworks.VoteInfo( id, function( result )

				VoteCache[ id ] = util.TableToJSON( result, false )
				self.HTML:Call( namespace .. ".ReceiveVoteInfo( \"" .. id .. "\", " .. VoteCache[ id ] .. " )" )

			end )
		end

	end

	function ret:Publish( filename, image )

		--MsgN( "PUBLISHING ", filename )
		--MsgN( "Image ", image )

		--
		-- Create the window
		--
		local Window = vgui.Create( "DFrame" )
		Window:SetTitle( "Publish Creation" )
		Window:SetSize( 400, 350 )
		Window:LoadGWENFile( "resource/ui/SaveUpload.gwen" ) -- TODO?
		Window:Center()
		Window:MakePopup()

		--
		-- Store the fields
		--
		local Submit		= Window:Find( "upload" )
		local Title			= Window:Find( "name" )
		local Description	= Window:Find( "description" )
		local Error			= Window:Find( "error" )
		local Image			= Window:Find( "image" )

		Image:SetImage( "../" .. image )

		--
		-- Hook up action
		--
		Submit.DoClick = function()

			if ( Title:GetText() == "" ) then
				Error:SetText( "You must provide a title!" )
				return
			end

			local error = self:FinishPublish( filename, image, Title:GetText(), Description:GetText() )
			if ( error ) then
				Error:SetText( error )
				return
			end

			Window:Remove()

		end

	end

	return ret

end
