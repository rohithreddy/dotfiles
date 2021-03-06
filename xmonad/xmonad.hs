 
import XMonad
import XMonad.Config.Desktop
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Monoid
 
import XMonad.Actions.CycleWS
import XMonad.Actions.FlexibleResize as Flex
import XMonad.Actions.Search
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo
import XMonad.Actions.GridSelect
import qualified XMonad.Actions.Submap as SM


import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks  
import XMonad.Hooks.UrgencyHook 
import XMonad.Hooks.ScreenCorners
 
import XMonad.Layout.LayoutHints
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowArranger
import XMonad.Layout.Mosaic
import XMonad.Layout.Circle
import XMonad.Layout.Grid
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Named         -- custom layout names
 
import XMonad.Prompt
import XMonad.Prompt.Layout
import XMonad.Prompt.Input
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Shell
import XMonad.Prompt.Window
 
import XMonad.Util.Run
import XMonad.Util.Font
import XMonad.Util.Themes
import XMonad.Util.Scratchpad
import XMonad.Util.WorkspaceCompare
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86


import System.Environment
import System.Cmd
import System.IO
import System.Exit
import Control.Concurrent

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- terminals
    [ ((modMask,                 xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask,   xK_Return), spawn "terminology")

    -- launcher
    , ((modMask .|. shiftMask,   xK_p), spawn "gmrun")
 
    -- file manager
    --, ((modMask,                 xK_Up    ), runOrRaise "nautilus ~" (className =? "Nautilus"))
    --, ((modMask .|. shiftMask,   xK_Up    ), spawn "nautilus ~")
    , ((modMask,                 xK_Up    ), spawn "nautilus ~")
 
     
    -- shell/window prompts
    , ((modMask,                 xK_F2 ), runOrRaisePrompt mySP)

    -- Volume keys 
    , ((0, 0x1008ff11), spawn "amixer -q set Master 5%-")
    , ((0, 0x1008ff13), spawn "amixer -q set Master 5%+")
    , ((0, 0x1008ff12), spawn "amixer -q set Master toggle")

    -- browser
    , ((modMask,               xK_f     ), runOrRaise
        "firefox" (className =? "Firefox"))  
     -- browser
    , ((modMask,               xK_c     ), runOrRaise
        "google-chrome-stable"(className =? "Chrome"))  
 
    -- print screen
    , ((0,                     xK_Print ), unsafeSpawn "scrot -e 'mv $f ~/Pictures'")
 
 
    -- cycle through workspaces
    , ((modMask,               xK_Right ), moveTo Next (WSIs (return $ not . (=="SP") . W.tag)))
    , ((modMask,               xK_Left  ), moveTo Prev (WSIs (return $ not . (=="SP") . W.tag)))
 
    -- move windows through workspaces
    , ((modMask .|. shiftMask, xK_Right ), shiftTo Next (WSIs (return $ not . (=="SP") . W.tag)))
    , ((modMask .|. shiftMask, xK_Left  ), shiftTo Prev (WSIs (return $ not . (=="SP") . W.tag)))
    , ((modMask .|. controlMask, xK_Right), shiftTo Next EmptyWS)
    , ((modMask .|. controlMask, xK_Left), shiftTo Prev EmptyWS)
 
    -- Rotate through layouts
    , ((modMask,               xK_space ), sendMessage NextLayout)
 

    -- Move focus to the next/previous window
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((mod1Mask,              xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp)
    , ((mod1Mask .|. shiftMask, xK_Tab  ), windows W.focusUp)
 
    -- Swap the focused window with next/prev window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown)
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp)
 
    -- Shrink/Expand the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)
    , ((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_l     ), sendMessage MirrorExpand)
 
    -- Swap the focused window and the master window
    , ((modMask,            xK_semicolon), windows W.swapMaster)
 
    -- Increment/Deincrement the number of windows in the master area
    , ((modMask,               xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask,               xK_period), sendMessage (IncMasterN (-1)))
 
    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)
    -- Reset layout of current workspace
    , ((modMask .|. shiftMask, xK_n     ), setLayout $ XMonad.layoutHook conf)
 
 
    -- Mosaic
    , ((modMask , xK_a                  ), sendMessage Taller)
    , ((modMask , xK_z                  ), sendMessage Wider)
    , ((modMask .|. controlMask, xK_n   ), sendMessage Reset)
    
    --Grid Select
    , ((modMask , xK_g			), goToSelected  $ gsconfig1 )
 
    -- toggle focused window fullscreen
    , ((modMask,               xK_m     ), sendMessage (Toggle "Full"))
 
    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
    --, ((modMask .|. shiftMask, xK_s     ), sendMessage Arrange)
 
    -- toggle the status bar gap
    , ((modMask,               xK_b     ), sendMessage ToggleStruts)
 
    -- close focused window
    , ((modMask .|. shiftMask,  xK_c     ), kill)
 
    -- Restart xmonad
    , ((modMask              , xK_q     ),
        broadcastMessage ReleaseResources >> restart "xmonad" True)

 -- Logout of  xmonad
    , ((modMask .|. shiftMask , xK_q     ),io (exitWith ExitSuccess))
    ]
 
    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [ ((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)] ]
 
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)] ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) ]
 


