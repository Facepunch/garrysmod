
--[[---------------------------------------------------------
    Create a timer that will be run every delay seconds
    until the callback function returns false or nil
-----------------------------------------------------------]]
function timer.Loop(delay, callback)
  timer.Simple(delay, function()
    local loop, newdelay = callback()
    if loop then timer.Loop(newdelay or delay, callback) end
  end)
end
