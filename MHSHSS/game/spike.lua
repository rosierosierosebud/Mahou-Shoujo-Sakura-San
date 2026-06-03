Spike = {img = love.graphics.newImage("graphics/level/spike.png")}
Spike.__index = Spike
Spike.width = Spike.img:getWidth()
Spike.height = Spike.img:getHeight()
A_Spikes = {}
--For clarity... these r not spikes... but the guy in the video is making spikes and eh for the sake of avoiding confusion i may as well join in on the name
--also if u r not me and u r reading thisss.... hAIIIII!!! hows it feel to be an ultimate supreme cool hacker. thankz for playin my gameeee i hope u r enjoying urself :D have a fun romp through the code :D ik its messy...
function Spike.new(x, y)
  local instance = setmetatable({}, Spike)
  instance.x = x
  instance.y = y
 
  

  instance.physics = {}
  instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
  instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
  instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
  instance.physics.fixture:setSensor(true)
  table.insert(A_Spikes, instance)
end

function Spike:update()
  
end


function Spike.updateAll(dt)
  for i,instance in ipairs(A_Spikes) do
    instance:update()
  end
end

function Spike:draw() 
  love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width/2, self.height/2)
end

function Spike.drawAll()
  for i,instance in ipairs(A_Spikes) do
    instance:draw()
  end
end

function Spike.beginContact(a, b, collision)
  for i, instance in ipairs(A_Spikes) do
    if a == instance.physics.fixture  or b == instance.physics.fixture then
      if a == Player.physics.fixture or b == Player.physics.fixture then
        instance.toberemoved = true
        return true 
      end
    end
  end
end
