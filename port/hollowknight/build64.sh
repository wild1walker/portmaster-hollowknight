#!/bin/bash
# build64.sh <out dir>: the 64-bit build's runtime for the release (port.toml [build] runs it; PMUNITY is a
# portmaster-unity checkout): ua_host64 (portmaster-unity's 64-bit runtime, runtime/build.sh with ARCH=arm64),
# the Mono bridge (runtime/mono64/build.sh) and Unity's Mono of the game's 6000.0 line built for 64-bit ARM
# Linux (tools/mono64/build-mono.sh; its work folder: PMUNITY_MONO64_WORK, else tools/mono64/work), with their
# licences. Each is built only where it is missing (Docker). Systems without a 32-bit userland run the game
# on them (setup/patchscript64): Unity's 64-bit IL2CPP player, whose libil2cpp.so is the bridge, runs the
# game's own assemblies on that Mono, so nothing is compiled on the handheld (portmaster-unity
# docs/mono-arm64.md).
set -euo pipefail
OUT=$(mkdir -p "$1" && cd "$1" && pwd); PM=${PMUNITY:?set PMUNITY to a portmaster-unity checkout}
LINE=6000.0
WORK=${PMUNITY_MONO64_WORK:-$PM/tools/mono64/work}
M="$WORK/out/unity-$LINE-mbe"; SRC="$WORK/src/unity-$LINE-mbe"
[ -f "$PM/runtime/host/out/arm64/ua_host" ] || ARCH=arm64 "$PM/runtime/build.sh"
[ -f "$PM/runtime/mono64/out/arm64/libil2cpp_mono.so" ] || "$PM/runtime/mono64/build.sh"
[ -f "$M/libmonobdwgc-2.0.so" ] || "$PM/tools/mono64/build-mono.sh" "$LINE" "$WORK"
cp "$PM/runtime/host/out/arm64/ua_host" "$OUT/ua_host64"
mkdir -p "$OUT/mono64"
cp "$PM/runtime/mono64/out/arm64/libil2cpp_mono.so" "$OUT/mono64/libil2cpp.so"
for n in libmonobdwgc-2.0.so libMonoPosixHelper.so libmono-native.so; do cp "$M/$n" "$OUT/mono64/"; done
# (Unity's Mono for 6000.0 has "Microsoft Patent Promise.TXT" where older lines have PATENTS.TXT)
{ cat "$SRC/LICENSE"; echo; echo; cat "$SRC/Microsoft Patent Promise.TXT"; } > "$OUT/LICENSE.mono-$LINE.txt"
cp "$SRC/external/bdwgc/README.QUICK" "$OUT/LICENSE.bdwgc-$LINE.txt"
cp "$SRC/external/corefx/LICENSE.TXT" "$OUT/LICENSE.corefx-$LINE.txt"
ls -l "$OUT/ua_host64" "$OUT"/mono64/*.so
