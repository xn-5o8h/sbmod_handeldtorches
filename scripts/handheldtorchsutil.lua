function TruncateDecimalsDisgustingly(n) --this is the only way I found, floor always return 1 decimal??
  local s = tostring(n)
  local t = string.find(s, ".", 1, true)
  if not t then return n else return tonumber(string.sub(s, 1, t - 1)) end
end

function rgbToHex(rgb) --https://gist.github.com/marceloCodget/3862929
  local hexadecimal = ""

  for key, value in pairs(rgb) do
    local hex = ''

    while(value > 0)do
      local index = math.fmod(value, 16) + 1
      value = math.floor(value / 16)
      hex = string.sub('0123456789ABCDEF', index, index) .. hex     
    end

    if(string.len(hex) == 0)then
      hex = '00'
    elseif(string.len(hex) == 1)then
      hex = '0' .. hex
    end

    hexadecimal = hexadecimal .. hex
  end

  return hexadecimal
end