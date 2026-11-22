# Building StandardOS

StandardOS is built from one public repository. Everything — every machine, the installer, the tests — comes out of its flake. This page is for people who want to build it, test a change, or make their own installer.

```sh
git clone https://github.com/maxpoww/StandardOS
cd StandardOS
```

You need a computer with Nix (flakes enabled), and plenty of disk: a full test build fills tens of gigabytes.

## The map

| Path | What |
|---|---|
| `flake.nix`, `flake.lock` | Every output, and the pins of every component |
| `system/Modular/` | The distribution: one *leaf* per concern (base, boot, cpu, gpu, disk, desktop…), `composition.nix`, and the hardware chooser `choose.nix` |
| `system/home/` | The desktop's home layer (home-manager); `hypr/` is Hyprland's configuration, in Lua |
| `system/modules/` | The 25 app modules, one file each |
| `system/machine/`, `machine.nix` | One computer from its own folder: the `/etc/nixos` layout and the commands `update`, `status`, `recover`, `rebuild` |
| `system/i18n/` | Golem's own messages, one catalogue per language |
| `Installer/preinstall/` | The installer: its own flake, the screens, `golem-install`, the hardware fixtures, `run-vm.sh` |
| `updates/` | The update lane and the client side every machine gets |
| `seam/` | The browser: Mozilla's build, policies, chrome, update lane |
| `docs/` | Design and maintainer documentation; `docs/manual/` is this documentation |
| `tools/` | Developer scripts |

The dock and shell (*waverunner*) and the overview plugin (*waveview*) live in their own repositories, pinned in `flake.lock`.

## Rules that save you hours

- **Evaluate as `git+file://`, never `path:`.** A `path:` flake copies the whole working tree into the store. The flake sees only files git tracks: `git add` a new file before you build.
- **Never move** `system/Modular/` (its paths are written into installed machines), `machine.nix`, the template's file names, an app module's id, `Installer/preinstall/fixtures/` or `seam/`.
- A changed message in a script is a new translation key: run `bash system/i18n/check.sh`.
- Before moving the nixpkgs or Hyprland pin, run `tools/latest/check.sh`: it fails when something Standard uses is gone or renamed.
- The installer's screens speak six languages: a new screen string needs all six.

## Everyday builds

```sh
G=git+file://$PWD
nix build --no-link "$G#checks.x86_64-linux.minimal-matrix"
nix build --no-link "$G#checks.x86_64-linux.desktop-matrix"
nix build --no-link "$G#checks.x86_64-linux.machine-layout" "$G#checks.x86_64-linux.machine-update"
nix build --no-link "$G#checks.x86_64-linux.boot-test"
```

The 16 checks, all in `checks.x86_64-linux`:

| Check | What it proves |
|---|---|
| `facts-matrix`, `chooser-matrix` | The hardware facts lead to the right leaves, for every fixture and for made-up machines |
| `minimal-matrix`, `desktop-matrix` | What each leaf does, on each fixture, without and with the desktop |
| `modules-matrix` | The app modules |
| `machine-layout`, `machine-update` | The machine folder composes, and an update merges, keeps edits and sets conflicts aside |
| `recover-standing` | `recover` puts Standard's files back |
| `boot-test` | A desktop VM starts and its desktop stays up |
| `session-keeper`, `idle-suspend`, `hypr-config` | The session comes back locked, the computer sleeps, Hyprland's configuration loads |
| `keyboard-table`, `timezone-defaults` | The installer's keyboards and time zones |
| `installer-lock` | The installer is pinned to the same components as Standard |
| `legacy-names` | Old option names still work |

Before a change to the session, also run the session test by hand — it boots a VM and checks the lock screen comes first, the keyring opens, screenshots and recordings work, and a crashed desktop comes back locked:

```sh
nix build "$G#session-test" -L
```

To test a change of the dock, point the build at your checkout of it: `--override-input waverunner git+file:///path/to/launcher`.

## A machine folder, without a machine

```sh
bash system/machine/scaffold.sh --to /tmp/m/etc/nixos --standard . --owner ana --hostname casa \
  --facts Installer/preinstall/fixtures/thinkpad-e15-gen2/facts.nix \
  --hardware-config system/machine/fixtures/thinkpad/hardware-configuration.nix
bash system/machine/checkout.sh --root /tmp/m --from . --branch main
```

That writes a folder exactly like an installed machine's, and nothing else.

## Virtual machines

- `nix build "$G#nixosConfigurations.standard-desktop-vm.config.system.build.vm"`, then run the script in `result/bin/` — a desktop VM (the owner's password is `golem`).
- `Installer/preinstall/run-vm.sh` boots the installer in QEMU with 4 GB of memory (the weak class, on purpose):

| Flag | Effect |
|---|---|
| (none) | A window, booting `result/iso/standardos-installer.iso` |
| `--iso PATH` | Another image |
| `--disk FILE[:SIZE]` | A target disk (created at `SIZE`, default 40G) |
| `--sata` | The target as `/dev/sda` (needed for a BIOS install) |
| `--uefi` | UEFI firmware (OVMF), with its own variables file |
| `--no-cd` | Boot the installed disk |
| `--headless` | No window; the census still sees a GPU |

The installer's screens also run in any terminal with nothing real behind them: `bash Installer/preinstall/mockup/install-cli --fake-disks` plays the whole flow, `--fake-fail` the failure screen.

## The installer image

```sh
cd Installer/preinstall
nix flake update standard
nix build .#iso                 # → result/iso/standardos-installer.iso
```

The installer's `standard` input is the repository itself (`path:../../`), so the whole working tree is copied: build from a clean worktree. The image carries a finished system for every fixture class in both firmwares, plus the two floors. `GOLEM_BAKE_ONLY=qemu,thinkpad nix build --impure .#iso` makes a smaller test image with only those classes (and the floors).

!!! warning "Lab images are not for other people"
    `GOLEM_LAB=1 nix build --impure .#iso` makes a *lab* image for the developers' own test machines: every system it installs accepts the developers' SSH keys and joins a test Wi-Fi network. Never give one to anyone.

A machine installed from any image takes its first update from GitHub's `stable` branch: make images only from commits that are pushed.

## The update lane

A build machine runs the lane that builds every Standard machine, starts the desktop in a VM, uploads the prebuilt pieces to the release cache and moves `stable`. To run one: import `updates/builder.nix`, set `standard.lane = { enable = true; user = "<you>"; };`, put a signing key in `~/.local/share/golem-lane/cache-key.sec` (mode 600), log in with `gh`, then `golem-lane run --no-publish` once and read `golem-lane status`. A lane of your own needs your own key and cache repository, and your machines must trust them: set `standard.update.cache.repo` and `standard.update.cache.publicKeys` on them. `updates/RUNBOOK.md` has the details.

## This documentation

This documentation is built from `docs/manual/`: one Markdown file per section in `guide/` and `expert/`, a template, and `build.py`, which makes one self-contained HTML page with its menus and search:

```sh
python3 docs/manual/build.py /tmp/manual.html --version dev
```

It needs Python with the `markdown` package. `MANUAL_STRICT=1` makes a broken link an error. Every StandardOS computer carries the same page (the `manual` command, and **Controls → Documentation**).

## Licence

StandardOS is free software, under the GNU General Public License, version 3 or later.
