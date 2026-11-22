# Files, logs and services

Where StandardOS keeps things, and where to look when you want to know what happened. Golem's own pieces keep the name **golem** — `/var/lib/golem`, `golem-autoupdate.service` — because they are its jobs; the tools you type have plain names.

## The machine

| Path | What |
|---|---|
| `/etc/nixos/flake.nix` | The machine's entry point (no inputs) |
| `/etc/nixos/configuration.nix` | This computer — yours to edit |
| `/etc/nixos/hardware-configuration.nix` | File systems, swap, kernel modules, as measured |
| `/etc/nixos/modules/*.nix` | Your own modules, imported automatically |
| `/etc/nixos/machine/facts.json` | The hardware facts the chooser reads (data) |
| `/etc/nixos/machine/install.json` | Profile and hostname from the installation |
| `/etc/nixos/machine/apps.list` | Apps installed from the dock (data) |
| `/etc/nixos/machine/modules.list` | App modules switched on by hand: `module` or `module.program` (data) |
| `/etc/nixos/machine/questions.json`, `answers.list` | Post-install questions and their answers |
| `/etc/nixos/standard/` | Standard's files: root's editable checkout (`.golem-rev` = its commit) |

## Golem's state

| Path | What |
|---|---|
| `/var/lib/golem/golem.git` | The git data of `/etc/nixos/standard` |
| `/var/lib/golem/local-edits/<when>/` (and `latest`) | Your edits an update set aside |
| `/var/lib/golem/held-revisions` | Versions Golem went back from and will not take again |
| `/var/lib/golem/update-behind-since` | When this machine first saw a newer version (the wave's clock) |
| `/var/lib/golem/first-boot.pending` | Left by the installer until the first-boot build has run |
| `/var/lib/golem/owner` | The last owner name activated (for renames) |
| `/var/lib/golem/secrets/` | The owner's password hash and the boot menu's password (root only) |
| `/var/lib/golem-notices/` | `update-ok`, `update-failed`, `rolled-back`: what the owner's notices read |
| `/run/golem-rebuild.lock` | The one rebuild lock: updates, dock installs and `rebuild` never run at once |
| `/run/golem-update-now` | "Skip the wave once" (Controls → Updates → Update now) |

## What each generation records

| Path | What |
|---|---|
| `/etc/golem/machine` | The machine folder this generation was built from |
| `/etc/golem/layout.json` | The layout, the profile, and the hardware leaves chosen, each with why |
| `/etc/golem/owner` | This system's owner |
| `/etc/golem/whats-new.json` | The release notes shown in Controls → Updates |
| `/etc/golem/lab-door` | Present only on the developers' lab machines |

## Your home

| Path | What |
|---|---|
| `~/.config/golem/settings.json` | Every choice made in Controls (live settings) |
| `~/.config/hypr/hyprland.lua` | A link to Standard's Hyprland configuration |
| `~/.config/hypr/user.lua` | Your own Hyprland configuration, loaded last |
| `~/.config/waverunner/packages.list` | The dock's install requests (data, read by a root helper) |
| `~/.config/waverunner/apply-status.json` | How the last install request ended |
| `~/.config/webapps.list` | The web apps catalogue the box offers |
| `~/.local/share/seam/` | The browser's profile |
| `~/.local/share/golem/versions/` | Originals of pictures you edited in Quick Look |
| `~/.local/state/golem/` | The desktop's working state: generated theme files, screens, notices already shown… |
| `*.before-golem` | Files the desktop's configuration had to move aside |

## Logs

| To see | Run |
|---|---|
| Last night's update | `journalctl -u golem-autoupdate --since yesterday` |
| An "Update now" | `journalctl -u golem-update-now` |
| The first-boot build | `journalctl -u golem-first-boot` |
| A dock install | `journalctl -u waverunner-apply` |
| A rollback | `journalctl -u golem-rollback -u golem-go-back` |
| The dock itself | `journalctl --user -u waverunner` |
| The browser's updates | `journalctl -u seam-update` |
| The installation | `sudo ls /var/log/golem-install/` |
| An account rename | `journalctl -b \| grep golem-owner` |

## System services

| Unit | What it does |
|---|---|
| `golem-autoupdate.service` / `.timer` | The nightly update (`update --nightly`) |
| `golem-update-now.service` | One update that skips the wave |
| `golem-first-boot.service` / `.timer` | The first build after an installation |
| `waverunner-apply.path` / `.service` | Dock installs → `machine/apps.list` → rebuild |
| `golem-postinstall-apply.path` / `.service` | Post-install answers → `machine/answers.list` → rebuild |
| `golem-rollback.service` | The crash-loop rollback |
| `golem-go-back.service` | Controls → Updates → Go back |
| `golem-clean-system.service` | Controls → Storage → Clean up: keeps two system versions, collects garbage, trims the journal to 7 days |
| `golem-store-check.service` / `.timer` | Weekly check and repair of the Nix store |
| `nix-gc.service` | Daily garbage collection, when you are not busy |
| `seam-update.service` / `.timer` | The browser's security updates |
| `golem-power-key.service` | The power key → the top bar's power pills |
| `golem-printers.service` | The default printer, and the list the desktop shows |
| `golem-prochot.service`, `golem-gpu-floor.service` | Processor and graphics speed fixes for some laptops on the charger |
| `bluetooth-reconnect-after-hibernate.service` | Reconnects trusted Bluetooth devices after hibernation |
| `sshguard.service` | Blocks addresses that keep failing to log in over SSH |

User services (`journalctl --user -u <unit>`): `waverunner` (the dock and the whole shell), `golem-update-notice`, `golem-rollback-notice`, `golem-return-notice` (the desktop came back on its own), `golem-disk-care` (daily: Bin items older than 30 days, stale build caches), `golem-disk-warn` (every 30 minutes: the disk is almost full), `golem-printer-notice`, `golem-home-heal`, `golem-bus-guard`, `golem-autobrightness`, `golem-caffeine`, `golem-user-dirs`, `golem-postinstall-ask`.
