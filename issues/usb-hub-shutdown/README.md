# 2.4GHz Dongle USB Power Fix

Notes + setup for the Ajazz AK820 Pro 2.4GHz receiver on an ASUS ROG Zephyrus M (GU502GU), Arch Linux.

## Problem

The AK820 Pro's 2.4GHz dongle (Microdia `0c45:fdfd`) goes dead and needs a physical replug.

- The USB layer is fine — the dongle enumerates and answers descriptors normally.
- The radio side gets stuck whenever the dongle sits **powered but without an active USB host** (across shutdown or suspend — e.g. the laptop keeps the USB-C port powered while off, so the dock stays live overnight).
- Only an actual VBUS power cut recovers it; a USB re-config (`authorized` toggle, unbind/rebind) does not.

Fix: have `uhubctl` power the dongle's hub port **off during sleep/shutdown** and back **on at resume**, so it never sits powered-but-hostless.

## Topology

```
laptop USB-C → Anker 565 dock (VIA hubs) → QinHeng hub (1a86:8091) → dongle
```

- Dongle lives behind the QinHeng, which is on **hub `1-1`, port `3`**.
- The QinHeng is `ganged` (no per-port switching), but hub `1-1` is VIA with `ppps`, so cutting `1-1` port `3` cuts power to the whole QinHeng (dongle + mouse dongle + USB speaker).
- Re-check the location after any hardware/port change: `sudo uhubctl`.

## Prerequisite

```bash
yay -S uhubctl            # AUR; or build from https://github.com/mvp/uhubctl
```

## Install

Just run `./install.sh`.

## What it writes

`/usr/lib/systemd/system-sleep/dongle-power.sh` — off during suspend, on at resume. Disarms the xHCI controller's wake first so the power-off disconnect can't bounce the machine awake.

`/usr/lib/systemd/system-shutdown/dongle-off.sh` — powers the port off on poweroff, covering the case where the laptop keeps USB powered while off.

## Notes

- **Trade-off:** with the xHCI wake disarmed during sleep, only the **power button** wakes the laptop — no USB/keyboard wake. The external keyboard is powered off during sleep anyway.
- Powering off `1-1` port `3` also cuts the mouse dongle and USB speaker during sleep/shutdown; they re-enumerate fine on resume/boot.
- Manual recovery any time: `sudo uhubctl -l 1-1 -p 3 -a cycle -d 2`.
- If suspend still wakes itself, the source is something other than the USB controller (likely the dock's USB-C/UCSI — `failed to register partner alt modes (-70)`); check `cat /sys/power/pm_wakeup_irq` and `/sys/kernel/debug/wakeup_sources` right after a failed suspend.

```

```
