import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local playerSprite = nil

local playerSpeed = 4

local playTimer = nil
local playTime = 30 * 1000

local coinSprite = nil
local score = 0

local function resetTimer()
  playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function moveCoin()
  local randX = math.random(40, 360)
  local randY = math.random(40, 200)
  coinSprite:moveTo(randX, randY)
end

local function initialize()
  math.randomseed(playdate.getSecondsSinceEpoch())
  playdate.startAccelerometer()

  -- Initialize player sprite

  local playerImage = gfx.image.new("Images/player")
  assert(playerImage)

  playerSprite = gfx.sprite.new(playerImage)
  playerSprite:moveTo(200, 120)
  playerSprite:setCollideRect(0, 0, playerSprite:getSize())
  playerSprite:add()

  -- Initialize coin sprite

  local coinImage = gfx.image.new("Images/coin")
  assert(coinImage)

  coinSprite = gfx.sprite.new(coinImage)
  moveCoin()
  coinSprite:setCollideRect(0, 0, coinSprite:getSize())
  coinSprite:add()

  local backgroundImage = gfx.image.new("Images/background2")
  assert(backgroundImage)

  gfx.sprite.setBackgroundDrawingCallback(
    function(x, y, width, height)
      gfx.setClipRect(x, y, width, height)
      backgroundImage:draw(0, 0)
      gfx.clearClipRect()
    end
  )

  resetTimer()
end

initialize()

function playdate.update()
  local x, y, z = playdate.readAccelerometer()

  if playTimer.value == 0 then
    if playdate.buttonJustPressed(playdate.kButtonA) then
      resetTimer()
      moveCoin()
      score = 0
    end
  else
    playerSprite:moveBy(x * playerSpeed, y * playerSpeed)

    if playdate.buttonIsPressed(playdate.kButtonUp) then
      playerSprite:moveBy(0, -playerSpeed)
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
      playerSprite:moveBy(playerSpeed, 0)
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
      playerSprite:moveBy(0, playerSpeed)
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
      playerSprite:moveBy(-playerSpeed, 0)
    end

    local collisions = coinSprite:overlappingSprites()
    -- #collisions is sugar for getting the length of a list, in this case collisions
    if #collisions >= 1 then
      moveCoin()
      score += 1
    end
  end

  playdate.timer.updateTimers()
  gfx.sprite.update()

  gfx.drawText("Time: *" .. math.ceil(playTimer.value/1000) .. "*", 8, 5)
  gfx.drawText("Score: *" .. score .. "*", 320, 5)
  gfx.drawText("Accelerometer: *" .. x .. "x, " .. y .. "y*", 8, 20)
end