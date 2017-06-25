
ws_save = WorkshopFileBase("save", { "save" })


function ws_save:FetchLocal(offset, perpage)

	local f = file.Find("saves/*.gms", "MOD", "datedesc")

	local saves = {}

	for k, v in pairs(f) do

		if (k <= offset) then continue end
		if (k > offset + perpage) then break end

		local entry =
		{
			file	= "saves/" .. v,
			name	= v:StripExtension(),
			preview	= "saves/" .. v:StripExtension() .. ".jpg"
		}

		table.insert(saves, entry)

	end

	local results = {
		totalresults	= #f,
		results			= saves
	}

	local json = util.TableToJSON(results, false)
	pnlMainMenu:Call("save.ReceiveLocal( " .. json .. ")")

end

function ws_save:DownloadAndLoad(id)

	steamworks.Download(id, true, function( name)

		ws_save:Load(name)

	end )

end


function ws_save:Load(filename)

	RunConsoleCommand("gm_load", filename)

end


function ws_save:FinishPublish(filename, imagename, name, desc, chosentag)

	local info = GetSaveFileDetails(filename)
	if (not info) then return "Couldn't get save informationnot " end

	steamworks.Publish({ "save", info.map, chosentag }, filename, imagename, name, desc)

end

function ws_save:Publish(filename, image)

	--MsgN("PUBLISHING ", filename)
	--MsgN("Image ", image)

	--
	-- Create the window
	--
	local Window = vgui.Create("DFrame")
		Window:SetTitle("Publish Creation")
		Window:SetSize(400, 350)
		Window:LoadGWENFile("resource/ui/SaveUpload.gwen")
		Window:Center()
		Window:MakePopup()

	--
	-- Store the fields
	--
	local Submit		= Window:Find("upload")
	local Title			= Window:Find("name")
	local Description	= Window:Find("description")
	local Error			= Window:Find("error")
	local Image			= Window:Find("image")

	Image:SetImage("../" .. image)

	--
	-- Hook up action
	--
	Submit.DoClick = function()

		local ChosenTag = nil

		local FindTag = function(tagname)

			local cb = Window:Find("tag_" .. tagname)
			if (not cb:GetChecked()) then return true end

			if (ChosenTag ~= nil) then
				Error:SetText("Choose only one tagnot ")
				return false
			end

			ChosenTag = tagname
			return true

		end

		if (not FindTag( "scenes")) then return end
		if (not FindTag( "machines")) then return end
		if (not FindTag( "buildings")) then return end
		if (not FindTag( "courses")) then return end
		if (not FindTag( "others")) then return end

		if (ChosenTag == nil) then
			Error:SetText("Choose a tagnot ")
			return
		end

		if (Title:GetText() == "") then
			Error:SetText("You must provide a titlenot ")
			return
		end

		--MsgN("Publish with tag ", ChosenTag)

		local error = self:FinishPublish(filename, image, Title:GetText(), Description:GetText(), ChosenTag)
		if (error) then
			Error:SetText(error)
			return
		end

		Window:Remove()

	end

end

--
-- Called from the enginenot
--
concommand.Add("save_publish", function( ply, cmd, args)

	ws_save:Publish(args[1], args[2])
	gui.ActivateGameUI()

end, nil, "", { FCVAR_DONTRECORD } )
