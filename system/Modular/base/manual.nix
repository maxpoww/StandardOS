# The manual — StandardOS's documentation on every machine, offline
# (docs/manual: the Guide and the Expert parts, Markdown made into ONE
# self-contained HTML page by docs/manual/build.py; the website carries the
# same page).
#
#   manual            opens it in the default browser (on a console: says where it is)
#   manual <section>  opens it at a section: `manual guide-updates`
#
# The dock's Controls → Documentation runs `manual`; the box finds it as
# "StandardOS Documentation" (help, manual, guide…).
{ config, lib, pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.markdown ]);
  rev = config.system.configurationRevision;
  version = if rev == null then "unknown" else builtins.substring 0 12 rev;

  page = pkgs.runCommand "standardos-manual" { nativeBuildInputs = [ python ]; } ''
    cp -r ${../../../docs/manual} src
    chmod -R u+w src
    mkdir -p $out/share/doc/standardos
    python3 src/build.py $out/share/doc/standardos/index.html --version ${lib.escapeShellArg version}
  '';

  manual = pkgs.writeShellScriptBin "manual" ''
    page=${page}/share/doc/standardos/index.html
    anchor=''${1:+#$1}
    if [ -n "''${WAYLAND_DISPLAY:-}''${DISPLAY:-}" ] && command -v xdg-open >/dev/null 2>&1; then
      exec xdg-open "file://$page$anchor"
    fi
    echo "The StandardOS documentation is in: $page"
    echo "Open that file in a web browser."
  '';

  entry = pkgs.makeDesktopItem {
    name = "standardos-manual";
    desktopName = "StandardOS Documentation";
    genericName = "Help";
    comment = "How to use StandardOS, fix a problem, and go further";
    exec = "manual";
    icon = "help-browser";
    categories = [ "Documentation" ];
    keywords = [ "help" "manual" "documentation" "guide" "docs" ];
  };
in
{
  # (hiPrio: Standard's `manual` wins over an app's of the same name.)
  environment.systemPackages = [ (lib.hiPrio manual) entry ];
}
