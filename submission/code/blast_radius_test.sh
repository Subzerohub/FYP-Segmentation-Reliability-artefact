#!/bin/bash
set -e

SCENARIO="$1"
OUT="results/${SCENARIO}_blast_radius.csv"

echo "scenario,compromised_host,target,ip,test,actual" > "$OUT"

probe_ping() {
    SRC="$1"
    TARGET="$2"
    IP="$3"

    if docker exec "$SRC" timeout 2 ping -c 1 -W 1 "$IP" >/dev/null 2>&1; then
        ACTUAL="REACHABLE"
    else
        ACTUAL="BLOCKED"
    fi

    echo "$SCENARIO,$SRC,$TARGET,$IP,ICMP,$ACTUAL" >> "$OUT"
}

probe_tcp() {
    SRC="$1"
    TARGET="$2"
    IP="$3"
    PORT="$4"

    if docker exec "$SRC" timeout 2 bash -lc "echo test | nc -w 1 $IP $PORT >/dev/null 2>&1"; then
        ACTUAL="REACHABLE"
    else
        ACTUAL="BLOCKED"
    fi

    echo "$SCENARIO,$SRC,$TARGET,$IP,TCP/$PORT,$ACTUAL" >> "$OUT"
}

if [ "$SCENARIO" = "flat" ]; then
    SRC="flat-student"

    probe_ping "$SRC" flat-student2 10.10.0.11
    probe_ping "$SRC" flat-staff 10.10.0.20
    probe_ping "$SRC" flat-admin 10.10.0.30
    probe_tcp "$SRC" flat-web 10.10.0.40 80
    probe_tcp "$SRC" flat-file 10.10.0.50 445
    probe_tcp "$SRC" flat-db 10.10.0.60 3306
    probe_ping "$SRC" flat-iot 10.10.0.70
    probe_ping "$SRC" flat-guest 10.10.0.80

elif [ "$SCENARIO" = "segmented" ]; then
    SRC="seg-student"

    probe_ping "$SRC" seg-student2 10.10.10.11
    probe_ping "$SRC" seg-staff 10.10.20.20
    probe_ping "$SRC" seg-admin 10.10.30.30
    probe_tcp "$SRC" seg-web 10.10.40.10 80
    probe_tcp "$SRC" seg-file 10.10.40.20 445
    probe_tcp "$SRC" seg-db 10.10.40.30 3306
    probe_ping "$SRC" seg-iot 10.10.50.50
    probe_ping "$SRC" seg-guest 10.10.60.60

else
    echo "Usage: $0 flat|segmented"
    exit 1
fi

echo "Saved: $OUT"
