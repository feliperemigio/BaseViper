"""
Performance baseline comparison utilities.

Loads a JSON file of threshold values and provides helpers that compare
measured metrics against those thresholds.
"""

import json
import os
from typing import Any, Dict, Optional

# Resolve the default path relative to this file so the module works from any
# working directory.
_DEFAULT_BASELINE_PATH = os.path.join(
    os.path.dirname(__file__), "..", "baselines", "performance_baselines.json"
)


class BaselineError(AssertionError):
    """Raised when a measured metric exceeds its configured baseline threshold."""


class PerformanceBaseline:
    """Load and query performance thresholds from a JSON file.

    Args:
        path: Path to the JSON baselines file.  Defaults to
            ``baselines/performance_baselines.json`` relative to this module.

    Example JSON structure::

        {
            "initial_view_controller_load": {
                "max_load_time_seconds": 2.0,
                "max_memory_mb": 50.0,
                "min_fps": 55.0
            }
        }
    """

    def __init__(self, path: Optional[str] = None) -> None:
        self._path = path or _DEFAULT_BASELINE_PATH
        self._thresholds: Dict[str, Any] = {}
        self._load()

    def _load(self) -> None:
        """Load thresholds from the JSON file, ignoring missing files gracefully."""
        try:
            with open(self._path, "r", encoding="utf-8") as fh:
                self._thresholds = json.load(fh)
        except FileNotFoundError:
            self._thresholds = {}

    def get(self, test_name: str) -> Dict[str, Any]:
        """Return the threshold dict for *test_name*, or an empty dict."""
        return self._thresholds.get(test_name, {})

    def assert_load_time(self, test_name: str, actual_seconds: float) -> None:
        """Assert that *actual_seconds* does not exceed the configured threshold.

        Args:
            test_name: Key in the baselines file (e.g. ``"initial_view_controller_load"``).
            actual_seconds: The measured load time.

        Raises:
            BaselineError: If the load time exceeds the threshold.
        """
        threshold = self.get(test_name).get("max_load_time_seconds")
        if threshold is None:
            return
        if actual_seconds > threshold:
            raise BaselineError(
                f"[{test_name}] Load time {actual_seconds:.3f}s exceeds "
                f"baseline threshold {threshold}s."
            )

    def assert_memory(self, test_name: str, actual_mb: Optional[float]) -> None:
        """Assert that *actual_mb* does not exceed the configured threshold.

        Args:
            test_name: Key in the baselines file.
            actual_mb: The measured memory usage in MB, or ``None`` to skip.

        Raises:
            BaselineError: If memory usage exceeds the threshold.
        """
        if actual_mb is None:
            return
        threshold = self.get(test_name).get("max_memory_mb")
        if threshold is None:
            return
        if actual_mb > threshold:
            raise BaselineError(
                f"[{test_name}] Memory {actual_mb:.1f} MB exceeds "
                f"baseline threshold {threshold} MB."
            )

    def assert_fps(self, test_name: str, actual_fps: Optional[float]) -> None:
        """Assert that *actual_fps* meets the configured minimum threshold.

        Args:
            test_name: Key in the baselines file.
            actual_fps: The measured FPS, or ``None`` to skip.

        Raises:
            BaselineError: If FPS falls below the threshold.
        """
        if actual_fps is None:
            return
        threshold = self.get(test_name).get("min_fps")
        if threshold is None:
            return
        if actual_fps < threshold:
            raise BaselineError(
                f"[{test_name}] FPS {actual_fps:.1f} is below "
                f"baseline threshold {threshold} FPS."
            )

    def assert_all(
        self,
        test_name: str,
        load_time_seconds: float,
        memory_mb: Optional[float] = None,
        fps: Optional[float] = None,
    ) -> None:
        """Convenience method that asserts all available metrics at once.

        Args:
            test_name: Key in the baselines file.
            load_time_seconds: Measured load time.
            memory_mb: Measured memory in MB, or ``None`` to skip.
            fps: Measured FPS, or ``None`` to skip.

        Raises:
            BaselineError: On the first metric that fails its threshold check.
        """
        self.assert_load_time(test_name, load_time_seconds)
        self.assert_memory(test_name, memory_mb)
        self.assert_fps(test_name, fps)
