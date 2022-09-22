import Control.Monad (forM_, join, liftM2)
import Data.Function (on)
import Data.List (sortBy)
import qualified Data.Map as M
import Data.Monoid
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce

myTerminal = "kitty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 3

myModMask = mod1Mask

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myNormalBorderColor = "#1A1A1A"

myFocusedBorderColor = "#8218c4"

toggleFull =
  withFocused
    ( \windowId -> do
        floats <- gets (W.floating . windowset)
        if windowId `M.member` floats
          then withFocused $ windows . W.sink
          else withFocused $ windows . (flip W.float $ W.RationalRect 0 0 1 1)
    )

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                ]
  where
    spawnTerm  = myTerminal ++ " -T scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.7
                 w = 0.7
                 t = 0.85 -h
                 l = 0.85 -w

myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    [ -- open browser
      ((modm, xK_b), spawn "qutebrowser"),
      -- open calculater
      ((modm, xK_c), spawn "qalculate-gtk"),
      -- open PcmanFM
      ((modm, xK_f), spawn "pcmanfm"),
      -- open kde colour picker
      ((modm, xK_p), spawn "kcolorchooser"),
      -- Volume control
      ((0, 0x1008ff11), spawn "pamixer --allow-boost -d 5"), --Folume down
      ((0, 0x1008ff13), spawn "pamixer --allow-boost -i 5"), --Folume up
      ((0, 0x1008ff12), spawn "pamixer -t"), --Mute Toggle
      ((0, 0x1008ffb2), spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle"), --Mic Toggle

      --Brightness control
      ((0, 0x1008ff02), spawn "light -A 10"), --Brightness Up
      ((0, 0x1008ff03), spawn "light -U 10"), --Brightness Up

      --Media Control
      ((0, 0x1008ff14), spawn "playerctl play-pause"), -- Play/Pause
      ((0, 0x1008ff16), spawn "playerctl previous"), -- Play/Pause
      ((0, 0x1008ff17), spawn "playerctl next"), -- Play/Pause

      -- Take screenshot
      ((0, 0xff61), spawn "flameshot gui"),
      -- Lock screen
      ((mod4Mask, xK_l), spawn "betterlockscreen --lock"),
      ((mod4Mask, xK_F5), spawn "/home/$USER/.config/script/refreshXmonad.sh"),
      ((mod4Mask, xK_F6), spawn "/home/$USER/.config/script/toggelTuchpad.sh"),
      ((mod4Mask, xK_F7), spawn "/home/$USER/.config/script/ariplaneMode.sh"),
      ((mod4Mask, xK_F10), spawn "arandr"),
      -- launch a terminal
      ((modm, xK_Return), spawn $ XMonad.terminal conf),
      ((modm, xK_backslash), namedScratchpadAction myScratchPads "terminal"),
      -- launch rofi
      ((modm, xK_d), spawn "rofi -no-lazy-greb -show drun -icon-theme 'Papirus' -show-icons"),
      -- launch a scrachpad
      ((modm .|. shiftMask, xK_s), spawn "kitty --class=scratchpad"),
      -- close focused window
      ((modm, xK_q), kill),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Move focus to the next window
      ((modm, xK_Tab), windows W.focusDown),
      -- Move focus to the next window
      ((modm, xK_j), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_k), windows W.focusUp),
      -- Move focus to the master window
      ((mod4Mask, xK_m), windows W.focusMaster),
      -- Swap the focused window and the master window
      ((modm .|. shiftMask, xK_m), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_k), windows W.swapUp),
      -- Shrink the master area
      ((modm .|. controlMask, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm .|. controlMask, xK_l), sendMessage Expand),
      -- toggle between full screen and tieling
      ((modm, xK_t), toggleFull),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      -- Quit xmonad
      ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess)),
      -- Restart xmonad
      ((modm .|. shiftMask, xK_r), spawn "xmonad --recompile; xmonad --restart")
    ]
      ++
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_l, xK_h] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]

myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        ( \w ->
            focus w >> mouseMoveWindow w
              >> windows W.shiftMaster
        )
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        ( \w ->
            focus w >> mouseResizeWindow w
              >> windows W.shiftMaster
        )
      )
    ]