-- Tags/Workspaces
-- clickable workspaces via dzen/xdotool
myWorkspaces            :: [String]
myWorkspaces            = clickable . (map dzenEscape) $ ["1","2","3","4","5","6","7","8","9"]
 
  where clickable l     = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
                            (i,ws) <- zip [1..] l,
                            let n = i ]

--Custom Taffy Bar colors 

--myTaffyBarPP = taffybarDefaultPP {
--    ppCurrent = taffybarColor "#f8f8f8" "DodgerBlue4"   . wrap " " " "
--  , ppVisible = taffybarColor "#f8f8f8" "LightSkyBlue4" . wrap " " " "
--  , ppUrgent  = taffybarColor "#f8f8f8" "red4"          . wrap " " " "
-- , ppLayout  = taffybarColor "DarkOrange" "" . wrap " [" "] "
--, ppTitle   = taffybarColor "#61ce3c" "" . shorten 50
--}


-- shell prompt theme
mySP = defaultXPConfig
    { bgColor           = "black"
    , fgColor           = "white"
    , bgHLight          = "gray"
    , fgHLight          = "black"
    , borderColor       = "orange"
    , promptBorderWidth = 1
    , position          = Bottom
    , height            = 20
    --, autoComplete      = Just 1000
    , historySize       = 1000 }

-- layouts
myLayout = toggleLayouts (noBorders Full) $ tiled ||| Circle ||| simpleFloat ||| Grid  ||| layoutHints (tabbed shrinkText myTab) ||| mosaic 2 [3,2]
  where
        tiled   = ResizableTall nmaster delta ratio []
        nmaster = 1
        delta   = 3/100
        ratio   = 1/2

-- special windows
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Pidgin"         --> doFloat
    , title     =? "glxgears"       --> doFloat
    , title 	=? "inferno"	    --> doFloat
    , title     =? "Contact List"   --> doFloat
    , className =? "Empathy"        --> doFloat
    , className =? "Gnome-panel"    --> doIgnore
    , className =? "XVkbd"          --> doIgnore
    , className =? "Cellwriter"     --> doIgnore
    , className =? "Gtkdialog"      --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , isFullscreen 		    --> doFullFloat
    --                                      x y w h
    , scratchpadManageHook $ W.RationalRect 0 0 1 0.42
    , manageDocks ] <+> manageHook defaultConfig
 
-- Grid Select Section
--gsconfig2 colorizer = (buildDefaultGSConfig colorizer) { gs_cellheight = 60 ,gs_cellwidth = 250, gs_font = "xft:Droid Sans:pixelsize=20",gs_cellpadding = 5 }
gsconfig1  = defaultGSConfig  { gs_cellheight = 60 ,gs_cellwidth = 250, gs_font = "xft:Cantarell Bold:pixelsize=18",gs_cellpadding = 5 }


-- | A green monochrome colorizer based on window classimport XMonad.Layout.IM
myColorizer = colorRangeFromClassName
                      (0x57,0xFF,0x1F) -- lowest inactive bg
                      (0x24,0x57,0xFF) -- highest inactive bg
                      (0x52,0x37,0xA4) -- active bg
                      black            -- inactive fg
                      white            -- active fg
   where black = minBound
         white = maxBound
 



appFontXft :: String
appFontXft = "xft:Cantarell Bold:pixelsize=9" 
--appFontXft = concat [ "xft:"
                     --,"Sans:"
					 --,"pixelsize=11:"
					 --,"weight=regular:"
					 --,"width=semicondensed:"
					 --,"dpi=96:hinting=true:"
					 --,"hintstyle=hintslight:"
					 --,"antialias=true:"
					 --,"rgba=rgb:"
					 --,"lcdfilter=lcdlight"]
-- Color of current window title in xmobar.--#FFB6B0
xmobarTitleColor = "red"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "red"



-- decoration theme
myDeco = defaultTheme
    { activeColor         = "orange"
    , inactiveColor       = "#222222"
    , urgentColor         = "yellow"
--    , activeBorderColor   = "orange"
    , activeBorderColor   = "blue"
    , inactiveBorderColor = "#222222"
    , urgentBorderColor   = "yellow"
    , activeTextColor     = "orange"
    , inactiveTextColor   = "#222222"
    , urgentTextColor     = "yellow"
    , decoHeight          = 10 }


