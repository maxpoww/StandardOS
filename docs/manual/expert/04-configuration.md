# Configuration reference

Three places decide how your computer behaves, and the later one wins: **Standard's defaults**, then **your machine** (`configuration.nix` and `modules/`), then **your live settings** (what you choose in Controls). This page lists what you can set in each.

## Standard's options

Set these in `/etc/nixos/configuration.nix` (or in a file in `modules/`), then run `rebuild`.

| Option | Default | What it does |
|---|---|---|
| `standard.owner` | `"max"` | The one person who uses this computer (the installer writes it) |
| `standard.locale.defaultLocale` | `"en_US.UTF-8"` | The system's language |
| `standard.locale.timeZone` | `"UTC"` | The time zone |
| `standard.keyboard.layout`, `.variant`, `.options`, `.model` | `us`, `""`, `""`, `pc104` | The keyboard, as XKB names it |
| `standard.keyboard.consoleKeyMap`, `.consoleFont` | `us`, none | The text console's keymap and font |
| `standard.desktop.effects` | `"full"` | `"light"` turns the desktop's blur off and uses the lighter dock; set by itself on weak graphics |
| `standard.upstream.url` | `https://github.com/maxpoww/StandardOS` | Where updates come from |
| `standard.upstream.branch` | `"stable"` | The branch your computer follows |
| `standard.update.waves` | `7` | Over how many days a new version reaches every machine |
| `standard.update.wave` | `null` | This computer's wave (0 = first); `null` derives it from the machine id |
| `standard.update.cache.repo` | `"maxpoww/golem-cache"` | Where each version's prebuilt pieces are published |
| `standard.update.cache.publicKeys` | Standard's signing key | The keys a prebuilt piece must be signed with |
| `standard.modules.<id>.enable` | `false` | Turns an app module on (see below) |
| `standard.hardware.*` | measured | The hardware facts found at install; read from `machine/facts.json` |
| `standard.lab.door` | `false` | Lab machines only: lets the developers' computer in by SSH |

Every NixOS option works too: `man configuration.nix` lists them all.

### App modules by hand

The dock's **Modules** page is the easy way. In a file, a module is:

```nix
standard.modules.gaming.enable = true;          # the recommended set

standard.modules.development = {                 # or tool by tool
  enable = true;
  install = "chosen";                            # "recommended" (default), "all" or "chosen"
  docker.enable = true;
  vscode.enable = true;
};
```

The 25 modules are: office, internet, social, media, gaming, productivity, content-creation, photography, education, kids, ai, remote-work, privacy-security, music-production, video-editing, graphic-design, 3d-printing, writing, web-design, development, commerce, trading-finance, science-data, accessibility, windows-apps. Each brings its programs and the system they need to work (services, device rules), never a group that equals root: Docker runs rootless, virtual machines in your own session.

## Home options

These belong to your account's configuration (home-manager). From `configuration.nix` they are written under the owner, for example for an owner called `ana`:

```nix
home-manager.users.ana.standard.home.idle.enable = false;
```

| Option | Default | What it does |
|---|---|---|
| `standard.home.idle.enable` | `true` | Lock after 5 min, screen off after 6, sleep after 15. Off keeps the lock screen and <kbd>Super</kbd>+<kbd>L</kbd> |
| `standard.home.loginLock.enable` | `true` | The lock screen is the first screen at every start, and your password also opens the keyring. Off: the desktop opens at once |
| `standard.home.menubox.hidePlumbing` | `true` | Hides the terminal, editor, player and other plumbing from the app list |
| `standard.home.hyprlandExtra` | `""` | Lua of this machine's own, loaded after Standard's |
| `standard.home.hyprlandModules` | `[ ]` | More app modules' Lua to load (e.g. `[ "gaming" ]`) |

## Your own desktop configuration

The desktop is Hyprland, configured in Lua. Standard's configuration is a folder of Lua files built into the system; you never edit it. For your own, write **`~/.config/hypr/user.lua`**: it loads after Standard's and after the app modules, so it wins over them; only your live settings from Controls load after it. A new `user.lua` is picked up at the next reload — run `hyprctl reload` once; from then on, saving it reloads the desktop. A mistake shows as a configuration error and stops nothing else.

```lua
-- ~/.config/hypr/user.lua — examples
hl.bind("SUPER + B", hl.dsp.exec_cmd("seam"))       -- a key of your own

hl.window_rule({                                     -- the calculator always floats
    name  = "my-calculator-floats",                  -- every rule needs a name of its own
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
})
```

The full load order, and the Lua API, are in [The desktop inside](#expert-desktop).

## Live settings

What you choose in **Controls** is kept in your home, never in `/etc/nixos`:

| File | Written by | What it holds |
|---|---|---|
| `~/.config/golem/settings.json` | The dock (Controls); the installer writes the first one | Keyboard, language, time zone, screens' scale and resolution, touchpad, dark mode, wallpaper, colours |
| `~/.config/golem/settings.lua` | The dock, from the JSON — never edit it | What the desktop must apply at start; Hyprland runs it last |
| `~/.config/golem/palettes/*.json` | You | Palettes of your own, beside the built-in ones |

A live setting is applied at once, saved, and wins over every default from the desktop's first frame — even when the dock is not running. Language and time zone chosen in Controls move your session; the system's own (`standard.locale.*`) change with a rebuild.

### A palette of your own

A palette is sixteen colours in the base16 layout, a dark and a light set, and an accent named by its slot. Put a file in `~/.config/golem/palettes/`:

```json
{
  "name": "Mine",
  "accent": "base09",
  "dark":  { "base00": "#16171a", "base01": "#1d2026", "…": "…", "base0F": "#d8a27c" },
  "light": { "base00": "#eae7e0", "base01": "#dcd9d1", "…": "…", "base0F": "#95603a" }
}
```

It appears in **Controls → Colours** with the others.

## First-run settings of apps ("fits")

When you install some apps from the dock, Standard lays down the small first-run setup they need to work at once — only the first time, never while the app runs, and as plain files the app may change afterwards: OBS Studio (screen capture scene, hardware encoder), Shotcut and Krita (the desktop's colours), Claude Code and opencode (the terminal's theme). After that, the app's configuration is yours.
