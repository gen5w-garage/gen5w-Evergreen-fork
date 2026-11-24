#!/system/bin/sh
# Evergreen service wireless.carplay.aa/tbt-trace: keeps the turn-by-turn trace.
#
# Only when the package was installed with EVERGREEN-TRACE on the install drive
# (scripts/common.sh trace_setup writes the flag below). Then DiPO logs each raw
# CarPlay route guidance, maneuver and lane message (numbers only; strings only as
# their count, so no road names) as "Leafia: trace ..." lines, and this writes every
# Leafia log line to TRACE_DIR from boot on: the log buffer itself only holds seconds
# on these units. At most 5 files of 2 MB, oldest dropped. NEMESIS Manager's
# Logs > Copy to USB and the kit's private logs take them.
# Without the flag it only waits (mode=restart would start it again if it ended).

export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

FLAG=/data/nemesis/wireless.carplay.aa.trace
DIR=/data/nemesis/logs/evergreen-trace

while [ ! -f "$FLAG" ]; do
    sleep 3600
done
umask 077
mkdir -p "$DIR" || exit 1
echo "$(date) trace on: $DIR/trace.log"
exec logcat -v time -s Leafia:V -f "$DIR/trace.log" -r 2048 -n 4
