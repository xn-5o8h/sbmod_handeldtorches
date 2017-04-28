require "/scripts/handheldtorchsutil.lua"

handheldtorchOldInit = init
function init()
  handheldtorchOldInit()
  toggle(true)
--  self.vol = config.getParameter("soundEffectRangeMultiplier")
end

handheldtorchOldUpdate = update
function update()
  handheldtorchOldUpdate()
  activeItem.setFacingDirection(mcontroller.movingDirection())
--  activeItem.setArmAngle(self.aimAngle) --kinda messy, would need to keep the flame vertical but imlazy.jpg

  --torch dying in water
  if mcontroller.liquidPercentage() >= 0.7 then
    if not self.wasInLiquid then
      self.wasInLiquid = true
      toggle(false)
    end
  else
    if self.wasInLiquid then
      self.wasInLiquid = false
      toggle(true)
    end
  end
end

function toggle(a) --heheh bytes are scarce heheh
  local s = ""
  if a then
    s = "on"
    animator.playSound("soundEffect", -1)
--    animator.setSoundVolume("soundEffect", self.vol) --not using that correctly
  else
    s = "off"
    animator.stopAllSounds("soundEffect")
  end
  animator.playSound(s)
  animator.setAnimationState("light", s)
  animator.setLightActive("lightSpread", a)
end