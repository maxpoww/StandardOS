#!/bin/sh
# Writes the Standard icon themes into $1 (default system/home/icons, what
# home/look.nix installs): each the scalable drawing plus the 24 and 16 px
# versions, and its index.theme (index.theme here, named and inherited per
# tone). Standard's own icons (folders, files, devices) only; everything else —
# apps above all — comes from Papirus / Papirus-Dark, which they inherit.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=${1:-$HERE/../../system/home/icons}
# Two tones (Max, 2026-10-14): Standard (silver) for the light look,
# Standard-Dark (graphite) for the dark one; the dark mode switches between
# them. (Golem and Golem-Dark until 2026-11-22: home/look.nix keeps those
# names as links, for an older dock and the settings that name them.)
for tone in light dark; do
  if [ $tone = light ]; then name=Standard; inherits=Papirus,hicolor; else name=Standard-Dark; inherits=Papirus-Dark,hicolor; fi
  DEST=$ROOT/$name
  rm -rf "$DEST"; mkdir -p "$DEST"
  for size in scalable 24 16; do
    dir=$size; [ "$size" = scalable ] || dir=${size}x${size}
    GOLEM_ICON_TONE=$tone GOLEM_ICON_SIZE=$size GOLEM_ICON_OUT="$DEST/$dir" python3 "$HERE/make.py" >/dev/null
    GOLEM_ICON_TONE=$tone GOLEM_ICON_SIZE=$size GOLEM_ICON_OUT="$DEST/$dir" python3 "$HERE/files.py" >/dev/null
  done
  # The file manager's own icon, in the tone (graphite in the dark, as the dock draws it).
  GOLEM_ICON_TONE=$tone GOLEM_ICON_OUT="$DEST/scalable" python3 "$HERE/app.py"
  # Seam's compass, in the tone of the theme (the dock swings its needle).
  GOLEM_ICON_TONE=$tone GOLEM_ICON_OUT="$DEST/scalable" python3 "$HERE/seam.py"
  sed -e "s/^Name=Standard$/Name=$name/" -e "s/^Inherits=.*/Inherits=$inherits/" "$HERE/index.theme" > "$DEST/index.theme"
  echo "$name: $(find "$DEST" -name '*.svg' | wc -l) names"
done
