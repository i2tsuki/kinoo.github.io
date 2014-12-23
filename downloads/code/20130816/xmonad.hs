main :: IO ()
main = do
    xmonad $ defaultConfig
        layoutHook = smartBorders $ mkToggle1 FULL $ desktopLayoutModifiers (named "V" tall ||| (named "H" $ Mirror tall))
