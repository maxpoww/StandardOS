# The tools' names before 2026-11-22 — a shell fragment for the end of a
# profile's build (the system's: environment.extraSetup in legacy-names.nix;
# the owner's: home.extraProfileCommands in home/home.nix).
#
# Standard's commands carry no brand: they ARE the standard ones — update,
# recover, rebuild, status, caffeine, screenshot, lock… (Golem's own jobs
# keep its name, and use these same commands: the nightly update is Golem
# running `update`). The name each one had before still answers, as a link
# to it, wherever it is installed: old notes, habits, scripts and an older
# dock (which runs golem-brightness, golem-caffeine…) keep working. And the
# other way round: a machine that brings a command only by its old name
# (the dev box's own rebuild-golem) answers to the new one too.
''
  if [ -d "$out/bin" ] && [ ! -L "$out/bin" ]; then
    has() { [ -e "$out/bin/$1" ] || [ -L "$out/bin/$1" ]; }
    for pair in \
      golem-update:update golem-status:status golem-recover:recover \
      rebuild-golem:rebuild golem-brightness:brightness \
      golem-autobrightness:autobrightness golem-boot-password:boot-password \
      golem-printer-ink:printer-ink golem-caffeine:caffeine \
      golem-lock-screen:lock golem-screenshot:screenshot
    do
      old=''${pair%%:*} new=''${pair#*:}
      if has "$new" && ! has "$old"; then
        ln -s "$new" "$out/bin/$old"
      elif has "$old" && ! has "$new"; then
        ln -s "$old" "$out/bin/$new"
      fi
    done
  fi
''
