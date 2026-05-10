# Results Summary

## Submitted Summary

The submitted result set is summarised in `results/summary.csv`.

| Scenario | Policy accuracy | Reachable targets | Blocked targets | Blast-radius exposure | Containment | Availability | Avg response time | Reliability index |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Flat | 50.00% | 8 | 0 | 100.00% | 0.00% | 100.00% | 0.001030s | 52.40 |
| Segmented | 100.00% | 2 | 6 | 25.00% | 75.00% | 100.00% | 0.001082s | 91.14 |

## Interpretation

The flat baseline allows all tested internal lateral movement from the compromised student host. This produces a blast-radius exposure of 100% and no containment in the submitted test set.

The segmented design allows the compromised student host to reach only the second student host and the web service. Access to staff, admin, file, database, IoT, and guest targets is blocked. This reduces blast-radius exposure to 25%.

Both scenarios maintain 100% HTTP availability in the submitted performance test. Average response times differ only slightly in this lab run, indicating that the segmented forwarding policy did not materially reduce web availability under the tested workload.

## Evidence Files

| Evidence | Flat | Segmented |
| --- | --- | --- |
| Policy test CSV | `results/flat_connectivity.csv` | `results/segmented_connectivity.csv` |
| Blast-radius CSV | `results/flat_blast_radius.csv` | `results/segmented_blast_radius.csv` |
| HTTP performance CSV | `results/flat_performance.csv` | `results/segmented_performance.csv` |
| Nmap scan output | `results/flat_nmap_scan.txt` | `results/segmented_nmap_scan.txt` |
| Figures | `results/plots/*` | `results/plots/*` |

## Figures

Generated figures are stored in `results/plots/`:

- `policy_accuracy.png`
- `blast_radius_exposure.png`
- `containment_score.png`
- `availability.png`
- `average_response_time.png`
- `reliability_index.png`
- `flat_student_response_time.png`
- `segmented_student_response_time.png`

