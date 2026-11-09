# Hollow Knight on PortMaster

Hollow Knight runs on Unity's own Android player, run natively on the handheld's 32-bit userland by
[portmaster-unity](https://github.com/wild1walker/portmaster-unity)'s `ua_host`. No game files come
with this port: you provide your own copy, and the first launch builds the game from it on the
handheld.

## What you need

- **Hollow Knight for Linux from GOG (version 1.5.12620, Unity 6000.0.61f1): GOG's installer (hollow_knight_*.sh) or the installed game folder.** The setup checks the Unity version it was built with (this port is made
  for 6000.0.61f1).
- Unity's Android player comes with the port (`donor/`: small games built with Unity for it, whose APKs carry the player); nothing is downloaded, no Wi-Fi.
- About 15.5 GB free on the card during the setup when you start from GOG's installer (the setup
  checks it before unpacking), about 8 GB from the installed game folder, about 4 GB once it is done.
- A handheld with a 32-bit (armhf) userland and GLES 3, and a 64-bit (aarch64) system for the
  setup's tools: Knulli or muOS on Allwinner H700 handhelds, dArkOS on RK3326 ones. Tested on an
  Anbernic RG34XX-SP (Knulli, muOS) and a BattleXP G350 (dArkOS).

## Setting it up

1. Copy the game (its folder, the archive it came in, or GOG's Linux installer `.sh`) into
   `ports/hollowknight/gamedata/`.
2. Launch Hollow Knight from the Ports menu. PortMaster's patcher shows the setup's progress: it finds
   (or unpacks) the game, unpacks Unity's player, converts the game for the handheld's GPU and
   packs it for the player (about 45 minutes on an RG34XX-SP with Knulli, about ten more for the
   cinematics on 1 GB handhelds). If it is interrupted, launch again: it continues where it stopped.
   The log is `ports/hollowknight/patchlog.txt`.
3. When it is done the game starts. The setup uses up the game's folder in `gamedata/` (its files
   are moved into the converted game), and deletes the archives or installers you put there once
   the game is built (`keep_installers=1` in `ports/hollowknight/setup.txt` keeps them).

Saves and settings: `ports/hollowknight/data/`. PortMaster's exit hotkey quits. The game's options
(the button letters, the picture, ...) are in `ports/hollowknight/port.env`; `log.txt` is the last
run's log.

**Updating:** install a newer release over this one, as you installed it. Its first launch brings
the game you already have up to date in place (newer code patches, smaller cinematics on 1 GB
handhelds): from about a minute to a few minutes, nothing downloaded, your saves untouched.

## The picture

The picture fills 4:3 (640x480) and 3:2 (720x480) screens: the game's own rule for 16:10 screens
(the width of 16:9, a little more above and below) carried down to them, instead of black bars. To
keep the bars, add `export ASMPATCH_HK_ASPECT=` at the top of `port.env`.

On every handheld the port gives a little of the picture for speed, the game play never: no
background blur, the game drawn smaller and scaled up (540x360 on handhelds with 1 GB of memory or
less, 480x360 on 4:3; at most about 960x576 on bigger ones), the game's own video options at their
lowest (until you change them in its Options, Video). On 1 GB handhelds also the sound mixed at
24 kHz and the textures and the cinematics at half size. The port is tested with all of these on;
each costs frame rate when it is off. To turn one off anyway, add its line at the top of `port.env`:

```bash
export ASMPATCH_HK_BLUR=full   # the game's four-pass background blur
export UA_RENDER_SIZE= UA_RENDER_PIXELS=   # draw at the screen's own size
export UA_AUDIO_RATE=          # mix the sound at 48 kHz
```

## Controls

The buttons work by position, as in the game on every controller: the bottom face button jumps and
confirms. The prompts show the letters printed on Anbernic, Miyoo, Powkiddy, TrimUI and R36S-type
handhelds (B at the bottom, A on the right), with the game's own Switch button pictures.

| Button | Action |
|--|--|
| D-pad | Move; with up or down, the nail and spells go that way |
| B (bottom) | Jump; confirm in menus |
| Y (left) | Attack with the nail |
| A (right) | Focus (hold) and cast spells; back in menus |
| X (top) | Dream Nail |
| R2 | Dash |
| L2 | Crystal Dash |
| L1 | Quick map |
| R1 | Quick cast |
| Select | Inventory |
| Start | Pause |
| Select + Start | Quit |

These are Hollow Knight's own default controls; its Options, Controller changes them. A handheld
printed like an Xbox pad (A at the bottom): add `export UA_PAD_LETTERS=xbox` at the top of
`port.env`, and the prompts show the game's Xbox buttons. The buttons never move.

## Licences

The port's code is MIT (`licenses/`). The setup tools are removed when the setup is done; their
licences are in `licenses/` too. Unity is a trademark of Unity Technologies; this port is not
affiliated with Unity Technologies or the game's makers.
