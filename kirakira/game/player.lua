Player = {}
function Player:load()
  self.x = 50
  self.y = 0
  self.startX = self.x
  self.startY = self.y
  
  self.width = 16
  self.height = 38
  self.physics = {}
  self.xVel = 0
  self.yVel = 100
  self.MaxSpeed = 200
  self.acceleration = 4000
  self.friction = 3500
  
  self.souls = 0 
  self.hp = {current = 3, max = 3}
  
  self.gracetime = 0
  self.graceduration = 0.1
  
  self.alive = true
  self.jumpamount = -390
  self.gravity = 1500
  self.grounded = false
  self.hasdoublejump = true
  
  self.direction = "right"
  self.state = "idle"
  
  self:loadAssets()
  
  self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
  self.physics.body:setFixedRotation(true)
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
  --self:takedamage(3)
end

function Player:loadAssets()
  self.animation = {timer = 0, rate = 0.1}
  self.animation.run = {total = 4, current = 1, img = {}}
  for i=1, self.animation.run.total do
    self.animation.run.img[i] = love.graphics.newImage("graphics/player/run/" .. i .. ".png")
  end
  self.animation.idle = {total = 4, current = 1, img = {}}
  for i=1, self.animation.idle.total do
    self.animation.idle.img[i] = love.graphics.newImage("graphics/player/idle/" .. i .. ".png")
  end
  self.animation.air = {total = 1, current = 1, img = {}}
  for i=1, self.animation.air.total do
    self.animation.air.img[i] = love.graphics.newImage("graphics/player/air/" .. i .. ".png")
  end
  --repeat that for loop with other animations, when added
  self.animation.draw = self.animation.idle.img[1] 
  self.animation.width = self.animation.draw:getWidth()
  self.animation.height = self.animation.draw:getHeight()
end

function Player:takedamage(amount)
  if self.hp.current - amount > 0 then
    self.hp.current = self.hp.current - amount
  else
    self.hp.current = 0
    self:die()
  end
  print("Player".. self.hp.current)
end
function Player:die()
  print("oops.. ur dead hehe")
  self.alive = false
end

function Player:respawn()
  if not self.alive then
    self.physics.body:setPosition(self.startX, self.startY) 
    self.hp.current = self.hp.max
    self.alive = true
  end
end

function Player:update(dt) 
  self:respawn()
  self:setDir()
  self:setState()
  self:animate(dt)
  self:jump()
  self:move(dt)
  self:applyGravity(dt)
  self:decreaseGrace(dt)
  love.keyboard.resetKey()
  gamepadpressed = {}
end
function Player:setState()
  if not self.grounded then 
    self.state = "air"
  elseif self.xVel == 0 then
    self.state = "idle"
  else
    self.state = "run"
  end
end

function Player:incrementCoins()
  TEsound.stop("sfx", false)
  self.souls = self.souls + 1
  play_collect()
end

function Player:setDir()
  if self.xVel < 0 then
    self.direction = "left"
  elseif self.xVel > 0 then
    self.direction = "right"
  end
end
function Player:animate(dt)
  self.animation.timer = self.animation.timer + dt
  if self.animation.timer > self.animation.rate then
    self.animation.timer = 0
    self:setNewFrame()
  end
end
function Player:setNewFrame()
  local anim = self.animation[self.state]
  if anim.current < anim.total then
    anim.current = anim.current +1 
  else
    anim.current = 1
  end
  self.animation.draw = anim.img[anim.current]
end

function Player:applyGravity(dt) 
  if not self.grounded then
    self.yVel = self.yVel + self.gravity* dt 
  end
end

function Player:decreaseGrace(dt)
  if not self.grounded then
    self.gracetime = self.gracetime - dt
  end
end

function Player:move(dt) 
  -- 3ds controls
  if console == "3ds" then 
    local delta = getDirectDelta()
    if delta.x > 0.2 then --moving LEFT
      if self.xVel < self.MaxSpeed then
        if self.xVel + self.acceleration * dt < self.MaxSpeed then
          self.xVel = self.xVel + self.acceleration * dt
        else
          self.xVel = self.MaxSpeed
        end
      end
    elseif delta.x < -0.2 then
      if self.xVel > -self.MaxSpeed then
        if self.xVel - self.acceleration * dt > -self.MaxSpeed then
          self.xVel = self.xVel - self.acceleration * dt
        else
          self.xVel = -self.MaxSpeed
        end
      end
    end
    self.x = self.x + self.xVel 
  --END--
  end
  --TESTING CONTROLS--
    if love.keyboard.isDown("d") then
      if self.xVel < self.MaxSpeed then
        if self.xVel + self.acceleration * dt < self.MaxSpeed then
          self.xVel = self.xVel + self.acceleration * dt
        else 
          self.xVel = self.MaxSpeed
        end
      end
    elseif love.keyboard.isDown("a") then
      if self.xVel > -self.MaxSpeed then
        if self.xVel - self.acceleration * dt > -self.MaxSpeed then
          self.xVel = self.xVel - self.acceleration * dt
        else
          self.xVel = -self.MaxSpeed
        end
      end
    else
    self:applyFriction(dt)
    end
  --END--
  --end
end
function Player:applyFriction(dt) 
  if self.xVel > 0 then
    self.xVel = math.max(self.xVel - self.friction * dt, 0)
  elseif self.xVel < 0 then
    self.xVel = math.min(self.xVel + self.friction * dt, 0)
  end
end

function Player:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
  self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:beginContact(a, b, collision)
  if self.grounded == true then return end
  local nx, ny = collision:getNormal()
  if a == self.physics.fixture then
    if ny > 0 then
      self:land(collision)
    elseif ny < 0 then
      self.yVel = 0
    end
  elseif b == self.physics.fixture then
    if ny < 0 then
      self:land(collision)
    elseif ny > 0 then
      self.yVel = 0
    end
  end
end

function Player:land(collision) 
  self.currentground = collision
  self.yVel = 0 
  self.grounded = true
  self.hasdoublejump = true
  self.gracetime = self.graceduration
end

function Player:jump(key)
  if console == "3ds" then
    if gamepadpressed["a"] then
      if self.grounded or self.gracetime > 0 then
        play_jump()
        self.yVel = self.jumpamount
        self.gracetime = 0
      elseif self.hasdoublejump then
        play_jump()
        self.hasdoublejump = false
        self.yVel = self.jumpamount * 0.6
      end
    end
  end
    if love.keyboard.isPressed("w") then
      if self.grounded or self.gracetime > 0 then
        play_jump()
        self.yVel = self.jumpamount
        self.gracetime = 0
      elseif self.hasdoublejump then
        play_jump()
        self.hasdoublejump = false
        self.yVel = self.jumpamount * 0.6
      end
    end
  end
function Player:endContact(a, b, collision)
  if a == self.physics.fixture or b == self.physics.fixture then
    if self.currentground == collision then
      self.grounded = false
    end
  end
end
function Player:draw()
  local scaleX = 1
  if self.direction == "left" then
    scaleX = -1
  elseif self.direction == "right" then
    scaleX = 1
  end
  love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width/2, self.animation.height/2)
end
