require "/scripts/vec2.lua"
require "/scripts/util.lua"
require "/scripts/handheldtorchsutil.lua"

function init()
  self.aim = activeItemAnimation.ownerAimPosition()
  self.image = animationConfig.animationParameter("image")

  self.borderColor = rgbToHex(config.getParameter("borderColor", {200, 100, 100}))
  self.validPlacementColor = config.getParameter("validPlacementColor", {150, 255, 150, 128})
  self.invalidPlacementColor = config.getParameter("invalidPlacementColor", {255, 150, 150, 96})
end

function update()
  localAnimator.clearDrawables()

  self.aim = activeItemAnimation.ownerAimPosition()
  self.transparency = rgbToHex({animationConfig.animationParameter("transparency")})
  self.processing = string.format("?setcolor=FFFFFF??border=1;%s?multiply=FFFFFF%s", self.borderColor, self.transparency)

  showPreview()
end

function showPreview()
  local highlightColor = animationConfig.animationParameter("validPlacement") == true and self.validPlacementColor or self.invalidPlacementColor

  localAnimator.addDrawable({
    image = self.image .. self.processing,
    position = {TruncateDecimalsDisgustingly(self.aim[1]) + 0.5, TruncateDecimalsDisgustingly(self.aim[2]) + 1},
    color = highlightColor
    }, "player-1")
end