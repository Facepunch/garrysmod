---------------
	FILESTREAM (inspired by slib sh_filestream.lua)

	Buffered file I/O with optional compression. Opens a file,
	buffers all writes in memory, and flushes on Close().
	Supports dynamic writing (auto-flush after each write).

	Usage:
		local stream = filestream.Open( "mydata/log.txt" )
		stream:WriteLine( "Server started at " .. os.date() )
		stream:WriteLine( "Players: " .. #player.GetAll() )
		stream:Close()

		-- With compression:
		local stream = filestream.Open( "mydata/save.dat", true )
		stream:Write( util.TableToJSON( bigTable ) )
		stream:Close()

		-- Read back:
		local stream = filestream.Open( "mydata/save.dat", true )
		local data = stream:Read()
		stream:Close()

		-- Dynamic writer (auto-saves each write):
		local stream = filestream.Open( "mydata/live.log", false, true )
		stream:WriteLine( "Event 1" )  -- auto-saved
		stream:WriteLine( "Event 2" )  -- auto-saved
----------------

filestream = filestream or {}


function filestream.Open( path, compressed, dynamicWrite )

	local private = {}
	private.path = path
	private.isOpen = false
	private.compressed = compressed or false
	private.dynamicWrite = dynamicWrite or false
	private.buffer = nil

	-- Internal helpers
	local function EnsureDirectory()
		local dir = string.GetPathFromFilename( path )
		if ( dir and dir != "" and !file.Exists( dir, "DATA" ) ) then
			file.CreateDir( dir )
		end
	end

	local function GetWriteData( data )
		data = data or private.buffer or ""
		if ( private.compressed ) then
			return util.Compress( data )
		end
		return data
	end

	local function FlushToDisk( appendStr )
		EnsureDirectory()

		if ( !private.compressed and appendStr and file.Exists( path, "DATA" ) ) then
			file.Append( path, appendStr )
		else
			file.Write( path, GetWriteData() )
		end
	end

	local function AutoFlush( appendStr )
		if ( private.dynamicWrite ) then
			FlushToDisk( appendStr )
		end
	end


	-- Public API
	local stream = {}
	stream.path = path
	stream.fileName = string.GetFileFromFilename( path )
	stream.directory = string.GetPathFromFilename( path )

	function stream:Open()
		if ( private.isOpen ) then return self end
		private.isOpen = true

		if ( file.Exists( path, "DATA" ) ) then
			local raw = file.Read( path, "DATA" )
			if ( private.compressed and raw ) then
				private.buffer = util.Decompress( raw ) or ""
			else
				private.buffer = raw or ""
			end
		else
			private.buffer = ""
		end

		return self
	end

	function stream:Write( text )
		if ( !private.isOpen ) then return self end
		text = tostring( text )

		-- Skip if content unchanged (MD5 dedup)
		if ( private.buffer == text ) then return self end

		private.buffer = text
		AutoFlush()
		return self
	end

	function stream:WriteLine( text )
		if ( !private.isOpen ) then return self end
		text = tostring( text )

		local appendStr = text
		if ( #private.buffer > 0 ) then
			appendStr = "\n" .. text
		end

		private.buffer = private.buffer .. appendStr
		AutoFlush( appendStr )
		return self
	end

	function stream:Append( text )
		if ( !private.isOpen ) then return self end
		text = tostring( text )
		private.buffer = private.buffer .. text
		AutoFlush( text )
		return self
	end

	function stream:Clear()
		if ( !private.isOpen ) then return self end
		private.buffer = ""
		AutoFlush()
		return self
	end

	function stream:Read()
		return private.buffer
	end

	function stream:LinePairs()
		if ( !private.isOpen or !private.buffer ) then
			return function() end
		end

		local lines = string.Explode( "\n", private.buffer )
		local idx = 0

		return function()
			idx = idx + 1
			if ( idx <= #lines ) then
				return idx, lines[ idx ]
			end
		end
	end

	function stream:Length()
		return private.buffer and #private.buffer or 0
	end

	function stream:IsOpen()
		return private.isOpen
	end

	function stream:Close()
		if ( !private.isOpen ) then return end

		if ( !private.dynamicWrite ) then
			FlushToDisk()
		end

		private.isOpen = false
		private.buffer = nil
	end

	-- Auto-open if dynamic write mode
	if ( dynamicWrite ) then
		stream:Open()
	end

	return stream

end

MsgN( "[FileStream] Buffered file I/O loaded." )
