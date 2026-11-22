# How StandardOS is made

StandardOS is a NixOS system described entirely by files. What your computer runs is built from those files, and the same files always build the same system. This part of the documentation explains those files, the commands that work with them, and how to change anything you want.

## The layers

From the bottom up:

| Layer | What it is | Where it lives |
|---|---|---|
| **NixOS** | The base: the Linux kernel, drivers, services, and the Nix package manager that builds everything | `nixpkgs`, pinned in Standard's `flake.lock` |
| **Standard** | The system itself: every module, setting and default that makes a computer a StandardOS computer | `/etc/nixos/standard` — root's own copy, a git checkout you may read and edit |
| **Your machine** | What is particular to this computer: its name, its owner, its hardware, your own changes | `/etc/nixos` — `configuration.nix`, `modules/`, `hardware-configuration.nix`, `machine/` |
| **The desktop** | Hyprland (the compositor), the dock and its boxes (*waverunner*), the overview plugin (*waveview*), Seam (the browser) | Built from pinned sources by Standard; configured by the home layer |
| **Your home** | The settings that belong to your account: the desktop's look, your apps' configuration | Built by home-manager into your home; your own choices in `~/.config` |

## One computer, one folder

Everything that makes your computer what it is lives in **`/etc/nixos`**:

```text
/etc/nixos
├── flake.nix                  the entry point (one line: build this machine with Standard)
├── configuration.nix          yours: name, owner, language, keyboard, your changes
├── hardware-configuration.nix this computer's disks and hardware, measured at install
├── modules/                   yours: any .nix file here is part of the system
├── machine/                   what Golem recorded about this computer (data, never code)
└── standard/                  StandardOS itself, root's editable copy
```

When you change a file and rebuild, the computer becomes what the files say. When Golem updates the system, it merges the new version of Standard into `standard/` and keeps what you changed there. Nothing else in `/etc/nixos` is ever rewritten. See [The machine folder](#expert-machine-folder).

## Tools and Golem

The model of the [Guide](#guide-welcome) holds inside too. The **tools** are commands and services with plain names: `update`, `recover`, `rebuild`, `status`… Anyone with the password can run them. **Golem** is a set of jobs that run those same tools on your behalf: the nightly update runs `update`, the first boot runs `update --converge`, the crash watcher goes back to the last version that worked. Golem's jobs keep its name (`golem-autoupdate.service`, `golem-first-boot.service`), and so does its memory, `/var/lib/golem`.

So there is nothing Golem does that you cannot do, see or undo:

- what it did is in its notices and in the journal (`journalctl -u golem-autoupdate`);
- what it would do, you can do now (`sudo update --now`);
- what it did, you can take back (go back a version, or `recover`).

## Reproducible, atomic, reversible

Three properties come from NixOS and shape everything else:

**Reproducible.** The system is a function of its files. The versions of everything Standard uses — NixOS, the dock, the desktop plugin — are pinned in `standard/flake.lock`, and the browser's in `standard/seam/sources.json`, so two computers on the same version of Standard run the same software. The browser is the one exception: it takes Mozilla's security releases on its own, between versions.

**Atomic.** A rebuild prepares the whole new system next to the running one and switches over in one step. A rebuild that fails changes nothing.

**Reversible.** Every system that was ever switched to stays on disk as a *generation* until it is cleaned away. The boot menu lists them, and going back is choosing one. See [Recovery](#expert-recovery).
