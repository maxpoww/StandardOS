# Hardware

StandardOS sets itself up for the computer it is installed on. At install, a probe measures the hardware and writes the facts down; at every build, a **chooser** reads those facts and picks the pieces of system that fit: the bootloader, the graphics drivers, the memory settings, the power settings, the fixes a particular machine needs. This page explains both, and how to correct them.

## The facts

The installer runs `golem-hw-detect`, which only reads (nothing is changed), and stores what it found in **`/etc/nixos/machine/facts.json`**. The system reads it at every build as `standard.hardware`.

| Fact | How it is found |
|---|---|
| `cpuModel`, `cores`, `threads`, `cpuVendor` | `/proc/cpuinfo` and sysfs |
| `ramMB` | the memory size |
| `gpu`, `intelLegacy`, `nvidiaGen` | the main graphics card's PCI vendor and device id; NVIDIA's generation (Turing and newer, or older) is known only from a known device id |
| `gpu2`, `gpu2Health` | a second graphics card, and whether it wakes up cleanly (tested at install; unsure means nothing is claimed) |
| `firmware` | `uefi` or `bios` |
| `chassis` | laptop or desktop, from the firmware's chassis type or a battery |
| `hasBluetooth`, `fingerprint`, `broadcomWifi`, `hasFacetimeHD`, `lightSensor` | the devices that need something particular |
| `panelDpi` | the laptop screen's density, from its EDID |
| `vmGuest` | running in a virtual machine (QEMU, VMware, VirtualBox, Hyper-V) |

The rule behind every fact: **an uncertain fact lands on the safe side.** NVIDIA's own driver is used only for a generation that is known; anything unsure gets the open drivers that always work.

## The chooser

The chooser maps facts to *leaves*: one file each under `system/Modular/`, imported whole. `/etc/golem/layout.json` lists the leaves this computer uses, each with the reason.

| Group | Leaf | Chosen when |
|---|---|---|
| boot | `grub-efi` / `grub-bios` | UEFI / BIOS |
| cpu | `intel-microcode` / `amd-microcode` | the CPU's vendor (AMD also gets `amd_pstate=active`) |
| gpu | `intel`, `intel-legacy`, `amd`, `virtio`, `auto` | the main GPU; `intel-legacy` for older Intel graphics, with light effects |
| gpu | `nvidia-turing`, `nvidia-preturing`, `nouveau-floor` | an NVIDIA main GPU of a known recent, known older, or unknown generation |
| gpu2 | `nvidia-offload-turing`, `nvidia-offload-preturing`, `amd-offload` | a working second GPU, used on demand (PRIME offload) |
| gpu2 | `failing` | a second GPU that did not wake cleanly: kept awake (default) or powered off |
| memory | tier 0 to 3 | the memory size (unknown · under 6 GB · 6–16 GB · over 16 GB) |
| power | `laptop` (+ `thermald` on Intel) | a laptop |
| virt | `qemu-guest` | running in QEMU |
| quirks | `broadcom-wl`, `facetimehd`, `fingerprint` | the device is present |

Always present, whatever the facts: the boot screen, hibernation-sized swap, the disk policy, and two runtime fixes that decide on the machine itself (below).

## Graphics

- **Intel**: VA-API video decoding with the right driver for the generation. Older Intel graphics (Haswell and before) get light effects: no blur, a denser dock, and the dock's small icon tier.
- **AMD**: the open drivers; video decoding through Mesa.
- **NVIDIA, Turing and newer**: NVIDIA's open kernel module with its power management on (for suspend and resume), and video decoding through `nvidia-vaapi-driver`.
- **NVIDIA, older**: NVIDIA's legacy 580 driver.
- **NVIDIA, unknown generation**: nouveau, the open driver, until the generation is known.
- **Two GPUs**: apps run on the integrated one; **Controls → Graphics → Open with the fast card** lists the apps to start on the discrete one, using PRIME offload.

## Memory, power and heat

| Memory tier | zram | Notes |
|---|---|---|
| under 6 GB | 150 % of RAM | builds use one job, two cores |
| 6–16 GB | 50 % | — |
| over 16 GB | 25 % | — |

- **Swap** is sized for hibernation (RAM plus a margin, rounded up), so closing the lid sleeps and then hibernates after two hours.
- **Laptops** get power profiles (balanced on battery, performance on the charger; the dock switches them) and, on Intel, thermald.
- **PROCHOT release** (every machine): some laptops hold the CPU at its lowest speed when the battery is dead or the charger is unknown. On the charger, and only when the CPU is cool, StandardOS releases that hold. On a MacBook Air 2013 this took the CPU from 800 MHz to 2.3 GHz.
- **Intel GPU clock floor** (every machine): on the charger, with a screen faster than 75 Hz, the Intel GPU keeps a clock high enough to draw every frame.

## Particular devices

- **Broadcom Wi-Fi** (MacBooks and others): the `wl` driver.
- **FaceTime HD camera** (MacBooks): its driver, with a timestamp fix and a re-bind after start-up that works around a cold-boot glitch.
- **Fingerprint readers**: fprintd is on; enrolling a finger is your choice.
- **Ambient light sensor**: `autobrightness` exists only where one was found.
- **Printers and scanners**: see [Printers and scanners](#guide-printing).

## Bootloader and kernel

- GRUB on every machine, BIOS and UEFI. On UEFI it is installed at the removable path (`EFI/BOOT/BOOTX64.EFI`) and never writes the firmware's boot entries, because some firmware deletes them.
- The kernel is the one the NixOS release defaults to (6.18 LTS today). StandardOS does not pick a kernel of its own; newer kernels broke NVIDIA's open module, the FaceTime camera and the Broadcom driver, so the update lane builds both NVIDIA desktops against every new kernel before publishing.

## Correcting the facts

If a fact is wrong (a GPU generation the probe could not know, say), you can:

1. edit `/etc/nixos/machine/facts.json` — it is data, safe to change — and run `rebuild` (for example `"nvidiaGen": "turing+"`): the chooser reads it at every build;
2. or add a module of your own in `/etc/nixos/modules/` for anything the chooser does not cover.

Setting `standard.hardware.*` in `configuration.nix` does not work: the facts file sets those options itself.

To measure again, boot the installation medium and choose **Start**: the census runs by itself and leaves its report in `/var/log/golem-audit/summary.txt`.
