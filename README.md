# FYP Segmentation Reliability Artefact

This artefact evaluates how network segmentation affects reliability, containment, and policy enforcement in a controlled Docker-based cyber-security lab. It compares two architectures:

- `flat-network/`: a single internal network protected by a forwarding firewall.
- `segmented-network/`: separate student, staff, admin, server, IoT, and guest networks with explicit inter-segment firewall policy.

The experiment measures whether segmentation improves containment after compromise while preserving required service availability.

## Artefact Contents

| Path | Purpose |
| --- | --- |
| `flat-network/` | Docker Compose topology and firewall rules for the flat baseline. |
| `segmented-network/` | Docker Compose topology and firewall rules for the segmented architecture. |
| `image_fyp/` | Reproducible container image with networking, scanning, and test tools. |
| `scripts/` | Connectivity, blast-radius, scan, performance, plotting, and summary scripts. |
| `results/` | Collected CSV and Nmap outputs from the submitted experiment run. |
| `results/plots/` | Figures generated from `results/summary.csv` and performance outputs. |
| `docs/` | Academic artefact guide, methodology, results summary, and manifest. |

## Research Question

Does role-based network segmentation improve containment and policy reliability compared with a flat internal network, without materially reducing web-service availability?

## Key Submitted Results

The supplied results show that the segmented design preserves HTTP availability while reducing lateral reachability from a compromised student host.

| Scenario | Policy accuracy | Blast-radius exposure | Containment | Availability | Reliability index |
| --- | ---: | ---: | ---: | ---: | ---: |
| Flat | 50.00% | 100.00% | 0.00% | 100.00% | 52.40 |
| Segmented | 100.00% | 25.00% | 75.00% | 100.00% | 91.14 |

## Quick Start

Prerequisites:

- Docker with Compose support.
- Bash.
- Python 3.
- Optional for plot regeneration: `matplotlib`.

Run the full experiment from the repository root:

```bash
./scripts/run_all.sh
```

The script rebuilds the lab image, runs both scenarios, refreshes `results/*.csv` and `results/*_nmap_scan.txt`, regenerates `results/summary.csv`, and attempts to regenerate plots.

To regenerate only the summary from existing result files:

```bash
./scripts/summarise_results.py
```

To regenerate plots from existing result files:

```bash
./scripts/make_plots.py
```

## Reading Order For Markers

1. [`docs/ARTIFACT_EVALUATION.md`](docs/ARTIFACT_EVALUATION.md) explains how to inspect, run, and validate the artefact.
2. [`docs/METHODOLOGY.md`](docs/METHODOLOGY.md) describes the experimental design and metrics.
3. [`docs/RESULTS.md`](docs/RESULTS.md) summarises the supplied evidence.
4. [`docs/MANIFEST.md`](docs/MANIFEST.md) lists the files and their roles.

## Reproducibility Notes

The artefact is self-contained except for Docker base-image retrieval and Python plotting dependencies. The saved result files allow assessment even if the Docker environment is unavailable. Re-running the experiment will overwrite the CSV, scan, summary, and plot outputs in `results/`.

