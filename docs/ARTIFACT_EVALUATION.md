# Artefact Evaluation Guide

## Purpose

This artefact supports the evaluation of a final-year project experiment comparing flat and segmented network designs. It is intended to let a marker inspect the implementation, reproduce the experiment, and verify the reported results.

## Claims Supported By The Artefact

1. The segmented architecture enforces the intended access-control policy more accurately than the flat baseline.
2. The segmented architecture reduces lateral movement from a compromised student host.
3. The segmented architecture preserves the required HTTP service availability in this lab configuration.
4. The reliability index is higher for the segmented architecture under the submitted metric weighting.

## Expected Environment

The artefact was designed for a Linux host with:

- Docker and Docker Compose.
- Bash.
- Python 3.
- Internet access for pulling `handsonsecurity/seed-ubuntu:large` if it is not already cached.
- Optional: Python `matplotlib` for plot generation.

The lab uses privileged containers and Linux networking features. It should be run only on a machine where Docker lab networking is acceptable.

## Evaluation Workflow

From the repository root, run:

```bash
./scripts/run_all.sh
```

This command performs the following steps:

1. Starts the flat topology.
2. Runs connectivity, blast-radius, Nmap, and HTTP performance tests.
3. Stops the flat topology.
4. Starts the segmented topology.
5. Runs the same tests against the segmented topology.
6. Stops the segmented topology.
7. Regenerates `results/summary.csv`.
8. Regenerates plots when `matplotlib` is installed.

The performance test uses 500 HTTP attempts per source and four sources per scenario, so a full run may take several minutes depending on the host.

## Fast Inspection Without Re-running

The submitted outputs are already present in `results/`:

- `results/summary.csv`
- `results/flat_connectivity.csv`
- `results/segmented_connectivity.csv`
- `results/flat_blast_radius.csv`
- `results/segmented_blast_radius.csv`
- `results/flat_performance.csv`
- `results/segmented_performance.csv`
- `results/flat_nmap_scan.txt`
- `results/segmented_nmap_scan.txt`
- `results/plots/*.png`

The most important file for checking the headline findings is `results/summary.csv`.

## Expected Results

The supplied run produced:

| Scenario | Policy accuracy | Reachable targets | Blocked targets | Exposure | Containment | Availability | Reliability index |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Flat | 50.00% | 8 | 0 | 100.00% | 0.00% | 100.00% | 52.40 |
| Segmented | 100.00% | 2 | 6 | 25.00% | 75.00% | 100.00% | 91.14 |

Minor timing values may vary between machines, but policy accuracy, blast-radius reachability, and availability should remain consistent if the Docker networking environment behaves normally.

## Clean-up

If a run is interrupted, stop either topology manually:

```bash
docker compose -f flat-network/docker-compose.yml down
docker compose -f segmented-network/docker-compose.yml down
```

The containers are named with `flat-` and `seg-` prefixes, making them easy to identify with `docker ps`.

