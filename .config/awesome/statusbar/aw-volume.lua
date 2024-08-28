local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")

-- Define the font
local widget_font = "Hack 10"

-- Define the volume command
local volume_command = "volume"

-- Create the volume widget
local my_volume_widget = wibox.widget.textbox()
my_volume_widget:set_font(widget_font)

-- Function to call the volume script and get its output asynchronously
local function get_volume_output(callback)
    awful.spawn.easy_async(volume_command .. ' display', function(stdout)
        local output = stdout:gsub("\n", "")  -- Remove newline characters
        callback(output)
    end)
end

local tooltip = awful.tooltip({
        objects = {my_volume_widget},
        text = "Left Click: Mute/Unmute\nRight Click: Open pavucontrol\nMiddle Click: Switch between speaker and headphones\nScroll Up: Increase Volume\nScroll Down: Decrease Volume",
        delay_show = 2,
    })



-- Function to update the widget text
local function update_widget()
    get_volume_output(function(output)
        my_volume_widget:set_text(output)
    end)
end

-- Function to toggle mute status
local function toggle_mute()
    awful.spawn.with_shell(volume_command .. ' toggle')
    update_widget()
end

-- Function to adjust volume
local function adjust_volume(direction)
    awful.spawn.with_shell(volume_command .. ' ' .. direction)
    update_widget()
end

-- Function to switch between headphones and speaker
local function switch_device(direction)
    awful.spawn.with_shell(volume_command .. ' ' .. 'switch')
    update_widget()
end


-- Function to open pavucontrol
local function open_pavucontrol()
    awful.spawn.with_shell("pavucontrol")
end

-- Initial update
update_widget()

-- Set up a timer to update the widget periodically
local update_timer = gears.timer({ timeout = 1 })  -- Update every 1 second
update_timer:connect_signal("timeout", function()
    update_widget()
end)
update_timer:start()

-- Add buttons to the widget
my_volume_widget:buttons(gears.table.join(
    awful.button({}, 1, function() toggle_mute() end),  -- Left click: Toggle mute
    awful.button({}, 2, function() switch_device() end),  -- Middle click: Switch between speaker and headphones
    awful.button({}, 3, function() open_pavucontrol() end),  -- Right click: Open pavucontrol
    awful.button({}, 4, function() adjust_volume('up') end),  -- Scroll up: Increase volume
    awful.button({}, 5, function() adjust_volume('down') end)  -- Scroll down: Decrease volume
))

-- Return the widget
return my_volume_widget
