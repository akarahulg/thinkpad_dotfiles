
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

-- Function to get the current audio output device and mute status
local function update_volume()
    awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@", function(mute_stdout)
        local is_muted = mute_stdout:match("Mute: yes")

        awful.spawn.easy_async_with_shell("amixer get Master", function(stdout)
            local vol = stdout:match("(%d+)%%")
            local icon

            if is_muted then
                icon = "  "  -- Mute icon
            else
                if tonumber(vol) >= 70 then
                    icon = "  "
                elseif tonumber(vol) >= 30 then
                    icon = "  "
                else
                    icon = "  "
                end
            end

            volume_widget:set_volume(icon .. vol .. "%")
        end)
    end)
end

-- Function to toggle mute status
local function toggle_mute()
    awful.spawn.easy_async_with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle", function()
        update_volume()
    end)
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
        handle_change()
    end
})

-- Initialize current volume and device
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
            toggle_mute()
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
