"""
Performance report generation.

Collects :class:`~utils.metrics.PerformanceSample` objects throughout a test
session and writes a human-readable text report (and optionally a JSON report)
when the session ends.
"""

import json
import os
import time
from typing import Dict, List, Optional

from .metrics import AggregatedMetrics, PerformanceSample, aggregate

_DEFAULT_REPORT_DIR = os.path.join(os.path.dirname(__file__), "..", "reports")


class PerformanceReporter:
    """Accumulate performance samples and write reports at the end of a session.

    Args:
        report_dir: Directory where reports are written.  Created on demand.
    """

    def __init__(self, report_dir: Optional[str] = None) -> None:
        self._report_dir = report_dir or _DEFAULT_REPORT_DIR
        self._samples: Dict[str, List[PerformanceSample]] = {}

    def record(self, sample: PerformanceSample) -> None:
        """Add a :class:`~utils.metrics.PerformanceSample` to the collection.

        Args:
            sample: The sample to record.
        """
        self._samples.setdefault(sample.label, []).append(sample)

    def aggregated(self) -> List[AggregatedMetrics]:
        """Return aggregated metrics for every recorded label."""
        return [aggregate(samples) for samples in self._samples.values()]

    def write_text_report(self, filename: Optional[str] = None) -> str:
        """Write a human-readable text report and return its path.

        Args:
            filename: Override the default timestamped filename.

        Returns:
            Absolute path of the written report file.
        """
        os.makedirs(self._report_dir, exist_ok=True)
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        filename = filename or f"performance_report_{timestamp}.txt"
        path = os.path.join(self._report_dir, filename)

        lines = [
            "=" * 72,
            "  BaseViper iOS Performance Test Report",
            f"  Generated: {time.strftime('%Y-%m-%d %H:%M:%S')}",
            "=" * 72,
            "",
        ]

        for metrics in self.aggregated():
            lines += self._format_metrics(metrics)
            lines.append("")

        with open(path, "w", encoding="utf-8") as fh:
            fh.write("\n".join(lines))

        return path

    def write_json_report(self, filename: Optional[str] = None) -> str:
        """Write a machine-readable JSON report and return its path.

        Args:
            filename: Override the default timestamped filename.

        Returns:
            Absolute path of the written report file.
        """
        os.makedirs(self._report_dir, exist_ok=True)
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        filename = filename or f"performance_report_{timestamp}.json"
        path = os.path.join(self._report_dir, filename)

        data = []
        for m in self.aggregated():
            entry = {
                "label": m.label,
                "count": m.count,
                "load_time": {
                    "min": round(m.min_load_time, 4),
                    "max": round(m.max_load_time, 4),
                    "avg": round(m.avg_load_time, 4),
                    "stddev": round(m.stddev_load_time, 4),
                },
            }
            if m.avg_memory_mb is not None:
                entry["memory_mb"] = {
                    "min": round(m.min_memory_mb, 2),
                    "max": round(m.max_memory_mb, 2),
                    "avg": round(m.avg_memory_mb, 2),
                }
            if m.avg_fps is not None:
                entry["fps"] = {
                    "min": round(m.min_fps, 2),
                    "max": round(m.max_fps, 2),
                    "avg": round(m.avg_fps, 2),
                }
            data.append(entry)

        with open(path, "w", encoding="utf-8") as fh:
            json.dump(data, fh, indent=2)

        return path

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    @staticmethod
    def _format_metrics(m: AggregatedMetrics) -> List[str]:
        lines = [
            f"Test: {m.label}",
            f"  Runs        : {m.count}",
            f"  Load time   : min={m.min_load_time:.3f}s  "
            f"max={m.max_load_time:.3f}s  "
            f"avg={m.avg_load_time:.3f}s  "
            f"stddev={m.stddev_load_time:.3f}s",
        ]
        if m.avg_memory_mb is not None:
            lines.append(
                f"  Memory (MB) : min={m.min_memory_mb:.1f}  "
                f"max={m.max_memory_mb:.1f}  "
                f"avg={m.avg_memory_mb:.1f}"
            )
        if m.avg_fps is not None:
            lines.append(
                f"  FPS         : min={m.min_fps:.1f}  "
                f"max={m.max_fps:.1f}  "
                f"avg={m.avg_fps:.1f}"
            )
        lines.append("-" * 72)
        return lines
