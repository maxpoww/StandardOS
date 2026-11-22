# When something goes wrong

Most problems in StandardOS fix themselves, and most of the rest take one click. Find your situation below. If it is not here, search this documentation (<kbd>/</kbd>), or look in the Expert part's [Recovery](#expert-recovery).

## The desktop

**The desktop broke after an update.** If it crashes twice in a row, StandardOS goes back to the version before by itself, restarts and tells you. If it starts but something no longer works, use **Controls → Updates → Go back**. Golem will not take that version again; it waits for a fixed one.

**A grey screen says "Golem can't start the desktop right now".** Press **Restart**. If the screen comes back, start an older version from the boot menu (it shows for one second when the computer starts: press an arrow key, then choose **Previous Versions**).

**A message says the desktop came back on its own.** Something closed your session without you asking; StandardOS opened it again, locked, and kept the reason in the log. Nothing to do. If it happens again and again, the text login says the desktop closed several times in a row: sign in with your password.

**The lock screen is frozen.** Press <kbd>Super</kbd>+<kbd>L</kbd>: a working lock screen comes back.

**The screen looks wrong after changing the resolution.** Do nothing: it goes back by itself after 15 seconds unless you press **Keep**.

**The screen flickers.** In **Controls → Monitors**, choose a fixed refresh rate instead of *Dynamic*.

**Some apps keep their old colours after I changed them.** Close and reopen them.

## Updates

**"Golem has an update ready".** Restart when it suits you: the new version starts then.

**"Golem could not update for N days".** Check that you are connected to the internet. Golem tries every day and needs nothing else; if the message keeps coming back, restart the computer. **Controls → Updates** shows when the last try was and whether it failed.

**"Golem kept your edits aside".** You (or someone) changed StandardOS's own files, and the new version changed the same lines. Your copy is kept in the folder the notice names. See [Updates](#guide-updates).

## Apps

**"Golem couldn't install the app".** Read the rest of the notice: the disk is full (empty the Bin, remove apps you do not use), there is no internet (connect, then try again), or something else went wrong (try again later). Nothing was half-installed.

**"Your apps arrive at the next restart".** The computer is still finishing its first setup. When **Controls → Updates** says *Restart to finish updating*, restart, and they are there.

**I can't find an app I installed.** Tap <kbd>Super</kbd> and type its name. Apps installed with a module are in the Apps grid too.

## Disk and memory

**"The disk is almost full".** Open **Controls → Storage → Free up space**: empty the Bin, clean caches, remove old system versions. Then look at your biggest folders (Downloads and Videos, often).

**The computer is slow.** **Controls → Memory** and **Controls → Processor** show what uses them, with a button to close or quit it. On older computers, **Controls → Graphics → Effects → No blur** helps.

## Power

**The computer locks or sleeps during a long task.** Turn on **Keep awake** in the gear, or change the times in **Controls → Lock screen** and **Controls → Sleep**.

**A game dims or sleeps while I play with a controller.** With the Gaming module, a fullscreen game keeps the computer awake. Otherwise, turn on **Keep awake**.

**The battery is very low.** Plug in. At 5 % the computer goes to sleep; if you wake it before plugging in, it hibernates, keeping everything you had open. Asleep, the battery still drains: plug in as soon as you can.

## Network

**Wi-Fi says the password is wrong.** Type it again in **Controls → Wi-Fi**.

**Hotel or airport Wi-Fi connects, but nothing loads.** These networks want you to sign in on a web page first. Open a web page in Seam: the network's sign-in page appears, or Seam offers to open it.

**No internet through the phone.** Plug the phone in, and choose **Use phone's internet** in its menu.

## Devices

**My phone shows no files.** Unlock it and choose **File transfer** (or MTP) when it asks. See [Your phone](#guide-phone).

**Mirror or camera asks for USB debugging.** The phone pill's box shows the steps; see [Your phone](#guide-phone).

**A printer was plugged in but nothing happened.** Wait for *"Printer ready"*. If it does not come, use **Controls → Printers → Add a printer by its address**.

**A print is stuck.** Cancel it on the task pill, or in **Controls → Printers**.

**The keyboard types the wrong letters.** Check **Controls → Keyboard layout**. With two layouts, the keys you chose switch between them.

**Dictation says nothing was heard.** Unmute the microphone (gear) and try again.

## Files

**I deleted or moved something by mistake.** Press <kbd>Ctrl</kbd>+<kbd>Z</kbd> (or the ↶ button in Files). Deleted files are in the Bin: **Put back** returns them.

## Passwords

**I forgot my drive's encryption password.** There is no way to recover it. This is what keeps the drive safe.

**I need the boot menu's password.** Type `sudo boot-password` in a terminal.

## Still stuck?

Start an older version from the boot menu (**Previous Versions**): it changes nothing on disk, and lasts for that one start. If the older version works, start normally again and use **Controls → Updates → Go back**: StandardOS returns to the version before and stays there. The Expert part's [Recovery](#expert-recovery) explains every tool, down to repairing a computer that does not start at all.
