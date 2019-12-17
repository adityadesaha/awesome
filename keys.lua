local awful = require("awful")
local gears = require("gears")
local menubar = require("menubar")
local revelation = require("revelation")
local hotkeys_popup = require( "awful.hotkeys_popup" )
local beautiful = require( "beautiful" )
local wibox = require( "wibox" )

menubar.utils.terminal = "xterm"

local keys = {}

-- keys
super_key = "Mod4"

mode_popup = awful.popup { --{{{
    widget = {
        {
            text = 'resize mode',
            align = 'center',
            widget = wibox.widget.textbox,
            forced_height = 30,
            forced_width = 100,
        },
        bg = beautiful.bg_urgent,
        widget = wibox.widget.background,
    },
    shape = gears.shape.rounded_rect,
    visible = false,
    ontop   = true,
    placement = awful.placement.top,
} --}}}

run_popup = awful.popup { --{{{
    widget = {
        {
            id = 'textbox',
            widget = wibox.widget.textbox,
            font = beautiful.consolefont,
            forced_height = 30,
        },
        bg = beautiful.bg_urgent,
        widget = wibox.widget.background,
    },
    shape = gears.shape.rounded_rect,
    visible = false,
    ontop = true,
    placement = awful.placement.top,
} --}}}

keys.globalkeys = gears.table.join(
    awful.key({ modkey, "Shift" }, "s", --{{{
        hotkeys_popup.show_help,
        { description="show help", group="awesome"}
    ), --}}}
    awful.key({ modkey }, "Escape",  --{{{
        revelation,
        { description = "Open the revelation widget", group = "tag" }
    ), --}}}

    -- Media Control keys
    awful.key({}, 'XF86AudioRaiseVolume', --{{{
                function()
                    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
                end,
                { description = "volume +5%", group = "hotkeys"}
    ), --}}}
    awful.key({}, 'XF86AudioLowerVolume', --{{{
                function()
                    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
                end,
                { description = "volume -5%", group = "hotkeys"}
    ), --}}}
    awful.key({}, 'XF86AudioMute', --{{{
                function()
                    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
                end,
                { description = "toggle mute", group = "hotkeys"}
    ), --}}}
    awful.key({}, 'XF86MonBrightnessUp', --{{{
                function()
                    awful.spawn("backlight.sh up")
                end,
                { description="raise brightness", group = "hotkeys"}
    ), --}}}
    awful.key({}, 'XF86MonBrightnessDown', --{{{
                function()
                    awful.spawn("backlight.sh down")
                end,
                { description="lower brightness", group = "hotkeys"}
    ), --}}}

    -- focusing clients by direction
    awful.key( { modkey }, "h",  --{{{
        function()
            awful.client.focus.bydirection( "left" )
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client" }
    ), --}}}
    awful.key( { modkey }, "j",  --{{{
        function()
            awful.client.focus.bydirection( "down" )
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }
    ), --}}}
    awful.key( { modkey }, "k",  --{{{
        function()
            awful.client.focus.bydirection( "up" )
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client" }
    ), --}}}
    awful.key( { modkey }, "l",  --{{{
        function()
            awful.client.focus.bydirection( "right" )
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client" }
    ), --}}}

    -- cycling clients by index
    awful.key( { modkey }, "Tab", --{{{
         function()
             awful.client.focus.byidx( 1 )
         end,
         { description = "focus next", group = "client" }
    ), --}}}
    awful.key( { modkey, "Shift" }, "Tab", --{{{
         function()
             awful.client.focus.byidx( -1 )
         end,
         { description = "focus previous", group = "client" }
    ), --}}}

    -- moving around
    awful.key( { modkey, "Shift" }, "h",  --{{{
        function()
            local c = client.focus
            if ( c.floating ) then
                c:relative_move( -20, 0, 0, 0 )
            else
                awful.client.swap.bydirection( "left" )
            end
            if client.focus then client.focus:raise() end
        end,
        { description = "move left", group = "client" }
    ), --}}}
    awful.key( { modkey, "Shift" }, "j",  --{{{
        function()
            local c = client.focus
            if ( c.floating ) then
                c:relative_move( 0, 20, 0, 0 )
            else
                awful.client.swap.bydirection( "down" )
            end
            if client.focus then client.focus:raise() end
        end,
        { description = "move down", group = "client" }
    ), --}}}
    awful.key( { modkey, "Shift" }, "k",  --{{{
        function()
            local c = client.focus
            if ( c.floating ) then
                c:relative_move( 0, -20, 0, 0 )
            else
                awful.client.swap.bydirection( "up" )
            end
            if client.focus then client.focus:raise() end
        end,
        { description = "move up", group = "client" }
    ), --}}}
    awful.key( { modkey, "Shift" }, "l",  --{{{
        function()
            local c = client.focus
            if ( c.floating ) then
                c:relative_move( 20, 0, 0, 0 )
            else
                awful.client.swap.bydirection( "right" )
            end
            if client.focus then client.focus:raise() end
        end,
        { description = "move right", group = "client" }
    ), --}}}

    -- Standard program
    awful.key({ modkey }, "Return", --{{{
        function () 
            awful.spawn(terminal) 
        end,
        { description = "open a terminal", group = "launcher"}
    ), --}}}
    awful.key({ modkey,   "Shift" }, "Return", --{{{
        function ()
            awful.spawn("urxvt", { placement = awful.placement.centered } )
        end,
        { description = "open urxvt", group = "launcher"}
    ), --}}}
    awful.key({ modkey, "Shift" }, "r",  --{{{
        awesome.restart,
        { description = "reload awesome", group = "awesome"}
    ), --}}}
    awful.key({ modkey, "Shift"   }, "e",  --{{{
        awesome.quit,
        { description = "quit awesome", group = "awesome"}
    ), --}}}

    -- Changing layouts
    awful.key({ modkey }, "space",  --{{{
        function ()
            awful.layout.inc(1)
            for s in screen do
                if (awful.layout.get(s) == awful.layout.suit.max) then
                    awful.screen.focused().myvtasklist.filter = awful.widget.tasklist.filter.currenttags
                end
            end
        end,
        { description = "select next", group = "layout"}
    ), --}}}
    awful.key({ modkey, "Shift"   }, "space",  --{{{
        function () 
            awful.layout.inc(-1)
        end,
        { description = "select previous", group = "layout"}
    ), --}}}

    -- Prompt
    awful.key({ modkey }, "r", --{{{
        function ()
            run_popup.visible = true
            awful.prompt.run {
                prompt = " $: ",
                font = beautiful.consolefont,
                exe_callback = function(s)
                    awful.spawn(s)
                    run_popup.visible = false
                end,
                textbox = run_popup.widget:get_children_by_id( "textbox" )[1],
            }
        end,
        { description = "run prompt", group = "launcher"}
    ), --}}}

    -- Menubar
    awful.key({ modkey }, "p",  --{{{
        function() 
            menubar.show() 
        end,
              { description = "show the menubar", group = "launcher"}
    ),--}}}

    -- hide wibar
    awful.key({ modkey }, "Prior", --{{{
        function()
            awful.screen.focused().topbar.visible = not awful.screen.focused().topbar.visible
        end,
        { description = "lol", group = "lol" }
    ), --}}}

    -- show wibar
    awful.key({ modkey }, "Next", --{{{
        function()
            awful.screen.focused().sidebar.visible = not awful.screen.focused().sidebar.visible
        end,
        { description = "lol", group = "lol" }
    ), --}}}

    -- go to resize mode
    awful.key({ modkey, "Shift" }, "b", --{{{
        function()
            root.keys(keys.globalkeys2)
            mode_popup.visible = true
            root.mode = 'mod'
        end,
        { description = "lol", group = "lol" }
    ) --}}}
)

