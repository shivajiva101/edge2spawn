-- Edge2Spawn for Minetest
-- Written by shivajiva101@hotmail.com

-- check minetest.conf for settings
local max_x = tonumber(minetest.setting_get("e2s.max_x")) or 7000
local min_x = tonumber(minetest.setting_get("e2s.min_x")) or -7000
local max_y = tonumber(minetest.setting_get("e2s.max_y")) or 7500
local min_y = tonumber(minetest.setting_get("e2s.min_y")) or -3500
local max_z = tonumber(minetest.setting_get("e2s.max_z")) or 7000
local min_z = tonumber(minetest.setting_get("e2s.min_z")) or -7000

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
	    		if pos.x >= max_x or pos.z >= max_z or pos.x <= min_x or pos.z <= min_z or
			pos.y >= max_y or pos.y <= min_y then
				player:setpos(spawn) -- move player to spawn
				minetest.chat_send_player(playerName, "Oops you're not allowed to go that far!")
	    		end	
	  	end
  	end
end

local check_throttle = 1
local function check_tick()
	checkPlayers() -- call function
	minetest.after(check_throttle, check_tick)
end)
-- register globalstep after the server starts
minetest.after(1, check_tick)
