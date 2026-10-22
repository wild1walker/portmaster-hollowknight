## Notes

Thanks to [Team Cherry](https://www.teamcherry.com.au/) for creating Hollow Knight and its hand-drawn kingdom of Hallownest.

This port does not include the game: you need Hollow Knight for Linux from GOG (version 1.5.12620, Unity 6000.0.61f1): GOG's installer (hollow_knight_*.sh) or the installed game folder. Copy it into
`ports/hollowknight/gamedata/`, then start Hollow Knight from the Ports menu. The first launch builds the
game on the handheld from your copy (one to three hours, once) and downloads Unity's Android player for
it from Unity (about 10 MB, Wi-Fi). It needs a handheld with a 32-bit (armhf) userland beside its 64-bit system (e.g. Knulli on Allwinner H700 devices).

The game runs on Unity's own Android player, through
[portmaster-unity](https://github.com/wild1walker/portmaster-unity)'s `ua_host` (its android
route). Saves and settings are in `ports/hollowknight/data/`; the game's options are in
`ports/hollowknight/port.env`.

## Controls

The game reads the handheld's pad as a gamepad and keeps its own gamepad controls.

| Button | Action |
|--|--|
| Select + Start | Quit |

## Compile

The port folder is made by portmaster-unity's `pmunity port new` from the port's settings,
`port.toml`. On Linux or macOS with git, Docker and Python 3.11 or newer:

```sh
git clone --recurse-submodules https://github.com/wild1walker/portmaster-unity.git
cd portmaster-unity
runtime/build.sh                                            # ua_host, the 32-bit runtime (Docker)
tools/port/build_pybundle.sh tools/port/out/python.tar.gz   # the setup's Python, aarch64 (Docker)
tools/asmpatch/build.sh                                     # asmpatch (.NET 8 SDK)
python3 -m pip install -r convert/requirements.txt
cd convert
python3 -m pmunity port new hollowknight --out <port folder>   # reads <port folder>/port.toml
python3 -m pmunity port package <port folder>                  # -> <port folder>/out/hollowknight.zip
```
