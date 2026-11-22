# Security

StandardOS is a computer for one owner. Its security model is short: **nothing a program running as you can do may silently become root**, nothing about you leaves the computer, and every protection is checked by a test, not just promised.

## No telemetry

There is no telemetry, no crash reporting, no usage statistics and no account. The update waves are computed from the local `machine-id`; notices are local files. The network calls StandardOS makes by itself are listed in [Privacy and security](#guide-privacy): the update (`git fetch` from GitHub, the release cache), NixOS's binary cache, the clock, firmware metadata (fwupd, daily), the browser's update check (Mozilla), and previews of links you copy.

StandardOS is free software under the GPL-3.0-or-later, so that nobody can take it, add telemetry or ads, and ship it closed.

## One door to root

The system is built only from root-owned files in `/etc/nixos`. The owner's account has no way to change what root builds, except through **data** that root checks:

| You do | Your account writes | A root helper |
|---|---|---|
| Install or remove an app in the dock | `~/.config/waverunner/packages.list` | Looks up every name, writes `/etc/nixos/machine/apps.list`, builds in a root-only copy first |
| Answer a post-install question | `~/.config/golem/postinstall-answers.json` | Checks the answer against `questions.json`, writes `machine/answers.list` |

The `.list` files are read by the build as text, one name per line, each one looked up — never imported as code. Everything else in `/etc/nixos` needs `sudo`.

## Accounts and sudo

- **root has no password.** Administration goes through `sudo`, for members of `wheel` only (`execWheelOnly`), with a password, never `NOPASSWD`. A password stays valid for 15 minutes.
- **The owner's password hash never enters the Nix store**: the system reads it from `/var/lib/golem/secrets/owner-password-hash`, which mirrors `/etc/shadow`. A `hashedPassword` left in a machine file triggers a build warning.
- **The owner's groups:** `wheel`, `networkmanager`, `video`, `uinput`, `adbusers`, `lp`, `scanner` — and `kvm` or `dialout` only when a module's program needs them. Not `input`, which would let any program read every keyboard.
- **Polkit** lets the owner *start* (only start) a few services without a password: the update, Update now, Go back, the rollback, Clean up, and `fstrim`.

## The network

- The firewall is on. Open by default: mDNS (UDP 5353), so network printers and scanners are found. App ports are opened only by the module that installs the app (KDE Connect, LocalSend). Sharing your connection opens DNS and DHCP only where it is shared: on wireless interfaces for the hotspot, on the Bluetooth link for Bluetooth sharing.
- Wi-Fi uses a private address per network (`wifi.macAddress = "stable"`): the same on each return to a network, different from one network to the next.
- **SSH** runs on every install with password and keyboard-interactive login off, and **no authorized key**, so nobody can log in; `sshguard` blocks addresses that keep trying. Port 22 is open in the firewall. To close it, or to turn SSH off, add to `configuration.nix`:

```nix
services.openssh.openFirewall = false;   # keep SSH, closed to the network
# services.openssh.enable = false;       # or no SSH at all
```

## The kernel

Standard sets `kernel.dmesg_restrict`, `kernel.kexec_load_disabled`, `net.core.bpf_jit_harden = 2`, `dev.tty.ldisc_autoload = 0`, `fs.protected_fifos = 2`, `fs.protected_regular = 2`, `vm.unprivileged_userfaultfd = 0`, reverse-path filtering, SYN cookies, no ICMP redirects or source routing, and the kernel parameters `slab_nomerge` and `page_alloc.shuffle=1`. Rarely used network protocols and old file systems (DCCP, SCTP, RDS, TIPC, AX.25, cramfs, HFS…) are blacklisted. `/tmp` is emptied at every start.

Deliberately not done, because they break debugging tools or apps people use: `ptrace_scope`, disabling core dumps, a kernel lockdown beyond the above.

## Start-up and disk

- **The boot menu** starts any entry without a password, but editing an entry or opening GRUB's command line asks for one (user `golem`, 16 random letters made at the first bootloader install, stored root-only). `sudo boot-password` shows it.
- **Disk encryption** (LUKS2, UEFI only) is an installer option, off by default. See [Installation in depth](#expert-install--encryption).
- **The lock screen is the login**: the desktop starts behind it, and the keyring opens only with the password the lock screen accepted. A desktop that restarts by itself always comes back locked.

## Updates you can trust

- Installed machines follow `stable`, which moves only after every class of Standard machine has been built and the desktop has started in a virtual machine.
- Prebuilt pieces are accepted only with the cache's signature or NixOS's.
- Seam's updates are taken from Mozilla only when Mozilla's `SHA256SUMS` carries a valid signature from Mozilla's release key, whose fingerprint is pinned: `14F2 6682 D091 6CDD 81E3 7B6D 61B7 B526 D98F 0353`.

## Reporting a weakness

If you find a security problem in StandardOS, please do not post its details in a public issue. Open an issue that only asks the maintainers for a private way to send them, so it can be fixed for everyone first.
