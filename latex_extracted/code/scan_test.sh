#!/bin/bash
set -e

SCENARIO="$1"
OUT="results/${SCENARIO}_nmap_scan.txt"

if [ "$SCENARIO" = "flat" ]; then
    docker exec flat-student nmap -Pn -p 80,445,3306 10.10.0.0/24 > "$OUT"

elif [ "$SCENARIO" = "segmented" ]; then
    docker exec seg-student nmap -Pn -p 80,445,3306 10.10.10.0/24 10.10.20.0/24 10.10.30.0/24 10.10.40.0/24 10.10.50.0/24 10.10.60.0/24 > "$OUT"

else
    echo "Usage: $0 flat|segmented"
    exit 1
fi

echo "Saved: $OUT"
