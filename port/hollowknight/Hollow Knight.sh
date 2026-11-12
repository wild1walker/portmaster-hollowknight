#!/bin/bash
# PORTMASTER: hollowknight.zip, Hollow Knight.sh

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
get_controls

# Hollow Knight on Unity's own Android player, run natively by portmaster-unity's ua_host: the 32-bit
# player (ua_host) where the system has a 32-bit (armhf) userland, else Unity's 64-bit player with the
# game's code on Unity's Mono for 64-bit ARM (ua_host64, the game in arm64/): no IL2CPP compile, nothing
# downloaded. On the first launch the setup builds the game from your copy in ports/hollowknight/gamedata/
# (see README.md there). Made with `pmunity port new` (android route; the 64-bit setup, setup/patchscript64,
# from its mono-arm64 route).

GAMEDIR="/$directory/ports/hollowknight"
cd "$GAMEDIR" || exit 1
mv -f "$GAMEDIR/log.txt" "$GAMEDIR/log.prev.txt" 2>/dev/null
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
echo "Hollow Knight: $CFW_NAME on $DEVICE_NAME ($DEVICE_ARCH), ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}, RAM $(awk '/MemTotal/{print int($2/1024)" MB"}' /proc/meminfo)"

# ---- the route: 32-bit where the system has 32-bit (armhf) libraries, else 64-bit. HK_ROUTE=64 at the
# top of port.env picks the 64-bit one on a system with both. A build that is set up, or a setup under
# way, keeps its route (the libraries' check alone flipped between launches on muOS for Cuphead's port).
[ -n "$HK_ROUTE" ] || HK_ROUTE=$(sed -n 's/^[[:space:]]*export[[:space:]]*HK_ROUTE=[^0-9]*\([0-9]*\).*/\1/p' "$GAMEDIR/port.env" 2>/dev/null | tail -1)
ARMHF=no; [ -e /lib/ld-linux-armhf.so.3 ] && ARMHF=yes
if [ "$HK_ROUTE" = 64 ]; then ROUTE_WHY="HK_ROUTE=64"
elif [ -f "$GAMEDIR/.setup_done" ] || [ -d "$GAMEDIR/gamedata/.setup" ]; then HK_ROUTE=32; ROUTE_WHY="the 32-bit build is there"
elif [ -f "$GAMEDIR/.setup_done64" ] || [ -d "$GAMEDIR/gamedata/.setup64" ]; then HK_ROUTE=64; ROUTE_WHY="the 64-bit build is there"
elif [ "$ARMHF" = yes ]; then HK_ROUTE=32; ROUTE_WHY="32-bit libraries found"
else HK_ROUTE=64; ROUTE_WHY="no 32-bit libraries"; fi
echo "$HK_ROUTE-bit build ($ROUTE_WHY; 32-bit libraries: $ARMHF)"
if [ "$HK_ROUTE" = 32 ] && [ "$ARMHF" = no ]; then
  pm_message "The 32-bit build is set up, but this system's 32-bit libraries are missing right now (/lib/ld-linux-armhf.so.3). Restart the handheld and launch again; please send ports/hollowknight/log.txt if it stays."
  sleep 8
  pm_finish
  exit 1
fi
if [ "$HK_ROUTE" = 64 ]; then
  SETUP=patchscript64; READY=.setup_done64; HOST=ua_host64; GAME="$GAMEDIR/arm64"
else
  SETUP=patchscript; READY=.setup_done; HOST=ua_host; GAME="$GAMEDIR"
fi

# Rockchip handhelds on vendor kernels (dArkOS, ArkOS): the video decoder's nodes are root-only while
# ports run as a user, and the port's libpmhwdec (pmhwdec/) needs them for the videos. They are opened to
# the video group for the game and put back exactly as they were when it ends (Knifethrower's fix;
# PortMaster's Moonlight opens the same nodes). Nothing changes where they are usable already.
[ -d "$GAMEDIR/pmhwdec" ] && rm -rf "$GAMEDIR/pmhw"   # the folder's name in releases before 2026-11-09
pmhwdec_nodes=()
if [ -d "$GAMEDIR/pmhwdec" ]; then
  for n in /dev/vpu_service /dev/hevc_service; do
    { [ -e "$n" ] && ! { [ -r "$n" ] && [ -w "$n" ]; }; } || continue
    o=$(stat -c '%u:%g:%a' "$n") || continue
    $ESUDO chgrp video "$n" && $ESUDO chmod 660 "$n" && pmhwdec_nodes+=("$n:$o") && echo "$n: opened to the video group (was $o)"
  done
