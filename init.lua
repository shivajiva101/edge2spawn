-- Edge2Spawn for Minetest
-- Written by shivajiva101@hotmail.com

-- check minetest.conf for settings
local edge = tonumber(minetest.setting_get("edge2spawn_edge")) or 1000
local spawn = minetest.setting_get_pos("static_spawnpoint") or {x= 0, y= 0, z=0}

-- register priv
minetest.register_privilege("explorer","Player can move beyond the edge limit")

--[[ Function creates a table of players and loop through checking players positions
against the edge value, returning any players exceeding this value to
the static spawnpoint unless they have the 'explorer' privilege ]]  
function checkPlayers()
-- create table
local players = minetest.get_connected_players()
-- loop table values
  for i, player in ipairs(players) do
	-- get player position
	local pos = vector.round(player:getpos())
	-- get player name
	local playerName = player:get_player_name()
	-- check player priv
	  if not minetest.check_player_privs(playerName, { explorer = true }) then
	  	-- check player position
	    if pos.x >= edge or pos.z >= edge or pos.x <= -edge or pos.z <= -edge then
		player:setpos(spawn) -- move player to spawn
		minetest.chat_send_player(playerName, "Oops you're not allowed to go that far!")
	    end	
	  end
  end
end

-- register global step
local stepTime = 0
minetest.register_globalstep(function(dtime)
	stepTime = stepTime + dtime
	if stepTime > 1 then
	      checkPlayers() -- call function
	      stepTime = 0
	end
end)
