if arg[2] == "debug" then
    require("lldebugger").start()
end
local push = require "push"

require("tesound")
require("lume")
require("input")
require("musicman")
require("dialogue")
require("player")
require("collectable")
require("GUI")
local STI = require("sti")
local bump = require("bump")
love.graphics.setDefaultFilter("nearest", "nearest")
button_height = 20
button_width = 80
mahou_y = 0



local going_up = true
local going_down = false
local width, height = 400, 240 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth-200, windowHeight-200
push:setupScreen(width, height, windowWidth, windowHeight, {fullscreen = false, resizable = true, canvas = false, pixelperfect = true, stretched = false})
love.graphics.setDefaultFilter("nearest", "nearest") --oh hi i remember u
function love.resize(w, h) --KEEPS CENTERED
    push:resize(w, h)
end

--To-Do! Text Wrapping for dialogue, fix player physics
local function sign(number)
  return number > 0 and 1 or (number == 0 and 0 or -1)
end
local function button(text, fn) 

  return {
    text = text,
    fn = fn,
    now = false,
    last = false
    }
end

local buttons = {}
local cTime = 0
local choiced = false

function love.load()
  GUI:load()
  map_N1 = STI("map/Night1.lua", {"box2d"})
  World = love.physics.newWorld(0,0)
  map_N1:box2d_init(World)
  map_N1.layers.solid.visible = false
  map_bg = love.graphics.newImage("graphics/bgs/bg_jump.png")
  --remnants of the old sound system..... thank you so very much TEsound you are a lifesaver...
  --sounds = {}
  --sounds.sfx_jump = love.audio.newSource("audio/sf_jump.ogg", "static")
  --sounds.sfx_jump:setLooping(false)
  --sounds.mus_intro = love.audio.newSource("audio/mus_ForWeAreOnlyMortal.mp3", "stream")
  --sounds.mus_intro:setLooping(true)
  --sounds.mus_mainmenu = love.audio.newSource("audio/mus_HELLYEAHBABYTHISPARTYISBUMPIN.mp3", "stream")
  --sounds.mus_mainmenu:setLooping(true)
  songs2play = {menu={hasrun = false}, human={hasrun = false}}
  current_dialogue = 1
  touches = love.touch.getTouches()
  font2 = love.graphics.newFont("BoldPixels.ttf", 20)
  font = love.graphics.newFont("BoldPixels.ttf", 13)
  --Important Things
  CurrentSceneType = "vnovel"
  CurrentScene = "Intro"
  Player:load()
  --SceneTypes are menu, mini, and vnovel
  --Intro is the first Scene.
  --Menu Buttons
  --menu, demo for demoscreen menu
  offset_dialogue_choice = 0 --For offsetting dialogue when a choice is onscreen.

  table.insert(buttons, button(
      "Start", 
      function()
        love.graphics.setColor(1,1,1,1)
        CurrentScene = "demo"
      end))
  table.insert(buttons, button(
      "Load Game",
      function()
        love.graphics.setColor(1,1,1,1)
        love.graphics.print("Load", 20, 20)
      end))
  table.insert(buttons, button(
      "Settings", 
      function()
        love.graphics.setColor(1,1,1,1)
        love.graphics.print("Settings", 20, 20)
      end))
  table.insert(buttons, button(
      "Quit", 
      function()
        love.event.quit(0)
      end))
  --menu, mini, vnovel
  x = 10
  y = height/2
  --Loading Images
  ImageMainMenuBG = love.graphics.newImage("graphics/main-menu.png")
  ImageMainMenuMahouShoujo = love.graphics.newImage("graphics/mahou-shoujo.png")
  ImageMainMenuSakura = love.graphics.newImage("graphics/sakura.png")
  ImageMainMenuSan = love.graphics.newImage("graphics/san.png")
  ImageMainMenuSakuraChibi = love.graphics.newImage("graphics/sakurasan.png")
  ImageMainMenuHaruko = love.graphics.newImage("graphics/harukochan.png")
  
  ImageCityG = love.graphics.newImage("graphics/bgs/cityground.png")
  ImageCityS = love.graphics.newImage("graphics/bgs/citysky.png")
  ImageClassroom = love.graphics.newImage("graphics/bgs/classroom.png")
  ImageNight = love.graphics.newImage("graphics/bgs/nightsky.png")
  ImagePark = love.graphics.newImage("graphics/bgs/park.png")
  ImageRoom = love.graphics.newImage("graphics/bgs/room.png")
  ImageB = love.graphics.newImage("graphics/backdrop.png")
  --Loading Collectables
  Coin.new(143, 48)
  Coin.new(159, 48)
  
end
--Contact callbacks for jump and gravity detection!
function beginContact(a, b, collision)
  play_land()
  if Coin.beginContact(a, b, collision) then
    return
  end
  Player:beginContact(a, b, collision)
