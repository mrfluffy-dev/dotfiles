--imports

import XMonad
import Data.Monoid
import Data.List (sortBy)
import Data.Function (on)
import XMonad.Hooks.DynamicBars ( dynStatusBarStartup, dynStatusBarEventHook, multiPP )
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicBars 
import Control.Monad (forM_, join)
import Control.Monad (liftM2)
import System.Exit
import System.IO
import XMonad.Util.SpawnOnce
import XMonad.Util.Scratchpad
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Util.NamedWindows (getName)
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig
import XMonad.Layout.Spacing
import XMonad.Actions.UpdatePointer
import XMonad.Actions.SwapWorkspaces
import qualified XMonad.StackSet as W
import qualified Data.Map        as M



-- import qualified XMonad.Layout.IndependentScreens as XLI

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1:MAIN","2:DEV","3:WWW","4:TERM","5:TEXT","6:FOLDER","7:SCHOOL","8:GAMES","9:MUSIC"] 

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#1A1A1A"
myFocusedBorderColor = "#8218c4"

-- Looks to see if focused window is floating and if it is the places it in the stack 
-- else it makes it floating but as full screen
toggleFull = withFocused (\windowId -> do
                              { floats <- gets (W.floating . windowset);
                                if windowId `M.member` floats
                                then withFocused $ windows . W.sink
                                else withFocused $ windows . (flip W.float $ W.RationalRect 0 0 1 1) })


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- open configs
    [ --((modm, xK_x     ), spawn "alacritty -e nvim /home/$USER/.xmonad/xmonad.hs ; alacritty -e nvim /home/$USER/.config/polybar/config")

    -- open browser 
    ((modm, xK_b     ), spawn "qutebrowser")

    -- open messinging app (ferdi)
    ,((modm, xK_c      ), spawn "qalculate-gtk")

    -- open PcmanFM
    , ((modm, xK_f     ), spawn "pcmanfm")

    -- open mailspring
    , ((modm, xK_e     ), spawn "mailspring")

    -- open kde colour picker
    , ((modm, xK_p     ), spawn "kcolorchooser")

    -- Open youtube music
    ,((modm, xK_m     ), spawn "youtube-music")

    -- Volume control
    , ((0,0x1008ff11), spawn "pamixer --allow-boost -d 5") --Folume down
    , ((0,0x1008ff13), spawn "pamixer --allow-boost -i 5") --Folume up
    , ((0,0x1008ff12), spawn "pamixer -t") --Mute Toggle
    , ((0,0x1008ffb2), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle") --Mic Toggle

    --Brightness control
    , ((0,0x1008ff02), spawn "light -A 10") --Brightness Up
    , ((0,0x1008ff03), spawn "light -U 10") --Brightness Up

    --Media Control
    , ((0,0x1008ff14), spawn "playerctl play-pause") -- Play/Pause
    , ((0,0x1008ff16), spawn "playerctl previous") -- Play/Pause
    , ((0,0x1008ff17), spawn "playerctl next") -- Play/Pause

    -- Take screenshot
    , ((0,0xff61), spawn "flameshot gui")

    -- Lock screen
    , ((mod4Mask, xK_l), spawn "betterlockscreen --lock")
    , ((mod4Mask, xK_F5), spawn "/home/$USER/.config/script/refreshXmonad.sh")
    , ((mod4Mask, xK_F6), spawn "/home/$USER/.config/script/toggelTuchpad.sh")
    , ((mod4Mask, xK_F7), spawn "/home/$USER/.config/script/ariplaneMode.sh")
    , ((mod4Mask, xK_F10), spawn "arandr")
    

    -- launch a terminal
    , ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm, xK_backslash), scratchpadSpawnActionTerminal "alacritty -class scratchpad")

    -- launch rofi
    , ((modm,               xK_d     ), spawn "rofi -no-lazy-greb -show drun -icon-theme 'Papirus' -show-icons")

    -- launch a scrachpad
    , ((modm .|. shiftMask, xK_s     ), spawn "alacritty --class scratchpad")


    -- close focused window
    , ((modm, xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((mod4Mask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_m     ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm .|. controlMask, xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm .|. controlMask, xK_l     ), sendMessage Expand)

    -- toggle between full screen and tieling
    , ((modm,               xK_t     ), toggleFull)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "killall polybar; killall polybar; killall picom; xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_l, xK_h] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    -- swap workspaces between desktosa
    -- ++
    -- [((modm .|. controlMask, k), windows $ swapWithCurrent i)
    --     | (i, k) <- zip workspaces [xK_1 ..]]



------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
mySpacing = spacingRaw False             -- Only for >1 window
                       -- The bottom edge seems to look narrower than it is
                       (Border 30 3 3 3) -- Size of screen edge gaps
                       True             -- Enable screen edge gaps
                       (Border 3 3 3 3) -- Size of window gaps
                       True             -- Enable window gaps



myLayout =  mySpacing $ avoidStruts ( tiled ||| Mirror tiled |||  noBorders Full ||| spiral (6/7) ||| ThreeCol 1 (3/100) (1/2))
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    
    , className =? "Gimp"           --> doFloat
    , className =? "Qalculate-gtk"     --> doFloat
    , className =? "Nextcloud"      --> doFloat
    , className =? "Pavucontrol"    --> doFloat
    , className =? "Nm-connection-editor"       --> doFloat
    , className =? "vlc"            --> doFloat
    , className =? "Alert"          --> doFloat
    , className =? "jetbrains-clion"--> doFloat
    , className =? "yakuake"        --> doFloat
    , className =? "Imager"         --> doFloat
    -- , className =? "krunner"        --> doFloat
    , className =? "jetbrains-clion"--> doShift "2:DEV"
    , className =? "Code"           --> doShift "2:DEV"
    , className =? "Oni2_editor"    --> viewShift "2:DEV"
    , className =? "Brave-browser"  --> doShift "3:WWW"
    , className =? "firefox"        --> viewShift "3:WWW"
    , className =? "okular"         --> viewShift "5:TEXT"
    -- ,className  =? "okular"         --> viewShift "5:TEXT"
    , className =? "Minecraft Launcher"         --> doShift "8:GAMES"
    , className =? "Microsoft Teams - Preview"  --> doShift "7:SCHOOL"
    , className =? "YouTube Music"  --> doShift "9:MUSIC"
    , className =? "Pcmanfm"        --> doShift "6:FOLDER"
    , className =? "dolphin"        --> viewShift "6:FOLDER"
    -- , className =? "Thunar"         --> viewShift "5:TEXT"
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ]
    where viewShift = doF . liftM2 (.) W.greedyView W.shift

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = handleEventHook def <+> fullscreenEventHook <+> dynStatusBarEventHook barInScreen (spawn "killall polybar; killall polybar")

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = do
  winset <- gets windowset
  title <- maybe (return "") (fmap show . getName) . W.peek $ winset
  let currWs = W.currentTag winset
  let wss = map W.tag $ W.workspaces winset
  let wsStr = join $ map (fmt currWs) $ sort' wss

  io $ appendFile "/tmp/.xmonad-title-log" (title ++ "\n")
  io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")

  where fmt currWs ws
          | currWs == ws = "[" ++ ws ++ "]"
          | otherwise    = " " ++ ws ++ " "
        sort' = sortBy (compare `on` (!! 0))


barInScreen :: ScreenId -> IO Handle
barInScreen (S 0) = do
    spawn "sleep 2; polybar MainWithTray"
    spawn "killall picom"
    spawn "sleep 1; picom --backend glx &"
    spawnPipe "cat >> /tmp/.xmonad-workspace-log"
    
barInScreen (S 1) = do
    spawn "sleep 3; polybar SeconderyWitNoTray"
    spawn "killall picom"
    spawn "sleep 1 ; picom --backend glx &"
    spawnPipe "cat >> /tmp/.xmonad-workspace-hdmi-log"
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.

myStartupHook = do
        spawnOnce "/home/$USER/.config/script/redshift.sh &"
--	spawnOnce "/homme/$USER/.config/scripr/docked.sh &"
        spawnOnce "xss-lock /home/$USER/.config/script/betterlockscreen.sh  &"
        spawnOnce "nextcloud --background &"
        spawnOnce "fcitx5 -d &"
        spawnOnce "copyq --start-server"
        --spawnOnce "mailspring -b &"
--        spawnOnce "/home/$USER/.config/script/audio.sh &"
        spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
        --"/home/$USER/.config/script/plkit.sh &"
        -- spawnOnce "powerkit &"
        -- spawnOnce "birdtray &"
        spawnOnce "nm-applet &"
        -- spawnOnce "connman-ui-gtk &"
        -- spawnOnce "yakuake &"
        -- spawnOnce "sh /home/$USER/.config/script/polybar-open.sh"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  spawn "picom --backend glx &"
  spawn "nitrogen --restore &"
  -- xmproc <- spawnPipe "polybar barbase" --"xmobar -x 0 /home/$USER/.config/xmobar/xmobar.config"
  -- xmproc <- spawnPipe "polybar barbase2"
  -- xmproc <- spawnPipe "xmobar -x 1 /home/$USER/.config/xmobar/xmobar.config"
  xmonad $ docks $ ewmh    def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings ,

      -- hooks, layouts
        layoutHook         = smartBorders $ myLayout,
        manageHook         = myManageHook <+> scratchpadManageHook (W.RationalRect 0.4 0.3 0.6 0.5),
        handleEventHook    = myEventHook,
        logHook            = myLogHook >> updatePointer (0.5, 0.5) (0, 0),
        startupHook        = myStartupHook  <+> dynStatusBarStartup barInScreen (return ())
    }
  forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> do 
    safeSpawn "mkfifo" ["/tmp/" ++ file]

 -- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--


-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
