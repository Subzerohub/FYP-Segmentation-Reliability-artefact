#!/bin/bash
set -e

SCENARIO="$1"
OUT="results/${SCENARIO}_connectivity.csv"

echo "scenario,source,target,ip,protocol_port,expected,actual,pass_fail,response_time_ms" > "$OUT"

tcp_test() {
    SRC="$1"
    TARGET="$2"
    IP="$3"
    PORT="$4"
    EXPECTED="$5"

    START=$(date +%s%3N)

    if docker exec "$SRC" timeout 2 bash -lc "echo test | nc -w 1 $IP $PORT >/dev/null 2>&1"; then
        ACTUAL="ALLOW"
    else
        ACTUAL="BLOCK"
    fi

    END=$(date +%s%3N)
    TIME=$((END - START))

    if [ "$ACTUAL" = "$EXPECTED" ]; then
        PF="PASS"
    else
        PF="FAIL"
    fi

    echo "$SCENARIO,$SRC,$TARGET,$IP,TCP/$PORT,$EXPECTED,$ACTUAL,$PF,$TIME" >> "$OUT"
}

ping_test() {
    SRC="$1"
    TARGET="$2"
    IP="$3"
    EXPECTED="$4"

    START=$(date +%s%3N)

    if docker exec "$SRC" timeout 2 ping -c 1 -W 1 "$IP" >/dev/null 2>&1; then
        ACTUAL="ALLOW"
    else
        ACTUAL="BLOCK"
    fi

    END=$(date +%s%3N)
    TIME=$((END - START))

    if [ "$ACTUAL" = "$EXPECTED" ]; then
        PF="PASS"
    else
        PF="FAIL"
    fi

    echo "$SCENARIO,$SRC,$TARGET,$IP,ICMP,$EXPECTED,$ACTUAL,$PF,$TIME" >> "$OUT"
}

if [ "$SCENARIO" = "flat" ]; then
    tcp_test flat-student flat-web 10.10.0.40 80 ALLOW
    tcp_test flat-student flat-db 10.10.0.60 3306 BLOCK
    ping_test flat-student flat-admin 10.10.0.30 BLOCK
    tcp_test flat-staff flat-file 10.10.0.50 445 ALLOW
    ping_test flat-iot flat-admin 10.10.0.30 BLOCK
    tcp_test flat-guest flat-db 10.10.0.60 3306 BLOCK
    tcp_test flat-attacker flat-web 10.10.0.40 80 ALLOW
    tcp_test flat-attacker flat-db 10.10.0.60 3306 BLOCK

elif [ "$SCENARIO" = "segmented" ]; then
    tcp_test seg-student seg-web 10.10.40.10 80 ALLOW
    tcp_test seg-student seg-db 10.10.40.30 3306 BLOCK
    ping_test seg-student seg-admin 10.10.30.30 BLOCK
    tcp_test seg-staff seg-file 10.10.40.20 445 ALLOW
    ping_test seg-iot seg-admin 10.10.30.30 BLOCK
    tcp_test seg-guest seg-db 10.10.40.30 3306 BLOCK
    tcp_test seg-attacker seg-web 10.10.40.10 80 ALLOW
    tcp_test seg-attacker seg-db 10.10.40.30 3306 BLOCK

else
    echo "Usage: $0 flat|segmented"
    exit 1
fi

echo "Saved: $OUT"
