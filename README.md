# Hollow Knight for PortMaster

A port of **Hollow Knight** to Linux handhelds with [PortMaster](https://portmaster.games/).

> **First test release: 2026.10.25** ([Releases](https://github.com/wild1walker/portmaster-hollowknight/releases)).
> Tested on one handheld, an Anbernic RG34XX-SP with Knulli. The setup that converts your copy has
> run end to end only in a stand-in for that handheld so far (see Status); please report how far it
> gets on yours.

- **You need your own copy of the game.** This project contains **no game files**, and its
  releases don't either. You bring the GOG Linux version; the port converts it for the handheld
  the first time you start it.
- **How it runs:** Hollow Knight is made with Unity. The
  [portmaster-unity](https://github.com/wild1walker/portmaster-unity) tools run Unity's Android
  player directly on the handheld's Linux, with no Android and no emulator. The same tools run
  [Cuphead](https://github.com/wild1walker/portmaster-cuphead) at close to 60 frames per second.
- **It plays like the original.** On handhelds with 1 GB of memory or less the port gives a
  little of the picture for speed (below, "Small handhelds"); one edit brings the full picture back.

## What it needs

| | |
|---|---|
| **A handheld** | One that runs PortMaster and has a 32-bit (armhf) userland with OpenGL ES 3, like Knulli on Allwinner H700 handhelds. The first tests are on an Anbernic RG34XX-SP (1 GB RAM). |
| **The game** | Hollow Knight for **Linux** from **GOG** (the `.sh` installer, or the installed game folder). Version 1.5.12620 is the one being tested. Other versions and stores: not tried. |
| **Free space and time** | About 8 GB free on the card during the setup, about 4 GB once it is done. The setup runs once, on the first launch: one to three hours (estimated; 32 minutes in the stand-in). |

## Status

| Step | State |
|---|---|
| Read the game's files and find its Unity version | Done (Unity 6, Mono scripting) |
| Get Unity's matching Android player | Done: the release ships a donor (a small game of pong built with Unity 6000.0.61f1, whose APK carries the player: the same 75 files Unity's installer has); the setup never downloads anything, no Wi-Fi. Nothing of Unity's is in this repository |
| Convert the shaders for the handheld's GPU | Done |
| Convert the textures so they fit in 1 GB of memory | Done (full resolution, re-encoded in a format the handheld's GPU reads) |
| Pack the game for the player | Done |
| First start in an emulated handheld | Done: menus, the opening cinematics and the first area (King's Pass) all work |
| Controls | Done: Hollow Knight's own Switch controls (see below) |
| Saves | Done: Quit to Menu saves, and the save loads again (on a real handheld) |
| Tests on a real handheld (RG34XX-SP, Knulli) | First launch to King's Pass, 30 minutes with steady memory. King's Pass about 36 fps with the full picture; walking and fighting there, **about 56 fps** with the small-handheld options (below); across twelve areas from Greenpath (46 fps) to the Colosseum (62), eleven at 50 fps or more |
| The setup on the handheld (converting your copy there) | Rehearsed in an arm64 container with 1 GB of memory: 32 minutes there, 3.9 GB installed, and the game it builds starts. On the handheld itself: to do |
| First test release | Done: 2026.10.25 |

## Small handhelds (1 GB of memory or less)

On these the port turns on six options by itself (`ports/hollowknight/port.env`):

- no background blur: the far background is drawn sharp instead of blurred
- the game drawn at 540x360 and scaled to the screen (a little softer)
- Unity's graphics jobs (the same picture, less work for the game's main thread)
- the sound mixed at 24 kHz instead of 48 kHz (slightly duller highs, the same sounds)
- the game's own Particle Effects Low and Dithering off, until you choose otherwise in its Options, Video
- one Unity job thread instead of three (the same game; the handheld's four cores go to the game itself)

The setup also makes the cinematics smaller on these handhelds: 960x540 instead of 1920x1080, which
looks the same on their screens and plays at the videos' own 30 pictures a second (at full size the
handheld cannot decode them in time and they played in slow motion). A game set up by an earlier
release gets this once, on its next launch after the update (a few minutes; PortMaster's patcher
shows it). Set `[convert.video] mode = "off"` in `port.toml` to keep them as they are.

The game play does not change. Measured in King's Pass on the RG34XX-SP while walking, attacking
and jumping: about 48 fps with the previous options (the blur at the game's Low, 48 kHz), 54 - 56
with these, and about six times fewer slow frames (over 25 ms).

To get the full picture and sound back, add these lines at the top of `port.env` (any one alone
works too):

```bash
export ASMPATCH_HK_BLUR=full   # the game's four-pass background blur
export UA_RENDER_SIZE=         # draw at the screen's own size
export UA_AUDIO_RATE=          # mix the sound at 48 kHz
```

## Controls

The port presents the handheld's pad to the game as a Switch Pro Controller, so Hollow Knight uses
its own Switch controls and shows Switch buttons in its prompts. They match the letters printed on
Anbernic and most other handhelds: **A** (the right button) jumps and confirms, **B** (the bottom
one) goes back. You can change any of them in the game's own controller settings.

Prefer the Xbox layout (the bottom button jumps)? Edit `ports/hollowknight/port.env` and change
`Nintendo Switch Pro Controller` to `Xbox Wireless Controller`.

## Reporting problems

Use the
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
