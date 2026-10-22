# Hollow Knight for PortMaster

A port of **Hollow Knight** to Linux handhelds with [PortMaster](https://portmaster.games/).

> **Work in progress: not playable yet.** There is no release to download. This page says what
> the port will need and how far it has got. Watch the repository (or its Releases page) to hear
> when a first test build is ready.

- **You will need your own copy of the game.** This project contains **no game files**, and its
  releases won't either. You bring the GOG Linux version; the port converts it for the handheld
  the first time you start it.
- **How it will run:** Hollow Knight is made with Unity. The
  [portmaster-unity](https://github.com/wild1walker/portmaster-unity) tools run Unity's Android
  player directly on the handheld's Linux, with no Android and no emulator. The same tools run
  [Cuphead](https://github.com/wild1walker/portmaster-cuphead) at close to 60 frames per second.
- **It should look and play like the original.** Anything that changes the picture or the game
  play (for example smaller textures, if a handheld's memory needs them) will be an option you
  choose, with the original as the default wherever the handheld can manage it.

## What it will need

| | |
|---|---|
| **A handheld** | One that runs PortMaster and has a 32-bit (armhf) userland with OpenGL ES 3, like Knulli on Allwinner H700 handhelds. The first tests are on an Anbernic RG34XX-SP (1 GB RAM). |
| **The game** | Hollow Knight for **Linux** from **GOG** (the `.sh` installer, or the installed game folder). Version 1.5.12620 is the one being tested. Other versions and stores: not tried. |
| **Free space and time** | Not known yet. Hollow Knight's textures are large, so the first-launch setup will take a while and need several GB of free space. |

## Status

| Step | State |
|---|---|
| Read the game's files and find its Unity version | Done (Unity 6, Mono scripting) |
| Get Unity's matching Android player | Done (downloaded from Unity during setup, never shipped here) |
| Convert the shaders for the handheld's GPU | Done |
| Convert the textures so they fit in 1 GB of memory | Done (full resolution, re-encoded in a format the handheld's GPU reads) |
| Pack the game for the player | Done |
| First start in an emulated handheld | Done: menus, the opening cinematics and the first area (King's Pass) all work |
| Controls | Done: Hollow Knight's own Switch controls (see below) |
| Saves | Done: Quit to Menu saves, and the save loads again (on a real handheld) |
| Tests on a real handheld (RG34XX-SP, Knulli) | First launch to King's Pass, 30 minutes with steady memory. Title 37 fps, King's Pass 32 - 34 fps (the game's main thread is the limit on this CPU) |
| The setup on the handheld (converting your copy there) | Rehearsed in an arm64 container with 1 GB of memory: 32 minutes there, 3.9 GB installed, and the game it builds starts. On the handheld itself: to do |
| First test release | To do |

## Controls

The port presents the handheld's pad to the game as a Switch Pro Controller, so Hollow Knight uses
its own Switch controls and shows Switch buttons in its prompts. They match the letters printed on
Anbernic and most other handhelds: **A** (the right button) jumps and confirms, **B** (the bottom
one) goes back. You can change any of them in the game's own controller settings.

Prefer the Xbox layout (the bottom button jumps)? Edit `ports/hollowknight/port.env` and change
`Nintendo Switch Pro Controller` to `Xbox Wireless Controller`.

## Reporting problems

There is nothing to test yet. Once a test build is out, use the
[issue forms](https://github.com/wild1walker/portmaster-hollowknight/issues/new/choose): they ask
for the details that help.

Please don't attach game files, and don't ask for them. Logs from the port are fine.

## For developers

The port is made with [portmaster-unity](https://github.com/wild1walker/portmaster-unity):
`port/hollowknight/port.toml` holds its settings, and everything else in `port/hollowknight/` is
generated from it by `pmunity port new`:

```bash
cd portmaster-unity/convert
python -m pmunity port new hollowknight --data <the GOG game folder> --out <this repo>/port/hollowknight
```

`port/hollowknight/package.sh` builds the release zip (set `PMUNITY` to a portmaster-unity
checkout with its runtime built). Hollow Knight is also a test case for those tools: what it needs
gets fixed there, so other Unity ports benefit too.

## Licence and credits

The code in this repository is under the [MIT licence](LICENSE).

Hollow Knight is made by Team Cherry; this project is not made or endorsed by them. Unity is a
trademark of Unity Technologies; this project is not affiliated with Unity.
