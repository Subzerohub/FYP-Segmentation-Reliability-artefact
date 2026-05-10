# Artefact Manifest

## Top-level Files

| File | Description |
| --- | --- |
| `README.md` | Entry point for the academic submission artefact. |
| `docs/ARTIFACT_EVALUATION.md` | Marker-facing evaluation and reproduction guide. |
| `docs/METHODOLOGY.md` | Experiment design, metric definitions, and limitations. |
| `docs/RESULTS.md` | Result interpretation and evidence map. |
| `docs/MANIFEST.md` | Inventory of artefact files. |

## Implementation

| Path | Description |
| --- | --- |
| `flat-network/docker-compose.yml` | Flat network topology. |
| `flat-network/firewall.sh` | Flat network firewall policy. |
| `segmented-network/docker-compose.yml` | Segmented network topology. |
| `segmented-network/firewall.sh` | Segmented network firewall policy. |
| `image_fyp/Dockerfile` | Shared container image definition. |

## Scripts

| Script | Description |
| --- | --- |
| `scripts/run_all.sh` | Full reproducibility runner for both scenarios. |
| `scripts/connectivity_test.sh` | Tests expected allowed and blocked flows. |
| `scripts/blast_radius_test.sh` | Measures reachability from a compromised student host. |
| `scripts/scan_test.sh` | Runs Nmap service scans. |
| `scripts/performance_test.sh` | Measures HTTP availability and response times. |
| `scripts/summarise_results.py` | Produces `results/summary.csv` and prints headline metrics. |
| `scripts/make_plots.py` | Produces figures in `results/plots/`. |
| `scripts/tcp_service.py` | Simple TCP service used by file and database containers. |

## Results

| Result | Description |
| --- | --- |
| `results/summary.csv` | Aggregated metrics and reliability index. |
| `results/*_connectivity.csv` | Per-flow policy correctness results. |
| `results/*_blast_radius.csv` | Per-target compromised-host reachability results. |
| `results/*_performance.csv` | Per-request HTTP response data. |
| `results/*_nmap_scan.txt` | Raw Nmap scan outputs. |
| `results/plots/*.png` | Generated figures for report inclusion. |

