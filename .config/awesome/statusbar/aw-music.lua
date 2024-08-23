
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Function to create the music control widget
local function create_music_widget()
    -- Widget to display the music title
    local music_title = wibox.widget {
        widget = wibox.widget.textbox,
        text = "   ",  -- Initial text when no music is playing
        align = "center",
        valign = "center",
        font = "Hack 10"
    }

    -- Create a container that scrolls the text horizontally
    local scrolling_text = wibox.widget {
        music_title,
        layout = wibox.container.scroll.horizontal,
        max_size = 120,  -- Adjust to your preferred maximum width
        step_function = wibox.container.scroll.step_functions.linear_increase,
        speed = 0  -- Initial speed set to 0
    }

    -- Create emojis for play/pause control
    local play_pause_emoji = wibox.widget {
        text = "  ",  -- Play emoji
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        font = "Hack 10"
    }

    local function toggle_play_pause()
        -- Check the status of the first active player
        awful.spawn.easy_async_with_shell("playerctl status | head -n 1", function(status)
            status = status:gsub("%s+$", "")  -- Trim trailing whitespace

            if status == "Playing" then
                -- Pause all players if any player is playing
                awful.spawn("playerctl -a pause")
            else
                -- Play all players if any player is paused
                awful.spawn("playerctl -a play")
            end
        end)
    end

    play_pause_emoji:connect_signal("button::press", toggle_play_pause)

    -- Create buttons with emojis for media control
    local prev_button = wibox.widget {
        text = "  ",  -- Previous track emoji
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        font = "Hack 10"
    }
    prev_button:connect_signal("button::press", function()
        awful.spawn("playerctl previous")
    end)

    local next_button = wibox.widget {
        text = "  ",  -- Next track emoji
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        font = "Hack 10"
    }
    next_button:connect_signal("button::press", function()
        awful.spawn("playerctl next")
    end)

    -- Function to update the widget
    local function update_widget()
	    -- "music" is my custom player status checking script
        awful.spawn.easy_async_with_shell("music", function(full_text)
            full_text = full_text:gsub("%s+$", "")  -- Trim trailing whitespace

            -- Extract player name and title
            local player_name, title = full_text:match("([^:]+)::::([^:]+)")

            if player_name and title then
                if title == "" then
                    music_title.text = "   "  -- No music playing emoji
                    scrolling_text.speed = 0  -- Stop scrolling when no music is playing
                else
                    music_title.text = (title .. " "):rep(10)  -- Repeat title to ensure scrolling
                    awful.spawn.easy_async_with_shell("playerctl -p " .. player_name .. " status | head -n 1", function(status)
                        status = status:gsub("%s+$", "")  -- Trim trailing whitespace
                        if status == "Playing" then
                            scrolling_text.speed = 40  -- Scroll only when playing
                            play_pause_emoji.text = "  "  -- Pause emoji
                        else
                            scrolling_text.speed = 0  -- Stop scrolling when paused
                            play_pause_emoji.text = "  "  -- Play emoji
                        end
                    end)
                end
            else
                music_title.text = "   "  -- No music playing emoji
                scrolling_text.speed = 0  -- Stop scrolling when no music is playing
                play_pause_emoji.text = "  "  -- Default to play emoji
            end
        end)
    end

    -- Update widget every second
    gears.timer({
        timeout = 1,
        autostart = true,
        callback = update_widget
    })

    -- Combine all widgets into a single horizontal layout
    local control_bar = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        prev_button,
        play_pause_emoji,
        next_button,
        scrolling_text,
    }

    return control_bar
end

-- Return the function to be used in rc.lua
return {
    create_music_widget = create_music_widget
}
