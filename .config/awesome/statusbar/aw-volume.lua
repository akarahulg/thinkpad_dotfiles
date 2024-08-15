local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")  -- Load the beautiful theme

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

-- Function to update volume
local function update_volume()
    awful.spawn.easy_async_with_shell("amixer get Master | grep -oP '\\[.*?%\\]' | head -1 | tr -d '[]%'", function(stdout)
        local vol = tonumber(stdout)
        local icon = "🔊"
        if vol >= 70 then
            icon = "🔊"
        elseif vol >= 30 then
            icon = "🔉"
        elseif vol >= 1 then
            icon = "🔈"
        else
            icon = "🔇"
        end
        volume_widget:set_volume(icon .. vol .. "%")
    end)

    -- Check mute status
    awful.spawn.easy_async_with_shell("amixer get Master | grep -oP '\\[off\\]' | head -1", function(stdout)
        if stdout:match("%[off%]") then
            volume_widget:set_volume("🔇")
        end
    end)
end

-- Update the volume when the widget is created
update_volume()

-- Apply the theme font to the volume widget
volume_widget:get_children_by_id("icon")[1].font = beautiful.font

-- Add mouse event listeners
volume_widget:buttons(
    awful.util.table.join(
        -- Left-click: Open pavucontrol
        awful.button({}, 1, function() awful.spawn("pavucontrol") end),

        -- Middle-click: Mute/Unmute the volume
        awful.button({}, 2, function()
            awful.spawn.easy_async("amixer set Master toggle", function()
                update_volume()  -- Update the volume and icon
            end)
        end),

        -- Right-click: Show a help notification
        awful.button({}, 3, function()
            naughty.notify({ title = "Volume Widget", text = "Left click: Open pavucontrol\nMiddle click: Mute/unmute\nScroll: Adjust volume" })
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

-- Return the widget and separator
return {
    volume_widget = volume_widget,
}
