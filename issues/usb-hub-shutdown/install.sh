#!/usr/bin/env bash
# Installs the 2.4GHz dongle USB-power hooks. Idempotent:
# verifies the expected config, and never overwrites existing hook files.
set -u

# ---- expected configuration (edit if your topology changes) ----
DONGLE_VID="0c45"; DONGLE_PID="fdfd"   # AK820 Pro receiver (Microdia)
HUB_LOC="1-1"                          # VIA hub with per-port power switching (ppps)
HUB_PORT="3"                           # port the QinHeng + dongle sit behind
QINHENG_ID="1a86:8091"                 # device expected on that port
XHCI_PCI="0000:00:14.0"                # USB controller; its wake is disarmed during sleep
SLEEP_HOOK="/usr/lib/systemd/system-sleep/dongle-power.sh"
SHUTDOWN_HOOK="/usr/lib/systemd/system-shutdown/dongle-off.sh"

fail=0
ok()  { echo "  [ok]   $1"; }
bad() { echo "  [FAIL] $1"; fail=1; }

echo "==> Checking requirements and configuration"

UHUBCTL="$(command -v uhubctl || true)"
if [ -n "$UHUBCTL" ]; then ok "uhubctl: $UHUBCTL"; else bad "uhubctl not installed (yay -S uhubctl)"; fi

sudo -v || exit 1

DONGLE_PATH=""
for d in /sys/bus/usb/devices/*/; do
  [ -f "$d/idVendor" ] || continue
  if [ "$(cat "$d/idVendor")" = "$DONGLE_VID" ] && [ "$(cat "$d/idProduct")" = "$DONGLE_PID" ]; then
    DONGLE_PATH="$(basename "$d")"; break
  fi
done
if [ -n "$DONGLE_PATH" ]; then ok "dongle $DONGLE_VID:$DONGLE_PID at $DONGLE_PATH"
else bad "dongle $DONGLE_VID:$DONGLE_PID not found (plug it in)"; fi

case "$DONGLE_PATH" in
  "$HUB_LOC.$HUB_PORT".*) ok "dongle is behind $HUB_LOC port $HUB_PORT" ;;
  "") ;;
  *) bad "dongle at $DONGLE_PATH, expected $HUB_LOC.$HUB_PORT.* (edit HUB_LOC/HUB_PORT)" ;;
esac

QH="/sys/bus/usb/devices/$HUB_LOC.$HUB_PORT"
if [ -f "$QH/idVendor" ] && [ "$(cat "$QH/idVendor"):$(cat "$QH/idProduct")" = "$QINHENG_ID" ]; then
  ok "hub $QINHENG_ID on $HUB_LOC port $HUB_PORT"
else bad "$QINHENG_ID not found at $HUB_LOC.$HUB_PORT"; fi

if [ -n "$UHUBCTL" ] && sudo "$UHUBCTL" -l "$HUB_LOC" -p "$HUB_PORT" >/dev/null 2>&1; then
  ok "uhubctl can switch $HUB_LOC port $HUB_PORT"
else bad "uhubctl cannot switch $HUB_LOC port $HUB_PORT (no ppps?)"; fi

if [ -f "/sys/bus/pci/devices/$XHCI_PCI/power/wakeup" ]; then ok "xHCI $XHCI_PCI present"
else bad "$XHCI_PCI/power/wakeup missing (edit XHCI_PCI)"; fi

if [ "$fail" -ne 0 ]; then
  echo; echo "==> Checks failed -- nothing written. Fix the above and re-run."
  exit 1
fi

echo; echo "==> Config OK. Writing hooks (existing files are left untouched)."
sudo mkdir -p "$(dirname "$SLEEP_HOOK")" "$(dirname "$SHUTDOWN_HOOK")"

if [ -e "$SLEEP_HOOK" ]; then echo "  skip (exists): $SLEEP_HOOK"; else
  sudo tee "$SLEEP_HOOK" >/dev/null <<EOF
#!/bin/sh
case "\$1" in
  pre)
    echo disabled > /sys/bus/pci/devices/$XHCI_PCI/power/wakeup
    $UHUBCTL -l $HUB_LOC -p $HUB_PORT -a off
    ;;
  post)
    $UHUBCTL -l $HUB_LOC -p $HUB_PORT -a on
    echo enabled > /sys/bus/pci/devices/$XHCI_PCI/power/wakeup
    ;;
esac
EOF
  sudo chmod +x "$SLEEP_HOOK"; echo "  wrote: $SLEEP_HOOK"
fi

if [ -e "$SHUTDOWN_HOOK" ]; then echo "  skip (exists): $SHUTDOWN_HOOK"; else
  sudo tee "$SHUTDOWN_HOOK" >/dev/null <<EOF
#!/bin/sh
$UHUBCTL -l $HUB_LOC -p $HUB_PORT -a off
EOF
  sudo chmod +x "$SHUTDOWN_HOOK"; echo "  wrote: $SHUTDOWN_HOOK"
fi

echo; echo "==> Done. Test:  systemctl suspend   (wake with the power button)"
