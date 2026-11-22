# Installing StandardOS

All you need to install StandardOS is a USB stick. The installer asks six simple questions, copies the system to your computer without needing the internet, and checks its own work before you restart.

!!! warning "The whole drive is erased"
    StandardOS installs on a whole drive, and everything on that drive is erased. Copy your files somewhere else first. Installing beside Windows on the same drive is not available yet.

## What you need

- **A 64-bit computer** (most made in the last fifteen years), with 4 GB of memory or more. StandardOS also installs on 2 GB, but it is slow there.
- **Enough disk:** about 22 GB for StandardOS, plus a swap area a little bigger than your memory, so the computer can hibernate. With 4 GB of memory, a 32 GB drive is enough; with 8 GB, the drive needs at least 33 GB; with 16 GB, at least 42 GB. Your files need room too.
- **A USB stick of 8 GB or more.** Its contents are erased when you write the installer onto it.
- **Secure Boot turned off** in the computer's firmware settings, on computers that have it.

## Make the USB stick

1. Download the StandardOS installer (an `.iso` file) from the website.
2. Write it to the USB stick with a USB-writing app — for example balenaEtcher on Windows, macOS or Linux. Choose the file, choose the stick, and write.

On StandardOS or another Linux, you can also use a terminal (replace `installer.iso` with the file you downloaded, and `sdX` with your stick — check it twice, because that drive is erased):

```sh
sudo dd if=installer.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Start the computer from the stick

Plug the stick in and turn the computer on while pressing its boot-menu key, then choose the USB stick. The key depends on the maker: often <kbd>F12</kbd>, <kbd>F9</kbd>, <kbd>F11</kbd> or <kbd>Esc</kbd>; on a Mac, hold <kbd>Option</kbd>.

The installer shows two choices:

- **Install** — install StandardOS on this computer.
- **Start** — a plain text console, for looking at the hardware or repairing an installed system. Nothing is installed.

## The six questions

Use the arrow keys and <kbd>Enter</kbd>. Typing filters a list; <kbd>Esc</kbd> goes back one step.

1. **Language.** The installer and the desktop speak English, Spanish, Portuguese, French, German and Italian. With any other language, they speak English.
2. **Time zone.** The list starts with the zones of your language, and shows the time it is in the zone you pick.
3. **Keyboard.** Suggested from your country; the keyboard switches at once so you can try it.
4. **Drive.** The drive to install on, with its model and size. The USB stick is never in the list. The last row, **Advanced**, offers to encrypt the drive (see below). On older computers that start with BIOS instead of UEFI, StandardOS can only be installed on the first drive.
5. **You.** A name for the computer, your user name (small letters and numbers), and your password, typed twice.
6. **Install StandardOS?** A summary of your answers and of what was found on this computer. <kbd>Enter</kbd> starts the installation.

The installer copies the system (a bar shows the progress), then checks it: the bootloader, the system, the kernel, the disks, StandardOS's own files and your account. When it says the installation is healthy, **remove the USB stick and press <kbd>Enter</kbd>**. The computer restarts into StandardOS.

## Encrypting the drive

In **Drive → Advanced → Full-Drive encryption** you can choose to encrypt the whole drive. Its password needs at least 8 characters, and it is shown as you type it, so you can check it. From then on, that password is asked every time the computer starts, before anything else — your files cannot be read without it, even if the computer is stolen.

!!! danger "There is no way to recover a forgotten drive password"
    If you forget the drive's password, everything on the drive is lost forever. Turn encryption on only if you will keep that password safe. It needs a computer with UEFI firmware (most made after 2012).

## If something goes wrong

If the installation fails, the installer shows the error on the screen. Take a photo of it: whoever helps you will want it (the full log is in `/var/log/golem-install`, reachable with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F2</kbd>). If the checks before the copy failed, nothing was written to your drive. Restarting and trying again is safe.

Next: [The first start](#guide-first-start).
