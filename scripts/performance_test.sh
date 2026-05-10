#!/bin/bash
set -e

SCENARIO="$1"
ITERATIONS=500
OUT="results/${SCENARIO}_performance.csv"

echo "scenario,source,url,attempt,http_code,total_time_seconds" > "$OUT"

run_curl_test() {
    SRC="$1"
    URL="$2"

    for i in $(seq 1 $ITERATIONS); do
        RESULT=$(docker exec "$SRC" curl -o /dev/null -s -w "%{http_code},%{time_total}" "$URL" || echo "000,0")
        CODE=$(echo "$RESULT" | cut -d',' -f1)
        TIME=$(echo "$RESULT" | cut -d',' -f2)
        echo "$SCENARIO,$SRC,$URL,$i,$CODE,$TIME" >> "$OUT"
    done
}

if [ "$SCENARIO" = "flat" ]; then
    run_curl_test flat-student http://10.10.0.40
    run_curl_test flat-staff http://10.10.0.40
    run_curl_test flat-admin http://10.10.0.40
    run_curl_test flat-guest http://10.10.0.40

elif [ "$SCENARIO" = "segmented" ]; then
    run_curl_test seg-student http://10.10.40.10
    run_curl_test seg-staff http://10.10.40.10
    run_curl_test seg-admin http://10.10.40.10
    run_curl_test seg-guest http://10.10.40.10

else
    echo "Usage: $0 flat|segmented"
    exit 1
fi

echo "Saved: $OUT"
