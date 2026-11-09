# Hollow Knight for PortMaster

A port of **Hollow Knight** to Linux handhelds with [PortMaster](https://portmaster.games/).

> **Latest test release: 2026.11.09.3** ([Releases](https://github.com/wild1walker/portmaster-hollowknight/releases)).
> Tested on an Anbernic RG34XX-SP (Knulli and muOS) and a BattleXP G350 (dArkOS, the RK3326 chip of
> the R36S family). The setup that converts your copy has run end to end on the RG34XX-SP with
> Knulli; the other two ran a copy converted there. Knifethrower reports it playable on an
> Anbernic RG552 with AmberELEC (a 1920x1152 screen: King's Pass at about 11 fps with the full
> picture; the next release turns the port's speed options on there too). Please report how far it gets on yours.

- **You need your own copy of the game.** This project contains **no game files**, and its
  releases don't either. You bring the Linux version, from GOG or Steam; the port converts it for the handheld
  the first time you start it.
- **How it runs:** Hollow Knight is made with Unity. The
  [portmaster-unity](https://github.com/wild1walker/portmaster-unity) tools run Unity's Android
  player directly on the handheld's Linux, with no Android and no emulator. The same tools run
  [Cuphead](https://github.com/wild1walker/portmaster-cuphead) at close to 60 frames per second.
- **It plays like the original.** The port gives a little of the picture for speed on every
  handheld, never anything of the game play (below, "The picture").

## What it needs

| | |
|---|---|
| **A handheld** | One that runs PortMaster, with OpenGL ES 3 and a 64-bit ARM system. With 32-bit (armhf) libraries beside it (Knulli or muOS on Allwinner H700 handhelds, dArkOS on RK3326 ones) the port runs its 32-bit build; without them (TrimUI handhelds, for one), its 64-bit build (below, "The 64-bit build"). Tested on an Anbernic RG34XX-SP and a BattleXP G350 (1 GB of RAM or less each). |
| **The game** | Hollow Knight for **Linux**, from **GOG** (its `.sh` installer as downloaded, no need to rename it, or the installed game folder) or **Steam** (the Linux game folder: below). GOG's 1.5.12620 is the version tested here; testers report Steam's current Linux files working too (2026-11-09). Both are Unity 6000.0.61f1, which the setup checks. |
| **Free space and time** | About 15.5 GB free on the card when you start from GOG's installer (the setup checks this before unpacking it), about 8 GB from the installed game folder, about 4 GB once it is done. The setup runs once, on the first launch: about 45 minutes on an RG34XX-SP with Knulli (2026-11-02), plus about ten minutes for the cinematics on 1 GB handhelds (below). |

**Steam's Linux files, from any PC with Steam** (Windows and macOS too): open Steam's console (type
`steam://open/console` into a web browser's address bar, or Windows' Run box), enter
`download_depot 367520 367523` and wait for Steam to say where it put the files (about 1 GB to download,
in Steam's folder under `steamapps/content/app_367520/depot_367523`). Copy everything in that folder
(`hollow_knight_Data`, `hollow_knight.x86_64`, `UnityPlayer.so` and the rest) into
`ports/hollowknight/gamedata/`. On Linux or a Steam Deck, install the game and copy its folder
(`steamapps/common/Hollow Knight`) instead. The Mac and Windows versions are not used.

## The 64-bit build

Firmwares without 32-bit (armhf) libraries, TrimUI handhelds for one, get a 64-bit build of the same game:
Unity's 64-bit player, with the game's own code run by Unity's Mono for 64-bit ARM, which the release ships.
Nothing is compiled on the handheld and nothing is downloaded. The setup is the 32-bit one's (the same
question, the same conversion of your copy), and the game goes into `ports/hollowknight/arm64/`. The launcher
picks the build by itself. On a handheld that has both, `export HK_ROUTE=64` at the top of
`ports/hollowknight/port.env` before the first launch picks the 64-bit one; a game already set up keeps its build.

Tested 2026-11-09: the whole 64-bit setup on a 64-bit-only system with 1 GB of memory and no network (an arm64
container on a PC, through the port's own launcher: 14 minutes there), then the game on an RG34XX-SP with muOS:
Greenpath, walking and fighting, 49.7 fps (the 32-bit build there: 50.0), at least 189 MB of memory free. Not
yet run on a TrimUI handheld itself.

## Status

| Step | State |
|---|---|
| Read the game's files and find its Unity version | Done (Unity 6, Mono scripting) |
| Get Unity's matching Android player | Done: the release ships a donor (a small game of pong built with Unity 6000.0.61f1, whose APK carries the player: the same 75 files Unity's installer has); the setup never downloads anything, no Wi-Fi. Nothing of Unity's is in this repository |
| Convert the shaders for the handheld's GPU | Done |
| Convert the textures so they fit in 1 GB of memory | Done (re-encoded in a format the handheld's GPU reads; at half size on handhelds with 1 GB or less, the text at full size: below) |
| Pack the game for the player | Done |
| First start in an emulated handheld | Done: menus, the opening cinematics and the first area (King's Pass) all work |
| Controls | Done: Hollow Knight's own controls by position, the prompts in the letters printed on the handheld (see below) |
| Saves | Done: Quit to Menu saves, and the save loads again (on a real handheld) |
| Tests on real handhelds | RG34XX-SP with Knulli: first launch to King's Pass, 30 minutes with steady memory. Walking and fighting with the 1 GB options of 2026.11.08 (below, "The picture") and the picture filling the screen, 2026-11-08, frames per second: Colosseum of Fools, Mantis Village and Dirtmouth 59.5, Kingdom's Edge 58, Deepnest 57, Crystal Peak 56, Queen's Gardens 54 - 55, City of Tears 53 - 57, Greenpath 52 - 54; boss fights from the Hall of Gods 52 - 59. The same handheld with muOS: Greenpath 55 - 56. BattleXP G350 with dArkOS: Greenpath 30 - 33, the other areas 35 - 45, Mantis Lords 36. Anbernic RG552 with AmberELEC (reported by Knifethrower, 2026-11-08): playable; at the screen's full 1920x1152 with the full blur (4 GB: none of the small-handheld options) the title 44 - 50 fps, King's Pass about 11, loads about 5 s of black as on the handhelds above |
| The setup on the handheld (converting your copy there) | Done on the RG34XX-SP with Knulli: about 45 minutes from GOG's installer (2026-11-02). Rehearsed before in an arm64 container with 1 GB of memory (32 minutes, 3.9 GB installed) |
| Test releases | The first 2026.10.25; the latest 2026.11.08.3 |

On every handheld the game's sprites reach the graphics chip by a faster path that draws the same
picture (ua_host's layers in `port.env`: Unity's moving sprites in one buffer drawn in place, its
buffers reused, the lit sprites without the lighting step their always-off light would add); a
press can reach the screen up to one frame later than without them.

The game's background flip-books (crowds, pulsing blobs, waterfalls, lamp bugs) are shown by a small
stand-in instead of Unity's whole animation pipeline (`UA_FLIPBOOK` in `port.env`, the list in
`flipbooks.txt`): the same pictures at the same speed, about one in 5,000 shown a frame (1/60 s) early or
late. Arenas full of them gain most (Broken Vessel's 48 -> 55 fps). Grass, cords, vines and
Deepnest's mushrooms that move only when you touch them are left still while nothing touches them,
and move exactly as before. The game itself is untouched; set `UA_FLIPBOOK=` (empty) in `port.env`
to turn it off.

**The picture fills the screen** on 4:3 (640x480) and 3:2 (720x480) handhelds instead of having
black bars above and below. Hollow Knight already does this itself on 16:10 screens by showing a
little more above and below; the port carries the game's own rule down to these screens. You see
the same width as on a 16:9 screen and a little more above and below; the HUD stays in the top
corner. To keep the bars, add `export ASMPATCH_HK_ASPECT=` at the top of `ports/hollowknight/port.env`.

On RK3326 handhelds (the R36S family, the BattleXP G350) the graphics driver made the game wait at
every frame until the GPU had finished drawing it. The port makes the game's graphics calls, and
shows each frame, from threads of its own, so the game goes on with the next frame: the same calls in
the same order, the same picture (`UA_PRESENT_THREAD` and `UA_GL_REC` in `port.env`). Greenpath on
the G350: 17.5 -> 30 - 33 fps. Nothing changes on the RG34XX-SP, which has no use for them.

**Updating:** install a newer release over the old one, as you installed the first. Its first launch
brings the game you already have up to date in place (newer code patches such as the screen fill,
the smaller cinematics on 1 GB handhelds): from about a minute to a few minutes, nothing downloaded,
your saves untouched.

## The picture

On every handheld the port turns on these by itself (`ports/hollowknight/port.env`):

- no background blur: the far background is drawn sharp instead of blurred
- the game drawn smaller and scaled to the screen (a little softer): 540x360 on handhelds with 1 GB
  of memory or less (480x360 on 4:3 screens, 480x480 on square ones), at most about 960x576 on bigger ones (a 1920x1152
  screen at half its size; a 720x480 one keeps its size)
- the game's own video options at their lowest: Shader Quality Low, Particle Effects Low, Dithering
  and Noise off, until you choose otherwise in its Options, Video

On handhelds with 1 GB of memory or less, also:

- Unity's graphics jobs (the same picture, less work for the game's main thread)
- the sound mixed at 24 kHz instead of 48 kHz (slightly duller highs, the same sounds)
- one Unity job thread instead of three (the same game; the handheld's four cores go to the game itself)

The setup also converts the textures at 0.375 of their size on these handhelds, the text at full
size: Hallownest's art, made for 1080p screens, still has about a texel for each pixel of the game's
540x360 picture. And it keeps at most 16 MB of a scene's sounds decoded in memory (36 MB on bigger
handhelds); the longer ones are decoded as they play. Handhelds with dArkOS keep EmulationStation in
memory while the game runs (up to about 126 MB), and with no swap the game ran a 1 GB handheld out of
memory in City of Tears before this. Measured on an RG34XX-SP with muOS in City of Tears: the game
663 -> 597 MB, the same frame rate, the same picture side by side. A game set up by an earlier release
keeps its textures and sounds as they were (the setup no longer has your copy's originals): to get
these, put your copy in `ports/hollowknight/gamedata/` again and delete `ports/hollowknight/.setup_done`
(`.setup_done64` for the 64-bit build); the next launch sets the game up again and your saves stay. Building the port yourself, `[convert.textures] lowmem_scale = 1.0` in
`port.toml` keeps the textures full size.

And it makes the cinematics smaller on these handhelds: 960x540 instead of 1920x1080, which
looks the same on their screens and plays at the videos' own 30 pictures a second (at full size the
handheld cannot decode them in time and they played in slow motion). Not where the handheld's video
engine decodes them through the port's libpmhwdec (Allwinner handhelds with Knulli or muOS, such as
the RG34XX-SP, and RK3326 handhelds with dArkOS, such as the G350): there they stay at full size and
the setup is about ten minutes shorter. On dArkOS the launcher opens the video decoder to the game
(its two device files, which are root-only there) while the game runs, and puts them back as they
were when it ends. A game set up by an earlier
release gets this once, on its next launch after the update (a few minutes; PortMaster's patcher
shows it). Set `[convert.video] mode = "off"` in `port.toml` to keep them as they are.

The game play does not change. Measured in King's Pass on the RG34XX-SP while walking, attacking
and jumping: about 48 fps with the previous options (the blur at the game's Low, 48 kHz), 54 - 56
with these, and about six times fewer slow frames (over 25 ms).

The port is tested with all of these on, and the setup offers no other picture. Each one costs
frame rate when it is off; to turn one off anyway, add its line at the top of `port.env`:

```bash
export ASMPATCH_HK_BLUR=full   # the game's four-pass background blur
export UA_RENDER_SIZE=1280x768 UA_RENDER_RAM= UA_RENDER_PIXELS=   # draw at a size of your choice (the screen's shape is kept)
export UA_RENDER_SIZE= UA_RENDER_PIXELS=   # draw at the screen's own size
export UA_AUDIO_RATE=          # mix the sound at 48 kHz
```

## Controls

The buttons work **by position**, as in the game on every controller: the **bottom face button
jumps and confirms** in menus. The game's button prompts show the letters printed on Anbernic,
Miyoo, Powkiddy, TrimUI and R36S-type handhelds (the Nintendo layout: **B** at the bottom, **A** on
the right), with the game's own Switch button pictures. Below, each button is named by that letter
and its position.

| Button | In the game | In menus |
|---|---|---|
| D-pad | move; with up or down, the nail and spells go that way | move the selection |
| **B** (bottom) | jump | confirm |
| **Y** (left) | attack with the nail | |
| **A** (right) | focus (hold) and cast spells | back |
| **X** (top) | Dream Nail | |
| **R2** | dash | |
| **L2** | Crystal Dash | |
| **L1** | quick map | |
| **R1** | quick cast | |
| **Select** | inventory | |
| **Start** | pause | |
| **Select + Start** | quit the game (PortMaster's exit hotkey) | |

These are Hollow Knight's own default controls; the game's **Options, Controller** changes them.

Handheld printed like an Xbox pad (A at the bottom)? Add `export UA_PAD_LETTERS=xbox` at the top of
`ports/hollowknight/port.env`: the prompts then show the game's Xbox buttons. The buttons themselves
never move.

Test releases up to 2026.11.08.2 named the pad as a Switch Pro Controller, and the game took its
buttons by their letters (the right button jumped and confirmed). From 2026.11.08.3 they work as
above.

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
