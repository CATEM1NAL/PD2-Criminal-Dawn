local upgrades = { skills = {}, perks = {}, stats = {}, deployable = {} }
local loc = managers.localization
local UpgradeStr, SkillHeader, PermaHeader
local MenuTitle, MenuText, MenuButtons

local function PermaUpgrade(upg_name, count)
  SkillHeader = true
  if upg_name == "permaskills" or upg_name == "permaperks" then
    local PermaType = upg_name:sub(6)

    if not PermaHeader and PermaType == "skills" then
      table.insert(upgrades[PermaType], string.upper("Perma-skills:"))
      PermaHeader = true
    end

    for i = 1, Global.CrimDawn.data.x[upg_name] do
      UpgradeStr = "- " .. string.upper(loc:text("cd_perma" .. PermaType .. i .. "_name")) ..": "
        .. loc:text("cd_perma" .. PermaType .. i .. "_desc")
      table.insert(upgrades[PermaType], UpgradeStr)
    end

  else -- Directly adding upgrade
    if not PermaHeader then
      table.insert(upgrades.skills, string.upper("Perma-skills:"))
      PermaHeader = true
    end

    UpgradeStr = "- " .. string.upper(loc:text("cd_" .. upg_name .. count .. "_name")) ..": "
      .. loc:text("cd_" .. upg_name .. count .. "_desc")
    table.insert(upgrades.skills, UpgradeStr)
  end
end

if Global.CrimDawn.data.x.permaskills > 0 then PermaUpgrade("permaskills") end
if Global.CrimDawn.data.x.lives > 0 then PermaUpgrade("player_drill_speed_multiplier", Global.CrimDawn.data.x.lives) end
if Global.CrimDawn.data.x.drill > 0 then PermaUpgrade("player_additional_lives_", Global.CrimDawn.data.x.drill) end

if Global.CrimDawn.data.x.permaperks > 0 then
  table.insert(upgrades.perks, string.upper("Perma-perks:"))
  PermaUpgrade("permaperks")
  table.insert(upgrades.perks, string.upper("\nRandom Perks:"))
end

if SkillHeader then table.insert(upgrades.skills, string.upper("\nRandom Skills:")) end

for _, upgrade in ipairs(Global.CrimDawn.data.upgrades) do
  local tableName, upgradeName = upgrade:match("([^%-]+)%-(.+)")

  local currentUpgrade = Global.CrimDawn.tables.upgrades[tableName][upgradeName]
  UpgradeStr = "- " .. string.upper(loc:text("cd_" .. upgradeName .. "_name")) ..": "
            .. loc:text("cd_" .. upgradeName .. "_desc")

  table.insert(upgrades[tableName], UpgradeStr)
end

local function UpgradeMenu()
  return QuickMenu:new(
    MenuTitle,
    MenuText,
    MenuButtons
  )
end

-- I was having so much trouble getting these menus to work correctly.
-- There's probably a better way of doing this, idk what it is though
function CrimDawn.BuildUpgradeMenus()
  local AllMenuButtons = {
    [1] = { text = loc:text("crimdawn_upgrades_button_skills"),
            callback = CrimDawn.DisplaySkills },
    [2] = { text = loc:text("crimdawn_upgrades_button_perks"),
            callback = CrimDawn_DisplayPerks },
    [3] = { text = loc:text("crimdawn_upgrades_button_stats"),
            callback = CrimDawn_DisplayStats },
    [4] = { text = loc:text("crimdawn_upgrades_button_deploy"),
            callback = CrimDawn_DisplayDeploy },
    [5] = { text = loc:text("menu_back"),
            is_cancel_button = true }
  }

  MenuTitle = loc:text("crimdawn_upgrades_title_skills")
  if next(upgrades.skills) then
    MenuText = table.concat(upgrades.skills, "\n")
    MenuButtons = deep_clone(AllMenuButtons)
    table.remove(MenuButtons, 1)
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.SkillsMenu = UpgradeMenu()

  MenuTitle = loc:text("crimdawn_upgrades_title_perks")
  if next(upgrades.perks) then
    MenuText = table.concat(upgrades.perks, "\n")
    MenuButtons = deep_clone(AllMenuButtons)
    table.remove(MenuButtons, 2)
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.PerksMenu = UpgradeMenu()

  MenuTitle = loc:text("crimdawn_upgrades_title_stats")
  if next(upgrades.stats) then
    MenuText = table.concat(upgrades.stats, "\n")
    MenuButtons = deep_clone(AllMenuButtons)
    table.remove(MenuButtons, 3)
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.StatsMenu = UpgradeMenu()

  MenuTitle = loc:text("crimdawn_upgrades_title_deploy")
  if next(upgrades.deployable) then
    MenuText = table.concat(upgrades.deployable, "\n")
    MenuButtons = deep_clone(AllMenuButtons)
    table.remove(MenuButtons, 4)
  else MenuText = loc:text("crimdawn_upgrades_none") end
  CrimDawn.DeployMenu = UpgradeMenu()
end

function CrimDawn.DisplaySkills()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.SkillsMenu:Show()
end

function CrimDawn_DisplayPerks()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.PerksMenu:Show()
end

function CrimDawn_DisplayStats()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.StatsMenu:Show()
end

function CrimDawn_DisplayDeploy()
  CrimDawn.BuildUpgradeMenus()
  CrimDawn.DeployMenu:Show()
end

CrimDawn.DisplaySkills()