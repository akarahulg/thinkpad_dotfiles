
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")

-- Create the volume widget
local volume_widget = wibox.widget {
    {
        id = "icon",
        widget = wibox.widget.textbox,
    },
    layout = wibox.container.margin(_, 2, 2),
    set_volume = function(self, text)
        local icon_widget = self:get_children_by_id("icon")[1]
        icon_widget.font = "Hack 10"
        icon_widget:set_text(text)
    end,
}

-- Initialize global variables to keep track of mute states
local mute_headphones = false
local mute_speakers = false

-- Function to get the current audio output device
local function get_audio_output_device(callback)
    awful.spawn.easy_async_with_shell("pactl list sinks | grep -E 'Name:|Active Port:'", function(stdout)
        local device
        for line in stdout:gmatch("[^\r\n]+") do
            if line:match("Active Port:") then
                if line:match("headphones") then
                    device = "headphones"
                else
                    device = "speakers"
                end
                break
            end
        end
        callback(device)
    end)
end

-- Function to update volume and mute state
local function update_volume()
    get_audio_output_device(function(device)
        -- Update volume and mute status for both headphones and speakers
        awful.spawn.easy_async_with_shell("amixer get Master", function(stdout)
            local vol = stdout:match("(%d+)%%")
            local mute_status = stdout:match("%[(on|off)%]")

            if device == "headphones" then
                mute_headphones = (mute_status == "off")
            else
                mute_speakers = (mute_status == "off")
            end

            local icon = "  "
            if device == "headphones" then
                if mute_headphones then
                    icon = "  "
                elseif tonumber(vol) >= 70 then
                    icon = "  "
                elseif tonumber(vol) >= 30 then
                    icon = "  "
                elseif tonumber(vol) >= 1 then
                    icon = "  "
                end
            else
                if mute_speakers then
                    icon = "   "
                elseif tonumber(vol) >= 70 then
                    icon = "  "
                elseif tonumber(vol) >= 30 then
                    icon = "  "
                elseif tonumber(vol) >= 1 then
                    icon = "  "
                end
            end

            volume_widget:set_volume(icon .. vol .. "%")
        end)
    end)
end

-- Function to toggle mute status for a specific device
local function toggle_mute(device)
    if device == "headphones" then
        mute_headphones = not mute_headphones
        awful.spawn("amixer set Master " .. (mute_headphones and "mute" or "unmute"))
    else
        mute_speakers = not mute_speakers
        awful.spawn("amixer set Master " .. (mute_speakers and "mute" or "unmute"))
    end
    update_volume()
end

-- Function to handle changes
local function handle_change()
    update_volume()
end

-- Create a timer to periodically check for changes
local watch_timer = gears.timer({
    timeout = 1, -- Check every second
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async_with_shell("amixer get Master", function(stdout)
            local new_vol = stdout:match("(%d+)%%")
            if new_vol ~= current_vol then
                current_vol = new_vol
                handle_change()
            end
        end)

        awful.spawn.easy_async_with_shell("pactl list sinks | grep -E 'Active Port:'", function(stdout)
            local new_device
            for line in stdout:gmatch("[^\r\n]+") do
                if line:match("Active Port:") then
                    if line:match("headphones") then
                        new_device = "headphones"
                    else
                        new_device = "speakers"
                    end
                    break
                end
            end
            if new_device ~= current_device then
                current_device = new_device
                handle_change()
            end
        end)
    end
})

-- Initialize current volume and device
local current_vol
local current_device
update_volume()  -- Initial update

-- Apply the theme font to the volume widget
volume_widget:get_children_by_id("icon")[1].font = beautiful.font

-- Add mouse event listeners
volume_widget:buttons(
    awful.util.table.join(
        -- Left-click: Open pavucontrol
        awful.button({}, 1, function() awful.spawn("pavucontrol") end),

        -- Middle-click: Mute/Unmute the current device
        awful.button({}, 2, function()
            get_audio_output_device(function(device)
                toggle_mute(device)
            end)
        end),

        -- Right-click: Show a help notification
        awful.button({}, 3, function()
            naughty.notify({ title = "Volume Widget", text = "Left click: Open pavucontrol\nMiddle click: Mute/unmute current device\nScroll: Adjust volume" })
        end),

        -- Scroll up: Increase volume by 5%
        awful.button({}, 4, function()
            awful.spawn("amixer set Master 5%+")
            update_volume()
        end),

        -- Scroll down: Decrease volume by 5%
        awful.button({}, 5, function()
            awful.spawn("amixer set Master 5%-")
            update_volume()
        end)
    )
)

-- Return the widget
return {
    volume_widget = volume_widget,
}
