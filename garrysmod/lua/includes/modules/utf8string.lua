local string = string
local print = print
local PrintTable = PrintTable
local error = error
local unpack = unpack
local table = table
local tostring = tostring
local setmetatable = setmetatable
local getmetatable = getmetatable
local bit = bit
local pairs = pairs
module("utf8string")
local unicode_string = {}
unicode_string._metatable = unicode_string
unicode_string.prototype = {}
-------------------------------------------
function unicode_string.__index(index)
	return unicode_string.prototype[index]
end
function unicode_string.__concat(t,t2)
	if getmetatable(t) == unicode_string and getmetatable(t2) == unicode_string then
		local str = utf8("")
		for _,value in pairs(t._string or {}) do 
			table.insert(str._string,value)
		end
		for _,value in pairs(t2._string or {}) do
			table.insert(str._string,value)
		end
		return str
	else
		error("cannot concatinate a non utf8string with a utf8string")
	end
end
function unicode_string.__len(t)
	return table.getn(t._string)
end
function unicode_string.__tostring(t)
	local str = ""
	for _,c in pairs(t._string) do
		for _,value in pairs(c) do
			str = str..string.char(value)
		end
	end
	return str
end
-------------------------------------------
function unicode_string.prototype:byte(index) -- called byte to match string function, should actually be called charCodeAt
	local retval = 0
	for _,b in pairs(t._string[index]) do
		if b > 0xF0 then
			retval = bit.bor(bit.lshift(retval,8),bit.band(b,0x07))
		elseif b > 0xE0 then
			retval = bit.bor(bit.lshift(retval,8),bit.band(b,0x0F))
		elseif b > 0xC0 then
			retval = bit.bor(bit.lshift(retval,8),bit.band(b,0x1F))
		elseif b > 0x80 then
			retval = bit.bor(bit.lshift(retval,8),bit.band(b,0x3F))
		else
			retval = b
		end
	end
	return retval
end
function unicode_string.prototype:len()
	return table.getn(self._string)
end
function unicode_string.prototype:sub(startpos,endpos)
	local retval = utf8("")
	retval._string = {unpack(self._string,startpos,endpos)}
	return retval
end
-------------------------------------------
function byte(utf,index) -- called byte to match string function, should actually be called charCodeAt
	return utf:byte(index)
end
function len(utf)
	return table.getn(utf._string)
end
function sub(utf,startpos,endpos)
	return utf:sub(startpos,endpos)
end
function utf8(utfstring)
	local utf_string = {}
	utf_string._string = {}
	utf_string = setmetatable(utf_string,unicode_string)
	local retval = 0
	for i = 1,string.len(utfstring) do
		local b = string.byte(utfstring,i)
		if b > 0xF0 then
			table.insert(utf_string._string,{b,string.byte(utfstring,i+1),string.byte(utfstring,i+2),string.byte(utfstring,i+3)})
			i = i+3
		elseif b > 0xE0 then
			table.insert(utf_string._string,{b,string.byte(utfstring,i+1),string.byte(utfstring,i+2)})
			i = i+2
		elseif b > 0xC0 then
			table.insert(utf_string._string,{b,string.byte(utfstring,i+1)})
			i = i+1
		elseif b > 0x80 then
			error("continuation byte found instead of character")
		else
			table.insert(utf_string._string,{b})
		end
	end
	return utf_string
end
function char(code)
	local retval = utf8("")
	if code < 0x0080 and code >= 0x0000 then
		table.insert(retval._string,{bit.band(code,0x7F)})
	elseif code < 0x0800 and code >= 0x0080 then
		table.insert(retval._string,{bit.bor(bit.band(bit.rshift(code,6),0x1F),0xC0), bit.bor(bit.band(code,0x3F),0x80)})
	elseif code < 0x10000 and code >= 0x0800 then
		table.insert(retval._string,{bit.bor(bit.band(bit.rshift(code,12),0x0F),0xE0), bit.bor(bit.band(bit.rshift(code,6),0x3F),0x80), bit.bor(bit.band(code,0x3F),0x80)})
	elseif code < 0x200000 and code >= 0x10000 then
		table.insert(retval._string,{bit.bor(bit.band(bit.rshift(code,18),0x07),0xF0), bit.bor(bit.band(bit.rshift(code,12),0x3F),0x80), bit.bor(bit.band(bit.rshift(code,6),0x3F),0x80), bit.bor(bit.band(code,0x3F),0x80)})
	elseif code < 0x4000000 and code >= 0x200000 then
		table.insert(retval._string,{bit.bor(bit.band(bit.rshift(code,24),0x03),0xF8), bit.bor(bit.band(bit.rshift(code,18),0x3F),0x80), bit.bor(bit.band(bit.rshift(code,12),0x3F),0x80), bit.bor(bit.band(bit.rshift(code,6),0x3F),0x80), bit.bor(bit.band(code,0x3F),0x80)})
	elseif bit.band(code,0x80000000) == 0 and code >= 0x4000000 then
		table.insert(retval._string,{bit.bor(bit.band(bit.rshift(code,30),0x03),0xF8), bit.bor(bit.band(bit.rshift(code,24),0x3F),0x80), bit.bor(bit.band(bit.rshift(code,18),0x3F),0x80), bit.bor(bit.band(bit.rshift(code,12),0x3F),0x80), bit.bor(bit.band(bit.rshift(code,6),0x3F),0x80), bit.bor(bit.band(code,0x3F),0x80)})
	else
		error("Invalid Code Point")
	end
	return retval
end