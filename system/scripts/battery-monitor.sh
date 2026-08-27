BAT_DIR="$(find -L /sys/class/power_supply -maxdepth 1 -type d -name 'BAT*' -print -quit)"
if [ -z "$BAT_DIR" ]; then
  exit 0
fi

last_notified_level=0

while true; do
  props="$(udevadm info -q property -p "$BAT_DIR")"
  capacity="$(printf '%s\n' "$props" | awk -F= '/^POWER_SUPPLY_CAPACITY=/{print $2; exit}')"
  status="$(printf '%s\n' "$props" | awk -F= '/^POWER_SUPPLY_STATUS=/{print $2; exit}')"

  if [ -z "$capacity" ] || [ -z "$status" ]; then
    udevadm monitor --subsystem-match=power_supply --property | grep -m 1 "POWER_SUPPLY_CAPACITY=" >/dev/null
    continue
  fi

  if [ "$status" = "Discharging" ]; then
    if [ "$capacity" != "$last_notified_level" ]; then
      # 15% - Low Battery
      if [ "$capacity" -le 15 ] && [ "$capacity" -gt 5 ]; then
        if [ "$capacity" -eq 15 ] || [ "$last_notified_level" -gt 15 ]; then
          notify-battery
          swayosd-client --custom-text="Battery low ($capacity)" --custom-icon=battery
        fi

      # 5% - Critical
      elif [ "$capacity" -le 5 ] && [ "$capacity" -gt 2 ]; then
        if [ "$capacity" -eq 5 ] || [ "$last_notified_level" -gt 5 ]; then
          notify-send -u critical "Battery Critical" "Level is at ${capacity}%. Connect charger!"
          swayosd-client --custom-text="Battery Critical ($capacity)" --custom-icon=battery
        fi

      # 2% - Sleep
      elif [ "$capacity" -le 2 ]; then
        notify-send -u critical "Battery Dying" "Suspending system now..."
        sleep 2
        systemctl suspend
      fi

      last_notified_level=$capacity
    fi
  else
    last_notified_level=100
  fi

  udevadm monitor --subsystem-match=power_supply --property | grep -m 1 "POWER_SUPPLY_CAPACITY=" >/dev/null
done
