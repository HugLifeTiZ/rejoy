#!/bin/bash
# Project file for Arcadia.

exit_usage () {
    echo "Usage: ./project.sh operation [path]"
    echo "This program manipulates /dev; only root can install/uninstall."
    echo "Operations:"
    echo "  install: Install Rejoy in prefix. Must be root."
    echo "  uninstall: Remove Rejoy from prefix. Must be root."
    exit 1
}

[[ $# -lt 1 ]] && exit_usage
[[ "$(whoami)" != "root" ]] && exit_usage
op="$1"; path="$2"

[[ "$path" ]] || path="/usr/local/share/rejoy"
bin_dir="$(readlink -f "$path/../../bin")";

cd "$(dirname "$(readlink -f "$0")")"
case "$1" in
install)
    export SIMPLE_BACKUP_SUFFIX="off"
    install -d "$path" "$path/opts" "$path/maps" "$bin_dir" \
     /etc/rejoy /etc/rejoy/opts /etc/rejoy/maps
    install -m0755 src/rejoyd "$bin_dir/rejoyd"
    install -m0755 src/rejoyctl "$bin_dir/rejoyctl"
    install -m0644 src/funcs "$path"
    install -m0644 opts/* "$path/opts"
    install -m0644 maps/* "$path/maps"
    install -m0644 data/profile.sh /etc/profile.d/xboxdrv-sdl2.sh
    install -m0644 data/udev.rules /etc/udev/rules.d/99-rejoy.rules
    install -m0644 data/rejoyd.service /etc/systemd/system/
    ;;
uninstall)
    rm -r "$path/share/rejoy"
    rm "$bin_dir/rejoyd" "$bin_dir/rejoyctl" /etc/udev/rules.d/99-rejoy.rules \
     /etc/profile.d/xboxdrv-sdl2.sh /etc/systemd/system/rejoyd.service
    ;;
esac
