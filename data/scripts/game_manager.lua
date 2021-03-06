-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

require("scripts/multi_events")
local initial_game = require("scripts/initial_game")
local stamina_manager = require"scripts/action/stamina_manager"
local game_restart = require("scripts/game_restart")
local footstep_manager = require"scripts/fx/footsteps"

local game_manager = {}

-- Creates a game ready to be played.
function game_manager:create(file)

  -- Create the game (but do not start it).
  local exists = sol.game.exists(file)
  local game = sol.game.load(file)
  if not exists then
    -- This is a new savegame file.
    initial_game:initialize_new_savegame(game)
  end

  --Get some things ready
  game.enemies_killed = {} --empty array to keep track of dead enemies

  require("scripts/fx/lighting_effects"):initialize()
  require("scripts/button_inputs"):initialize(game)
  require("scripts/game_over"):initialize(game)
  require("scripts/menus/pause"):initialize(game)

  --reset some values whenever game starts or restarts
  game:register_event("on_started", function()
    game_restart:reset_values(game)
    stamina_manager:start(game)
    sol.timer.start(sol.main, 400, function() footstep_manager:start() end)
  end)

  return game
end

return game_manager
