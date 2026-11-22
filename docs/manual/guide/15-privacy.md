# Privacy and security

StandardOS does not watch you. There is no account to create, no advertising, and no telemetry: nothing about you, your files or how you use the computer is collected or sent anywhere. What happens on your computer stays on it.

## What does go on the internet

A computer has to reach the internet for some things. This is what StandardOS itself reaches it for:

| What | Why |
|---|---|
| StandardOS's updates | Golem downloads each new version from GitHub, and asks whether its prebuilt pieces exist |
| NixOS's packages | The pieces of the system and of the apps you install, from cache.nixos.org (also asked, before an update, to check that the internet works) |
| The time | The clock is set from the internet's time servers (pool.ntp.org) |
| The browser's updates | Seam asks Mozilla for new Firefox releases, every four hours |
| Firmware updates | Device firmware, from the Linux firmware service, once a day |
| Previews of copied links | When you copy a link, the page is asked for its title and picture |
| The browser's safety checks | Seam keeps Firefox's Safe Browsing (dangerous sites), certificate checks and the hotel Wi-Fi check, and uBlock Origin updates its block lists |

None of these carries anything about you. The waves that spread updates over a week are worked out on your computer, not asked from anyone. Apps you install, and the websites you visit, are their own business; Seam blocks ads and trackers, and has Firefox's telemetry turned off.

## The lock screen and your password

- The lock screen is the first screen at every start, and it comes back after 5 minutes away (change that in **Controls → Lock screen**). <kbd>Super</kbd>+<kbd>L</kbd> locks at once.
- If the desktop ever has to restart by itself, it always comes back locked.
- Your password also opens your **keyring**, where apps keep the passwords you save in them. It opens only after the lock screen accepted your password.
- Change your password in **Controls → Your account**.

## Administrator tasks

Changes to the system — installing an app from the terminal, editing the system's files — ask for your password (`sudo`). Installing and removing apps from the dock does not need it: the system checks every request itself. The system's own folders can be read but not changed from Files.

## Encrypting your drive

At installation you can encrypt the whole drive (**Drive → Advanced → Full-Drive encryption**). Then nobody can read your files without the drive's password, even with the disk in their hands. There is no way to recover a forgotten drive password. See [Installing StandardOS](#guide-install).

## The boot menu's password

The boot menu has a password of its own, made at installation. You never need it to start the computer or an older version; it only protects *editing* the boot menu, which would otherwise let anyone at the keyboard get into the system without a password. `sudo boot-password` shows it.

## Wi-Fi and Bluetooth

- On each Wi-Fi network your computer uses a private address of its own, so it cannot be followed from one network to another (**Controls → Wi-Fi** → a network → **Private address**).
- Bluetooth's **Be visible to others** switch (**Controls → Bluetooth**) decides whether other devices can find your computer.

## Apps and your camera and microphone

**Controls → Privacy** shows what is using your microphone or camera right now, and mutes the microphone with one click. Voice-to-text, dictation, the dictionary and the translator all work on your computer: nothing you say or write is sent anywhere.

## The browser

Seam has telemetry, studies, sponsored content and Firefox accounts turned off, and its AI chat and page summaries too; uBlock Origin blocks ads and trackers; saved passwords stay on your computer. Firefox's own crash reports are never sent.
