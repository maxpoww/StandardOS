# Installation in depth

The installer is a small console system on a USB stick that carries finished StandardOS systems with it. It measures the computer, asks six questions, picks the finished system that fits, copies it — offline, nothing is compiled — and writes the machine folder around it. This page follows it step by step, for people who want to know exactly what lands where, or to install by hand.

## The installer medium

| | |
|---|---|
| Source | `Installer/preinstall/` — a flake of its own whose `standard` input is the repository itself, every other input following Standard's pins |
| Image | `standardos-installer.iso`, volume label `STANDARD_INST` |
| System | NixOS's minimal installation CD plus `iso.nix`: console only, all firmware, no desktop |
| Carries | Finished systems for every class of hardware Standard tests on (the *baked matrix*), plus everything needed to evaluate offline |

The boot menu has two entries and no timeout:

- **Install** — tty1 runs the installer's six screens as root. tty2–tty6 keep a normal login.
- **Start** — the plain console, logged in as `nixos`. Nothing is installed. Two commands are offered:
    - `cat /var/log/golem-audit/summary.txt` — what the census found (below).
    - `sudo golem-setup` — rehearses the whole installation on this computer and **writes nothing**: every command that would change a disk is logged as `would …`, and the bundle is kept in `/var/log/golem-rehearsal/`.

Secure Boot must be off: nothing in Standard is signed for it.

## The census

On both entries, `golem-audit.service` measures the hardware without touching any disk, then decides what the system will need:

1. `golem-hw-evidence -t` — raw evidence (lspci, lsusb, dmidecode, EDID, sysfs…).
2. `golem-hw-detect` — the facts, as a Nix module (`golem-hardware.nix`).
3. `golem-hw-decide --facts` — the decisions those facts lead to.

Everything goes to `/var/log/golem-audit/`: `summary.txt`, `decision.json`, `golem-hardware.nix`, `evidence/` (and `evidence.tar.gz`), the three tools' logs, and `status` (`ok` or `FAILED at: <stage>`). The facts are the ones described in [Hardware](#expert-hardware).

## The six screens

Keys: <kbd>Enter</kbd> takes the row, typing filters the list, <kbd>↑</kbd> <kbd>↓</kbd> move, <kbd>Esc</kbd> goes back one step, <kbd>F1</kbd> or <kbd>Ctrl</kbd>+<kbd>C</kbd> leaves (the installer starts again from the first screen).

| # | Screen | Sets |
|---|---|---|
| 1 | **Language** (61 in the list) | The system locale. The installer itself speaks English, Spanish, French, German, Italian and Portuguese. |
| 2 | **Timezone** | Opens on the zones of the chosen language, and shows the clock of the one you pick. |
| 3 | **Keyboard** | Seeded from the time zone's country. One row sets the console keymap, the XKB layout, variant, options and model, and a console font if needed; it is applied at once so you can try it. |
| 4 | **Drive** | Internal disks first, with model and size. Never the stick the installer started from, nor loop, zram, optical or floppy devices. The last row is **Advanced**. |
| 5 | **You** | The device's name (RFC 1123), the user name (`^[a-z][a-z0-9_-]{0,31}$`, not a system name), the password twice — hashed at once with yescrypt; the text itself is never written anywhere. |
| 6 | **Install StandardOS?** | A summary of the answers, of the decisions (memory compression, swap, thermal daemon, lid, scaling) and of the hardware found. |

**Advanced** offers *Full-Drive encryption* (below). *Dual-Boot* and *Install on a partition* answer "not in this release yet".

<kbd>Enter</kbd> on the last screen runs:

```sh
golem-install --answers /tmp/golem-answers --disk <drive> --yes
```

## Installing by hand

`golem-install` can be run from the **Start** console, without the screens:

```sh
sudo golem-install --disk /dev/nvme0n1 \
  --hostname casa --owner ana \
  --locale es_AR.UTF-8 --timezone America/Argentina/Buenos_Aires \
  --kb-layout latam --kb-console la-latin1 \
  --password-hash "$(mkpasswd -m yescrypt)"
```

| Flag | Effect |
|---|---|
| `--disk DEV` | Required: the whole drive to install on. |
| `--owner`, `--full-name`, `--hostname` | The account (always pass it), its full name, the computer's name (default `Standard`). |
| `--locale`, `--timezone` | Default `en_US.UTF-8` and `UTC`. |
| `--kb-layout`, `--kb-variant`, `--kb-options`, `--kb-model`, `--kb-console`, `--kb-font` | The keyboard (default `us`, `pc104`). |
| `--password-hash H` | A hash, never the password itself (a flag can be read in `ps`). |
| `--answers FILE` | Reads the screens' answers file instead. |
| `--luks --luks-key FILE` | Encrypts the drive with the passphrase in `FILE` (UEFI only). |
| `--yes` | Skips "This ERASES the disk completely. Type ERASE to continue". |
| `--rehearse` | Logs every disk-changing command as `would …` and writes nothing. |
| `--system PATH` | Installs this system instead of looking for a baked match. |
| `--prepare-only` / `--skip-prepare` | Stops after partitioning and writing the machine folder / resumes from there. |

## The checks before any write

The installer stops, before touching the drive, when:

- the drive is the medium it started from;
- the root partition would get less than 20 GiB after the boot partition and swap (the system needs about 19 GiB);
- encryption is asked on a BIOS machine;
- on a BIOS machine, the drive is not the first one (`/dev/sda`): the finished BIOS systems put GRUB there.