fi
pmhwdec_restore() {
  local e n o
  for e in "${pmhwdec_nodes[@]}"; do
    n=${e%%:*}; o=${e#*:}
    $ESUDO chown "${o%:*}" "$n"; $ESUDO chmod "${o##*:}" "$n"; echo "$n: put back ($o)"
  done
  pmhwdec_nodes=()
}
trap 'pmhwdec_restore; pm_message_end' EXIT   # funcs.txt set pm_message_end as the EXIT trap: a second trap replaces it

# ---- first launch: build the game from your copy (PortMaster's patcher shows the progress)
if [ ! -f "$GAMEDIR/$READY" ]; then
  if [ -f "$GAMEDIR/setup/$SETUP" ] && [ -f "$controlfolder/utils/patcher.txt" ]; then
    export GAMEDIR DEVICE_ARCH controlfolder
    chmod +x "$GAMEDIR/setup/$SETUP"
    export PATCHER_FILE="$GAMEDIR/setup/$SETUP"
    export PATCHER_GAME="Hollow Knight"
    export PATCHER_TIME="one to three hours, once"
    [ -f "$GAMEDIR/setup/questions.lua" ] && export PATCHER_QUESTIONS="$GAMEDIR/setup/questions.lua"
    source "$controlfolder/utils/patcher.txt"
  fi
  if [ ! -f "$GAMEDIR/$READY" ]; then
    if [ -f "$GAMEDIR/setup/$SETUP" ]; then
      pm_message "Hollow Knight is not set up yet: put Hollow Knight for Linux (Unity 6000.0.61f1): GOG's installer as downloaded (hollow_knight_*.sh, no renaming), or the game folder from GOG or Steam in ports/hollowknight/gamedata and launch again (ports/hollowknight/README.md; log: ports/hollowknight/patchlog.txt)."
    else    # (no setup to run: the port's folder without its setup/, e.g. deleted, or copied without it)
      pm_message "Hollow Knight is not set up and its setup files are missing. Install the port again (unzip it over your ports folder), put the game in ports/hollowknight/gamedata if it is not there any more, and launch again."
    fi
    sleep 8
    pm_finish
    exit 1
  fi
fi

# ---- a game set up by an earlier release: what this release's setup does that it has not had yet
# (setup/update, once: the setup folder comes with each release and goes when it is done), on the
# build this handheld runs (UPDATE_*: the 64-bit build's files are in arm64/, its mark is .setup_done64)
if [ -f "$GAMEDIR/setup/update" ] && [ -f "$controlfolder/utils/patcher.txt" ]; then
  export GAMEDIR DEVICE_ARCH controlfolder
  export UPDATE_GAME="$GAME" UPDATE_READY="$READY" UPDATE_PMHWDEC=pmhwdec
  [ "$HK_ROUTE" = 64 ] && UPDATE_PMHWDEC=pmhwdec64
  chmod +x "$GAMEDIR/setup/update"
  export PATCHER_FILE="$GAMEDIR/setup/update"
  export PATCHER_GAME="Hollow Knight"
  export PATCHER_TIME="a few minutes, once"
  unset PATCHER_QUESTIONS
  source "$controlfolder/utils/patcher.txt"
fi

# ---- the game is set up: what a setup cut off right after it marked the game set up left behind,
# and the setup files a release unzipped over the set-up game brings again, are not needed to play
# (setup/update still there: the update has not run or not finished, and runs at the next launch)
if [ ! -f "$GAMEDIR/setup/update" ]; then
  work=gamedata/.setup; [ "$HK_ROUTE" = 64 ] && work=gamedata/.setup64
  for d in setup donor "$work"; do
    [ -d "$GAMEDIR/$d" ] && rm -rf "${GAMEDIR:?}/$d" && echo "removed $d: the setup's, not needed to play"
  done
fi

# the built-in pad reaches the game as an Android gamepad (ua_host: SDL GameController ->
# KeyEvent and MotionEvent)
export SDL_GAMECONTROLLERCONFIG="${SDL_GAMECONTROLLERCONFIG:-$sdl_controllerconfig}"
# audio: the 32-bit build the system's default ALSA device, else (a sound server holding the card and no
# 32-bit client libraries) raw PCM piped into pw-cat / pacat; the 64-bit build SDL's own choice (a 64-bit
# program reaches the system's sound server or ALSA itself)
[ "$HK_ROUTE" = 32 ] && export SDL_AUDIODRIVER=${SDL_AUDIODRIVER:-alsa}
# the 64-bit build's libpmhwdec (pmhwdec64/; port.env names the 32-bit one)
[ "$HK_ROUTE" = 64 ] && export UM_PMHWDEC=${UM_PMHWDEC-pmhwdec64/libpmhwdec.so.1}
export UA_FPS=${UA_FPS:-10}                     # a line of frame statistics every 10 s in log.txt
# the game's options (port.env), and the setup's answers that apply when the game runs
# the picture shape and the button letters the setup asked for: aspect.txt (fill, or bars for the game's
# 16:9 with black bars) and buttons.txt (nintendo or xbox), read at each launch; port.env's own lines are
# defaults, so these win over them, and a line at the top of port.env wins over these
case "$(cat "$GAMEDIR/aspect.txt" 2>/dev/null)" in fill) export ASMPATCH_HK_ASPECT=fill ;; bars) export ASMPATCH_HK_ASPECT= ;; esac
case "$(cat "$GAMEDIR/buttons.txt" 2>/dev/null)" in nintendo) export UA_PAD_LETTERS=nintendo ;; xbox) export UA_PAD_LETTERS=xbox ;; esac
# the world at its render size by the game itself, the HUD and the text at the panel's size (port.env's
# UA_RENDER_SIZE_VAR with asmpatch's hk-render-size): only for a game whose code has had that patch (the setup
# and the update note their patches in the setup's marker); a game set up before it keeps the picture that
# ua_host scales, as it was
grep -qs hk-render-size "$GAMEDIR/$READY" || export UA_RENDER_SIZE_VAR=${UA_RENDER_SIZE_VAR-}
[ -f "$GAMEDIR/port.env" ] && source "$GAMEDIR/port.env"
[ -f "$GAMEDIR/answers.env" ] && source "$GAMEDIR/answers.env"
# handhelds without analog sticks whose pad mapping still names a left stick: where PortMaster says there are
# none (device_info.txt: ANALOG_STICKS=0), auto means a pad without sticks
if [ "${ANALOG_STICKS:-2}" = 0 ]; then
  case "${UA_DPAD_STICK:-}" in auto|auto,both) export UA_DPAD_STICK=${UA_DPAD_STICK/auto/1} ;; esac
fi
# a Wwise game: ua_host's own Wwise player plays the banks the setup converted (set UA_WWISE_DATA= empty for none)
[ -d "$GAMEDIR/wwise" ] && export UA_WWISE_DATA="${UA_WWISE_DATA-$GAMEDIR/wwise}"
chmod +x "$GAMEDIR/$HOST"
for d in pmhwdec pmhwdec64; do   # libpmhwdec's Allwinner decoder, where the port ships it
  [ -f "$GAMEDIR/$d/pmhwdec-cedard" ] && chmod +x "$GAMEDIR/$d/pmhwdec-cedard"
done

$GPTOKEYB2 "$HOST" -c "$GAMEDIR/hollowknight.ini" &   # exit hotkey only
pm_platform_helper "$GAMEDIR/$HOST"

if [ "$HK_ROUTE" = 64 ]; then
  ./ua_host64 "$GAME"
else
  # the 32-bit libraries first (Knulli: /lib32, /usr/lib32)
  LD_LIBRARY_PATH=/lib32:/usr/lib32${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} ./ua_host "$GAME"
fi
echo "game exited ($?)"

pm_finish
