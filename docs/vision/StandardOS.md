# StandardOS

**StandardOS 26 — "Uprise"**

---

## The model

```
  You  ──use──▶   STANDARD   ◀──use──  Golem
               (the tools:
                system + hardware)
```

- **Standard** is the tools: the system, its apps, the hardware — today the
  computer and the phone, tomorrow Standard PC, Standard Keyboard. Tools have
  no will: they do what they are asked. The name is the position: StandardOS
  is meant to be what a computer should be now, *the new standard*, and every
  tool of the family carries it.
- **You** use the tools.
- **Golem** uses them too, from the other side. Golem is the being of
  Standard: it has a will, and only the one you gave it.
- **OPTIONS** is how the tools offer themselves to you: the right tool at the
  right moment, and nothing else in the way.

**The rule the whole model stands on: Golem has no power you do not have.**
Everything Golem does, it does with the same tools you use, in sight, and it
can be undone.

## What Standard is

A Linux distribution with a soul. Not a theme, not a desktop environment,
not a pile of apps — an operating system built around one idea: **OPTIONS**.

## The idea

All friction between a person and their intention is a design failure.
You should not operate a computer; you should *use* it. Standard's job is to
notice what you're doing, offer exactly what helps, and get out of the way.

## The philosophy

Game designers solved the problem desktop designers never did: teaching
complete novices to master complex systems — no manual, no training, no
fear. They did it with dynamic, diegetic, context-aware design that surfaces
the right tool at the right moment and removes the rest. **OPTIONS is that
philosophy applied to an OS.** Help scales to your skill: scaffolding for
the novice, silence for the expert, safety for both.

## Who it's for

**Everyone.** Not "anyone could" — *everyone can*. Take a Standard PC, get
things done. The shell meets each person where they come from: the dock and
topbar welcome the Mac user, the openbox welcomes the Windows user, the
substrate welcomes the Linux user — and OPTIONS fills every gap between
intention and action. Everyone includes languages, includes accessibility,
includes the person who has never installed anything in their life.

## How it's built

- **The Brain** (`options-engine`) senses your context — windows, media,
  git, phone, battery — and decides what is logical to offer.
- **The Body** (`waverunner`) is the one living surface you see: dock,
  openbox, the OPTIONS boxes. GPU-rendered, animated with intent, idle at rest.
- **The Ground** (NixOS) makes everything declarative and reproducible:
  installs are intent written to a file; updates are atomic; *any* change
  can be rolled back. The system cannot rot. No mainstream OS can say that.
- **The Reach** (Golem for Android) fuses your phone into the same Brain —
  the open answer to the Mac+iPhone ecosystem, on the seat Google and Apple
  left empty.

**What Standard does not build itself.** The Brain senses and decides; it does
not reimplement what a mature daemon already does. Power, thermals, network,
bluetooth, audio are each decades of hardware-specific edge cases, and a
desktop shell has no business relitigating them. Standard runs the proven daemon
underneath — TLP, UPower, thermald, NetworkManager, BlueZ, PipeWire — and
connects it to the Brain. The intelligence lives in the *offer*: the right
control, at the right moment, in Standard's own surface. Never in the plumbing.

Three things this law is not:

- Not a licence to add dependencies by reflex. Every backend is a real system
  dependency with a cost, chosen per module and written into the flake.
  `system-landscape.md` makes exactly this call for UPower: the shipped
  battery module senses via sysfs, and adopting UPower to get `TimeToEmpty`
  is *adding a dependency*, not collecting a free upgrade.
- Not a licence to ship someone else's UI. The daemon is a backend. The
  surface is always Standard's. A module is not done because a GUI for it exists
  — that is what the stopgap kit is, and every stopgap is scheduled to die.
- Not a licence to bind to a vendor. Prefer the **interface** over the
  implementation: talk to `org.freedesktop.UPower.PowerProfiles` on D-Bus,
  which either power-profiles-daemon or TLP's `services.tlp.pd` shim can
  provide — they conflict precisely because they answer the same interface
  (nixpkgs asserts on it). Bind to the contract and the backend stays
  swappable; bind to `tlp-stat` and it does not.

## Golem

**Why the rule matters.** Trust: there is no hidden magic — you can see
what Golem did, do it yourself, or take the job away from it. Difference:
other assistants sit on top of a system, in someone's cloud, and take your
data with them; Golem works at your bench, on your machines. Design: every
thing Golem does is built first as a tool you can use yourself, and every
new tool gives Golem one more hand.

