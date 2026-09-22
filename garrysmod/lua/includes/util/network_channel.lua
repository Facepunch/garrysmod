-- =====================================================================
-- Project: Network Channel for Garry's Mod
-- Date : 2025-09-22
-- Author: Léo Cirpaci
-- Description: An advanced networking framework built on top of the
--               native 'net' library using a closure-based architecture
--               (avoiding verbose metatables). It features recursive
--               serialization with ZigZag encoding, duplicate channel
--               protection, per-player rate-limiting, structural schema
--               validation, correlation IDs for safe async callbacks,
--               and a built-in bandwidth profiler.
--
--               Designed as a streamlined alternative for developers who
--               want to avoid boilerplate networking headaches. Note that
--               this abstraction is meant for convenience and does not
--               aim to fully replace manual net messages for low-level
--               or edge-case network optimizations.
-- =====================================================================

print("network_channel.lua loaded")

local util = util or {}
local NetworkChannels = {}

-- Type identifiers used during custom network serialization
local TYPE_NIL     = 0
local TYPE_BOOL    = 1
local TYPE_NUMBER  = 2
local TYPE_STRING  = 3
local TYPE_VECTOR  = 4
local TYPE_ANGLE   = 5
local TYPE_ENTITY  = 6
local TYPE_COLOR   = 7
local TYPE_TABLE   = 8

local BITS_TYPE = 4
local DECIMAL_PRECISION = 100

-- Converts signed integers into unsigned integers efficiently using ZigZag encoding
local function EncodeZigZag(n)
    if n >= 0 then return n * 2 else return (-n * 2) - 1 end
end

-- Decodes unsigned ZigZag integers back into signed integers
local function DecodeZigZag(u)
    if u % 2 == 0 then return u / 2 else return -(u + 1) / 2 end
end

-- Calculates the minimum number of bits required to transmit a given number
local function GetBitsRequired(n)
    if n <= 0 then return 1 end
    return math.min(32, math.ceil(math.log(n + 1, 2)))
end