end
function endContact(a, b, collision)
  Player:endContact(a, b, collision)
end
-- end callbacks!
function love.update(dt)
  if CurrentSceneType == "menu" then
    if songs2play.menu.hasrun == false then
      play_menu()
    end
    if mahou_y < 6 and going_up then
      mahou_y = mahou_y + 0.1
    elseif mahou_y == 6 or mahou_y > 6 then
      going_up = false
      going_down = true 
    end
    if going_down == true then
      going_up = false
      if mahou_y < -6 or mahou_y == -6 then
        going_down = false
        going_up = true
      else 
        mahou_y = mahou_y - 0.1
      end
    end
  end
  if CurrentScene == "demo" then
    --testingcontrols
    if love.keyboard.isPressed("a") then
      CurrentSceneType = "vnovel"
      CurrentScene = "Intro"
      TEsound.stop("mus", false)
    end
    if love.keyboard.isPressed("b") then
      CurrentSceneType = "mini"
      CurrentScene = ""
      TEsound.stop("mus", false)
    end
    
    if gamepadpressed["a"] then
      CurrentSceneType = "vnovel"
      CurrentScene = "Intro"
      TEsound.stop("mus", false)
    end
    if gamepadpressed["b"] then 
      CurrentSceneType = "mini"
      CurrentScene = ""
      TEsound.stop("mus", false)
    end
    gamepadpressed = {}
  end
  if CurrentSceneType == "mini" then
    GUI:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    World:update(dt)
    
    local delta = getDirectDelta()
    local tx = x + 300 * delta.x * dt
    local ty = y + 300 *delta.y *dt
    if tx < 380 and tx > 0 then
      x = tx
    end
    if ty < 220 and ty > 0 then 
      y = ty
    end
    
  end
  if CurrentSceneType == "vnovel" then
    --DIALOGYE HANDLER (hell this took me so frigging long to code. kill me now. even with a tutorial it was HARD)
    _table = "dialogue_"..CurrentScene
    local joystick = love.joystick.getJoysticks()
    if #joystick > 0 then
      joystick = joystick[1]
      if gamepadpressed["a"] and #_G[_table][current_dialogue].choices == 0 then
        if playnoise == true then
          play_next()
        end
        if choiced == true then 
          current_dialogue = current_dialogue + 2
          choiced = false
        else
          current_dialogue = current_dialogue + 1
        end
        if current_dialogue > #_G[_table] then
          current_dialogue = 1 --To be removed later and have it move to the next scene.
        end
      end
      if gamepadpressed["x"] and #_G[_table][current_dialogue].choices >= 1 then 
        play_confirm()
        if #_G[_table][current_dialogue].choices >= 2 then
          choiced = true
        end
        current_dialogue = _G[_table][current_dialogue].choices[1].next
      elseif gamepadpressed["b"] and #_G[_table][current_dialogue].choices >= 2 then 
        play_confirm()
        current_dialogue = _G[_table][current_dialogue].choices[2].next
      end
    end
    --testingcontrols
    if love.keyboard.isPressed("space") and #_G[_table][current_dialogue].choices == 0 then
      if playnoise == true then
        play_next()
      end
      if choiced == true then 
        current_dialogue = current_dialogue + 2
        choiced = false
      else
        current_dialogue = current_dialogue + 1
      end
      if current_dialogue > #_G[_table] then
        current_dialogue = 1 --To be removed later and have it move to the next scene.
      end
    end
    if love.keyboard.isPressed("a") and #_G[_table][current_dialogue].choices >= 1 then 
      play_confirm()
      if  #_G[_table][current_dialogue].choices >= 2 then
        choiced = true
        print(choiced)
      end
      current_dialogue = _G[_table][current_dialogue].choices[1].next
    elseif love.keyboard.isPressed("d") and #_G[_table][current_dialogue].choices >= 2 then 
      play_confirm()
      current_dialogue = _G[_table][current_dialogue].choices[2].next
    end
    --end controls
    love.keyboard.resetKey()
    
  end
  gamepadpressed = {}
  TEsound.cleanup()