myLayout = mySpacing $ avoidStruts (tiled ||| Mirror tiled ||| noBorders Full ||| spiral (6 / 7) ||| ThreeCol 1 (3 / 100) (1 / 2))
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

mySpacing =
  spacingRaw
    False -- Only for >1 window
    -- The bottom edge seems to look narrower than it is
    (Border 30 3 3 3) -- Size of screen edge gaps
    True -- Enable screen edge gaps
    (Border 3 3 3 3) -- Size of window gaps
    True -- Enable window gaps

myManageHook =
  composeAll
    [ className =? "Gimp" --> doFloat,
      className =? "Qalculate-gtk" --> doFloat,
      className =? "Pavucontrol" --> doFloat,
      className =? "Minecraft Launcher" --> doShift "8",
      className =? "YouTube Music" --> doShift "9",
      className =? "Thunar" --> viewShift "5",
      resource =? "desktop_window" --> doIgnore,
      resource =? "kdesktop" --> doIgnore
    ]
  <+> namedScratchpadManageHook myScratchPads
  where
    viewShift = doF . liftM2 (.) W.greedyView W.shift

myEventHook = swallowEventHook (className =? "kitty" <||> className =? "Termite") (return True)

myLogHook = do
  winset <- gets windowset
  title <- maybe (return "") (fmap show . getName) . W.peek $ winset
  let currWs = W.currentTag winset
  let wss = map W.tag $ W.workspaces winset
  let wsStr = join $ map (fmt currWs) $ sort' wss

  io $ appendFile "/tmp/.xmonad-title-log" (title ++ "\n")
  io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")
  where
    fmt currWs ws
      | currWs == ws = "[" ++ ws ++ "]"
      | otherwise = " " ++ ws ++ " "
    sort' = sortBy (compare `on` (!! 0))

myHandleEventHook = swallowEventHook (className =? "kitty" <||> className =? "Termite") (return True)

myStartupHook = do
  spawnOnce "caffeine &"
  spawnOnce "/home/$USER/.config/script/redshift.sh &"
  spawnOnce "xss-lock /home/$USER/.config/script/betterlockscreen.sh  &"
  spawnOnce "nextcloud --background &"
  spawnOnce "fcitx -d &"
  spawnOnce "copyq --start-server"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  spawnOnce "nm-applet &"
  spawnOnce "picom --backend glx &"
  spawnOnce "nitrogen --restore &"

myPP = def {ppCurrent = xmobarColor "black" "whight"}

mainBar = statusBarPropTo "_XMONAD_LOG_1" "polybar barbase1" (pure myPP)

secondBar = statusBarPropTo "_XMONAD_LOG_2" "polybar barbase2" (pure myPP)

barSpawner :: ScreenId -> IO StatusBarConfig
barSpawner 0 = pure $ mainBar
barSpawner 1 = pure $ secondBar
barSpawner _ = mempty

main = do
  xmonad $
    docks $
      ewmhFullscreen $
        ewmh $
          dynamicSBs
            barSpawner
            def
              { -- simple stuff
                terminal = myTerminal,
                focusFollowsMouse = myFocusFollowsMouse,
                clickJustFocuses = myClickJustFocuses,
                borderWidth = myBorderWidth,
                modMask = myModMask,
                workspaces = myWorkspaces,
                normalBorderColor = myNormalBorderColor,
                focusedBorderColor = myFocusedBorderColor,
                -- key bindings
                keys = myKeys,
                mouseBindings = myMouseBindings,
                -- hooks, layouts
                layoutHook = smartBorders $ myLayout,
                manageHook = myManageHook <+> scratchpadManageHook (W.RationalRect 0.4 0.3 0.6 0.5),
                handleEventHook = myEventHook,
                logHook = myLogHook >> updatePointer (0.5, 0.5) (0, 0),
                startupHook = myStartupHook -- dynStatusBarStartup barInScreen (return ())
              }
  forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> do
    safeSpawn "mkfifo" ["/tmp/" ++ file]
