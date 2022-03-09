import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local playerSprite = nil

local function initialize()
  local playerImage = gfx.image.new("Images/player")
  playerSprite = gfx.sprite.new(playerImage)
  playerSprite:moveTo(200, 120)
  playerSprite:add()
end

initialize()

function playdate.update()
  gfx.sprite.update()
end