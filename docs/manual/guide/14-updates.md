# Updates and going back

StandardOS keeps itself up to date. You do not have to do anything: Golem gets each new version ready at night and your computer uses it the next time it starts. If a new version ever gives you trouble, you can go back to the one before.

## How updates reach your computer

Every new version of StandardOS goes through the same road before it reaches you:

1. **It is built and tested first.** Before a version is published, it is built for every kind of computer StandardOS supports and started in test machines. A version that fails any check is not published.
2. **It is published once a week.** A version that passed its tests becomes the new *stable* version, the one every installed computer follows.
3. **It arrives in waves.** Not every computer takes a new version on the same night. Computers are spread over a week, so a problem that slipped through the tests reaches few machines before it is stopped.
4. **Golem prepares it at night.** Once a night, at a moment of its own between midnight and six in the morning, Golem looks for a new version. When it is your computer's turn, it downloads the new version and builds it next to the one you are using. Nothing you see changes while it does. If the computer was off at that time, Golem does it soon after you turn it on, once you have been using it calmly for a while.
5. **You use it at the next start.** The new version takes over the next time the computer starts. Until then, everything stays exactly as it was. Golem never restarts your computer for an update.

If a new version has been waiting for two days or more, Golem reminds you once a day: *"Golem has an update ready — Restart when it suits you to start using it."*

## Updating now

You do not need to wait for the night. Open **Controls → Updates** and choose **Update now**, or type in a terminal:

```sh
update          # get the newest version; it starts at the next restart
update --now    # get it and switch to it right away
```

`update` asks for your password and tells you in plain words what it is doing: whether there is a newer version, what it is building, and when the new version takes over. If your computer is already on the newest version, it says so and does nothing.

!!! note "Updating by hand skips the waves"
    A version you ask for yourself is taken at once, even if your computer's wave has not come yet.

## Going back a version

If something worked before an update and does not work after it:

1. Open **Controls → Updates**.
2. Choose **Go back to it**, then **Go back and restart**.

The computer restarts a few seconds later, on the version you had before. Golem remembers that you went back from that version and will not take it again: it waits for a newer one. After the restart it tells you: *"Golem went back to the previous version — As you asked. It will update again when a newer version is out."*

You can also start an older version from the boot menu, for one start. When the computer starts, a menu shows for one second: press an arrow key to hold it, choose **Previous Versions**, and pick an older version from the list (each one is named by its number and date). The next normal start is on the newest version again; to stay on the version before it, use **Go back** as above.

## When the desktop fails to start

You do not have to do anything. If the desktop crashes once, it starts again by itself. If it crashes twice in a row right after starting, StandardOS goes back by itself to the version before, restarts, and tells you: *"The desktop kept crashing after an update, so Golem restarted on the version before it. It will update again when a fixed version is out."* Golem will not take that version again: it waits for a fixed one.

## Your own changes are kept

If you changed StandardOS's own files (most people never do; see [The machine folder](#expert-machine-folder) in the Expert part), an update keeps your changes: the new version is merged into the files as you left them. Only when you and the new version changed the very same lines does the new version win; your file is then kept aside, not lost, and Golem tells you: *"Golem kept your edits aside"*.

## If updates stop

If your computer could not update for a week, Golem tells you: *"Golem could not update for N days — It tries again every day and needs nothing from you but an internet connection. If this keeps coming back, restart the computer."* The most common reasons, and what to do, are in [Troubleshooting](#guide-troubleshooting).