keys.clientkeys = gears.table.join(
    awful.key({ modkey }, "s",       --{{{
        function(c)
            c.floating = not c.floating
            if c.floating then
                --c:relative_move( 100, 100, -100, -100 )
                if c.resized then
                else
                    c.width = 800
                    c.height = 600
                    c.x = 400
                    c.y = 100
                    c.resized = true
                end
            end
        end,
        { description="show help", group="awesome"}
    ), --}}}
    awful.key({ modkey }, "f", --{{{
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client"}
    ), --}}}
    awful.key({ modkey, "Shift"   }, "q", --{{{
        function (c) 
            c:kill()                         
        end,
        { description = "close", group = "client"}
    ), --}}}
    awful.key({ modkey }, "m", --{{{
        function (c)
            c.minimized = true
        end ,
        { description = "minimize", group = "client"}
    ),--}}}
    awful.key({ modkey, "Shift" }, "m", --{{{
        function ()
            local c = awful.client.restore()
            if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
            end
        end,
        { description = "restore minimized", group = "client"}
    ) --}}}
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keys.globalkeys = gears.table.join(
        keys.globalkeys,
        awful.key({ modkey }, "#" .. i + 9, --{{{
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  { description = "view tag #"..i, group = "tag"}
        ), --}}}
        awful.key({ modkey, "Control" }, "#" .. i + 9, --{{{
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  { description = "toggle tag #" .. i, group = "tag"}
        ), --}}}
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function () --{{{ 
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  { description = "move focused client to tag #"..i, group = "tag"}
        ), --}}}
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, --{{{
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  { description = "toggle focused client on tag #" .. i, group = "tag"}
        ) --}}}
    )
end

keys.clientbuttons = gears.table.join( --{{{
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
) --}}}

-- The new RESIZE Mode:
keys.globalkeys2 = gears.table.join( --{{{
    awful.key({}, "h", --{{{
        function()
            local c = client.focus
            if c.floating then
                c:relative_move( 20, 0, -40, 0 )
            --elseif c == awful.client.getmaster() then
            --    awful.tag.incmwfact(0.05)
            else
                awful.tag.incmwfact(0.05)
                -- awful.client.incwfact(-0.05)
            end
        end,
        { description =  "lol", group = "lol" } 
    ), --}}}
    awful.key({}, "j", --{{{
        function()
            local c = client.focus
            if c.floating then
                c:relative_move( 0, 20, 0, -40 )
            elseif c == awful.client.getmaster() then
                --awful.tag.incmwfact(-0.05)
            else
                awful.client.incwfact(-0.05)
            end
        end,
        { description =  "lol", group = "lol" } 
    ), --}}}
    awful.key({}, "k", --{{{
        function()
            local c = client.focus
            if c.floating then
                c:relative_move( 0, -20, 0, 40 )
            elseif c == awful.client.getmaster() then
                --awful.tag.incmwfact(-0.05)
            else
                awful.client.incwfact(0.05)
            end
        end,
        { description =  "lol", group = "lol" } 
    ), --}}}
    awful.key({}, "l", --{{{
        function()
            local c = client.focus
            if c.floating then
                c:relative_move( -20, 0, 40, 0 )
            --elseif c == awful.client.getmaster() then
            --    awful.tag.incmwfact(-0.05)
            else
                awful.tag.incmwfact(-0.05)
                --awful.client.incwfact(-0.05)
            end
        end,
        { description =  "lol", group = "lol" } 
    ), --}}}
    awful.key({}, "Escape", --{{{
        function()
            root.mode = 'default'
            root.keys(keys.globalkeys)
            mode_popup.visible = false
        end,
        { description = "lol", group = "lol" } 
    ) --}}}
) --}}}

return keys
