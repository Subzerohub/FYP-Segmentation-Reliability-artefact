#!/usr/bin/env python3
import csv
from statistics import mean

def read_csv(path):
    with open(path, newline="") as f:
        return list(csv.DictReader(f))

def connectivity_summary(scenario):
    rows = read_csv(f"results/{scenario}_connectivity.csv")
    total = len(rows)
    passed = sum(1 for r in rows if r["pass_fail"] == "PASS")
    failed = total - passed
    accuracy = (passed / total) * 100 if total else 0
    return total, passed, failed, accuracy

def blast_summary(scenario):
    rows = read_csv(f"results/{scenario}_blast_radius.csv")
    reachable = sum(1 for r in rows if r["actual"] == "REACHABLE")
    blocked = sum(1 for r in rows if r["actual"] == "BLOCKED")
    total = len(rows)
    exposure = (reachable / total) * 100 if total else 0
    containment = 100 - exposure
    return total, reachable, blocked, exposure, containment

def performance_summary(scenario):
    rows = read_csv(f"results/{scenario}_performance.csv")
    success = [r for r in rows if r["http_code"] == "200"]
    times = [float(r["total_time_seconds"]) for r in success]
    total = len(rows)
    success_count = len(success)
    availability = (success_count / total) * 100 if total else 0
    avg_time = mean(times) if times else 0
    performance_score = max(0, 100 - (avg_time * 1000))
    return total, success_count, availability, avg_time, performance_score

summary_rows = []

print("SCENARIO SUMMARY")
print("================")

for scenario in ["flat", "segmented"]:
    ct_total, ct_passed, ct_failed, ct_accuracy = connectivity_summary(scenario)
    br_total, br_reach, br_block, exposure, containment = blast_summary(scenario)
    pf_total, pf_success, availability, avg_time, performance_score = performance_summary(scenario)

    reliability_index = (
        0.30 * availability +
        0.35 * containment +
        0.25 * ct_accuracy +
        0.10 * performance_score
    )

    print()
    print(f"Scenario: {scenario}")
    print(f"Connectivity policy accuracy: {ct_accuracy:.2f}% ({ct_passed}/{ct_total} passed)")
    print(f"Blast radius exposure: {exposure:.2f}% ({br_reach}/{br_total} reachable)")
    print(f"Containment score: {containment:.2f}%")
    print(f"Web availability: {availability:.2f}% ({pf_success}/{pf_total} successful)")
    print(f"Average web response time: {avg_time:.6f} seconds")
    print(f"Performance score: {performance_score:.2f}/100")
    print(f"Reliability index: {reliability_index:.2f}/100")

    summary_rows.append({
        "scenario": scenario,
        "policy_accuracy_percent": round(ct_accuracy, 2),
        "reachable_targets": br_reach,
        "blocked_targets": br_block,
        "blast_radius_exposure_percent": round(exposure, 2),
        "containment_score_percent": round(containment, 2),
        "availability_percent": round(availability, 2),
        "average_response_time_seconds": round(avg_time, 6),
        "performance_score": round(performance_score, 2),
        "reliability_index": round(reliability_index, 2),
    })

with open("results/summary.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=summary_rows[0].keys())
    writer.writeheader()
    writer.writerows(summary_rows)

print()
print("Saved: results/summary.csv")
