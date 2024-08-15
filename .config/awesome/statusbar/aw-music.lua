
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Function to create the music control widget
local function create_music_widget()
    local music_title = wibox.widget {
        widget = wibox.widget.textbox,
        text = "No music playing",
        align = "center",
        valign = "center",
        font = "Hack 10"  -- Set font to "Hack" with size 10
    }

    -- Create a container that scrolls the text horizontally in a continuous manner
    local scrolling_title = wibox.widget {
        {
            music_title,
            layout = wibox.container.scroll.horizontal,
            max_size = 200,  -- Adjust to your preferred maximum width
            step_function = wibox.container.scroll.step_functions.linear_increase,  -- Train-like scrolling
            speed = 50  -- Adjust to control the scrolling speed (higher for faster)
        },
        layout = wibox.layout.fixed.horizontal
    }

    -- Update widget function
    local function update_widget()
        awful.spawn.easy_async_with_shell("playerctl -p $(playerctl -l) metadata title", function(stdout)
            local title = stdout:gsub("%s+$", "")  -- Trim trailing whitespace
            if title == "" then
                music_title.text = "No music playing"
            else
                music_title.text =  title .. " "
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
        text = "⏮",  -- Previous track symbol
        widget = wibox.widget.textbox,
        align  = "center",
        valign = "center",
        font = "Hack 10"  -- Set font to "Hack" with size 10
    }
    prev_button:connect_signal("button::press", function() awful.spawn("playerctl previous") end)

    local play_button = wibox.widget {
        text = "⏵",  -- Play symbol
        widget = wibox.widget.textbox,
        align  = "center",
        valign = "center",
        font = "Hack 10"  -- Set font to "Hack" with size 10
    }
    play_button:connect_signal("button::press", function() awful.spawn("playerctl play") end)

    local pause_button = wibox.widget {
        text = "⏸",  -- Pause symbol
        widget = wibox.widget.textbox,
        align  = "center",
        valign = "center",
        font = "Hack 10"  -- Set font to "Hack" with size 10
    }
    pause_button:connect_signal("button::press", function() awful.spawn("playerctl pause") end)

    local next_button = wibox.widget {
        text = "⏭",  -- Next track symbol
        widget = wibox.widget.textbox,
        align  = "center",
        valign = "center",
        font = "Hack 10"  -- Set font to "Hack" with size 10
    }
    next_button:connect_signal("button::press", function() awful.spawn("playerctl next") end)

    -- Combine all widgets into a horizontal layout
    local control_bar = wibox.widget {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        prev_button,
        scrolling_title,
        next_button,
        wibox.widget.textbox(" "),  -- Spacer
        play_button,
        pause_button
    }

    return control_bar
end

-- Return the function to be used in rc.lua
return {
    create_music_widget = create_music_widget
}
