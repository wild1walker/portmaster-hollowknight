# Hollow Knight (PortMaster port)

Made with portmaster-unity's `pmunity port new` (android route: Unity's Android player (armv7, Mono) on the handheld's 32-bit userland: portmaster-unity's runtime). Porter:
wild1walker.

| file | what |
|---|---|
| `port.toml` | the port's settings: edit, then `python -m pmunity port new hollowknight --data <game>` again |
| `port.build.json` | everything resolved from port.toml and the game check (written by `port new`) |
| `Hollow Knight.sh` | the launcher (PortMaster conventions; the first launch runs the setup) |
| `hollowknight/` | the folder installed as `ports/hollowknight/`: `setup/patchscript` (the setup), `setup/setup.env`, `setup/convert.json`, `port.env` (ua_host's options), `port.json`, READMEs |
| `package.sh` | builds the release zip (`out/hollowknight.zip`) with portmaster-unity's packager |

## Notes

The player provides Hollow Knight for Linux from GOG (version 1.5.12620, Unity 6000.0.61f1): GOG's installer (hollow_knight_*.sh) or the installed game folder; nothing of the game or of Unity is in
this port. The first launch builds the game on the handheld (one to three hours).

## Controls

The handheld's pad reaches the game as an Android gamepad. Port-specific options (pointer mode
for mouse-driven menus, pad buttons that press keys) are in `hollowknight/port.env`.

## Building

`./package.sh` (needs a portmaster-unity checkout with its runtime built: `PMUNITY=<checkout>`).
Test the setup on a device, or in an arm64 container as docs/porting.md in portmaster-unity
describes.
