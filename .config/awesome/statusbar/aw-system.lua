
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- Create the RAM widget with an icon
local ram_widget = wibox.widget {
    {
        {
            id = "icon",
            widget = wibox.widget.textbox,
            -- font = "Hack 10",
            text = " ",  -- RAM icon (could be a different icon from an icon font)
        },
        {
            id = "text",
            widget = wibox.widget.textbox,
            -- font = "Hack 10",
        },
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.container.margin(_, 2, 2),
    set_ram_usage = function(self, text)
        self:get_children_by_id("text")[1]:set_text(text)
    end,
}

-- Create the CPU widget with an icon
local cpu_widget = wibox.widget {
    {
        {
            id = "icon",
            widget = wibox.widget.textbox,
            -- font = "Hack 10",
            text = " ",  -- CPU icon (could be a different icon from an icon font)
        },
        {
            id = "text",
            widget = wibox.widget.textbox,
            -- font = "Hack 10",
        },
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.container.margin(_, 2, 2),
    set_cpu_usage = function(self, text)
        self:get_children_by_id("text")[1]:set_text(text)
    end,
}

-- Create the Home folder usage widget with an icon
local home_widget = wibox.widget {
    {
        {
            id = "icon",
            widget = wibox.widget.textbox,
            -- font = "Hack 10",
            text = " ",  -- Home folder icon (could be a different icon from an icon font)
        },
        {
            id = "text",
            widget = wibox.widget.textbox,
            -- font = "Hack 10",
        },
        layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.container.margin(_, 2, 2),
    set_home_usage = function(self, text)
        self:get_children_by_id("text")[1]:set_text(text)
    end,
}

-- Function to update RAM usage (as percentage)
local function update_ram()
    awful.spawn.easy_async_with_shell("free | awk '/^Mem/ {printf(\"%.f%%\", $3/$2 * 100)}'", function(stdout)
        ram_widget:set_ram_usage(stdout:gsub("\n", ""))
    end)
end

-- Function to update CPU usage
local function update_cpu()
    awful.spawn.easy_async_with_shell("top -bn1 | grep '^%Cpu' | awk '{print $2}'", function(stdout)
        cpu_widget:set_cpu_usage(stdout:gsub("\n", "") .. "%")
    end)
end

-- Function to update Home folder usage
local function update_home()
    awful.spawn.easy_async_with_shell("df -h ~ | awk 'NR>1 {print $5}'", function(stdout)
        home_widget:set_home_usage(stdout:gsub("\n", ""))
    end)
end

-- Set update intervals (in seconds)
awful.widget.watch("free", 10, function() update_ram() end)
awful.widget.watch("top -bn1", 10, function() update_cpu() end)
awful.widget.watch("df -h ~", 60, function() update_home() end)

-- Return the widgets
return {
    ram_widget = ram_widget,
    cpu_widget = cpu_widget,
    home_widget = home_widget,
}
