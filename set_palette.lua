---@diagnostic disable: undefined-global

local path = "D:/Program Files/Aseprite/data/palettes/playpal.gpl"

local palettes = {
  PLAYPAL = "playpal",
  AAP64 = "AAP-64"
}

local palettePaths = {
  [palettes.PLAYPAL] = "D:/Program Files/Aseprite/data/palettes/playpal.gpl",
  [palettes.AAP64] = "D:/Program Files/Aseprite/data/extensions/adigunpolack-palettes/aap-64.gpl"
}

local optStrings = {
  active = "Active Sprite",
  all = "All Open Sprites"
}

------------------------------------------------------------------------------------------------------------------------
-- dialog options

local dlg = Dialog("Set Palette Options")
local apply = false
local selectedPalette = palettes.PLAYPAL -- default

dlg:combobox{
  id = "target",
  label = "Target",
  options = {
    optStrings.active,
    optStrings.all
  }
}

dlg:combobox{
  id = "palette",
  label = "Palette",
  options = {
    palettes.PLAYPAL,
    palettes.AAP64
  }
}

dlg:button{
  text = "Apply",
  onclick = function ()
    apply = true
    dlg:close()
  end
}

dlg:button{
  text = "Cancel",
  onclick = function ()
    dlg:close()
  end
}

dlg:show()

------------------------------------------------------------------------------------------------------------------------
-- process data

local function setAndConvToPalette(sprite)
  app.sprite = sprite

  app.transaction(function()
    app.command.ChangePixelFormat{
      format = "rgb"
    }

    local palette = Palette{ fromFile = palettePaths[selectedPalette] }
    sprite:setPalette(palette)

    app.command.ChangePixelFormat{
      format = "indexed"
    }
  end)
end

local function processData()
  if not apply then
    return
  end

  local dialogData = dlg.data
  local sprites

  selectedPalette = dialogData.palette

  if (dialogData.target == optStrings.all) then
    sprites = app.sprites
  else
    sprites = { app.activeSprite }
  end

  if #sprites == 0 then
    app.alert("No sprite file(s) open")
    return
  end

  for _, s in ipairs(sprites) do
    setAndConvToPalette(s)
  end

  app.refresh()
end

processData()