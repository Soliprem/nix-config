let bat_dirs = (ls /sys/class/power_supply | where name =~ "BAT")
if ($bat_dirs | length) == 0 { exit 0 }
let bat_dir = ($bat_dirs | get 0 | get name)
let BATTERY_LEVEL = (open $"($bat_dir)/capacity" | into int)
swayosd-client --custom-progress=($BATTERY_LEVEL / 100) --custom-progress-text=$"($BATTERY_LEVEL)%" --custom-icon=battery
