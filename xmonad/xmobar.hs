-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
    font = "xft:Droid Sans-12:antialias=true",
    bgColor = "#000000",
    fgColor = "#5BE400",
    position = TopW L 90,
    lowerOnStart = True,
    commands = [
        Run Weather "VAGO" ["-t","<tempF>F <skyCondition>","-L","64","-H","77","-n","#5BE400","-h","#FE1300","-l","#5BE400"] 36000,
        Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FE1300","-l","#5BE400","-n","#5BE400","-w","3"] 10,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FE1300","-l","#5BE400","-n","#5BE400"] 10,
        Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FE1300","-l","#5BE400","-n","#5BE400"] 10,
        Run Network "eth0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FE1300","-l","#5BE400","-n","#5BE400"] 10,
        Run Date "%a %b %_d %l:%M" "date" 10,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %multicpu%   %memory%   %swap%   %eth0%   <fc=#5BE400>%date%</fc>   %VAGO%"
}