myEventHook e = do
		screenCornerEventHook e

 
myStartupHook = do
		spawn "/usr/lib/unity-settings-daemon/unity-settings-daemon"
--		spawn "/usr/libexec/notification-daemon"
--		spawn "thermald --no-daemon --dbus-enable"
		spawn "/usr/libexec/gnome-fallback-mount-helper"
--		spawn "/usr/local/bin/tomate"
		spawn "/usr/bin/gnome-sound-applet"
--		spawn "whenjobs --daemon-start"
		spawn "/usr/bin/nm-applet"
		spawn "/usr/bin/synapse"
		spawn "taffybar"
		spawn "/usr/bin/start-pulseaudio-x11"
		spawn "/usr/bin/gsettings-data-convert"
		spawn "/usr/bin/xdg-user-dirs-gtk-update"
		spawn "/usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 200 --widthtype pixel  --transparent true --height 22"
		spawn "/usr/bin/compton"
		spawn "/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh"
--		spawn "/usr/bin/tasque"
--		spawn "/bin/bash /root/scriptz/synclient.sh"
		spawn "/usr/bin/zim"
--		spawn "/usr/local/bin/artha"


-- tab theme
myTab = defaultTheme
    { activeColor         = "black"
    , inactiveColor       = "black"
    , urgentColor         = "yellow"
    , activeBorderColor   = "orange"
    , inactiveBorderColor = "#222222"
    , urgentBorderColor   = "black"
    , activeTextColor     = "orange"
    , inactiveTextColor   = "#222222"
    , urgentTextColor     = "yellow" }

--myLogHook = ewmhDesktopsLogHookCustom scratchpadFilterOutWorkspace >> updatePointer Nearest
myLogHook h = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }

myDzenStatus = "dzen2 -w '600' -ta 'l'" ++ myDzenStyle
myDzenConky  = "conky -c ~/.xmonad/conkyrc | dzen2 -x '600' -w '650' -ta 'r'" ++ myDzenStyle
myDzenStyle  = " -h '22' -fg '#777777' -bg '#222222' -fn 'Cantarell Bold:size=9'"
--myStartMenu = "/home/roh/.xmonad/start /home/roh/.xmonad/start_apps"

myDzenPP  = dzenPP
    { ppCurrent = dzenColor "#3399ff" "" . wrap " " " " 
    , ppHidden  = dzenColor "#dddddd" "" . wrap " " " " 
    , ppHiddenNoWindows = dzenColor "#777777" "" . wrap " " " "
    , ppUrgent  = dzenColor "#ff0000" "" . wrap " " " "
    , ppSep     = "     "
    , ppLayout  = dzenColor "#afd700" "#303030" . wrap "^ca(1,xdotool key super+space)· " " ·^ca()"
    , ppTitle   = dzenColor "#ffffff" "" 
                    . wrap "^ca(1,xdotool key super+k)^ca(2,xdotool key super+shift+c)"
                           "                          ^ca()^ca()" . dzenEscape 
    }


main = do
	status <- spawnPipe myDzenStatus    -- xmonad status on the left
        conky  <- spawnPipe myDzenConky     -- conky stats on the right
--	dzenStartMenu	<- spawnPipe myStartMenu
	env <- getEnvironment
	case lookup "DESKTOP_AUTOSTART_ID" env of
        	Just id -> do
        	    forkIO $ (>> return ()) $ rawSystem "dbus-send" ["--session","--print-reply=string","--dest=org.gnome.SessionManager","/org/gnome/SessionManager","org.gnome.SessionManager.RegisterClient","string:xmonad","string:"++id]
        	    return ()
        	Nothing -> return ()
	xmonad $ withUrgencyHook NoUrgencyHook $ desktopConfig {
			     terminal           = "gnome-terminal"
                           , borderWidth        = 1
                           , normalBorderColor  = "black"
                           , focusedBorderColor = "orange"
                           , focusFollowsMouse  = True
                           , modMask            = mod4Mask
                           , keys               = myKeys
			   , mouseBindings      = myMouseBindings
			   , workspaces = myWorkspaces
			   , startupHook	= myStartupHook <+> ewmhDesktopsStartup >> setWMName "LG3D"
                           , layoutHook         =  smartBorders $avoidStruts $ myLayout
                           , manageHook         =  manageDocks <+> myManageHook 
							 <+> manageHook defaultConfig
                           , handleEventHook    = myEventHook <+> fullscreenEventHook <+> handleEventHook desktopConfig
			   , logHook 		= myLogHook status
			   }
