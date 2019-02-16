
promise = {}

--[[---------------------------------------------------------
    Promise object definition
-----------------------------------------------------------]]
local PENDING = 0
local RESOLVED = 1
local REJECTED = -1

local Promise = {}
Promise.__index = Promise
function Promise:_New(callback)
  local self = {}
  self._state = PENDING
  self._handlers = {}
  setmetatable(self, Promise)
  local safe, args = pcall(function()
    callback(function(res)
      self:_Resolve(res)
    end, function(err)
      self:_Reject(args)
    end)
  end)
  if not safe then self:_Reject(args) end
  return self
end
function Promise:_Resolve(res)
  if self:IsSettled() then return end
  local safe, args = pcall(function()
    if getmetatable(res) == Promise then
      res:Then(function(res)
        self:_Resolve(res)
      end, function(err)
        self:_Reject(args)
      end)
    else
      self._state = RESOLVED
      self._value = res
      for i, handler in ipairs(self._handlers) do
        handler.onresolve(res)
      end
    end
  end)
  if not safe then self:_Reject(args) end
end
function Promise:_Reject(err)
  if self:IsSettled() then return end
  self._state = REJECTED
  self._value = err
  for i, handler in ipairs(self._handlers) do
    handler.onreject(err)
  end
end
function Promise:IsPending()
  return self._state == PENDING
end
function Promise:IsSettled()
  return not self:IsPending()
end
function Promise:IsResolved()
  return self._state == RESOLVED
end
function Promise:IsFulfilled()
  return self:IsResolved()
end
function Promise:IsRejected()
  return self._state == REJECTED
end
function Promise:Done(onresolve, onreject)
  if onresolve == nil then onresolve = function() end end
  if onreject == nil then onreject = function() end end
  timer.Simple(0, function()
    if self:IsPending() then
      table.insert(self._handlers, {
        onresolve = onresolve,
        onreject = onreject
      })
    elseif self:IsResolved() then
      onresolve(self._value)
    else
      onreject(self._value)
    end
  end)
end
function Promise:Then(onresolve, onreject)
  return Promise(function(resolve, reject)
    self:Done(function(res)
      if isfunction(onresolve) then
        local safe, args = pcall(function()
          resolve(onresolve(res))
        end)
        if not safe then reject(args) end
      else resolve(res) end
    end, function(err)
      if isfunction(onreject) then
        local safe, args = pcall(function()
          resolve(onreject(err))
        end)
        if not safe then reject(args) end
      else reject(err) end
    end)
  end)
end
function Promise:Catch(onreject)
  return self:Then(nil, onreject)
end
function Promise:Await()
  if not coroutine.running() then return end
  while self:IsPending() do coroutine.yield() end
  if self:IsResolved() then
    if getmetatable(self._value) == Promise then
      return self._value:Await()
    else return self._value end
  else error(self._value) end
end
setmetatable(Promise, {__call = Promise._New})

--[[---------------------------------------------------------
    Returns a new Promise
-----------------------------------------------------------]]
function promise.New(callback)
  return Promise(callback)
end

--[[---------------------------------------------------------
    Returns a Promise that is resolved when every Promise
    passed as a parameter is resolved, or rejected
    when one of the passed promises is rejected
-----------------------------------------------------------]]
function promise.All(promises)
  return Promise(function(resolve, reject)
    local remaining = #promises
    if remaining > 0 then
      for i, promise in ipairs(promises) do
        promise:Then(function(res)
          remaining = remaining - 1
          if remaining == 0 then
            local results = {}
            for i, promise in ipairs(promises) do
              table.insert(results, promise._value)
            end
            resolve(results)
          end
        end, reject)
      end
    else resolve({}) end
  end)
end

--[[---------------------------------------------------------
    Returns a Promise that is resolved/rejected
    with the first settled Promise
-----------------------------------------------------------]]
function promise.First(promises)
  return Promise(function(resolve, reject)
    for i, promise in ipairs(promises) do
      promise:Then(resolve, reject)
    end
  end)
end
