if CrimDawn then return end
local FileIdent = "setup"
CrimDawn = {}

function CrimDawn:Init()
  self.ModPath = ModPath
  self.SavePath = SavePath

  self.SaveFile = self.SavePath .. "crimdawn_save.txt"
  self.SettingsFile = self.SavePath .. "crimdawn_settings.txt"

  self.SettingsData = io.load_as_json(CrimDawn.SettingsFile) or {}
  if not self.SettingsData then self.SettingsData = {} end

  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/settings.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist1.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist2.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist3.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist4.json", CrimDawn, CrimDawn.SettingsData)
  MenuHelper:LoadFromJsonFile(CrimDawn.ModPath .. "menus/heist5.json", CrimDawn, CrimDawn.SettingsData)

  if not CrimDawn.SettingsData.diff_cap then CrimDawn.SettingsData.diff_cap = 4 end

  self.state = { maskup_time = false,
                 heist_started = false,
                 cap_reached = false,
                 upg_queue = {} }

  function self.Log(FileIdent, LogMessage)
    log("[DAWN>" .. FileIdent .. "] " .. LogMessage)
  end -- Yes, this WILL crash without a FileIdent. This is intentional, otherwise I'd get lazy

  function self.ScoreNeeded()
    local n = math.ceil((math.sqrt(1 + 8 * (Global.CrimDawn.data.game.score) - 1) / 2))
    return (n * (n + 1) / 2) - math.floor(Global.CrimDawn.data.game.score)
  end

  function self.MaxTimeItems()
    if Global.CrimDawn.data.game.seed then
      if Global.CrimDawn.data.game.run_length > 0 then
        return math.floor((Global.CrimDawn.data.game.run_length * 15) / (Global.CrimDawn.data.game.timer_strength / 60) - 0.5)
      else return math.floor(100 / (Global.CrimDawn.data.game.timer_strength / 60) - 0.5) end
    end
  return 121200 end -- This can be any non-0 value, I chose my birthday

  function self.DiffScale(ignore_settings)
    local RunLength = Global.CrimDawn.data.game.run_length
    if RunLength == 0 then RunLength = 6 end
    local MaxDiff = ignore_settings and Global.CrimDawn.data.game.run_length or CrimDawn.SettingsData.diff_cap
    local DiffItemCount = Global.CrimDawn.data.x.bots +
                          Global.CrimDawn.data.x.permaskills +
                          Global.CrimDawn.data.x.permaperks +
                          Global.CrimDawn.data.x.skills +
                          Global.CrimDawn.data.x.perks +
                          Global.CrimDawn.data.x.lives

    return math.max(math.floor((DiffItemCount - 1) / (Global.CrimDawn.data.game.max_diff_items / MaxDiff)), 0)
  end

  -- Lookup Tables (unimplemented)
  local DiffTables = {
    { -- Easy (End on Very Hard)
      { 2, 2, 3, 3, 3, 4 },
      { 2, 2, 3, 3, 4, 4 },
      { 2, 3, 3, 3, 4, 4 },
      { 3, 3, 3, 4, 4, 4 },
      { 3, 3, 4, 4, 4, 4 },
      { 3, 4, 4, 4, 4, 4 }
    },
    { -- Normal (End on Overkill)
      { 2, 2, 3, 3, 4, 5 },
      { 2, 3, 3, 4, 4, 5 },
      { 3, 3, 4, 4, 5, 5 },
      { 3, 4, 4, 5, 5, 5 },
      { 4, 4, 4, 5, 5, 5 },
      { 4, 4, 5, 5, 5, 5 }
    },
    { -- Hard (End on Mayhem)
      { 2, 3, 4, 4, 5, 6 },
      { 3, 4, 4, 5, 5, 6 },
      { 3, 4, 5, 5, 6, 6 },
      { 4, 4, 5, 5, 6, 6 },
      { 4, 5, 5, 6, 6, 6 },
      { 4, 5, 6, 6, 6, 6 }
    },
    { -- Overkill (End on Death Wish)
      { 2, 3, 4, 5, 6, 7 },
      { 3, 4, 4, 5, 6, 7 },
      { 3, 4, 4, 5, 6, 7 },
      { 4, 4, 5, 6, 7, 7 },
      { 4, 5, 6, 7, 7, 7 },
      { 5, 6, 7, 7, 7, 7 }
    },
    { -- Death Sentence (Death Sentence)
      { 2, 3, 4, 5, 5, 8 },
      { 3, 3, 4, 5, 6, 8 },
      { 3, 4, 5, 6, 6, 8 },
      { 4, 5, 6, 6, 6, 8 },
      { 5, 6, 6, 6, 6, 8 },
      { 6, 6, 6, 6, 6, 8 }
    }
  }

  local function CalculateDiff(offset)
    local DiffCap = CrimDawn.SettingsData.diff_cap
    local HeistNum = #Global.CrimDawn.data.game.heists - offset
    local RunLength = Global.CrimDawn.data.game.run_length
    if RunLength == 0 then RunLength = 6 end

    -- Any questions about this equation should be directed to @jordansds
    local BaseDiff = (1 + HeistNum / RunLength) * (1 + (HeistNum + CrimDawn.DiffScale()) / RunLength) * 2
    return math.max(math.min(math.floor(BaseDiff), 8) + (DiffCap - 7), 2)
  end

  function self.DiffIndex()
    if #Global.CrimDawn.data.game.heists == 1 then return CalculateDiff(0)
    else return math.min(CalculateDiff(0), CalculateDiff(1) + 1) end
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
        if Global.CrimDawn.data.x.time_upgrades >= CrimDawn.MaxTimeItems() then
          CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score_cap .. " (score cap reached).")
        else
          CrimDawn.ChatNotify(" " .. Global.CrimDawn.data.game.score_cap .. " (score cap reached)."
                           .. "\nTime Bonus required to increase cap.")
        end
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

  function self.CorrectSaveLoaded()
    local SaveSeed, SaveSlot = Global.CrimDawn.data.game.seed, Global.CrimDawn.data.game.slot
    local ClientSeed, ClientSlot = CrimDawnClient.data.seed, CrimDawnClient.data.slot
    if SaveSeed == ClientSeed and SaveSlot == ClientSlot then return true
    else CrimDawn.Log(FileIdent, "Save is invalid!") return false end
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
        seed = false, slot = false, max_diff = false, max_diff_items = false, timer_strength = false, run_length = 0,
        score = 0, f_score = 0, score_cap = false, ponr = false, deathlink = os.time(),
        run = 1, heists_won = 0, heists = {}, cash = 0, goal = false, campaign = false
      },
      chat = { message = "", timestamp = 0 },
      safehouse = {}
    }
  end

  if Global.CrimDawn then Global.CrimDawn.data.chat = { message = "", timestamp = 0 } end

  function self:WriteSave(FileIdent, SaveReason)
    if not self.CorrectSaveLoaded() then return end
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

  dofile(CrimDawn.ModPath .. "lua/managers/safehouse.lua")