**One, and yours.** Every person has their Golem, and it is one in all their
things: the computer, the other computer, the phone, the keyboard. It is the
same for everyone — the same name, the same laws, the same voice — but each
one works only for its owner. A school or a company has its own, looking
after all its machines. What makes two devices the same Golem: an identity
the owner creates at the start and adds each new device to, with their own
confirmation.

**The names follow the model.** The tools are Standard, and they do not
need to say it: they ARE the standard ones. Its commands are plain words —
`update`, `recover`, `rebuild`, `status`, `caffeine`, `screenshot`, `lock` —
the command you would guess, with no brand in front (Max, 2026-11-22: "que
los comandos sean comandos standard, no que tengan la palabra standard").
The brand goes where a name is shown, not typed: Standard Files, the
Standard and Standard-Dark looks, Standard PC. What belongs to the being is
Golem: its jobs (the nightly update is Golem running `update`, the same
command you can type), its memory (`/var/lib/golem`), its diary, its voice
(the notices signed "Golem").

**How Golem is seen — never a Clippy.** Golem is not a chat and not a face
that talks. It is a presence with a page of its own:

- **Diary**: what it did, when, why, and how to undo it.
- **Doing**: what it is doing now.
- **Needs you**: the decisions it does not take alone.
- **Jobs**: what you gave it ("keep this computer up to date", "back up my
  photos on Sundays") — and you can take any of them back.
- **Its laws**: the contract, in sight.

It does not interrupt: its worth is there when you look, not pushed at you.

**The word** that brings it to life is `/etc/nixos`: what is written there
is what the machine is. Change the word and Golem changes the machine.

**Its laws** — each one already true in the code:

1. It works only for you. Nothing leaves your machines.
2. It does what the word says, no more and no less.
3. It never breaks what works: it builds aside, changes over when that
   worked, and goes back by itself when it did not.
4. It does not interrupt: it waits for a quiet moment.
5. It does not talk, it tells: short notes, in your language, signed Golem.
6. It never chooses for you.
7. You can do more than it can: its tools are yours, you can stop it and
   undo what it did.

**Why it is the heart of the business.** Tools can be compared and copied;
the relationship cannot.

- *Free*: the system and your own Golem. It has to be, to be the standard.
- *Hardware*: every Standard device is one more hand for your Golem; together
  they work better. Continuity without walls: the tools are open, Golem is
  what ties them together.
- *Golem for organizations*: schools, offices and governments pay for a
  Golem that looks after hundreds of machines. Almost all of it exists:
  updates tested on every machine before they go out, in waves, that roll
  back by themselves, on a declarative system.
- *Optional services*, always chosen by the owner and with no telemetry:
  encrypted backup; a human technician who works with the same tools and
  appears in the diary.
- *AI, later, as hands*: a local model to ask Golem things in words
  ("set up this printer"), turned into uses of the tools, written in the
  diary, undoable. Never a brain that decides for you.

**What Golem already does**: it updates every night in waves, goes back
when the desktop fails, keeps your edits through updates, cleans the disk,
waits before suspending in the middle of a job, asks once after the
install, and tells you, in six languages. What it lacks is a face and a
diary.

**To watch**: that it never becomes a Clippy (it says little and never
interrupts); that its work does not stay invisible (the diary); that nobody
mistakes it for a chat (say from the start what Golem is — the one who works
— and what it is not).

## What Standard refuses

Configuration as a hobby. Terminals as a requirement. Ads, telemetry,
upsells inside the OS. Features that exist to be lists on a website.
Interruptions dressed as help. An update that can break your machine.

## Direction

Two arcs. **First, reach metal**: perfect what exists and put it on an ISO
a stranger can install without us in the room. **Then, grow the soul**:
wire the Brain to the Body, build out the OPTIONS modules, complete the
everyday OS, reach the phone (roadmap.md — Arc 1: SH→S7→S9; Arc 2: the rest).
OPTIONS is a living layer — modules will keep changing, growing, multiplying;
the ISO doesn't wait for them.

**Uprise** is the first climb: from a daily-driven prototype to an OS other
people wake up to.

---

*One surface. One Brain. Zero friction. For everyone.*
