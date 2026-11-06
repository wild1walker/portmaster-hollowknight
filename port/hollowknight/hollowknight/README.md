# Hollow Knight on PortMaster

Hollow Knight runs on Unity's own Android player, run natively on the handheld's 32-bit userland by
[portmaster-unity](https://github.com/wild1walker/portmaster-unity)'s `ua_host`. No game files come
with this port: you provide your own copy, and the first launch builds the game from it on the
handheld.

## What you need

- **Hollow Knight for Linux from GOG (version 1.5.12620, Unity 6000.0.61f1): GOG's installer (hollow_knight_*.sh) or the installed game folder.** The setup checks the Unity version it was built with (this port is made
  for 6000.0.61f1).
- Unity's Android player comes with the port (`donor/`: small games built with Unity for it, whose APKs carry the player); nothing is downloaded, no Wi-Fi.
- About 15 GB free on the card during the setup.
- A handheld with a 32-bit (armhf) userland and GLES 3 (e.g. Knulli on Allwinner H700 devices),
  and a 64-bit (aarch64) system for the setup's tools.

## Setting it up

1. Copy the game (its folder, the archive it came in, or GOG's Linux installer `.sh`) into
   `ports/hollowknight/gamedata/`.
2. Launch Hollow Knight from the Ports menu. PortMaster's patcher shows the setup's progress: it finds
   (or unpacks) the game, unpacks Unity's player, converts the game for the handheld's GPU and
   packs it for the player (one to three hours). If it is interrupted, launch again: it continues
   where it stopped. The log is `ports/hollowknight/patchlog.txt`.
3. When it is done the game starts. The setup uses up the game's folder in `gamedata/` (its files
   are moved into the converted game), and deletes the archives or installers you put there once
   the game is built (`keep_installers=1` in `ports/hollowknight/setup.txt` keeps them).

Saves and settings: `ports/hollowknight/data/`. PortMaster's exit hotkey quits. The game's options
(pointer mode, keys, ...) are in `ports/hollowknight/port.env`; `log.txt` is the last run's log.

## Controls

The game reads the handheld's pad as a gamepad and keeps its own gamepad controls.

| Button | Action |
|--|--|
| Select + Start | Quit |

## Licences

The port's code is MIT (`licenses/`). The setup tools are removed when the setup is done; their
licences are in `licenses/` too. Unity is a trademark of Unity Technologies; this port is not
affiliated with Unity Technologies or the game's makers.