end

if Global.CrimDawn then SetColours() end

-- THIS SECTION ONLY RUNS ONCE ON GAME LAUNCH --
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

function Global.CrimDawn:Init()
  CrimDawn.Log(FileIdent, "Attempting to load save file...")
  self.data = io.load_as_json(CrimDawn.SaveFile)
  if not self.data then CrimDawn:Reset() end
  self.data.game.deathlink = os.time()

  self.next_point = 100 + (self.data.game.score - self.data.game.score % 100)

  dofile(CrimDawn.ModPath .. "lua/tables/heists.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/upgrades.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/weapons.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/etc.lua")
  dofile(CrimDawn.ModPath .. "lua/tables/dlc.lua")

  SetColours()
end

-- Logo replacements
DB:create_entry(Idstring("texture"), Idstring("guis/textures/menu_title_screen"), CrimDawn.ModPath .. "assets/logo/title.texture")
DB:create_entry(Idstring("texture"), Idstring("guis/textures/game_small_logo"), CrimDawn.ModPath .. "assets/logo/small.texture")
DB:create_entry(Idstring("texture"), Idstring("units/menu/menu_scene/menu_cylinder_logo"), CrimDawn.ModPath .. "assets/logo/menu.texture")

for i = 0, 6 do -- Safehouse frames
  DB:create_entry(Idstring("texture"), Idstring("crimdawn/safehouse" .. i), CrimDawn.ModPath .. "assets/safehouse/tier" .. i .. ".texture")
end

-- Background replacements
DB:create_entry(Idstring("texture"), Idstring("guis/textures/loading/loading-bg"), CrimDawn.ModPath .. "assets/bg/loading.texture")
DB:create_entry(Idstring("texture"), Idstring("guis/textures/pd2/menu_backdrop/bd_baselayer"), CrimDawn.ModPath .. "assets/bg/briefing.texture")

Global.CrimDawn:Init()