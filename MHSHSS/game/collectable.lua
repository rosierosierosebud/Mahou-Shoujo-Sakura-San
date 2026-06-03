Coin = {img = love.graphics.newImage("graphics/level/collectable.png")}
Coin.__index = Coin
Coin.width = Coin.img:getWidth()
Coin.height = Coin.img:getHeight()
A_Coins = {}

function Coin.new(x, y)
  local instance = setmetatable({}, Coin)
  instance.x = x
  instance.y = y
  
  
  instance.toberemoved = false
  instance.scaleX = 1
  instance.timeoffset = math.random(0, 100)
  instance.physics = {}
  instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
  instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
  instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
  instance.physics.fixture:setSensor(true)
  table.insert(A_Coins, instance)
end
function Coin:remove_it()
  for i, instance in ipairs(A_Coins) do
    if instance == self then
      Player:incrementCoins()
      self.physics.body:destroy()
      table.remove(A_Coins, i)
    end
  end
end
function Coin:update()
  self:spin(dt)
  self:removal()
end
function Coin:removal()
  if self.toberemoved == true then
    self:remove_it()
  end
end

function Coin:spin(dt)
  self.scaleX = math.sin(love.timer.getTime()+ self.timeoffset * 2)
end

function Coin.updateAll(dt)
  for i,instance in ipairs(A_Coins) do
    instance:update()
  end
end

function Coin:draw() 
  love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width/2, self.height/2)
end

function Coin.drawAll()
  for i,instance in ipairs(A_Coins) do
    instance:draw()
  end
end

function Coin.beginContact(a, b, collision)
  for i, instance in ipairs(A_Coins) do
    if a == instance.physics.fixture  or b == instance.physics.fixture then
      if a == Player.physics.fixture or b == Player.physics.fixture then
        instance.toberemoved = true
        return true 
      end
    end
  end
end
