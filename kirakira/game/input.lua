local keyStates = {}
local actions = {attack = 'z',jump = 'space',move_left = 'a',move_right = 'd', idk = 'b'}
gamepadpressed = {}

function getDirectDelta()
  local delta = {x=0,y=0}
  
  --begin testingcontrols
  
  if love.keyboard.isDown(actions.move_left) then 
   delta.x = -1
  elseif love.keyboard.isDown(actions.move_right) then 
   delta.x = 1
  else
    delta.x = 0
  end
  
  --end testingcontrols
  local jsticks = love.joystick.getJoysticks()
  if #jsticks >0 then -- # is number of
    local xaxis = jsticks[1]:getAxis(1)
    local yaxis = jsticks[1]:getAxis(2)
    delta.x = xaxis
    delta.y = -yaxis
    
    if delta.x < 0.2 and delta.x > 0 or delta.x > -0.2 and delta.x < 0 then
      delta.x = 0
    end
    if delta.y < 0.2 and delta.y > 0 or delta.y > -0.2 and delta.y < 0 then
      delta.y = 0
    end
  end
  return delta
end

love.gamepadpressed = function(joystick, button) 
  if button then
    gamepadpressed[button] = true
    
  end
end
love.keyboard.isPressed = function(k) 
    local now = love.keyboard.isDown(k)
    if keyStates[k] then
      local last = keyStates[k].last
      keyStates[k].now = now
      return now and not last
    else 
      keyStates[k] = {now = now, last = false}
      return now
    end
  end
  
  love.keyboard.isReleased = function(k) 
    local now = love.keyboard.isDown(k)
    if keyStates[k] then
      local last = keyStates[k].last
      keyStates[k].now = now
      return last and not now
    else 
      keyStates[k] = {now = now, last = false}
      return now
    end
  end
  
  love.keyboard.resetKey = function() 
    for k, _ in pairs(keyStates) do 
      keyStates[k].last = keyStates[k].now
      end
  end
  
touches = love.touch.getTouches()

function love.touchpressed(id, x, y, dx, dy, pressure)
    touches[id] = {x = x, y = y}
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    touches[id] = nil
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    touches[id] = {x = x, y = y}
end