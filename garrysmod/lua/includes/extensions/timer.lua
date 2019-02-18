
--[[---------------------------------------------------------
    Create a timer that will be run every delay seconds
    until the callback function returns false or nil
-----------------------------------------------------------]]
function timer.Loop(delay, callback)
  timer.Simple(delay, function()
    if callback() then timer.Loop(delay, callback) end
  end)
end
