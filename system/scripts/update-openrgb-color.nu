let accent_color = (caelestia scheme get | lines | get 6 | parse "{foo}: {bar}" | get bar | get 0 | ansi strip)
echo $accent_color
openrgb --color $accent_color
