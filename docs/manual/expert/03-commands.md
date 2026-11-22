# Commands

StandardOS's commands are plain words: the command you would guess, with no brand in front. They are the same tools Golem uses: the nightly update runs `update`, the first boot runs `update --converge`, going back runs `recover`. This page lists every command a person may type, what it does and what it says.

| Command | What it does | Runs as |
|---|---|---|
| [`update`](#expert-commands--update) | Takes the newest version of Standard, keeps your edits, builds it | asks for your password |
| [`status`](#expert-commands--status) | Lists what this computer changed in Standard's files | asks for your password |
| [`rebuild`](#expert-commands--rebuild) | Applies what you changed in `/etc/nixos` | asks for your password |
| [`recover`](#expert-commands--recover) | Puts Standard's files back to what built a working system | root (`sudo recover`) |
| [`manual`](#expert-commands--manual) | Opens this documentation, offline | you |
| [`caffeine`](#expert-commands--caffeine) | Keeps the computer awake | you |
| [`lock`](#expert-commands--lock) | Locks the screen | you |
| [`screenshot`](#expert-commands--screenshot) | Takes a screenshot of a region, the screen or a window | you |
| [`brightness`](#expert-commands--brightness) | Sets or reads the screen's backlight | you |
| [`autobrightness`](#expert-commands--autobrightness) | The screen follows the room's light (machines with a light sensor) | you |
| [`boot-password`](#expert-commands--boot-password) | Shows the boot menu's password | root (`sudo boot-password`) |
| [`printer-ink`](#expert-commands--printer-ink) | Reads the ink levels of an HP printer | you |
| [`ups`](#expert-commands--ups) | Runs the newest upstream version of an app, beside the system | you |
| [`seam-update`](#expert-commands--seam-and-seam-update) | Updates the browser to Mozilla's current release | root |
| [`waverunner-ctl`](#expert-commands--waverunner-ctl) | Talks to the dock | you |

!!! note "The old names still work"
    Before 2026-11-22 these commands were called `golem-update`, `golem-status`, `golem-recover`, `rebuild-golem`, `golem-caffeine`, `golem-lock-screen`, `golem-screenshot`, `golem-brightness`, `golem-autobrightness`, `golem-boot-password` and `golem-printer-ink`. Each old name is a link to the new one, so scripts and habits keep working.

## update

```text
update [--now | --nightly | --converge]
```

| Form | What it does |
|---|---|
| `update` | Takes the newest version of the branch your computer follows (`stable`), merges it with your edits, builds it, and makes it start at the next restart |
| `update --now` | The same, and switches to it at once |
| `update --nightly` | What Golem's nightly job runs: honours the waves and the versions held back, and never compiles when GitHub cannot be asked for the version's published pieces |
| `update --converge` | What the first boot runs: builds this computer's own system even when there is no newer version |

What happens, in order:

1. It takes Standard's one rebuild lock, so it never runs at the same time as another rebuild (it waits up to two hours).
2. It fetches the branch from GitHub. If GitHub cannot be reached, it stops with *"update: … could not be reached"*.
3. **It never goes backwards.** If your computer is already ahead of the branch, it says *"this machine's Standard (…) is ahead of stable (…) — nothing to take from it"* and stops.
4. **It merges** the new version with your files as they are, in memory, the way git does. Where you and the new version changed the same lines, the new version wins and your file is set aside in `/var/lib/golem/local-edits/<date>/`, with a line saying so.
5. **It builds** the result in a copy only root can read. If the build fails, `/etc/nixos` is not touched: *"update: … does not build here — the machine stays as it was"*.
6. **It puts the files in place** and records the new version: *"update: this machine is on Standard … from its next start"*.

Two more things it decides by itself: if your computer has a newer browser than the new version of Standard (Seam updates itself between versions), your browser's version stays; and when run by hand, `update` ignores the waves and will take even a version you went back from.

| Exit code | Meaning |
|---|---|
| 0 | Updated, or nothing to do |
| 1 | The lock was busy for two hours, no checkout, or the merge failed |
| 2 | An unknown argument |
| 75 | No network, or GitHub could not say whether the version's pieces are published |
| other | The rebuild's own exit code |

## status

```text
status
```

Compares `/etc/nixos/standard` with the version it came from and lists what this computer changed:

```text
Standard 0dffaf79990b (branch stable), in /etc/nixos/standard
Changed on this machine (kept by an update where it can be):
  M	seam/sources.json
(seam/sources.json is the browser updating itself between Standard's versions: the newer one always stays.)
See a change:  sudo git -C /etc/nixos/standard diff 0dffaf79990b -- <file>
```

When nothing changed: *"No file of Standard's was changed on this machine."* Right after an install the history has not arrived yet; it comes with the first update.

## rebuild

```text
rebuild [switch | boot | test | build …] [nixos-rebuild options…]
```

`rebuild` alone applies what is written in `/etc/nixos` now (`switch`); `rebuild boot` makes it start at the next restart. It is `nixos-rebuild` for this computer's own configuration (`/etc/nixos#default`), behind Standard's rebuild lock and with your version's published cache. Any other `nixos-rebuild` option is passed through.

Plain `sudo nixos-rebuild switch` works too; it skips the lock and the cache.

## recover

```text
sudo recover [system]
```

Puts the folder `/etc/nixos/standard` back to the copy kept by a working system — by default the one running now (`/run/current-system`), or any generation you name:

```sh
sudo recover                                        # back to what built the running system
sudo recover /nix/var/nix/profiles/system-41-link   # back to what built generation 41
```

Only `standard/` is restored. `configuration.nix`, `modules/` and `machine/` are yours and stay as they are. Use it when an edit of yours in Standard's files no longer builds. Golem's *Go back* and the automatic rollback both run it.

## manual

```text
manual [section]
```

Opens this documentation in your browser, from the copy on your computer. `manual expert-commands` opens it at this page. On a computer with no desktop, it says where the file is.

## caffeine

| Form | What it does |
|---|---|
| `caffeine on` | No lock, no screen-off, no idle sleep, and closing the lid does not sleep. A nearly empty battery still sleeps. |
| `caffeine off` | Lock, screen-off and sleep are back |
| `caffeine` or `caffeine status` | Prints `on` or `off` |

The state is a file (`~/.config/golem/caffeine`), so it survives a restart. The gear's **Keep awake** switch is the same command.

## lock

`lock` locks the screen now (<kbd>Super</kbd> + <kbd>L</kbd> runs it). After the unlock, the keyring opens with the same password. The desktop runs `lock --login` as its first step, which is why the lock screen is the login screen.

## screenshot

```text
screenshot [region | screen | window]
```

Takes a picture of a region you drag (the default), the screen the keyboard is on, or the window in focus. It goes to the clipboard and to **Pictures → Screenshots** (`Screenshot YYYY-MM-DD HH-MM-SS.png`), with a notification that opens it. <kbd>Shift</kbd> + <kbd>Print</kbd> and <kbd>Alt</kbd> + <kbd>Print</kbd> run it. <kbd>Print</kbd> itself belongs to the dock (the screen at once, with a preview); this command stands in for it only when the dock is not running. See [Screenshots](#guide-screenshots).

## brightness

```text
brightness [set 40% | set 5%+ | set 5%- | get | max | -m]
```

Sets or reads the backlight of the panel that is actually lit, found again at every call (so it follows the GPU that drives the screen on hybrid laptops). Any `brightnessctl` argument works. Members of the `video` group may use it without a password; the owner is one.

## autobrightness

```text
autobrightness [on | off | status | reset]
```

Exists only on a computer whose ambient light sensor was found at install. With it on, the screen follows the room's light, the brightness keys still work, and a level you set by hand is learned for that light. `reset` forgets what it learned. The gear's **Auto** brightness switch is the same command.

## boot-password

`sudo boot-password` shows the password of the boot menu. The menu asks for it only to **edit** an entry (<kbd>e</kbd>) or open GRUB's command line (<kbd>c</kbd>); starting StandardOS or any older version never needs it. It is made at install: 16 random letters that sit on the same keys on QWERTY, QWERTZ and AZERTY keyboards, kept where only root can read it.

## printer-ink

`printer-ink <printer address>` reads the ink of an HP printer that does not report it to the printing system (most HP inkjets over USB). It prints one line per cartridge: its kind and the percent left. The dock's **Printers** page uses it.

## ups

`ups` runs the newest upstream version of an app beside the system, in a container of its own, without changing anything of the system. The app keeps its real name and your real home; `ups erase` removes it and the system's own version is back.

| Form | What it does |
|---|---|
| `ups add <name>` | Installs an app from a recipe |
| `ups update <name>` / `ups update all` | Updates it, keeping a snapshot to go back to |
| `ups rollback <name>` | Back to the snapshot of the last update |
| `ups doctor [name]` | Repairs an app whose container broke |
| `ups erase <name> [--purge]` | Removes it (`--purge` also removes its settings) |
| `ups autoupdate daily\|weekly\|monthly\|off` | Updates everything on a schedule |
| `ups list`, `ups catalog` | What is installed; what can be |

Standard ships two recipes today, `claudecode` (Claude Code) and `opencode`, in `/etc/ups/recipes.d`. Yours go in `~/.config/ups/recipes.d/<name>.sh`: a recipe names a container image, the commands that install the app, and the programs it exports.

## seam and seam-update

`seam` is the browser (Firefox, at a pinned version, with Standard's settings and look). Its profile is `~/.local/share/seam`.

The browser updates itself to each new Mozilla release, apart from the rest of the system: `seam-update.timer` checks every four hours, downloads only releases whose checksums Mozilla's release key signed, rebuilds, tests the new build, and tells you to restart the browser. By hand:

```sh
seam-update --check     # pinned, built and latest versions
sudo seam-update        # update now
```

## waverunner-ctl

`waverunner-ctl <verb>` sends one command to the dock. The key bindings use it; so can your scripts.

| Verb | What it does |
|---|---|
| `toggle`, `show`, `hide` | The dock's box |
| `fast-launch`, `fast-controls` | The quick launcher (<kbd>Super</kbd> + <kbd>J</kbd>), the quick controls (<kbd>Super</kbd> + <kbd>H</kbd>) |
| `control-panel` | Controls |
| `files [folder]` | Standard Files |
| `terminal [words]` | The box as a terminal |
| `capture`, `record` | The capture tool; start or stop recording the screen |
| `display scale <n>`, `display mode <W>x<H>[@Hz]`, `display keep`, `display back` | Screen settings, live |
| `power` | The power pills (what a short press of the power key does) |

It exits 0 when the dock answered, 1 when the dock is not running.
