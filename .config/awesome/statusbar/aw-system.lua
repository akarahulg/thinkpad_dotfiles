local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- Create a generic widget function
local function create_widget(icon)
    return wibox.widget {
        {
            {
                id = "icon",
                widget = wibox.widget.textbox,
                text = icon .. "",  -- Icon
            },
            {
                id = "text",
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.container.margin(_, 4, 4),
        set_value = function(self, text)
            self:get_children_by_id("text")[1]:set_text(text)
        end,
    }
end

-- Widgets
local ram_widget = create_widget(" ")   -- RAM icon
local cpu_widget = create_widget("")   -- CPU icon
local home_widget = create_widget(" ")  -- Home folder icon
local temp_widget = create_widget("")  -- CPU temperature icon

-- Function to update RAM usage
local function update_ram()
    awful.spawn.easy_async_with_shell("free | awk '/^Mem/ {printf(\"%.f%%\", $3/$2 * 100)}'", function(stdout)
        ram_widget:set_value(stdout:gsub("\n", ""))
    end)
end

-- Function to update CPU usage
local function update_cpu()
    awful.spawn.easy_async_with_shell("top -bn1 | grep '%Cpu' | awk '{print $2}'", function(stdout)
        cpu_widget:set_value(stdout:gsub("\n", "") .. "%")
    end)
end

-- Function to update Home folder usage
local function update_home()
    awful.spawn.easy_async_with_shell("df -h ~ | awk 'NR>1 {print $5}'", function(stdout)
        home_widget:set_value(stdout:gsub("\n", ""))
    end)
end

-- Function to update CPU Temperature
local function update_temp()
    awful.spawn.easy_async_with_shell("cat /sys/class/thermal/thermal_zone0/temp", function(stdout)
        local temp = tonumber(stdout) / 1000  -- Convert millidegrees to degrees
        temp_widget:set_value(string.format("%.0f°C", temp))
    end)
end

-- Set update intervals
awful.widget.watch("free", 10, function() update_ram() end)
awful.widget.watch("top -bn1", 10, function() update_cpu() end)
awful.widget.watch("df -h ~", 60, function() update_home() end)
awful.widget.watch("cat /sys/class/thermal/thermal_zone0/temp", 5, function() update_temp() end)

-- Return the widgets
return {
    ram_widget = ram_widget,
    cpu_widget = cpu_widget,
    home_widget = home_widget,
    temp_widget = temp_widget,
}