Less than about 4 GB of memory is only a warning: a 2 GB computer installs, because the system is copied, not built.

**Swap** is sized for hibernation: memory plus a margin of a tenth of it (at least 2 GiB), rounded up to whole GiB — 4 GB of memory gets 6 GiB, 8 gets 10, 16 gets 18, 32 gets 36.

## The partitions

Every drive gets a GPT partition table.

| Firmware | Encryption | Partitions | File systems |
|---|---|---|---|
| UEFI | off (default) | ESP 512 MiB · swap · root | FAT32 `ESP` on `/boot` · swap · ext4 `standard` on `/` |
| UEFI | on | ESP 512 MiB · one encrypted partition | LUKS2 opened as `standard`, holding an LVM group `standardvg` with `swap` and `root` (ext4 `standard`) |
| BIOS | off | 1 MiB BIOS boot partition · swap · root | no ESP; `/boot` is on the root partition |
| BIOS | on | refused | |

## Which system is copied

The medium carries finished systems, one for each combination of hardware leaves it was built for, in each firmware, plus a generic **floor** per firmware that starts on anything. The installer:

1. runs the [chooser](#expert-hardware--the-chooser) on the fresh facts;
2. takes the finished system with exactly those leaves;
3. if there is none, takes the floor for the firmware ("boots on anything");
4. copies it with `nixos-install --system <system> --no-root-password`, in the background, while the bar shows each piece copied.

The floor is not a lesser install: at the first start, Golem builds this machine's own system from its folder (see below).

## What is written where

| On the new drive | What |
|---|---|
| `/etc/nixos/flake.nix` | The machine's flake, with no inputs: `outputs = { self }: import ./standard/machine.nix ./.;` |
| `/etc/nixos/configuration.nix` | This computer: owner, name, language, time zone, keyboard (and, with encryption, the encrypted partition) |
| `/etc/nixos/hardware-configuration.nix` | As measured by `nixos-generate-config` |
| `/etc/nixos/machine/facts.json` | The census's facts, as data |
| `/etc/nixos/machine/install.json` | `{ "profile": "desktop", "hostname": … }` |
| `/etc/nixos/machine/questions.json` | The post-install questions for this machine (usually none) |
| `/etc/nixos/standard/` | Standard's files: root's editable copy, with `.golem-rev`, the commit the medium was made from |
| `/var/lib/golem/golem.git` | Its git data; origin is GitHub, branch `stable` |
| `/var/lib/golem/secrets/owner-password-hash` | The password's hash (root only) |
| `~/.config/golem/settings.json` | Language, time zone and keyboard, so the first desktop already speaks your language |
| `/var/lib/golem/first-boot.pending` | Asks for the first-boot build |
| `/var/log/golem-install/` | The installation's logs (root only) |

Root gets no password; the owner uses `sudo`.

## The checks after the copy

Before it offers to restart, the installer verifies its work, one line each: the **bootloader**, the **system** profile, the **kernel** and initrd, **fstab** (a root entry), Standard's **files** (`/etc/nixos`, `/etc/nixos/standard`, the git data) and the **account** (a password hash). All good → "the installation is healthy"; then "remove the USB and press ENTER". The restart waits for <kbd>Enter</kbd>.

Logs, in `/var/log/golem-install/`: `plan.txt`, `checks.txt`, `transcript.txt`, `folder.log`, `choose.err`, `nixos-install.log`, `personalize.err`, `verify.txt`, `status`, `output.txt`. When an installation fails, the screen shows the error line and "Its whole log is in /var/log/golem-install (Ctrl+Alt+F2 opens a console)".

## Encryption

*Advanced → Full-Drive encryption → Encrypt this Drive → Yes.* The passphrase needs at least 8 characters, is typed twice and shown in the clear, and a warning says there is no recovery. It never enters the answers file: it goes to a root-only file in RAM, which is shredded right after `cryptsetup luksFormat --type luks2` and `cryptsetup open`.

One encrypted container holds both swap and root, so one passphrase at start also lets the computer resume from hibernation. The ESP stays unencrypted. At start, Plymouth draws the prompt: the word *Password* and one dot per character; the initrd waits as long as it takes.

## The first start

- The desktop opens without a password, once per boot, as the system's account, and the lock screen is the door.
- 30 seconds after boot, `golem-first-boot.service` (only where `first-boot.pending` exists) waits until the desktop has run for a minute (on weak machines, a quarter of an hour plus a calm minute), waits for the internet (or retries in an hour), then runs `update --converge`: it fetches `stable`, adopts the medium's commit into git without touching a file, and builds this machine's own system for the next start.
- At that next start, if the account name typed at installation differs from the system's, it is renamed in place: same uid and password, `/home/<old>` moved to `/home/<new>`. A live switch that would rename the logged-in account is refused, with: *"golem-owner: this system's owner is '…' and '…' is logged in: the account is renamed at a restart, so this system can only start at one."* — use `sudo rebuild boot` and restart.

`journalctl -b | grep golem-owner` shows the rename.

## Post-install questions

The installer computes them from the same facts. Today there is one: when a second GPU failed its wake test, *"Your second GPU didn't wake up during setup"* — keep it available (default) or turn it off. After the first desktop session, a small terminal asks it once; the answer is validated by a root helper, written to `/etc/nixos/machine/answers.list` (read as data) and applied with a rebuild.
