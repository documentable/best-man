-- # tranquil.monster resolver
-- # ultimate hvh resolver with full customizability

-- # required libraries
local ui = ui
local client = client
local entity = entity
local bit = bit
local globals = globals

-- # resolver ui in rage tab
local resolver_setting = ui.new_combobox("rage", "other", "tranquil resolver", {
    "off",
    "anti-desync",
    "jitter resolver",
    "on-shot resolver",
    "freestanding resolver",
    "max aggression",
    "custom",
    "randomized"
})

-- # custom mode settings (only visible when custom mode is active)
local custom_yaw_offset = ui.new_slider("rage", "other", "yaw offset", -60, 60, 0)
local custom_pitch_offset = ui.new_slider("rage", "other", "pitch offset", -89, 89, 0)
local custom_desync_sensitivity = ui.new_slider("rage", "other", "desync prediction", 1, 5, 3)

local custom_auto_freestand = ui.new_checkbox("rage", "other", "auto freestanding")
local custom_anti_bruteforce = ui.new_checkbox("rage", "other", "anti-bruteforce")
local custom_adaptive_on_shot = ui.new_checkbox("rage", "other", "adaptive on-shot resolver")
local custom_spin_exploit_detection = ui.new_checkbox("rage", "other", "spin exploit detection")
local custom_anti_loss_resolver = ui.new_checkbox("rage", "other", "anti-loss resolver")

-- # function to log debug messages
local visual_debug = ui.new_checkbox("rage", "other", "enable debug logs")
local function debug_log(msg)
    if ui.get(visual_debug) then
        client.color_log(0, 255, 255, "[tranquil] " .. msg)
    end
end

-- # function to update visibility of custom settings
local function update_custom_settings()
    local is_custom = ui.get(resolver_setting) == "custom"
    
    -- only show custom settings when custom is selected
    ui.set_visible(custom_yaw_offset, is_custom)
    ui.set_visible(custom_pitch_offset, is_custom)
    ui.set_visible(custom_desync_sensitivity, is_custom)
    ui.set_visible(custom_auto_freestand, is_custom)
    ui.set_visible(custom_anti_bruteforce, is_custom)
    ui.set_visible(custom_adaptive_on_shot, is_custom)
    ui.set_visible(custom_spin_exploit_detection, is_custom)
    ui.set_visible(custom_anti_loss_resolver, is_custom)
end
ui.set_callback(resolver_setting, update_custom_settings)
update_custom_settings()

-- # player data storage
local player_data = {}

-- # aggressive resolver logic
local function aggressive_mode_logic(enemy, prev_data, yaw_diff, eye_x, eye_y, eye_z)
    local invert = math.random(0, 1) == 1 and -1 or 1
    if yaw_diff > 35 then
        local aggressive_yaw = prev_data.yaw + (math.random(20, 35) * invert)
        entity.set_prop(enemy, "m_angEyeAngles", eye_x, aggressive_yaw, eye_z)
        debug_log("aggressive mode: corrected desync")
    elseif yaw_diff < 15 then
        entity.set_prop(enemy, "m_angEyeAngles", eye_x, prev_data.yaw - (10 * invert), eye_z)
        debug_log("aggressive mode: reduced overcompensation")
    end
end

-- # resolver logic
local function resolver_logic(local_player)
    local mode = ui.get(resolver_setting)
    local enemies = entity.get_players(true)

    if #enemies == 0 then
        player_data = {} -- reset when no enemies
        return
    end

    for _, enemy in ipairs(enemies) do
        if entity.is_alive(enemy) and not entity.is_dormant(enemy) then
            player_data[enemy] = player_data[enemy] or {}

            local eye_x, eye_y, eye_z = entity.get_prop(enemy, "m_angEyeAngles")
            local prev_data = player_data[enemy]
            local yaw_diff = math.abs((prev_data.yaw or eye_y) - eye_y)

            -- randomized resolver mode
            if mode == "randomized" then
                local random_mode = math.random(1, 5)
                if random_mode == 1 then
                    mode = "anti-desync"
                elseif random_mode == 2 then
                    mode = "jitter resolver"
                elseif random_mode == 3 then
                    mode = "on-shot resolver"
                elseif random_mode == 4 then
                    mode = "freestanding resolver"
                else
                    mode = "max aggression"
                end
                debug_log("randomized resolver mode selected: " .. mode)
            end

            -- aggressive mode
            if mode == "max aggression" then
                aggressive_mode_logic(enemy, prev_data, yaw_diff, eye_x, eye_y, eye_z)

            -- custom mode logic
            elseif mode == "custom" then
                local final_yaw = eye_y + ui.get(custom_yaw_offset)
                local final_pitch = eye_x + ui.get(custom_pitch_offset)
                entity.set_prop(enemy, "m_angEyeAngles", final_pitch, final_yaw, eye_z)
                debug_log("custom resolver applied: yaw=" .. ui.get(custom_yaw_offset) .. ", pitch=" .. ui.get(custom_pitch_offset))
            end

            -- update stored player data
            player_data[enemy] = {
                yaw = eye_y,
                sim_time = entity.get_prop(enemy, "m_flSimulationTime"),
                shot_time = entity.get_prop(enemy, "m_fLastShotTime")
            }
        end
    end
end
client.set_event_callback("setup_command", resolver_logic)
