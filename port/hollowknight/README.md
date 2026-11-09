## Notes

Thanks to [Team Cherry](https://www.teamcherry.com.au/) for creating Hollow Knight and its hand-drawn kingdom of Hallownest.

This port does not include the game: you need Hollow Knight for Linux from GOG (version 1.5.12620, Unity 6000.0.61f1): GOG's installer (hollow_knight_*.sh) or the installed game folder. Copy it into
`ports/hollowknight/gamedata/`, then start Hollow Knight from the Ports menu. The first launch builds the
game on the handheld from your copy (one to three hours, once). Unity's Android player comes with the port (`donor/`: small games built with Unity for it, whose APKs carry the player); nothing is downloaded, no Wi-Fi. It needs a handheld with a 32-bit (armhf) userland beside its 64-bit system (e.g. Knulli on Allwinner H700 devices).

The game runs on Unity's own Android player, through
[portmaster-unity](https://github.com/wild1walker/portmaster-unity)'s `ua_host` (its android
route). Saves and settings are in `ports/hollowknight/data/`; the game's options are in
`ports/hollowknight/port.env`. Tested on an Anbernic RG34XX-SP (Knulli, muOS) and a BattleXP G350
(dArkOS).

The picture fills 4:3 and 3:2 screens (the game's own rule for 16:10 carried down to them); `export
ASMPATCH_HK_ASPECT=` at the top of `port.env` keeps the bars. On every handheld the picture gives a
little for speed, the game play never (the port's README says what). A newer release installed over this one updates the game in place on its first launch
(about a minute; saves untouched).

## Controls

The buttons work by position (the bottom one jumps and confirms); the prompts show the letters
printed on the handheld (B at the bottom, A on the right). `export UA_PAD_LETTERS=xbox` in `port.env`
shows the game's Xbox buttons instead, for handhelds printed like an Xbox pad.

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

## Compile

The port folder is made by portmaster-unity's `pmunity port new` from the port's settings,
`port.toml`. On Linux or macOS with git, Docker and Python 3.11 or newer:

```sh
git clone --recurse-submodules https://github.com/wild1walker/portmaster-unity.git
cd portmaster-unity
runtime/build.sh                                            # ua_host, the 32-bit runtime (Docker)
setup-rs/tools/build_pmu.sh tools/port/out/pmu               # the setup's tools, pmu, aarch64 (Docker)
tools/asmpatch/build.sh                                     # asmpatch (.NET 8 SDK)
python3 -m pip install -r convert/requirements.txt
cd convert
python3 -m pmunity port new hollowknight --out <port folder>   # reads <port folder>/port.toml
DONORS=<donor folder> python3 -m pmunity port package <port folder>   # -> <port folder>/out/hollowknight.zip
```
