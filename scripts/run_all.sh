#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE=(docker compose)

if ! docker compose version >/dev/null 2>&1; then
    if command -v docker-compose >/dev/null 2>&1; then
        COMPOSE=(docker-compose)
    else
        echo "Docker Compose was not found. Install 'docker compose' or 'docker-compose'."
        exit 1
    fi
fi

mkdir -p "$ROOT_DIR/results"
CURRENT_SCENARIO=""

cleanup() {
    if [ -n "$CURRENT_SCENARIO" ]; then
        stop_scenario "$CURRENT_SCENARIO" || true
    fi
}

trap cleanup EXIT

start_scenario() {
    local scenario="$1"
    local dir="$ROOT_DIR/${scenario}-network"

    echo
    echo "Starting ${scenario} topology..."
    CURRENT_SCENARIO="$scenario"
    (cd "$dir" && "${COMPOSE[@]}" up -d --build)

    echo "Waiting for services to initialise..."
    sleep 5
}

stop_scenario() {
    local scenario="$1"
    local dir="$ROOT_DIR/${scenario}-network"

    echo
    echo "Stopping ${scenario} topology..."
    (cd "$dir" && "${COMPOSE[@]}" down)
    CURRENT_SCENARIO=""
}

run_tests() {
    local scenario="$1"

    echo
    echo "Running ${scenario} tests..."
    (cd "$ROOT_DIR" && ./scripts/connectivity_test.sh "$scenario")
    (cd "$ROOT_DIR" && ./scripts/blast_radius_test.sh "$scenario")
    (cd "$ROOT_DIR" && ./scripts/scan_test.sh "$scenario")
    (cd "$ROOT_DIR" && ./scripts/performance_test.sh "$scenario")
}

for scenario in flat segmented; do
    start_scenario "$scenario"
    run_tests "$scenario"
    stop_scenario "$scenario"
done

echo
echo "Regenerating summary..."
(cd "$ROOT_DIR" && ./scripts/summarise_results.py)

echo
echo "Regenerating plots..."
if (cd "$ROOT_DIR" && ./scripts/make_plots.py); then
    echo "Plots regenerated."
else
    echo "Plot generation failed. Install matplotlib if plots are required."
fi

echo
echo "Artefact run complete. See results/summary.csv and docs/RESULTS.md."
