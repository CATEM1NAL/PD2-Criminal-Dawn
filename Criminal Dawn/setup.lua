if CrimDawn then return end
local FileIdent = "setup"
CrimDawn = {}

function CrimDawn:Init()
  self.ModPath = ModPath
  self.SavePath = SavePath

  self.SaveFile = self.SavePath .. "crimdawn_save.txt"
  self.SettingsFile = self.SavePath .. "crimdawn_settings.txt"

  self.SettingsData = io.load_as_json(CrimDawn.SettingsFile)
  if not self.SettingsData then self.SettingsData = {} end

  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/settings.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist1.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist2.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist3.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist4.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist5.json", CrimDawn, CrimDawn.SettingsData)

  self.state = { ponr = false,
                 heist_started = false,
                 maskup_time = 0,
                 cap_reached = false,
                 upg_queue = {} }

  function self.Log(FileIdent, LogMessage)
    log("[DAWN>" .. FileIdent .. "] " .. LogMessage)
  end -- Yes, this WILL crash without a FileIdent. This is intentional, otherwise I'd get lazy

  function self.ScoreNeeded()
    local n = math.ceil((math.sqrt(1 + 8 * (Global.CrimDawn.data.game.score) - 1) / 2))
    return (n * (n + 1) / 2) - math.floor(Global.CrimDawn.data.game.score)
  end

  function self.DiffScale(ignore_settings)
    local MaxDiff = ignore_settings and Global.CrimDawn.data.game.run_length or Global.CrimDawn.data.game.max_diff
    local DiffItemCount = Global.CrimDawn.data.x.bots +
                          Global.CrimDawn.data.x.permaskills +
                          Global.CrimDawn.data.x.permaperks +
                          Global.CrimDawn.data.x.skills +
                          Global.CrimDawn.data.x.perks +
                          Global.CrimDawn.data.x.lives

    return math.max(math.floor((DiffItemCount - 1) / (Global.CrimDawn.data.game.max_diff_items / MaxDiff)), 0)
  end

  function self.ScoreCap(points)
    if not Global.CrimDawn.data.game.score_cap then return true end

    local NewScore = Global.CrimDawn.data.game.score + points
    if NewScore >= Global.CrimDawn.data.game.score_cap then CrimDawnClient:PollTimeUpgrades() end
    -- Might seem redundant, but we only want to check if upgrades were received IF we are over the score cap before
    -- we continue. Otherwise we'd be polling the client EVERY SINGLE TIME we get a point, which feels very wasteful
    if NewScore >= Global.CrimDawn.data.game.score_cap then
      Global.CrimDawn.data.game.score = Global.CrimDawn.data.game.score_cap
      CrimDawn.state.cap_reached = true

      if Utils:IsInGameState() then
        CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score_cap .. " (score cap reached)."
                         .. "\nTime Bonus required to increase cap.")
      end return true
    else Global.CrimDawn.data.game.score = NewScore return false end
  end

  function self.ChatNotify(message)
    managers.chat:_receive_message(
      ChatManager.GAME,
      "CRIMINAL DAWN",
      message,
      Global.CrimDawn.archicolours.orange
    )
  end

  function self:Reset()
    Global.CrimDawn.data = {
      upgrades = {},
      unlocks = {},
      x = {
        bots = 0, time_upgrades = 0,
        skills = 0, permaskills = 0, perks = 0, permaperks = 0, stats = 0,
        drill = 0, lives = 0, saws = 0,
        coins = 0
      },
      game = {
        seed = false, max_diff = false, max_diff_items = false, timer_strength = false, run_length = 0,
        score = 0, f_score = 0, score_cap = false, ponr = false, deathlink = os.time(),
        run = 1, heists_won = 0, heists = {},
      },
      chat = { message = "", timestamp = 0 },
      safehouse = {}
    }
  end

  if Global.CrimDawn then Global.CrimDawn.data.chat = { message = "", timestamp = 0 } end

  function self:WriteSave(FileIdent, SaveReason)
    if Global.CrimDawn.data.game.seed ~= CrimDawnClient.data.seed then return end
    io.save_as_json(Global.CrimDawn.data, self.SaveFile)
    self.Log(FileIdent, "Saved " .. self.SaveFile .. " (" .. SaveReason .. ")")
  end -- Yes, this WILL crash without a FileIdent or SaveReason. This is intentional, otherwise I'd get lazy

  dofile(self.ModPath .. "lua/archipelago/heist_selector.lua")
  dofile(self.ModPath .. "lua/archipelago/unlock_generator.lua")
  dofile(self.ModPath .. "lua/archipelago/client_bridge.lua")
