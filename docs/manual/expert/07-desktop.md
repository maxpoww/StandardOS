# The desktop inside

The desktop is four programs working together: **Hyprland**, the compositor that draws the windows; the **dock** (*waverunner*), which draws the dock, the top bar, the boxes, Files and the desktop icons; the **overview plugin** (*waveview*), which draws the overview, the spread and the windows' title bars; and **Seam**, the browser. This page explains how they are put together and where you can change them.

## Hyprland, Standard's build

StandardOS runs Hyprland 0.55.4 configured in **Lua**, with 24 patches of its own. They fix crashes upstream has not fixed yet and add behaviour the desktop needs, for example:

- a crash restarts the normal desktop (never Hyprland's "safe mode"); two quick crashes start the rollback;
- a drag held over a window for 650 ms raises it; drags never raise the windows they pass over;
- a new tile splits beside the window under the pointer, on that window's own screen;
- each screen keeps its own focused look; a workspace swipe stays on its own screen's desks;
- floating windows stay on their screen across unplugging and plugging back in.

The overview plugin is compiled against this same patched Hyprland.

## The configuration, as Lua

Standard's configuration is a folder of Lua modules, the same on every computer, plus one generated file of this machine's facts. A build copies them into the store; your home holds a single link, `~/.config/hypr/hyprland.lua`, that points at it. A rebuild replaces that link, and Hyprland reloads once into the whole new configuration.

The order is the contract — what loads later wins:

1. **Standard's modules**: monitors, layers, autostart, environment, compat, gestures, look, animations, layout, misc, input, the key bindings, screens, rules, effects.
2. **The app modules' Lua**, for the modules that are on (for example, Gaming keeps the screen awake while a game is fullscreen).
3. **This machine's own Lua**, from the home option `standard.home.hyprlandExtra`.
4. **Your own Lua**: `~/.config/hypr/user.lua`. Saving it reloads (a brand-new file is picked up at the next `hyprctl reload`); a mistake is shown as a configuration error and stops nothing else.
5. **Your live settings**: `~/.config/golem/settings.lua`, written by the dock from Controls.

```lua
-- ~/.config/hypr/user.lua — examples
hl.bind("SUPER + B", hl.dsp.exec_cmd("seam"))       -- a key of your own

hl.window_rule({                                     -- the calculator always floats
    name  = "my-calculator-floats",                  -- every rule needs a name of its own
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
})
```

### This machine's facts

`standard/machine.lua` is generated at each build from the system's options: the keyboard, the panel's density (which sets the laptop screen's scale: 2.0 from 280 dpi, 1.6 from 210, 1.25 from 170), whether Bluetooth exists, the effects tier, the active app modules. It is never edited by hand.

### Screens and desks

Each screen owns its own 18 workspaces ("desks"). The laptop's panel keeps 1–18; another screen takes the next free block the first time it is plugged in, and keeps it: Standard remembers screens in `~/.local/state/golem/screens`.

## The session

- **Login.** greetd starts your desktop once per boot with no password, and the first thing the desktop runs is `lock --login`: the lock screen *is* the login. Your password opens the desktop and the keyring together (GNOME Keyring, unlocked only after hyprlock accepted the password).
- **No log out.** There is no "log out" on StandardOS: you lock, sleep, hibernate, restart or power off. If the desktop ends without being asked to, the session keeper starts it again at once, locked. A desktop that keeps failing to start stops after a few tries and says so on the text login.
- **Idle.** After 5 minutes the screen locks, after 6 it turns off, after 15 the computer sleeps — but sleep waits while an update, an app install or the first-boot build is running. `caffeine on` holds all three.
- **Lid and power key.** Closing the lid sleeps, then hibernates after two hours. A short press of the power key shows the power pills (hibernate, sleep, restart); a long press powers off.

## The dock (waverunner)

The dock is a single program, `waverunner`, running as your user service (`systemctl --user status waverunner`). It draws the dock, the top bar and its pills, the boxes, Controls, the card, Files, the desktop's icons, the notifications and the capture tool, all on the GPU.

| What | Where |
|---|---|
| Its configuration (written by the system) | `~/.config/waverunner/config.toml` |
| Its log | `journalctl --user -u waverunner` |
| Your apps installed from it | requested in `~/.config/waverunner/packages.list`, recorded in `/etc/nixos/machine/apps.list` |
| Talking to it from a script | `waverunner-ctl` (see [Commands](#expert-commands--waverunner-ctl)) |

On weak computers (light effects, or less than 6 GB of memory) the system builds the dock with smaller icon tiles, a quarter of the memory per icon; with light effects, the dock's glass is also denser, since nothing blurs behind it.

### Installing an app, inside

When you install an app from the dock, nothing runs as root in your session. The dock writes the app's name to `~/.config/waverunner/packages.list`; a root service watching that file (`waverunner-apply`) reads it as plain data, accepts only valid package names, builds the new system in a copy only root can read, switches to it, and only then records the app in `/etc/nixos/machine/apps.list`. A failed download is retried (up to six times); a failure ends in a notice, *"Golem couldn't install the app"*, with the reason.

## The overview (waveview)

The plugin is loaded into Hyprland at the start of the session. It draws:

- **the overview** (<kbd>Super</kbd>+<kbd>R</kbd>): every desk of the screen as a 3 × 3 grid; a digit jumps to a desk, <kbd>Esc</kbd> closes;
- **the spread**: every window of the desk side by side;
- **the windows' title bars**, with their buttons;
- **minimizing** a window to the dock.

## Seam

Seam is Mozilla's own Firefox build at a pinned version, with Standard's settings (telemetry, studies, sponsored content, accounts and AI features off; uBlock Origin on), its colours and its title bar. Its profile is `~/.local/share/seam`. Web apps are Firefox web-app windows of the same browser, so you sign in once. It updates itself to each Mozilla release between versions of Standard (see [Updates in depth](#expert-updates)).
