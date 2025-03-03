
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Function to create the music control widget
local function create_music_widget()
    -- Widget to display the music title
    local music_title = wibox.widget {
        widget = wibox.widget.textbox,
        text = " No music ",  -- Initial text when no music is playing
        align = "center",
        valign = "center",
        -- font = "Hack 10"
    }

    -- Create a container that scrolls the text horizontally
    local scrolling_text = wibox.widget {
        music_title,
        layout = wibox.container.scroll.horizontal,
        max_size = 120,  -- Adjust to your preferred maximum width
        step_function = wibox.container.scroll.step_functions.linear_increase,
        speed = 0  -- Initial speed set to 0
    }

    -- Add a background color to the scrolling text
    local scrolling_text_with_bg = wibox.widget {
        scrolling_text,
        widget = wibox.container.background,
        bg = "#222222",  -- Set your desired background color here
    }

    -- Tooltip to show instructions
    local tooltip = awful.tooltip({
        objects = {scrolling_text_with_bg},
        text = "Left Click: Play/Pause\nRight Click: Next Track\nMiddle Click: Previous Track",
        delay_show = 2,
    })

    -- Function to update the widget
    local function update_widget()
        awful.spawn.easy_async_with_shell("music", function(full_text)
            full_text = full_text:gsub("%s+$", "")  -- Trim trailing whitespace

            -- Extract player name and title
            local player_name, title = full_text:match("([^:]+)::::([^:]+)")

            if player_name and title then
                if title == "" then
                    music_title.text = " No music "  -- No music playing emoji
                    scrolling_text.speed = 0  -- Stop scrolling when no music is playing
                else
                    music_title.text = (title .. " "):rep(10)  -- Repeat title to ensure scrolling
                    awful.spawn.easy_async_with_shell("playerctl -p " .. player_name .. " status | head -n 1", function(status)
                        status = status:gsub("%s+$", "")  -- Trim trailing whitespace
                        if status == "Playing" then
                            scrolling_text.speed = 40  -- Scroll only when playing
                        else
                            scrolling_text.speed = 0  -- Stop scrolling when paused
                        end
                    end)
                end
            else
                music_title.text = " No music "  -- No music playing emoji
                scrolling_text.speed = 0  -- Stop scrolling when no music is playing
            end
        end)
    end

    -- Update widget every second
    gears.timer({
        timeout = 1,
        autostart = true,
        callback = update_widget
    })

    -- Function to toggle play/pause
    local function toggle_play_pause()
        awful.spawn.easy_async_with_shell("playerctl status | head -n 1", function(status)
            status = status:gsub("%s+$", "")  -- Trim trailing whitespace
            if status == "Playing" then
                awful.spawn("playerctl -a pause")  -- Pause all players
            else
                awful.spawn("playerctl play")  -- Play all players
            end
        end)
    end

    -- Handle clicks and scrolls on scrolling text
    scrolling_text_with_bg:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then  -- Left click
            toggle_play_pause()
        elseif button == 3 then  -- Right click
            awful.spawn("playerctl next")  -- Next track
        elseif button == 2 then  -- Middle click
            awful.spawn("playerctl previous")  -- Previous track
        end
    end)

    return scrolling_text_with_bg
end

-- Return the function to be used in rc.lua
return {
    create_music_widget = create_music_widget
}
