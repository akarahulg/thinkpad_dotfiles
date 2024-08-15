
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Function to create the music control widget
local function create_music_widget()
    local music_title = wibox.widget {
        widget = wibox.widget.textbox,
        text = "🔕",  -- Initial text when no music is playing
        align = "center",
        valign = "center",
        font = "Hack 10"
    }

    -- Create a container that scrolls the text horizontally
    local scrolling_text = wibox.widget {
        music_title,
        layout = wibox.container.scroll.horizontal,
        max_size = 200,  -- Adjust to your preferred maximum width
        step_function = wibox.container.scroll.step_functions.linear_increase,
        speed = 0  -- Initial speed set to 0
    }

    -- Make the scrolling text clickable to toggle play/pause
    local clickable_text = wibox.container.background(scrolling_text)
    clickable_text:connect_signal("button::press", function()
        awful.spawn("playerctl play-pause")
    end)

    -- Update widget function
    local function update_widget()
        awful.spawn.easy_async_with_shell("playerctl -p $(playerctl -l) metadata title", function(stdout)
            local title = stdout:gsub("%s+$", "")  -- Trim trailing whitespace
            if title == "" then
                music_title.text = "🔕"
                scrolling_text.speed = 0  -- Stop scrolling when no music is playing
            else
                music_title.text = title .. " "
                awful.spawn.easy_async_with_shell("playerctl -p $(playerctl -l) status", function(status)
                    if status:match("Playing") then
                        scrolling_text.speed = 50  -- Scroll only when playing
                    else
                        scrolling_text.speed = 0  -- Stop scrolling when paused
                    end
                end)
            end
        end)
    end

    -- Update widget every second
    gears.timer({
        timeout = 1,
        autostart = true,
        callback = update_widget
    })

    -- Create buttons with standardized media control symbols
    local prev_button = wibox.widget {
        text = "⏪",  -- Previous track symbol
        widget = wibox.widget.textbox,
        align  = "center",
        valign = "center",
        font = "Hack 10"
    }
    prev_button:connect_signal("button::press", function() awful.spawn("playerctl previous") end)

    local next_button = wibox.widget {
        text = "⏭",  -- Next track symbol
        widget = wibox.widget.textbox,
        align  = "center",
        valign = "center",
        font = "Hack 10"
    }
    next_button:connect_signal("button::press", function() awful.spawn("playerctl next") end)

    -- Combine all widgets into a single horizontal layout
    local control_bar = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        prev_button,
        clickable_text,
        next_button,
    }

    return control_bar
end

-- Return the function to be used in rc.lua
return {
    create_music_widget = create_music_widget
}
