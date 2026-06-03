GUI = {}

function GUI:load() 
  font3 = love.graphics.newFont("BoldPixels.ttf", 15)
  self.coins = {}
  self.coins.img = love.graphics.newImage("graphics/level/collectable.png")
  self.coins.width = self.coins.img:getWidth()
  self.coins.height = self.coins.img:getHeight()
  self.coins.scale = 2
  self.coins.x = love.graphics.getWidth() - 70
  self.coins.y = 20
  
  self.hearts = {}
  self.hearts.img = love.graphics.newImage("graphics/level/lives.png")
  self.hearts.width = self.hearts.img:getWidth()
  self.hearts.height = self.hearts.img:getHeight()
  self.hearts.x = 0
  self.hearts.y = 30
  self.hearts.scale = 2
  self.hearts.space = self.hearts.width*self.hearts.scale + 10
end

function GUI:update(dt)
  
end

function GUI:draw()
  self:displayCoins()
  self:displayCounter()
end

function GUI:displayCoins()
  love.graphics.setFont(font3)
  love.graphics.setColor(0,0,0,0.5)
  love.graphics.draw(self.coins.img, self.coins.x+2, self.coins.y+2, 0, self.coins.scale, self.coins.scale)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
end
function GUI:displayCounter()
  local x = self.coins.x + 30
  local y = self.coins.y+10
  love.graphics.setColor(0,0,0,0.5)
  love.graphics.print(" x ".. Player.souls, x+2, y+2)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(" x ".. Player.souls, x, y)
end
