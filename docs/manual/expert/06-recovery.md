# Recovery

StandardOS is built so that you rarely need this page: an update that fails changes nothing, a desktop that crashes comes back, and a desktop that keeps crashing goes back to the version before by itself. When you do need it, these are the tools, from the gentlest to the last resort.

## Generations and the boot menu

Every update and every rebuild makes a new **generation** of the system, and the old ones stay on disk. When the computer starts, the boot menu (GRUB) shows for one second:

- **Start Standard** — the newest system, started by default.
- **Previous Versions** — the older generations, each as *Gen N - date*. Choose one to start it.

Press an arrow key during that second to hold the menu.

| Kept | How many |
|---|---|
| In the boot menu (UEFI) | the newest 3 (the boot partition is small) |
| In the boot menu (BIOS) | the newest 15 |
| On disk | 15 system generations; only 3 when less than 15 GiB are free |

Starting an older generation is safe, changes nothing on disk, and lasts for that one start. To stay on the version before, start the newest one normally and use **Controls → Updates → Go back** (below). Go back holds the version that is *running* and starts the one before it, so pressing it while an older generation runs would hold that one instead.

!!! note "The boot menu's password"
    Starting any entry never asks for a password. The menu asks for one only to **edit** an entry (<kbd>e</kbd>) or open GRUB's command line (<kbd>c</kbd>) — the classic way to get a root shell without a password. User `golem`; `sudo boot-password` shows the password.

## Go back

**Controls → Updates → Go back** (or `systemctl start golem-go-back`, which your account may run without a password):

1. writes the running version to `/var/lib/golem/held-revisions`, so it is not taken again;
2. makes the newest earlier generation that is not held the default;
3. runs `recover`, so `/etc/nixos/standard` holds the files that built that generation;
4. restarts the computer six seconds later.

After the restart, Golem says what it did.

## The desktop's safety net

- **One crash**: the desktop starts again by itself, at once (Standard's Hyprland never falls back to its "safe mode").
- **A crash loop** — two crashes in a row, each within a minute of starting: `golem-crash-loop` starts `golem-rollback.service`, which does what *Go back* does, then restarts. The notice says the desktop kept crashing after an update.
- **The desktop closed for another reason**: the session keeper starts it again and leaves a notice (*"The desktop came back on its own"*). A desktop that starts again within the same boot is always locked first.
- **Nothing to go back to**: a last-resort screen offers one button, *Restart*.

## recover: Standard's files back to a working state

If an edit of yours in `/etc/nixos/standard` no longer builds:

```sh
sudo recover                                        # the files that built the running system
sudo recover /nix/var/nix/profiles/system-41-link   # those that built generation 41
```

Only `standard/` changes. Every generation keeps its own copy of the folder it was built from: the running one's is `/etc/golem/machine`, another's is inside that generation, e.g. `/nix/var/nix/profiles/system-41-link/etc/golem/machine`.

## Freezes and disk damage

- A kernel panic restarts the computer after 10 seconds; a soft lockup panics (and so restarts) instead of hanging forever.
- Once a week, `golem-store-check` verifies every file of the Nix store against its hash and repairs what is damaged (`journalctl -u golem-store-check`).
- Store paths are written with `fsync`, so a power cut during an update cannot leave a half-written system.

## When nothing starts

1. In the boot menu, try **Previous Versions** and an older generation. An older generation also gives the account back its old name if a rename was involved.
2. An encrypted disk asks for its password on the boot screen and waits as long as needed: nothing is broken if it is waiting there.
3. As a last resort, start the installation medium (choose **Start**, not Install) and repair from there. This is standard NixOS practice, not a StandardOS tool:

```sh
sudo cryptsetup open /dev/disk/by-partlabel/crypt standard   # encrypted disks only
sudo vgchange -ay standardvg                                 # encrypted disks only
sudo mount /dev/disk/by-label/standard /mnt
sudo mount /dev/disk/by-label/ESP /mnt/boot     # UEFI machines
sudo nixos-enter --root /mnt
# inside: go back to generation N and make it the default
nix-env -p /nix/var/nix/profiles/system --switch-generation N
/nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

Or fix the files in `/etc/nixos` and rebuild from inside with `nixos-rebuild boot --flake /etc/nixos#default`.