end

CrimDawn:Init()

local function SetColours()
  local player1 = Global.CrimDawn.archicolours.blue
  local player2 = Global.CrimDawn.archicolours.pink
  local player3 = Global.CrimDawn.archicolours.red
  local player4 = Global.CrimDawn.archicolours.yellow
  local team_ai = Global.CrimDawn.archicolours.orange

  tweak_data.peer_vector_colors[1] = player1
  tweak_data.chat_colors[1] = player1
  tweak_data.preplanning_peer_colors[1] = player1

  tweak_data.peer_vector_colors[2] = player2
  tweak_data.chat_colors[2] = player2
  tweak_data.preplanning_peer_colors[2] = player2

  tweak_data.peer_vector_colors[3] = player3
  tweak_data.chat_colors[3] = player3
  tweak_data.preplanning_peer_colors[3] = player3

  tweak_data.peer_vector_colors[4] = player4
  tweak_data.chat_colors[4] = player4
  tweak_data.preplanning_peer_colors[4] = player4

  tweak_data.peer_vector_colors[5] = team_ai
  tweak_data.chat_colors[5] = team_ai

  tweak_data.system_chat_color = Global.CrimDawn.archicolours.orange

  tweak_data.screen_colors.resource = Global.CrimDawn.archicolours.red
  tweak_data.screen_colors.button_stage_2 = Global.CrimDawn.archicolours.orange
  tweak_data.screen_colors.button_stage_3 = Global.CrimDawn.archicolours.red
  tweak_data.screen_colors.risk = Global.CrimDawn.archicolours.yellow
  tweak_data.screen_colors.ghost_color = Global.CrimDawn.archicolours.red
end

if Global.CrimDawn then SetColours() end

-- Add save data to global table
if Global.CrimDawn then return end
Global.CrimDawn = {
    tables = {},
    archicolours = {
      green = Color(255, 117, 194, 117) / 255,
      blue = Color(255, 118, 126, 189) / 255,
      pink = Color(255, 202, 148, 194) / 255,
      red = Color(255, 201, 118, 130) / 255,
      orange = Color(255, 217, 160, 125) / 255,
      yellow = Color(255, 238, 227, 145) / 255,
    }
  }
SetColours()

function Global.CrimDawn:Init()
  CrimDawn.Log(FileIdent, "Attempting to load save file...")
  self.data = io.load_as_json(CrimDawn.SaveFile)
  if not self.data then CrimDawn:Reset() end

  self.next_point = 100 + (self.data.game.score - self.data.game.score % 100)

  dofile(CrimDawn.ModPath .. "lua/tables/heists.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/upgrades.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/weapons.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/etc.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/dlc.lua")
end

-- Logo replacements
DB:create_entry(Idstring("texture"), Idstring("guis/textures/menu_title_screen"), CrimDawn.ModPath .. "assets/logo/title.texture")
DB:create_entry(Idstring("texture"), Idstring("guis/textures/game_small_logo"), CrimDawn.ModPath .. "assets/logo/small.texture")
DB:create_entry(Idstring("texture"), Idstring("units/menu/menu_scene/menu_cylinder_logo"), CrimDawn.ModPath .. "assets/logo/menu.texture")

-- Safehouse textures
DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse0"), CrimDawn.ModPath .. "assets/safehouse/tier0.texture")
DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse1"), CrimDawn.ModPath .. "assets/safehouse/tier1.texture")
DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse2"), CrimDawn.ModPath .. "assets/safehouse/tier2.texture")
DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse3"), CrimDawn.ModPath .. "assets/safehouse/tier3.texture")
DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse4"), CrimDawn.ModPath .. "assets/safehouse/tier4.texture")
DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse5"), CrimDawn.ModPath .. "assets/safehouse/tier5.texture")
DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse6"), CrimDawn.ModPath .. "assets/safehouse/tier6.texture")

-- Background replacements
DB:create_entry(Idstring("texture"), Idstring("guis/textures/loading/loading-bg"), CrimDawn.ModPath .. "assets/bg/loading.texture")
DB:create_entry(Idstring("texture"), Idstring("guis/textures/pd2/menu_backdrop/bd_baselayer"), CrimDawn.ModPath .. "assets/bg/briefing.texture")

Global.CrimDawn:Init()