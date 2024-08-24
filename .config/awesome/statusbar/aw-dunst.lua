
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Define the command to toggle and check Dunst status
local toggle_command = "toggle-dunst --toggle"
local status_command = "toggle-dunst" -- Command to check the current status

-- Create the widget
local dunst_widget = wibox.widget {
    text   = "Dunst", -- Initial text for the widget
    align  = 'center',
    valign = 'center',
    font = "Hack 12",
    widget = wibox.widget.textbox,
}

-- Function to update the widget text with the current Dunst status
local function update_widget()
    awful.spawn.easy_async(status_command, function(stdout)
        -- Update the widget text with the output of the status command
        dunst_widget.text = stdout
    end)
end

-- Connect the click event to toggle Dunst
dunst_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.easy_async(toggle_command, function()
            update_widget() -- Update the widget after toggling
        end)
    end)
))

-- Periodically check the status of Dunst and update the widget
gears.timer {
    timeout   = 10, -- Time in seconds between updates
    autostart = true,
    callback  = update_widget
}

-- Initial update
update_widget()

-- Return the widget
return dunst_widget