-- Recursively serializes data types and tracks total bit usage for network profiling
local function SerializeRecursive(data, stats)
    local t = type(data)
    if t == "boolean" then
        net.WriteUInt(TYPE_BOOL, BITS_TYPE)
        net.WriteBool(data)
        stats.bits = stats.bits + BITS_TYPE + 1
    elseif t == "number" then
        net.WriteUInt(TYPE_NUMBER, BITS_TYPE)
        local isDecimal = (math.floor(data) ~= data)
        local scaled = isDecimal and math.Round(data * DECIMAL_PRECISION) or data
        local encoded = EncodeZigZag(scaled)
        local bits = GetBitsRequired(encoded)
        net.WriteBool(isDecimal)
        net.WriteUInt(bits, 6)
        net.WriteUInt(encoded, bits)
        stats.bits = stats.bits + BITS_TYPE + 1 + 6 + bits
    elseif t == "string" then
        net.WriteUInt(TYPE_STRING, BITS_TYPE)
        net.WriteString(data)
        stats.bits = stats.bits + BITS_TYPE + ((#data + 1) * 8)
    elseif t == "Vector" then
        net.WriteUInt(TYPE_VECTOR, BITS_TYPE)
        net.WriteVector(data)
        stats.bits = stats.bits + BITS_TYPE + 96
    elseif t == "Angle" then
        net.WriteUInt(TYPE_ANGLE, BITS_TYPE)
        net.WriteAngle(data)
        stats.bits = stats.bits + BITS_TYPE + 96
    elseif t == "Entity" and IsValid(data) then
        net.WriteUInt(TYPE_ENTITY, BITS_TYPE)
        net.WriteEntity(data)
        stats.bits = stats.bits + BITS_TYPE + 16
    elseif t == "table" then
        if IsColor and IsColor(data) or (data.r and data.g and data.b and not data[1]) then
            net.WriteUInt(TYPE_COLOR, BITS_TYPE)
            net.WriteUInt(data.r or 255, 8)
            net.WriteUInt(data.g or 255, 8)
            net.WriteUInt(data.b or 255, 8)
            net.WriteUInt(data.a or 255, 8)
            stats.bits = stats.bits + BITS_TYPE + 32
        else
            net.WriteUInt(TYPE_TABLE, BITS_TYPE)
            stats.bits = stats.bits + BITS_TYPE + 16
            local count = 0
            for _ in pairs(data) do count = count + 1 end
            net.WriteUInt(count, 16)
            for k, v in pairs(data) do
                SerializeRecursive(k, stats)
                SerializeRecursive(v, stats)
            end
        end
    else
        net.WriteUInt(TYPE_NIL, BITS_TYPE)
        stats.bits = stats.bits + BITS_TYPE
    end
end

-- Recursively deserializes incoming network payloads back into standard Lua structures
local function DeserializeRecursive()
    local dataType = net.ReadUInt(BITS_TYPE)
    if dataType == TYPE_BOOL then return net.ReadBool()
    elseif dataType == TYPE_NUMBER then
        local isDecimal = net.ReadBool()
        local bits = net.ReadUInt(6)
        local encoded = net.ReadUInt(bits)
        local scaled = DecodeZigZag(encoded)
        return isDecimal and (scaled / DECIMAL_PRECISION) or scaled
    elseif dataType == TYPE_STRING then return net.ReadString()
    elseif dataType == TYPE_VECTOR then return net.ReadVector()
    elseif dataType == TYPE_ANGLE then return net.ReadAngle()
    elseif dataType == TYPE_ENTITY then return net.ReadEntity()
    elseif dataType == TYPE_COLOR then return Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
    elseif dataType == TYPE_TABLE then
        local count = net.ReadUInt(16)
        local tbl = {}
        for i = 1, count do
            local k = DeserializeRecursive()
            local v = DeserializeRecursive()
            if k ~= nil then tbl[k] = v end
        end
        return tbl
    end
    return nil
end

-- Registers the client-side response receiver for a specific channel
local function RegisterClientReceiver(channel)
    if not CLIENT then return end
    net.Receive(channel.name .. "_response", function()
        local reqId = net.ReadUInt(32)
        local success = net.ReadBool()
        local reqCb = channel.pendingRequests[reqId]
        channel.pendingRequests[reqId] = nil

        if success then
            local data = DeserializeRecursive()
            if reqCb and reqCb.success then reqCb.success(data) end
        else
            local err = net.ReadString()
            local data = DeserializeRecursive()
            if reqCb and reqCb.failure then reqCb.failure(err, data) end
        end
    end)
end

-- Factory function to create or retrieve a Network Channel instance
function util.NetworkChannel(name)
    if NetworkChannels[name] then
        error(string.format("[Framework] Duplicate channel declaration detected: '%s'", name), 2)
    end

    if SERVER then
        util.AddNetworkString(name)
        util.AddNetworkString(name .. "_response")
    end

    local channel = {
        name = name,
        rateLimit = nil,
        playerRequests = {},
        expectedSchema = nil,
        profilerCallback = nil,
        pendingRequests = {},
        requestCounter = 0,
        currentData = nil,
        tempSuccessCallback = nil,
        tempFailureCallback = nil
    }

    function channel:setRateLimit(limit, interval)
        self.rateLimit = { limit = limit, interval = interval }
        self.playerRequests = {}
        return self
    end

    function channel:netProfiler(callback)
        self.profilerCallback = callback
        return self
    end

    function channel:expect(schema)
        self.expectedSchema = schema
        return self
    end

    function channel:write(data)
        self.currentData = data
        return self
    end

    function channel:OnSuccess(callback)
        self.tempSuccessCallback = callback
        return self
    end

    function channel:OnFailure(callback)
        self.tempFailureCallback = callback
        return self
    end

    if CLIENT then
        function channel:SendToServer()
            self.requestCounter = (self.requestCounter or 0) + 1
            local reqId = self.requestCounter
            self.pendingRequests[reqId] = { success = self.tempSuccessCallback, failure = self.tempFailureCallback }
            self.tempSuccessCallback = nil
            self.tempFailureCallback = nil

            net.Start(self.name)
            net.WriteUInt(reqId, 32)
            local stats = { bits = 32 }
            SerializeRecursive(self.currentData, stats)
            net.SendToServer()

            if self.profilerCallback then
                self.profilerCallback(stats.bits, "client_to_server")
            end
            self.currentData = nil
        end

        function channel:OnReceive(callback)
            net.Receive(self.name, function(len)
                local reqId = net.ReadUInt(32)
                local data = DeserializeRecursive()
                callback(data, reqId)
            end)
            return self
        end
    end

    if SERVER then
        local function SendWithProfiling(ch, plyFunc, ply, reqId, isSuccess, ...)
            net.Start(ch.name .. "_response")
            net.WriteUInt(reqId, 32)
            net.WriteBool(isSuccess)
            local stats = { bits = 32 + 1 }
            if isSuccess then
                local result = ...
                SerializeRecursive(result, stats)
            else
                local err, responseData = ...
                net.WriteString(tostring(err or "Unknown error"))
                stats.bits = stats.bits + (#tostring(err) + 1) * 8
                SerializeRecursive(responseData, stats)
            end
            plyFunc(ply)
            if ch.profilerCallback then
                ch.profilerCallback(stats.bits, "server_to_client", ply)
            end
            ch.currentData = nil
        end

        function channel:Send(ply) SendWithProfiling(self, function(p) net.Send(p) end, ply, 0, true, self.currentData) end
        function channel:Broadcast() SendWithProfiling(self, function() net.Broadcast() end, nil, 0, true, self.currentData) end
        function channel:SendOmit(vars) SendWithProfiling(self, function() net.SendOmit(vars) end, nil, 0, true, self.currentData) end
        function channel:SendPVS(pos) SendWithProfiling(self, function() net.SendPVS(pos) end, nil, 0, true, self.currentData) end

        function channel:OnReceive(callback)
            net.Receive(self.name, function(len, ply)
                if not IsValid(ply) then return end
                local reqId = net.ReadUInt(32)

                if self.rateLimit then
                    local curTime = CurTime()
                    local record = self.playerRequests[ply]
                    if not record or curTime > record.resetTime then
                        self.playerRequests[ply] = { count = 1, resetTime = curTime + self.rateLimit.interval }
                    else
                        record.count = record.count + 1
                        if record.count > self.rateLimit.limit then
                            SendWithProfiling(self, function(p) net.Send(p) end, ply, reqId, false, "[SPAM] Rate limit exceeded!", { status = "spam_error" })
                            return
                        end
                    end
                end

                local data = DeserializeRecursive()

                if self.expectedSchema then
                    local isValid = true
                    local errorMsg = ""
                    if type(self.expectedSchema) == "string" then
                        if type(data) ~= self.expectedSchema then
                            isValid = false
                            errorMsg = string.format("Expected %s, got %s", self.expectedSchema, type(data))
                        end
                    elseif type(self.expectedSchema) == "table" then
                        if type(data) ~= "table" then
                            isValid = false
                            errorMsg = "Expected table structure"
                        else
                            for _, item in ipairs(data) do
                                for fieldName, expectedType in pairs(self.expectedSchema) do
                                    if type(item[fieldName]) ~= expectedType then
                                        isValid = false
                                        errorMsg = string.format("Field '%s' expected %s", fieldName, expectedType)
                                        break
                                    end
                                end
                                if not isValid then break end
                            end
                        end
                    end

                    if not isValid then
                        SendWithProfiling(self, function(p) net.Send(p) end, ply, reqId, false, errorMsg, { status = "schema_error" })
                        return
                    end
                end

                local success, errOrResult, responseData = callback(data, ply)
                if success then
                    SendWithProfiling(self, function(p) net.Send(p) end, ply, reqId, true, errOrResult)
                else
                    SendWithProfiling(self, function(p) net.Send(p) end, ply, reqId, false, errOrResult, responseData)
                end
            end)
        end
    end

    if CLIENT then
        RegisterClientReceiver(channel)
    end

    NetworkChannels[name] = channel
    return channel
end

-- Global cleanup for disconnected players
if SERVER then
    hook.Add("PlayerDisconnected", "CleanNetworkChannelsRateLimit", function(ply)
        for _, channel in pairs(NetworkChannels) do
            if channel.playerRequests then
                channel.playerRequests[ply] = nil
            end
        end
    end)
end
