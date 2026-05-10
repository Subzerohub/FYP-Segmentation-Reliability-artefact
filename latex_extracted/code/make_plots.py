#!/usr/bin/env python3
import csv
import os
import matplotlib.pyplot as plt

os.makedirs("results/plots", exist_ok=True)

def read_csv(path):
    with open(path, newline="") as f:
        return list(csv.DictReader(f))

summary = read_csv("results/summary.csv")

def bar_plot(metric, title, ylabel, filename):
    names = [r["scenario"] for r in summary]
    values = [float(r[metric]) for r in summary]

    plt.figure()
    plt.bar(names, values)
    plt.title(title)
    plt.ylabel(ylabel)
    plt.xlabel("Architecture")
    plt.tight_layout()
    plt.savefig(f"results/plots/{filename}")
    plt.close()

bar_plot("policy_accuracy_percent", "Firewall Policy Accuracy", "Accuracy (%)", "policy_accuracy.png")
bar_plot("blast_radius_exposure_percent", "Blast Radius Exposure", "Exposure (%)", "blast_radius_exposure.png")
bar_plot("containment_score_percent", "Containment Score", "Containment (%)", "containment_score.png")
bar_plot("availability_percent", "HTTP Availability", "Availability (%)", "availability.png")
bar_plot("average_response_time_seconds", "Average Response Time", "Seconds", "average_response_time.png")
bar_plot("reliability_index", "Overall Reliability Index", "Score / 100", "reliability_index.png")

for scenario in ["flat", "segmented"]:
    rows = read_csv(f"results/{scenario}_performance.csv")
    attempts = [int(r["attempt"]) for r in rows if r["source"].endswith("student")]
    times = [float(r["total_time_seconds"]) for r in rows if r["source"].endswith("student")]

    plt.figure()
    plt.plot(attempts, times)
    plt.title(f"{scenario.capitalize()} Student Response Time Across 100 Iterations")
    plt.xlabel("Attempt")
    plt.ylabel("Response time, seconds")
    plt.tight_layout()
    plt.savefig(f"results/plots/{scenario}_student_response_time.png")
    plt.close()

print("Saved plots in results/plots/")
