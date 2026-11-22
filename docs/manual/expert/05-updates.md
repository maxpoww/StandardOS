# Updates in depth

An update of StandardOS travels from the developers' repository to your computer through three stops: the **lane**, which builds and tests every version; the **stable** branch, which every installed computer follows; and **Golem's nightly job** on your computer, which merges, builds and stages it. This page follows that road.

## Two branches

| Branch | What it is |
|---|---|
| `main` | Where work lands. It reaches no installed computer by itself. |
| `stable` | What installed computers follow. Only the lane moves it, only forward, and only to a version that built, booted and has its prebuilt pieces published. `stable` never holds a commit that `main` lacks. |

## The lane

The lane runs every day on the build machine. On a publishing day (once a week) it:

1. Starts from a clean clone of `main`.
2. Moves to a new NixOS release when one is due (four weeks after it appears, or when the current one ends within two weeks). `system.stateVersion` never changes.
3. Updates NixOS and home-manager to their newest commits (weekly), in one commit.
4. Runs **the gate**: every flake check, a boot test of the real desktop in a virtual machine, and a build of every kind of computer StandardOS supports (each lab machine, BIOS and UEFI, plus synthetic NVIDIA desktops). Any failure stops here; `stable` is not touched and the developers are told.
5. Publishes **the cache**: every built piece that cache.nixos.org does not have, signed with Standard's key, as release `g-<commit>` of [maxpoww/golem-cache](https://github.com/maxpoww/golem-cache).
6. Moves `stable` to that commit.

On other days it only checks `main` when it moved.

## Golem's nightly job on your computer

`golem-autoupdate.timer` fires once a day at a moment fixed for each computer between 00:00 and 06:00, and soon after power-on if that moment was missed. Then `golem-autoupdate.service`:

1. **Waits for a quiet moment**: the dock must have been up for a minute (fifteen minutes and a calm minute on a weak machine), or five minutes with nobody logged in.
2. **Waits for the network**; with none, it tries again in an hour.
3. **Runs `update --nightly`** at the lowest priority (nice 19, idle I/O): see [update](#expert-commands--update).
4. **Makes the new version start at the next boot** — never a live switch, never a forced restart: your session is never touched.
5. Checks that the new version is in the boot menu (if `/boot` is full, it says so and the run fails).
6. Records the result for the notices.

### Waves

Each computer has a wave from 0 to 6, derived from its machine id. A new version waits `wave × 24 h`, counted from its publication or from the first night that found the computer behind. Nothing is reported or asked to decide this: the wave is computed on the computer.

### The published cache

Before building, `update` asks GitHub whether the version's prebuilt pieces exist (`golem-cache-args`):

- **Published**: the build downloads them; nothing heavy is compiled.
- **Not published** (a version cut from work that the lane has not published yet): the build compiles what it needs.
- **No answer** (no network, GitHub down): the nightly job builds nothing and tries again in an hour — it never compiles blind for hours.

A piece is accepted only if it is signed by a key in `standard.update.cache.publicKeys`, so a wrong address can only make a build slower, never different. cache.nixos.org is always asked first.

## Your edits and the merge

The files in `/etc/nixos/standard` are a git checkout. `update` builds a commit of the files exactly as they are on disk (your edits, new files, deletions) on top of the version they came from, and merges the new version into it with `git merge-tree`, in memory:

- Changes that do not touch the same lines are combined: your edit stays.
- Where both changed the same lines, the new version wins, and your copy of that file goes to `/var/lib/golem/local-edits/<date>/`. `/var/lib/golem/local-edits/latest` names the newest such folder, and you get a notice.
- After the update, your edits remain as uncommitted changes on top of the new version: `sudo status` shows them.

## Never backwards, and held versions

`update` never moves to an older version than the one your files came from: a computer ahead of `stable` (installed from a newer medium) waits until `stable` catches up.

When you **go back** from a version, or the desktop crashed with it, that version is written to `/var/lib/golem/held-revisions`; the nightly job never builds it again and waits for a newer one. A manual `update` does not hold back.

## The browser updates on its own

Seam follows Mozilla's releases between versions of Standard: `seam-update.timer` checks every four hours and changes only the browser's pin (`seam/sources.json`). When Standard's next version arrives with an older browser, your newer one stays.

## Notices

Golem tells you, at most once a day each:

- *"Golem has an update ready"* — a new version has waited two days or more for a restart.
- *"Golem could not update for N days"* — seven days without a successful run, and a failure since.

What changed in each version is in **Controls → Updates**, from `/etc/golem/whats-new.json`.

Nothing about your updates is ever sent anywhere. The only network requests are the downloads themselves and the question to GitHub about the published pieces.

## NixOS releases and the kernel

StandardOS follows a NixOS release (`nixos-26.05` today) and the kernel that release defaults to (6.18 LTS); Standard does not choose a kernel of its own. The lane moves to the next NixOS release by itself before the current one stops getting security fixes.
