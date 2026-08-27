let expansions = [
  [key value];
  ["mdash" —]
  ["name" "Francesco Prem Solidoro"]
  ["sign" "Kindest Regards,\nFrancesco Prem Solidoro"]
]
let chosen_key = $expansions.key | to text | fuzzel --dmenu
if ($chosen_key | is-empty) { exit 0 }

let chosen_value = ($expansions | where key == $chosen_key | get value.0)
let lines = ($chosen_value | lines)

for line in $lines {
  wtype $line
  if $line != ($lines | last) {
    wtype -k Return
  }
}
