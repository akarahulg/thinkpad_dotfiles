local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- Create a widget with a music update symbol
local spotifydownload = wibox.widget {
    {
        {
            text = "",  -- FontAwesome Spotify symbol
            font = "Font Awesome 6 Free Solid 10", -- Increase font size
            widget = wibox.widget.textbox,
            id = "icon",
            align = "center",
            valign = "center"
        },
        margins = 5,
        widget = wibox.container.margin
    },
    shape = gears.shape.rounded_bar,
    bg = "#282c34",
    fg = "#61afef",
    widget = wibox.container.background
}

-- Tooltip for better user interaction
local spotify_tooltip = awful.tooltip {
    objects = { spotifydownload },
    text = "Click to update playlist",
    mode = "outside",
    preferred_positions = { "top", "bottom" }
}

-- Function to update playlist with animation
local function update_playlist()
    local icon = spotifydownload:get_children_by_id("icon")[1]
    icon.text = ""  -- Show loading symbol

    awful.spawn.easy_async_with_shell(
        "notify-send 'Updating local playlist...' && spotifydl.py > /dev/null 2>&1 && notify-send 'Local playlist updated'",
        function(_, _, _, exitcode)
            if exitcode == 0 then
                icon.text = ""  -- Success symbol
            else
                icon.text = ""  -- Failure symbol
            end
            gears.timer.start_new(2, function()
                icon.text = ""  -- Restore icon after 2s
            end)
        end
    )
end

-- Add mouse click event
spotifydownload:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then  -- Left click
        update_playlist()
    end
end)

return spotifydownload

