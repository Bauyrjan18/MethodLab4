import csv
import sys
from pathlib import Path


def load_metrics(csv_path):
    records = []
    with open(csv_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            records.append({
                "method": row["method"],
                "concurrency": int(row["concurrency_level"]),
                "mean": float(row["mean_latency_ms"]),
                "std": float(row["std_latency_ms"]),
                "median": float(row["median_latency_ms"]),
                "p25": float(row["p25_latency_ms"]),
                "p75": float(row["p75_latency_ms"]),
                "ci_lower": float(row["ci95_lower_ms"]),
                "ci_upper": float(row["ci95_upper_ms"]),
                "p95": float(row["p95_latency_ms"]),
                "p99": float(row["p99_latency_ms"]),
                "qps": float(row["throughput_qps"]),
                "error_rate": float(row["guardrail_error_rate_pct"]),
                "sla_violation": float(row["guardrail_sla_violation_pct"]),
                "recall": float(row["mean_recall_at_10"]),
            })
    return records


def format_latex_row(record):
    method_name = "Baseline (Flat)" if "Baseline" in record["method"] else "Proposed (HNSW-SQ8)"
    mean_std = f"${record['mean']:.2f} \\pm {record['std']:.2f}$"
    median_iqr = f"${record['median']:.2f}\\ ({record['p25']:.2f}\\text{{--}}{record['p75']:.2f})$"
    ci_range = f"$[{record['ci_lower']:.2f}, {record['ci_upper']:.2f}]$"
    p95 = f"${record['p95']:.2f}$"
    p99 = f"${record['p99']:.2f}$"
    qps = f"${record['qps']:.1f}$"
    error_pct = f"${record['error_rate']:.1f}\\%$"
    sla_pct = f"${record['sla_violation']:.1f}\\%$"
    recall = f"${record['recall']:.4f}$"
    
    return f"{method_name} & {record['concurrency']} & {mean_std} & {median_iqr} & {ci_range} & {p95} & {p99} & {qps} & {error_pct} & {sla_pct} & {recall} \\\\"


def generate_table(records):
    lines = [
        "\\begin{tabular}{lrrrrrrrrrr}",
        "\\toprule",
        "Architecture & Load ($C$) & Mean $\\pm$ SD (ms) & Median ($p_{25}$--$p_{75}$) (ms) & 95\\% Bootstrap CI (ms) & $p_{95}$ (ms) & $p_{99}$ (ms) & QPS & $E_{\\text{rate}}$ & SLA Breach & Recall@10 \\\\",
        "\\midrule"
    ]
    baseline_records = [r for r in records if "Baseline" in r["method"]]
    proposed_records = [r for r in records if "Proposed" in r["method"]]
    
    for r in baseline_records:
        lines.append(format_latex_row(r))
    lines.append("\\midrule")
    for r in proposed_records:
        lines.append(format_latex_row(r))
    lines.append("\\bottomrule")
    lines.append("\\end{tabular}")
    return "\n".join(lines)


if __name__ == "__main__":
    base_dir = Path(__file__).resolve().parent.parent
    csv_file = base_dir / "data" / "processed" / "metrics_summary.csv"
    if not csv_file.exists():
        sys.exit(f"File not found: {csv_file}")
    data = load_metrics(csv_file)
    print(generate_table(data))
