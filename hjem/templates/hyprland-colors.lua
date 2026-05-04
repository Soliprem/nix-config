local image = "{{image}}"
<* for name, value in colors *>
local {{name}} = "rgba({{value.default.hex_stripped}}ff)"
<* endfor *>