end
function love.draw()
  push:apply("start")
  love.graphics.setColor(1, 1, 1, 1)
  if CurrentSceneType == "mini" then
    love.graphics.draw(map_bg)
    --love.graphics.rectangle("fill", x, y, 20, 20) original rectangle do not steal
    map_N1:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2,2)
    Player:draw()
    Coin.drawAll()
    love.graphics.pop()
    GUI:draw()
  end
  if CurrentSceneType == "menu" then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(ImageMainMenuBG, 0, 0)
    love.graphics.draw(ImageMainMenuSakuraChibi,0, 0)
    love.graphics.draw(ImageMainMenuMahouShoujo, 0, mahou_y)
    love.graphics.draw(ImageMainMenuSan, 0, mahou_y)
    love.graphics.draw(ImageMainMenuSakura, 0, mahou_y)
    love.graphics.draw(ImageMainMenuHaruko, 0, 0)   
  end
  if CurrentSceneType == "menu" and CurrentScene == "" then
    local margin = 5 --button stuff
    local toHeight = (margin + button_height)*#buttons
    local cursory = 0
    for i, button in ipairs(buttons) do
      button.last = button.now
      local color = {0.7, 0.1, 0.3, 0.7}
      local bx = 400/6 - button_width/2 + cursory 
      local by = 240-(toHeight/4) 
      local touches = love.touch.getTouches()
      if touches[1] ~= nil then
        --local mx, my = love.touch.getPosition(touches[1])
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + button_height
        if hot then
          love.graphics.print("hot", 10, 10)
          button.fn() 
          love.graphics.setColor(1,1,1,1)
          love.graphics.print("in!", 30, 20)
          color = {.9, .2, .4, .8}
        end
      end
      --button.now = love.touch.getTouches()
      button.now = love.mouse.isDown(1)      
      love.graphics.setColor(unpack(color))
      love.graphics.rectangle("fill", bx, by, button_width, button_height)
      love.graphics.setColor(0.3,0.1,0.3, 1.0)
      love.graphics.print(
        button.text,
        font, 
        (bx+10),
        by
      )
      cursory = cursory + button_width+margin 
    end
  end
  if CurrentSceneType == "menu" and CurrentScene == "demo" then
    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Press A for VNovel!", width/4, height/4)
    love.graphics.print("Press B for Platformer!", width/4, height/3)
    love.graphics.setColor(1,1,1,1)
  end
  if CurrentSceneType == "vnovel" then
    love.graphics.setColor(1,1,1,1)
    if (_G[_table][current_dialogue].bg ~= nil) then
      bgtodraw = _G[_table][current_dialogue].bg
    end
    if bgtodraw ~= nil and bgtodraw ~= "none" then
      love.graphics.draw(bgtodraw,0,0)
    end
    if (_G[_table][current_dialogue].frame ~= nil) then
      frame = _G[_table][current_dialogue].frame
    end
    if frame ~= nil and frame ~= "none" then
      love.graphics.draw(frame,0,0)
    end
    if (_G[_table][current_dialogue].por ~= nil) then
      portrait = _G[_table][current_dialogue].por
    end
    if portrait ~= nil and portrait ~= "none" then
      love.graphics.draw(portrait,width/2-66.5,240-228)
    end
    if (_G[_table][current_dialogue].cmd ~= nil) then
      _G[_table][current_dialogue].cmd()
    end
    if (_G[_table][current_dialogue].overlay ~= nil) then
      overlay = _G[_table][current_dialogue].overlay
    end
    if overlay ~= nil and overlay ~= "none" then
      love.graphics.draw(overlay,0,0)
    end
    local yoffset = height/3
    for i, choice in ipairs(_G[_table][current_dialogue].choices) do 
      local op = nil
      if i == 1 then
        op = " [X]"
      else
        op = " [B]"
      end
      love.graphics.setFont(font2)
      love.graphics.setColor(0,0,0,1)
      local opwid = font2:getWidth(op.. ". ".. choice.text) + 10
      love.graphics.rectangle("fill", width/2.5-(opwid/2), yoffset, opwid, font2:getHeight(op.. ". ".. choice.text) + 4)
      love.graphics.setColor(1,1,1,1)
      love.graphics.rectangle("line", width/2.5-1-(opwid/2), yoffset-1, opwid, font2:getHeight(op.. ". ".. choice.text) + 4)
      love.graphics.print(op..". ".. choice.text, width/2.5-(opwid/2), yoffset)
      yoffset = yoffset + font:getWidth(i.. ". ".. choice.text) + 10
    end
    if _G[_table][current_dialogue].choices == true then
      offset_dialogue_choice = 100
    else
      offset_dialogue_choice = 0
    end
    local dialogue_box_width = font:getWidth(_G[_table][current_dialogue].text)+50
    local dialogue_box_y = 170+offset_dialogue_choice
    love.graphics.setFont(font)
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", 45, dialogue_box_y, dialogue_box_width, 60)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", 44,dialogue_box_y-1, dialogue_box_width+1, 61)
    love.graphics.print(_G[_table][current_dialogue].text, 55, dialogue_box_y+(font:getHeight(_G[_table][current_dialogue].text)/2))
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", 5, 155+offset_dialogue_choice, font:getWidth(_G[_table][current_dialogue].name)+20, 20)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", 4,154+offset_dialogue_choice, font:getWidth(_G[_table][current_dialogue].name)+21, 21)
    love.graphics.print(_G[_table][current_dialogue].name, 9, 157+offset_dialogue_choice)
  end
  push:apply("end")
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end