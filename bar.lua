local awful = require( "awful" )
local gears = require( "gears" )
local wibox = require( "wibox" )
local beautiful = require( "beautiful" )
local common = require( "awful.widget.common" )

local keys = require( "keys" )

--{{{ misc functions

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- utility function for fixed width tasklist
local function list_update( w, buttons, label, data, objects )
    common.list_update( w, buttons, label, data, objects )
    w:set_max_widget_size( 250 )
end

--}}}

--{{{ widgets
    local mytextclock = wibox.widget.textclock( "%l:%M%P ")
    local battery_widget = require( "widgets/battery-widget" ) { --{{{
        ac_prefix = {
            { 25, "  " },
            { 50, "  " },
            { 75, "  " },
            { 95, "  " },
            {100, "  " }
        },
        battery_prefix = {
            { 25, " " },
            { 50, " " },
            { 75, " " },
            { 95, " " },
            {100, " " }
        },
        listen = true,
        widget_font = "Font Awesome 5 Free 12",
        widget_text = "${AC_BAT}",
        tooltip_text = "Battery ${state}: ${percent}%; est${time_est}"
    } --}}}
    local net_widget = require( "widgets/wireless" ) { --{{{
        interface="wlp3s0",
        font = "Inconsolata for Powerline 13",
        show_icon = false,
    } --}}}
    local promptbox = awful.widget.prompt { --{{{
            bg = beautiful.bg_urgent,
            fg = beautiful.fg_urgent
        } --}}}
    local function taglist(s) --{{{
        return awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.noempty,
            buttons = taglist_buttons,
        }
    end --}}}
    local function vtaglist(s) --{{{
        return awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.noempty,
            buttons = taglist_buttons,
            layout = wibox.layout.fixed.vertical,
            style = {
                shape = gears.shape.circle,
            },
            widget_template = {
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    left = 8,
                    top = 2,
                    widget = wibox.container.margin,
                },
                id = 'background_role',
                shape = gears.shape.circle,
                forced_height = 24,
                forced_width = 24,
                widget = wibox.container.background,
            }
        }
    end
    --}}}
    local function tasklist(s) --{{{
        return awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            style = {
                align = 'center',
            },
            update_function = list_update,
            layout = wibox.layout.flex.horizontal(),
        }
    end --}}}
    local function vtasklist(s) --{{{
        return awful.widget.tasklist {
                screen = s,
                filter = awful.widget.tasklist.filter.minimizedcurrenttags,
                button = tasklist_buttons,
                layout = wibox.layout.fixed.vertical(),
                widget_template = {
                    {
                        {
                            id = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        left = 2,
                        top = 9,
                        widget = wibox.container.margin,
                    },
                    id = 'background_role',
                    widget = wibox.container.background,
                    forced_height = 40,
                }
            }
    end --}}}
--}}}

-- {{{ buttons
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))
local layoutbox_buttons = gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end))

--}}}

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) --{{{
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- awful.tag({"a", "b", "c", "d", "e", "f" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = promptbox

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons( layoutbox_buttons )

    -- Create a taglist widget
    s.mytaglist = taglist(s)

    s.myvtaglist = vtaglist(s)
    s.myvtasklist = vtasklist(s)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = wibox.layout.fixed.horizontal(),
        widget_template = {
            {
                id = 'icon_role',
                widget = wibox.widget.imagebox,
            },
            id = 'background_role',
            widget = wibox.container.background,
        }
    }

    -- Create the top bar   --{{{
    s.topbar = awful.wibar({
        visible = false,
        ontop = true,
        position = "top",
        screen = s,
        height = 23,
    }) --}}}

    -- Create the side bar {{{
    s.sidebar = awful.wibar ( {
        ontop = true,
        position = "right",
        screen=s,
        width = 24,
    } ) --}}}

    -- Activate the side bar --{{{
    s.sidebar:setup {
        layout = wibox.layout.align.vertical,
        {
            layout = wibox.layout.fixed.vertical,
            s.myvtaglist,
        },
        {
            layout = wibox.layout.fixed.vertical,
            s.myvtasklist,
        },
        {
            layout = wibox.layout.fixed.vertical,
            net_widget,
            s.mylayoutbox,
        },
    }
    -- }}}

    -- Activate the top bar {{{
    s.topbar:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.align.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            s.mypromptbox,
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mytextclock,
            battery_widget,
        },
    } --}}}

end) --}}}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

