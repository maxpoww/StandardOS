# The machine folder

Your computer is the folder `/etc/nixos`. What is written there is what the computer is: change a file, rebuild, and the computer follows. This section explains each file, what is yours to edit, and what Golem touches.

## What is in it

| Path | Whose | What it is |
|---|---|---|
| `flake.nix` | Standard's, never edit | One line: build this machine with the copy of Standard beside it. It has no inputs of its own. |
| `configuration.nix` | **Yours** | This computer: its name, its owner, its language and keyboard, its modules, and any change you want. Golem never rewrites it. |
| `modules/` | **Yours** | Every `.nix` file you put here is part of the system, imported in name order. Golem never writes here. |
| `hardware-configuration.nix` | This computer's | The disks and hardware, measured by the installer. Edit only if you change disks. |
| `machine/` | Golem's records | What Golem recorded about this computer: the hardware facts found at install, the apps you installed from the dock (`apps.list`), your answers after install. Data, never code. |
| `standard/` | Root's copy of Standard | StandardOS itself: a git checkout you may read and edit as root. Updates merge into it and keep your edits. |

## configuration.nix

A new computer gets this file, filled with the installer's answers:

```nix
{ config, lib, pkgs, ... }:

{
  # ── Who and what (the installer's questions) ───────────────────────────
  standard.owner = "ana";
  networking.hostName = "ana-laptop";
  users.users."ana".description = "Ana";

  standard.locale.defaultLocale = "es_AR.UTF-8";
  standard.locale.timeZone = "America/Argentina/Buenos_Aires";

  standard.keyboard = {
    layout = "latam";
    variant = "";
    options = "";
    model = "";
    consoleKeyMap = "la-latin1";
  };

  # ── Modules: a whole kind of work, its programs and the system they need ─
  #   standard.modules.gaming.enable = true;              # the recommended set
  #   standard.modules.development = {                    # or tool by tool
  #     enable = true;
  #     install = "chosen";
  #     docker.enable = true;
  #     vscode.enable = true;
  #   };

  # ── Your own changes ────────────────────────────────────────────────────
  # environment.systemPackages = [ pkgs.htop ];
  # services.openssh.enable = true;
}
```

Anything NixOS can do, you can write here: every NixOS option works (`man configuration.nix` lists them all). An option you set here wins over Standard's default; when Standard insists on a value, `lib.mkForce` makes yours win.

!!! warning "No passwords or keys in this folder"
    Everything in `/etc/nixos` is copied, readable by every user, into the Nix store at each rebuild. Keep passwords and private keys out of these files.

## Applying a change

After editing, rebuild:

```sh
rebuild          # apply now (it asks for your password)
rebuild boot     # apply at the next start
```

`rebuild` is `nixos-rebuild` for this machine (`/etc/nixos#default`), behind Standard's one rebuild lock, so it never collides with Golem's nightly update, and with the published cache of your version of Standard, so it downloads instead of compiling where it can. A rebuild that fails changes nothing: the running system stays as it was, and the error says which file and line to look at.

## Your own modules

Put anything that deserves a file of its own in `modules/`: a printer, a VPN, a service you run, a whole module of your own.

```nix
# /etc/nixos/modules/printer.nix
{ pkgs, ... }:
{
  services.printing.drivers = [ pkgs.brlaser ];
}
```

Then `rebuild`.

## Changing one of Standard's modules

Most of the time you do not need to: an option set in `configuration.nix` already wins over Standard's default. When you do, there are two ways.

**Edit Standard's file in place.** Standard's own files are in `/etc/nixos/standard`, yours to edit as root. Change the file and run `rebuild`. When Golem updates, it merges the new version into the files as you left them (a three-way merge, as git does). Where you and the new version changed the same lines, the new version wins and your file is set aside in `/var/lib/golem/local-edits/`. `sudo status` lists what this computer changed.

**Replace the module with your own version.** Leave Standard's file alone and carry a whole copy of your own in `modules/`, disabling Standard's:

```nix
# /etc/nixos/modules/gaming.nix — my version of Standard's Gaming module
{ standardSource, ... }:
{
  disabledModules = [ "${standardSource}/system/modules/gaming.nix" ];
  # … the contents of ../standard/system/modules/gaming.nix, edited …
}
```

`standardSource` is the path of this computer's copy of Standard, given to every module. In your copy, make the module's relative imports absolute: `import ./lib.nix` becomes `import "${standardSource}/system/modules/lib.nix"`.

## What Golem touches, and what it does not

- **Golem writes** `standard/` (merging each update, keeping your edits) and `machine/` (its records: apps installed from the dock, answers, hardware facts).
- **Golem never writes** `configuration.nix`, `modules/` or `hardware-configuration.nix`.
- **Every write is visible**: `standard/` is a git checkout (`sudo git -C /etc/nixos/standard log`), and Golem's notices and journal say what it did.
