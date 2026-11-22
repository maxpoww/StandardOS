# Installing apps

Every app is installed from the box: tap <kbd>Super</kbd>, type its name, and drag it from the **Install** row to your apps. The box knows more than twenty thousand apps and programs, 76 web apps, and 25 *modules* — everything a kind of work needs, in one switch.

## Installing an app

1. Tap <kbd>Super</kbd> and type the app's name (or what it does: *photo editor*, *video player*).
2. The **Install** row shows the most used matches first; **More** shows the rest.
3. Either **drag** the app onto your apps (or straight onto the dock, which also pins it), or **click** it to see its page.

An app's page shows its name, version, licence and what it does, with three buttons:

- **Install** — installs it.
- **Website** — its home page.
- **Try** — runs it once without installing it.

The install shows on the task pill. When it ends, the app is in your apps — and if it needs a first setup to work (OBS Studio ready to record the screen, for example), StandardOS has done it.

!!! note "If an install fails"
    The system stays exactly as it was. Golem tells you why: *"Golem couldn't install the app"* — the disk is full, there is no internet, or something else went wrong (try again later). Nothing is half-installed.

## Removing an app

Drag it onto the dock's **Recycle Bin**, or back into the **Install** row; or open its row in the box (<kbd>Shift</kbd> on it) and click **Uninstall** twice. Only apps you installed can be removed this way — the system's own apps stay.

## Web apps

Some services work best as a website: WhatsApp, Gmail, YouTube, Spotify, Netflix, Google Docs, Notion, Figma, ChatGPT, Claude and many more. Installed from the **Install** row, each one gets its own window and its own icon in the dock, like an app. They run in the browser, so you sign in once for both.

## Modules

A module is everything a kind of work needs, in one switch: the programs, and the parts of the system they need (Steam's 32-bit graphics, Docker's service…). Open the **Modules** tile in the box, choose a module, and either **Install recommended** or switch programs on one by one; then **Apply changes**. Your files are never touched.

| Module | Recommended programs |
|---|---|
| Office | LibreOffice, Okular, PDF Arranger, Thunderbird, Microsoft fonts, Document Scanner |
| Internet | Brave, qBittorrent, LocalSend, KDE Connect |
| Social | WhatsApp, Telegram, Signal |
| Media & Entertainment | VLC, Spotify, Netflix, YouTube |
| Gaming | Steam, Heroic, Prism Launcher, GameMode — and a fullscreen game keeps the computer awake |
| Productivity | Obsidian, Planify, Thunderbird |
| Content Creation | OBS Studio, Audacity, EasyEffects, Kdenlive, Canva |
| Photography | darktable, digiKam, GIMP |
| Education | Anki, Xournal++, GeoGebra, Calibre |
| Kids | GCompris, Tux Paint, Scratch, SuperTuxKart, time and app limits, family-safe web |
| AI | Claude, ChatGPT, Gemini |
| Remote Work | Zoom, Microsoft Teams, Google Meet, Slack, RustDesk, EasyEffects |
| Privacy & Security | KeePassXC, Bitwarden, Proton VPN, Authenticator, Déjà Dup |
| Music Production | Ardour, LMMS, Hydrogen, Surge XT, Calf, Audacity |
| Video Editing | Kdenlive, HandBrake |
| Graphic Design | Inkscape, Krita, GIMP, Figma |
| 3D & Printing | Blender, FreeCAD, PrusaSlicer, OrcaSlicer |
| Writing | Zettlr, novelWriter, LanguageTool, Zotero |
| Web Design | Visual Studio Code, Figma, Chromium, Node.js |
| Development | Visual Studio Code, Git, GitHub CLI, Docker, Python |
| Commerce | Shopify, GnuCash, Canva |
| Trading & Finance | TradingView, HomeBank |
| Science & Data | JupyterLab, RStudio, GNU Octave, QGIS |
| Accessibility | Screen reader, voices, magnifier, on-screen keyboard |
| Windows Apps | Bottles (runs Windows programs) |

## What comes installed

- **Seam**, the web browser.
- **Standard Files**, the file manager — and GNOME's Files as a second one.
- Text Editor, Image Viewer, Papers (PDF and e-books), Archive Manager.
- Built into the desktop itself: a dictionary (English and Spanish), a translator (English, Spanish, French, German, Portuguese, Italian), voice-to-text, and text recognition in screenshots — all working without the internet.

Which app opens each kind of file is in **Controls → Default apps**.

## Seam, the browser

Seam is Firefox, set up to fit StandardOS: no telemetry, no sponsored content, an ad blocker (uBlock Origin) built in, and the desktop's colours.

- **Tap <kbd>Alt</kbd> alone** to see all your tabs as a grid (<kbd>Esc</kbd> closes it; <kbd>1</kbd>…<kbd>9</kbd> jump to a tab).
- **Dark websites:** in **Controls → Colours**, set the **Web** section dark, and websites follow.
- Seam updates itself to each new Firefox release; when it does, it asks you to restart it — your tabs come back.
- Seam's language is the desktop's: change it in **Controls → Language**.
- Seam starts fresh: it does not copy bookmarks or passwords from other browsers.

## Programs from websites

On StandardOS, apps come from the box, not from installers downloaded from websites: what the **Install** row offers is checked to install on your system. Two modules cover the exceptions:

- **Windows programs** (`.exe`): switch on **Windows Apps** (Bottles) in the Modules.
- **Linux programs downloaded as a file**: switch on **Downloaded programs** in the Development module.

## For experts

Want the newest version of a tool straight from its makers, before StandardOS ships it? `ups` runs it beside the system without changing anything, for the tools it has a recipe for (today Claude Code and opencode; you can write your own) — see [ups](#expert-commands--ups).
