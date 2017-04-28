require "/scripts/handheldtorchsutil.lua"

--I tried to make this as generic as possible, but you might have to edit some stuff out (mainly self.image??)

function init()
  self.placeObject = config.getParameter("placeObject")
  self.beamLength = tonumber(config.getParameter("beamLength"))
--  self.vol = config.getParameter("soundEffectRangeMultiplier")

  self.config = root.itemConfig(self.placeObject)
  -- this probably won't work with all items but it works for mine???
  self.image = self.config.directory .. self.config.config.orientations[1].image:gsub("<color>", "default"):gsub("<frame>", 1)
  self.nonemptyregnion = root.nonEmptyRegion(self.image)
  activeItem.setScriptedAnimationParameter("image", self.image)
end

function activate()
  if self.validPlacement and world.placeObject(self.placeObject, self.aim, self.facingDirection) then item.consume(1) end
end

function update() 
  --aiming etc
  self.aim = activeItem.ownerAimPosition()
  self.aimAngle, self.facingDirection = activeItem.aimAngleAndDirection(0, self.aim)
  self.truncatedAim = {TruncateDecimalsDisgustingly(self.aim[1]) + 0.5, TruncateDecimalsDisgustingly(self.aim[2]) + 0.5}

  local colli = { --probably no need for the -0.5 or could be done better but ahwellthisworks.gif
    0 + self.truncatedAim[1] - 0.5,
    0 + self.truncatedAim[2] - 0.5,
    (self.nonemptyregnion[3] / 8) + self.truncatedAim[1] - 0.5,
    (self.nonemptyregnion[4] / 8) + self.truncatedAim[2] - 0.5
  }

  --TODO: add check for background anchors??
  self.validPlacement = not (world.magnitude(self.aim, mcontroller.position()) >= self.beamLength) and not (world.rectTileCollision(colli, {"Platform", "Null", "Block", "Dynamic"}) or world.tileIsOccupied(self.truncatedAim))
  activeItem.setScriptedAnimationParameter("validPlacement", self.validPlacement)

  --MATHS!!! We get the distance between us and the cursor, divide that by the beamLength, turn that negative for later reverse, multiply by 255 to get padded(?) value, add 255 to reverse
  --TODO: add flicker
  local transparency = math.max(25, TruncateDecimalsDisgustingly((((world.magnitude(self.aim, mcontroller.position()) / self.beamLength) * -1 ) * 255) + 255))
  activeItem.setScriptedAnimationParameter("transparency", transparency)
end