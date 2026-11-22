# The first start

The first time StandardOS starts, the desktop is ready at once, in your language, with your keyboard and your time zone. While you start using it, Golem quietly finishes setting the computer up for its exact hardware; that takes effect the next time you restart.

## The lock screen is the door

Every time the computer starts, the first screen is the lock screen: a clock and a password field. Type the password you chose during the installation and press <kbd>Enter</kbd>. The same password also opens your *keyring*, where apps keep your saved passwords — you will not be asked twice.

## What happens in the background

About half a minute after the first start, once you have been using the desktop calmly for a moment (a quarter of an hour on less powerful computers), Golem:

1. connects to the internet,
2. builds your computer's own system — its exact drivers, its name, the account name you typed,
3. sets it to start at the next restart.

You can use the computer normally meanwhile; Golem works at the lowest priority. If there is no internet, it tries again an hour later or at the next start. When you next restart, your computer starts with its own system, and your account carries the name you typed.

!!! note "Apps you install right away"
    If you install apps before this first setup has finished, Golem tells you: *"Your apps arrive at the next restart"*. The setup is done when **Controls → Updates** says *Restart to finish updating*: restart then, and they are there.

!!! note "A question about graphics"
    On a few laptops with two graphics cards, the second card does not wake up properly during the installation. Then a small window asks you once whether to keep it available (it uses a little more power) or to turn it off (it saves battery, but that card cannot be used). If you are unsure, keep it available.

## The screen at a glance

| | Where | What it is |
|---|---|---|
| **The top bar** | The top edge | The open window's name, the clock, and small round buttons ("pills") for the gear (quick settings), notifications, and whatever is happening now. See [The top bar](#guide-top-bar). |
| **The dock** | The bottom edge | Your apps. It stays out of your way when a window covers its place, and comes back when you touch the bottom edge with the pointer. See [Apps and the dock](#guide-dock). |
| **The box** | A tap of <kbd>Super</kbd> | Every app, a search, your files and the settings, in one place. |
| **The desktop** | Behind the windows | The files of your `Desktop` folder. A click on the bare background hides or shows them. |

<kbd>Super</kbd> is the key with the logo on it (Windows or command key).

## The first things to do

- **Open an app:** tap <kbd>Super</kbd>, type a few letters of its name, press <kbd>Enter</kbd>.
- **Change a setting:** tap <kbd>Super</kbd> and <kbd>Ctrl</kbd> together to open Controls, or press <kbd>Super</kbd>+<kbd>H</kbd>, type the setting's name (*wifi*, *wallpaper*, *language*…) and press <kbd>Enter</kbd>.
- **Connect to Wi-Fi:** open **Controls → Wi-Fi** and choose your network. (Or rest the pointer on the gear, at the top left: small symbols slide out of it; click the Wi-Fi one.) See [Controls](#guide-controls).
- **Choose a wallpaper:** put pictures in your **Pictures → Wallpapers** folder, then **Controls → Wallpaper**. A fresh StandardOS has no wallpaper: the background is a quiet grey, and the desktop wears the Standard colours.
- **Install an app:** tap <kbd>Super</kbd>, type its name, and drag it from the **Install** row to your apps. See [Installing apps](#guide-apps).

## Turning off, sleeping, restarting

There is no "log out" in StandardOS: you lock, sleep, hibernate, restart or turn off.

- **Lock:** <kbd>Super</kbd>+<kbd>L</kbd>.
- **Sleep, hibernate or restart:** press the power key briefly: a round **Hibernate** pill appears at the top, and **Sleep** and **Restart** come out of it when the pointer reaches it. Click one. The gear's box has them too, at the bottom.
- **Turn off:** hold the power key for about five seconds.
- **Close the laptop's lid:** it sleeps, and after two hours it hibernates so the battery is not drained.

Hibernating saves everything you have open to the disk and turns the computer off; when you turn it on, everything comes back as it was.
